import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart'
    show
        NativeWebRtcEvent,
        ScreenSharingStartedEvent,
        ScreenSharingStoppedEvent;

import '../../audio/platform_audio_controller.dart';
import '../../call_state.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../webrtc/media/media_constraints.dart';
import '../../webrtc/media/screen_share_source.dart';
import '../../webrtc/model/rtc_video_parameters.dart';
import '../../webrtc/rtc_media_device/rtc_media_device_notifier.dart';
import '../call_connect_options.dart';
import '../call_events.dart';
import '../session/call_session.dart';
import '../state/call_state_notifier.dart';

/// Applies or removes a screen share on the call's session.
typedef ApplyScreenShare =
    Future<Result<None>> Function({
      required bool enabled,
      required ScreenShareConstraints constraints,
    });

/// A call's screen share through the iOS broadcast extension.
///
/// Requesting shows the broadcast picker. The share starts once the
/// broadcast does, in the call that owns it, and a broadcast that starts
/// while the call has no session, or before any call is active, is shared by
/// the next session.
@internal
class IosBroadcastScreenShare {
  IosBroadcastScreenShare({
    required this._stateManager,
    required this._session,
    required this._isApplying,
    required this._hasApplied,
    required this._applyScreenShare,
    required this._readConnectOptions,
    required this._writeConnectOptions,
    required this._hasPermission,
    required this._rtcMediaDeviceNotifier,
    required this._defaultTarget,
    required this._onCallEvent,
    required this._logger,
  });

  static final _owner = _BroadcastOwner();

  final CallStateNotifier _stateManager;
  final CallSession? Function() _session;

  /// Whether a session is applying the connect options.
  final bool Function(CallSession session) _isApplying;

  /// Whether a session has finished applying the connect options.
  final bool Function(CallSession session) _hasApplied;
  final ApplyScreenShare _applyScreenShare;
  final CallConnectOptions Function() _readConnectOptions;
  final void Function(CallConnectOptions options) _writeConnectOptions;
  final bool Function(CallPermission permission) _hasPermission;
  final RtcMediaDeviceNotifier Function() _rtcMediaDeviceNotifier;

  /// The share of the call that takes a broadcast no call requested: the
  /// client's active call, or none.
  final IosBroadcastScreenShare? Function() _defaultTarget;

  /// Delivers an event on the call's events.
  final void Function(StreamCallEvent event) _onCallEvent;
  final TaggedLogger _logger;

  /// The constraints of the last request, used once the broadcast starts.
  ScreenShareConstraints? _requestedConstraints;

  /// A broadcast that started while no session could share it, shared by
  /// the next session that applies the connect options.
  ScreenShareConstraints? _pendingConstraints;

  CallState get _state => _stateManager.callState;

  /// Records the broadcast starts and stops of the app, also while no call
  /// observes them, so the next call that joins shares a running broadcast.
  /// Does nothing when already observing.
  static void observeBroadcasts() {
    _owner.observe(PlatformAudioController.instance.nativeWebRtcEventsStream());
  }

  /// Clears which call owns the broadcast and whether it runs, and stops
  /// observing the broadcast starts and stops.
  @visibleForTesting
  static void resetOwnership() => _owner.reset();

