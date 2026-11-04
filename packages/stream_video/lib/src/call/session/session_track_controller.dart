import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../call_state.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/call_participant_state.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_media_device/rtc_media_device.dart';
import '../../webrtc/rtc_track/rtc_track.dart';

/// Starts, stops, suspends and resumes a session's tracks as they are
/// published, received and unpublished.
///
/// An audio track that arrives while audio is suspended is disabled and
/// recorded instead of started, so [resumeSuspendedAudioTracks] can bring it
/// back.
@internal
class SessionTrackController {
  SessionTrackController({
    required this._rtcManager,
    required this._getTrack,
    required this._isAudioSuspended,
    required this._localParticipant,
    required this._participants,
    required this._audioOutputSelectedByUser,
    required this._audioOutputDevice,
    required this._videoInputDevice,
    required this._onSuspendedAudioTrackRecorded,
    required this._setAudioOutputDevice,
    required this._setVideoInputDevice,
    required this._setScreenShareEnabled,
    required this._sendMuteState,
    required this._updateSubscriberTrack,
    required String logTag,
  }) : _logger = taggedLogger(tag: logTag);

  final RtcManager? Function() _rtcManager;
  final RtcTrack? Function(String trackIdPrefix, SfuTrackType trackType)
  _getTrack;
  final bool Function() _isAudioSuspended;
  final CallParticipantState? Function() _localParticipant;
  final List<CallParticipantState> Function() _participants;
  final bool Function() _audioOutputSelectedByUser;
  final RtcMediaDevice? Function() _audioOutputDevice;
  final RtcMediaDevice? Function() _videoInputDevice;
  final void Function(String trackId) _onSuspendedAudioTrackRecorded;
  final Future<Result<None>> Function(RtcMediaDevice device)
  _setAudioOutputDevice;
  final Future<void> Function(RtcMediaDevice device) _setVideoInputDevice;
  final Future<void> Function(bool enabled) _setScreenShareEnabled;
  final void Function(RtcLocalTrack track, bool muted) _sendMuteState;
  final void Function({
    required String trackIdPrefix,
    required SfuTrackType trackType,
  })
  _updateSubscriberTrack;
  final TaggedLogger _logger;

  /// Starts the remote track the SFU says was published. Local tracks are
  /// started by the user.
  Future<void> onTrackPublished(SfuTrackPublishedEvent event) async {
    _logger.v(() => '[onTrackPublished] event: $event');

    final trackResult = await _getTrackForParticipant(
      event.userId,
      event.sessionId,
      event.trackType,
    );

    final track = trackResult.getDataOrNull();
    if (track == null) return;

    // Only start remote tracks. Local tracks are started by the user.
    if (track is! RtcRemoteTrack) return;

    await _startOrSuspend(track, tag: '[onTrackPublished]');
  }

  /// Stops the remote track the SFU says was unpublished. A local screen
  /// share that is still enabled was muted by the server, so screen sharing
  /// is turned off.
  Future<void> onTrackUnpublished(SfuTrackUnpublishedEvent event) async {
    _logger.v(() => '[onTrackUnpublished] event: $event');

    final trackResult = await _getTrackForParticipant(
      event.userId,
      event.sessionId,
      event.trackType,
    );

    final track = trackResult.getDataOrNull();
    if (track == null) return;

    // Only stop remote tracks. Local tracks are stopped by the user.
    if (track is! RtcRemoteTrack) {
      final localTrack = _rtcManager()?.getTrack(track.trackId);
      if (localTrack != null &&
          localTrack.isScreenShareTrack &&
          localTrack.mediaTrack.enabled) {
        // If the unpublished track is a local screen share track and it's still enabled,
        // disable screen sharing. It means the screen sharing was muted by the server.
        await _setScreenShareEnabled(false);
      }

      return;
    }

    await track.stop(disposeWebAudioPlayer: false);
  }

  /// Starts a published local track, re-applies the selected video input to
  /// a video track, and tells the SFU the track is unmuted.
  Future<void> onLocalTrackPublished(RtcLocalTrack track) async {
    _logger.d(() => '[onPublisherTrackPublished] track: $track');

    await _startOrSuspend(track, tag: '[onPublisherTrackPublished]');

    if (track.isVideoTrack) {
      await _applyCurrentVideoInputDevice();
    }

    // Send a mute state update to the server.
    _sendMuteState(track, false);
  }

  /// Starts a received remote track and records it in the call state.
  Future<void> onRemoteTrackReceived(
    StreamPeerConnection pc,
    RtcRemoteTrack remoteTrack,
  ) async {
    _logger.d(() => '[onRemoteTrackReceived] remoteTrack: $remoteTrack');

    await _startOrSuspend(remoteTrack, tag: '[onRemoteTrackReceived]');

    _updateSubscriberTrack(
      trackIdPrefix: remoteTrack.trackIdPrefix,
      trackType: remoteTrack.trackType,
    );
  }

  /// Hands every remote track of the manager to [onRemoteTrackReceived]
  /// again, after a fast reconnect.
  Future<void> replayRemoteTracks() async {
    final rtcManager = _rtcManager()!;

    for (final track in rtcManager.remoteTracks.values) {
      await onRemoteTrackReceived(rtcManager.subscriber, track);
    }
  }

  /// Re-applies the audio output the user selected, if any.
  Future<void> applyCurrentAudioOutputDevice() async {
    // Only re-apply an output the user explicitly selected.
    if (!_audioOutputSelectedByUser()) return;

    final audioOutputDevice = _audioOutputDevice();
    if (audioOutputDevice == null) return;

    final result = await _setAudioOutputDevice(audioOutputDevice);
    if (result is Failure) {
      _logger.w(
        () =>
            '[applyCurrentAudioOutputDevice] ${audioOutputDevice.id} not '
            'applied: ${result.videoError.message}',
      );
    }
  }

  /// Resumes audio tracks that were suspended or arrived during suspension.
  Future<void> resumeSuspendedAudioTracks(
    Map<String, SuspendedTrackState> priorStates,
  ) async {
    final rtcManager = _rtcManager();
    if (rtcManager == null) return;

    final tracks = <String, RtcTrack>{
      ...rtcManager.localTracks,
      ...rtcManager.remoteTracks,
    };
    for (final trackId in tracks.keys) {
      // Read again: an earlier track's resume awaits, and meanwhile this one
      // may have been removed or replaced under the same id.
      final track = rtcManager.getTrack(trackId);
      if (track == null || !track.isAudioTrack) continue;

      final prior = priorStates[trackId];
      if (prior == null) continue;

      await _resumeSuspendedAudioTrack(trackId, track, prior);
    }
  }

  /// Disables an audio track while audio is suspended, and starts any other
  /// track, re-applying the audio output for audio.
  Future<void> _startOrSuspend(RtcTrack track, {required String tag}) async {
    if (track.isAudioTrack && _isAudioSuspended()) {
      _logger.d(
        () =>
            '$tag audio suspended, '
            'disabling and skipping start for audio track ${track.trackId}',
      );
      _suspendAudioTrack(track);
      return;
    }

    await track.start();

    if (track.isAudioTrack) {
      await applyCurrentAudioOutputDevice();
    }
  }

  Future<Result<RtcTrack>> _getTrackForParticipant(
    String userId,
    String sessionId,
    SfuTrackType trackType,
  ) async {
    bool matchParticipant(CallParticipantState participant) {
      return participant.userId == userId && participant.sessionId == sessionId;
    }

    final participant = _participants().firstWhereOrNull(matchParticipant);

    if (participant == null) {
      return failureWithError('Participant not found: $userId:$sessionId');
    }

    final trackIdPrefix = participant.trackIdPrefix;
    final track = _getTrack(trackIdPrefix, trackType);

    // If the track is not found, return an error.
    if (track == null) {
      return failureWithError('Track not found: $trackIdPrefix:$trackType');
    }

    // If the track is found, return it.
    return Result.success(track);
  }

  Future<void> _applyCurrentVideoInputDevice() async {
    final videoInputDevice = _videoInputDevice();
    if (videoInputDevice != null) {
      await _setVideoInputDevice(videoInputDevice);
    }
  }

  /// Disables a freshly-received audio track and records it so
  /// [resumeSuspendedAudioTracks] can re-enable it on resume.
  void _suspendAudioTrack(RtcTrack track) {
    track.disable();
    _onSuspendedAudioTrackRecorded(track.trackId);
  }

  /// Whether [track] is the local microphone track and the SDK currently
  /// considers it muted.
  bool _isMutedLocalMicrophoneTrack(RtcTrack track) {
    if (track is! RtcLocalTrack) return false;
    if (track.trackType != SfuTrackType.audio) return false;

    final localParticipant = _localParticipant();
    if (localParticipant == null) {
      // Warned about because the resume that follows is indistinguishable
      // from a legitimate mute in a customer log.
      _logger.w(
        () =>
            '[isMutedLocalMicrophoneTrack] no local participant in state, '
            'treating ${track.trackId} as muted',
      );
      return true;
    }

    return !localParticipant.isAudioEnabled;
  }

  Future<void> _resumeSuspendedAudioTrack(
    String trackId,
    RtcTrack track,
    SuspendedTrackState prior,
  ) async {
    switch (prior) {
      case SuspendedTrackState.wasEnabled:
        // [priorStates] is a snapshot, user may have muted since.
        // Re-enabling could make the mic live while UI/SDK show muted, especially on iOS/macOS.
        if (_isMutedLocalMicrophoneTrack(track)) {
          _logger.d(
            () =>
                '[resumeSuspendedAudioTracks] track $trackId was muted '
                'during the suspension, leaving disabled',
          );
          return;
        }

        track.enable();
        _logger.d(
          () => '[resumeSuspendedAudioTracks] re-enabled track $trackId',
        );
      case SuspendedTrackState.neverStarted:
        // For local mic tracks published during suspension, starting here
        // could make the mic live even if muted in the SDK/UI.
        if (_isMutedLocalMicrophoneTrack(track)) {
          _logger.d(
            () =>
                '[resumeSuspendedAudioTracks] track $trackId was muted '
                'during the suspension, leaving unstarted',
          );
          return;
        }

        await track.start();
        await applyCurrentAudioOutputDevice();
        _logger.d(
          () => '[resumeSuspendedAudioTracks] started track $trackId',
        );
      case SuspendedTrackState.wasDisabled:
        _logger.v(
          () =>
              '[resumeSuspendedAudioTracks] track $trackId was '
              'disabled before suspension, leaving disabled',
        );
    }
  }
}