  /// Shows the picker of the broadcast extension. The share starts when the
  /// broadcast does, in [onStarted].
  ///
  /// Fails without showing the picker while the call has no session.
  Future<Result<None>> request(ScreenShareConstraints constraints) async {
    if (_session() == null) {
      return failureWithError(
        'Call session is null, cannot start screen share',
      );
    }
    _requestedConstraints = constraints;
    _owner.request(this);
    try {
      await _rtcMediaDeviceNotifier().presentiOSBroadcastPicker();
      return const Result.success(none);
    } catch (error, stackTrace) {
      _logger.e(() => '[requestBroadcast] failed to show the picker: $error');
      releaseRequest();
      return failureWithError(
        'Failed to show the broadcast picker',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Forgets this call's request, so a broadcast that starts later is not
  /// shared with its constraints, and another call can take a broadcast
  /// nobody requested.
  void releaseRequest() {
    _requestedConstraints = null;
    _pendingConstraints = null;
    _owner.release(this);
  }

  /// Whether [constraints] capture the broadcast extension while it is
  /// broadcasting.
  bool isRunning(ScreenShareConstraints constraints) {
    return _owner.isActive &&
        ScreenShareSource.forPlatform().usesBroadcastExtension(constraints);
  }

  /// Captures the running broadcast again for a new session, without
  /// showing the picker.
  Future<Result<None>> recapture(ScreenShareConstraints constraints) async {
    if (!_hasPermission(CallPermission.screenshare)) {
      return failureWithError(
        'Missing permission to share screen for the user',
      );
    }
    return _applyScreenShare(enabled: true, constraints: constraints);
  }

  /// Writes a broadcast that started before this session into the connect
  /// options, so the session shares it.
  void takePending() {
    var pending = _pendingConstraints;
    _pendingConstraints = null;
    if (pending == null &&
        identical(_defaultTarget(), this) &&
        _owner.claim()) {
      pending = _defaultConstraints();
    }
    if (pending == null) return;

    _logger.d(() => '[applyConnectOptions] sharing the running broadcast');
    _writeConnectOptions(
      _readConnectOptions().copyWith(
        screenShare: TrackOption.enabled(constraints: pending),
      ),
    );
  }

  /// Records that the broadcast stopped, and turns off a screen share option
  /// that captures it, so a later session does not capture a stopped
  /// broadcast.
  void onStopped() {
    _owner.onStopped();
    _pendingConstraints = null;

    final options = _readConnectOptions();
    final option = options.screenShare;
    if (option is! TrackEnabled) return;
    final constraints = option.constraints;
    if (constraints is! ScreenShareConstraints ||
        !ScreenShareSource.forPlatform().usesBroadcastExtension(constraints)) {
      return;
    }
    _writeConnectOptions(
      options.copyWith(screenShare: TrackOption.disabled()),
    );
  }

  /// Shares the screen once the broadcast extension has started, with the
  /// constraints of the last request or the default broadcast ones.
  ///
  /// Skipped in a call that does not own the broadcast. While the call has no
  /// session, or one is being applied, it is shared once the session applies.
  Future<void> onStarted() async {
    _owner.onStarted();

    if (!_ownsBroadcast()) {
      _logger.v(() => '[onBroadcastStarted] shared by another call');
      return;
    }

    final constraints = _requestedConstraints ?? _defaultConstraints();
    final session = _session();
    if (session == null || _awaitsSession(session)) {
      _logger.i(() => '[onBroadcastStarted] shared once a session applies');
      _pendingConstraints = constraints;
      return;
    }

    await _share(session, constraints);
  }

  /// Shares a broadcast that started while [session] applied the connect
  /// options, once it has applied them and is still the call's session.
  Future<void> sharePending(CallSession session) async {
    final constraints = _pendingConstraints;
    if (constraints == null || !identical(session, _session())) return;
    _pendingConstraints = null;

    _logger.d(() => '[sharePending] sharing the running broadcast');
    await _share(session, constraints);
  }

  /// Publishes the running broadcast on [session] with [constraints].
  ///
  /// Skipped while a screen share is live. A missing permission or a failed
  /// share ends the broadcast and is reported as a
  /// [StreamCallScreenShareFailedEvent].
  Future<void> _share(
    CallSession session,
    ScreenShareConstraints constraints,
  ) async {
    final localParticipant = _state.localParticipant;
    final shared = localParticipant == null
        ? null
        : session.getTrack(
            localParticipant.trackIdPrefix,
            SfuTrackType.screenShare,
          );
    if (shared != null && shared.mediaTrack.enabled) {
      _logger.w(() => '[onBroadcastStarted] skipped: a screen share is live');
      return;
    }

    if (!_hasPermission(CallPermission.screenshare)) {
      _logger.w(() => '[onBroadcastStarted] missing screenshare permission');
      await _stop();
      _reportFailure(ScreenShareFailureReason.missingPermission);
      return;
    }

    try {
      final result = await _applyScreenShare(
        enabled: true,
        constraints: constraints,
      );
      if (result case Failure(:final error)) {
        _logger.e(() => '[onBroadcastStarted] share failed: $error');
        await _stop();
        _reportFailure(ScreenShareFailureReason.publishFailed, error: error);
      }
    } catch (error, stackTrace) {
      _logger.e(() => '[onBroadcastStarted] share failed: $error\n$stackTrace');
      await _stop();
      _reportFailure(ScreenShareFailureReason.publishFailed, error: error);
    }
  }

  /// Broadcast constraints at the call's screen share resolution.
  ScreenShareConstraints _defaultConstraints() {
    return const ScreenShareConstraints(
      useiOSBroadcastExtension: true,
    ).copyWith(
      params: _readConnectOptions().screenShareTargetResolution?.toVideoParams(
        defaultBitrate: RtcVideoParametersPresets.k1080pBitrate,
      ),
    );
  }

  /// Whether this call shares the broadcast that started: the call that
  /// requested it, or with no request, the client's active call.
  bool _ownsBroadcast() {
    final owns = _owner.hasRequest
        ? _owner.isRequestedBy(this)
        : identical(_defaultTarget(), this);
    if (owns) _owner.markClaimed();
    return owns;
  }

  /// Whether a share now would reach a session that is applying the connect
  /// options, or one being replaced that has not applied them.
  bool _awaitsSession(CallSession session) {
    if (_isApplying(session)) return true;
    if (_hasApplied(session)) return false;
    final status = _state.status;
    return status.isMigrating ||
        (status.isReconnecting && !status.isFastReconnecting);
  }

  /// Reports a broadcast this call could not share on the call's events.
  void _reportFailure(ScreenShareFailureReason reason, {Object? error}) {
    _onCallEvent(
      StreamCallScreenShareFailedEvent(
        _state.callCid,
        reason: reason,
        error: error,
      ),
    );
  }

  /// Asks the broadcast extension to finish the broadcast this call could
  /// not share. The local participant is not sharing.
  Future<void> _stop() async {
    _stateManager.participantSetScreenShareEnabled(enabled: false);
    try {
      await _rtcMediaDeviceNotifier().stopiOSBroadcast();
    } catch (error) {
      _logger.e(() => '[stopBroadcast] failed: $error');
    }
  }
}

/// Which call shares the broadcast. Process-wide, as the app has one
/// broadcast extension.
///
/// The broadcast belongs to the call that showed the picker last. One that
/// starts without a request, such as from Control Center, belongs to the
/// client's active call, or with none, to the next call that joins.
class _BroadcastOwner {
  StreamSubscription<NativeWebRtcEvent>? _events;
  Object? _requester;
  bool _isActive = false;
  bool _isUnclaimed = false;

  /// Whether the broadcast is running, as the last start or stop event said.
  bool get isActive => _isActive;

  /// Whether a call showed the picker and the broadcast has not stopped
  /// since.
  bool get hasRequest => _requester != null;

  /// Whether [call] showed the picker last.
  bool isRequestedBy(Object call) => identical(_requester, call);

  /// Records that [call] showed the picker.
  void request(Object call) => _requester = call;

  /// Drops the request of [call], if it made the last one.
  void release(Object call) {
    if (identical(_requester, call)) _requester = null;
  }

  /// Follows the broadcast starts and stops in [events]. Does nothing when
  /// already following.
  void observe(Stream<NativeWebRtcEvent> events) {
    _events ??= events.listen((event) {
      switch (event) {
        case ScreenSharingStartedEvent _:
          onStarted();
        case ScreenSharingStoppedEvent _:
          onStopped();
        default:
          return;
      }
    });
  }

  /// Records a running broadcast, unclaimed until a call takes it. A start
  /// while it runs changes nothing.
  void onStarted() {
    if (_isActive) return;
    _isActive = true;
    _isUnclaimed = true;
  }

  void onStopped() {
    _isActive = false;
    _isUnclaimed = false;
    _requester = null;
  }

  /// Records that a call took the running broadcast, so the next call that
  /// joins does not take it too.
  void markClaimed() => _isUnclaimed = false;

  /// Whether a running broadcast was waiting for a call. Only the first
  /// caller gets true.
  bool claim() {
    final unclaimed = _isUnclaimed && _isActive;
    _isUnclaimed = false;
    return unclaimed;
  }

  void reset() {
    unawaited(_events?.cancel());
    _events = null;
    _requester = null;
    _isActive = false;
    _isUnclaimed = false;
  }
}
