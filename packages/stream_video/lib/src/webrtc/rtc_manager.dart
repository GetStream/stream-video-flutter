import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../disposable.dart';
import '../errors/video_error_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../logger/stream_log.dart';
import '../models/call_cid.dart';
import '../platform_detector/platform_detector.dart';
import '../sfu/data/models/sfu_model_parser.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'codecs_helper.dart' as codecs;
import 'media/media_constraints.dart';
import 'model/rtc_audio_bitrate_preset.dart';
import 'model/rtc_tracks_info.dart';
import 'model/rtc_video_dimension.dart';
import 'model/rtc_video_encoding.dart';
import 'model/rtc_video_parameters.dart';
import 'peer_connection.dart';
import 'peer_type.dart';
import 'rtc_media_device/rtc_media_device.dart';
import 'rtc_parser.dart';
import 'rtc_track/rtc_track.dart';

/// {@template OnLocalTrackMuted}
/// Callback for when a local track is muted.
/// {@endtemplate}
typedef OnLocalTrackMuted = void Function(RtcLocalTrack track, bool muted);

/// {@template OnLocalTrackPublished}
/// Called when a local track is published.
/// {@endtemplate}
typedef OnLocalTrackPublished = void Function(RtcLocalTrack track);

/// {@template OnRemoteTrackPublished}
/// Called when a subscriber track is received.
/// {@endtemplate}
typedef OnRemoteTrackReceived = void Function(
  StreamPeerConnection pc,
  RtcRemoteTrack track,
);

const _tag = 'SV:RtcManager';

class RtcManager extends Disposable {
  RtcManager({
    required this.sessionId,
    required this.callCid,
    required this.publisherId,
    required StreamPeerConnection publisher,
    required StreamPeerConnection subscriber,
  })  : _publisher = publisher,
        _subscriber = subscriber {
    _subscriber.onTrack = _onRemoteTrack;
  }

  final _logger = taggedLogger(tag: _tag);

  final String sessionId;
  final StreamCallCid callCid;
  final String publisherId;
  final StreamPeerConnection _publisher;
  final StreamPeerConnection _subscriber;

  final publishedTracks = < /*trackId*/ String, RtcTrack>{};

  set onPublisherIceCandidate(OnIceCandidate? cb) {
    _publisher.onIceCandidate = cb;
  }

  set onSubscriberIceCandidate(OnIceCandidate? cb) {
    _subscriber.onIceCandidate = cb;
  }

  set onRenegotiationNeeded(OnRenegotiationNeeded? cb) {
    _publisher.onRenegotiationNeeded = cb;
  }

  set onStatsReceived(OnStats? cb) {
    _subscriber.onStats = cb;
    _publisher.onStats = cb;
  }

  OnLocalTrackMuted? onLocalTrackMuted;
  OnLocalTrackPublished? onLocalTrackPublished;
  OnRemoteTrackReceived? onRemoteTrackReceived;

  /// Returns a generic sdp.
  static Future<String> getGenericSdp() async {
    const direction = rtc.TransceiverDirection.RecvOnly;
    final tempPC = await rtc.createPeerConnection({});

    await tempPC.addTransceiver(
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: rtc.RTCRtpTransceiverInit(direction: direction),
    );

    await tempPC.addTransceiver(
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: rtc.RTCRtpTransceiverInit(direction: direction),
    );

    final offer = await tempPC.createOffer();
    final sdp = offer.sdp;

    await tempPC.dispose();

    return sdp!;
  }

  Future<String?> onSubscriberOffer(String offerSdp) async {
    final result = await _subscriber.setRemoteOffer(offerSdp);
    if (result.isFailure) return null;

    final rtcAnswer = await _subscriber.createAnswer();
    return rtcAnswer.getDataOrNull()?.sdp;
  }

  Future<Result<None>> onRemoteIceCandidate({
    required StreamPeerType peerType,
    required String iceCandidate,
  }) async {
    final candidate = RtcIceCandidateParser.fromJsonString(iceCandidate);
    if (peerType == StreamPeerType.publisher) {
      return _publisher.addIceCandidate(candidate);
    } else if (peerType == StreamPeerType.subscriber) {
      return _subscriber.addIceCandidate(candidate);
    }
    return Result.error('unexpected peerType: $peerType');
  }

  void _onRemoteTrack(StreamPeerConnection pc, rtc.RTCTrackEvent event) {
    _logger.d(
      () => '[onRemoteTrack] event.streams.length: ${event.streams.length}',
    );

    final stream = event.streams.firstOrNull;
    if (stream == null) {
      _logger.w(() => '[onRemoteTrack] stream is null');
      return;
    }
    _logger.v(() => '[onRemoteTrack] stream.id: ${stream.id}');

    event.track.onEnded = () {
      _logger.w(() => '[onRemoteTrack] #onTrackEnded; no args');
    };
    stream.onRemoveTrack = (_) {
      _logger.w(() => '[onRemoteTrack] #onRemoveTrack; no args');
    };

    final track = event.track;
    final receiver = event.receiver;
    final transceiver = event.transceiver;

    final idParts = stream.id.split(':');
    final trackId = idParts[0];
    final trackType = idParts[1];

    final remoteTrack = RtcRemoteTrack(
      trackIdPrefix: trackId,
      trackType: SfuTrackTypeParser.parseSfuName(trackType),
      mediaTrack: track,
      mediaStream: stream,
      receiver: receiver,
      transceiver: transceiver,
    );

    onRemoteTrackReceived?.call(pc, remoteTrack);
    publishedTracks[remoteTrack.trackId] = remoteTrack;
    _logger.v(() => '[onRemoteTrack] published: ${remoteTrack.trackId}');
  }

  Future<void> unpublishTrack({required String trackId}) async {
    final publishedTrack = publishedTracks.remove(trackId);
    if (publishedTrack == null) {
      _logger.w(() => '[unpublishTrack] rejected (track not found): $trackId');
      return;
    }

    await publishedTrack.stop();

    final sender = publishedTrack.transceiver?.sender;
    if (sender != null) {
      try {
        await _publisher.pc.removeTrack(sender);
      } catch (e) {
        _logger.w(() => '[unpublishTrack] removeTrack failed: $e');
      }
    }
  }

  Future<void> onPublishQualityChanged(Set<String> rids) async {
    final transceivers = await _publisher.pc.getTransceivers();
    for (final transceiver in transceivers) {
      if (transceiver.sender.track?.kind == 'video') {
        var changed = false;
        final params = transceiver.sender.parameters;
        params.encodings?.forEach((enc) {
          // flip 'active' flag only when necessary
          final shouldEnable = rids.contains(enc.rid);
          if (shouldEnable != enc.active) {
            enc.active = shouldEnable;
            changed = true;
          }
        });
        if (changed) {
          if (params.encodings?.length == 0) {
            _logger.v(() => 'No suitable video encoding quality found');
          }
          await transceiver.sender.setParameters(params);
        }
      }
    }
  }

  @override
  Future<void> dispose() async {
    for (final trackSid in [...publishedTracks.keys]) {
      await unpublishTrack(trackId: trackSid);
    }

    publishedTracks.clear();

    onLocalTrackMuted = null;
    onLocalTrackPublished = null;
    onRemoteTrackReceived = null;
    onStatsReceived = null;

    await _publisher.dispose();
    await _subscriber.dispose();

    return super.dispose();
  }

  RtcTrack? getTrack(String trackId) {
    _logger.d(() => '[getTrack] trackId: $trackId');
    return publishedTracks[trackId];
  }

  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [
      ...publishedTracks.values.where((track) {
        return track.trackIdPrefix == trackIdPrefix;
      }),
    ];
  }
}

extension PublisherRtcManager on RtcManager {
  List<RtcLocalTrack> getPublisherTracks() {
    return [...publishedTracks.values.whereType<RtcLocalTrack>()];
  }

  RtcLocalTrack? getPublisherTrackByType(SfuTrackType trackType) {
    final track = getPublisherTracks().firstWhereOrNull((track) {
      return track.trackType == trackType;
    });

    if (track == null) {
      _logger.w(() => '[getPublisherTrackInfos] track not found: $trackType');
      return null;
    }

    return track;
  }

  List<RtcTrackInfo> getPublisherTrackInfos() {
    return getPublisherTracks().map((it) {
      List<RtcVideoLayer>? videoLayers;

      // Calculate video layers for video tracks.
      if (it.isVideoTrack) {
        final dimension = it.videoDimension!;
        final encodings = it.transceiver?.sender.parameters.encodings;
        _logger.i(() => '[getPublisherTrackInfos] dimension: $dimension');

        // default to a single layer, HQ
        final defaultLayer = RtcVideoLayer(
          rid: 'f',
          parameters: RtcVideoParametersPresets.h720_16x9.copyWith(
            dimension: dimension,
          ),
        );
        if (encodings == null) {
          videoLayers = [defaultLayer];
        } else {
          videoLayers = encodings.map((it) {
            final scale = it.scaleResolutionDownBy ?? 1;
            return RtcVideoLayer(
              rid: it.rid ?? defaultLayer.rid,
              parameters: RtcVideoParameters(
                encoding: RtcVideoEncoding(
                  maxBitrate: it.maxBitrate ??
                      defaultLayer.parameters.encoding.maxBitrate,
                  maxFramerate: it.maxFramerate ??
                      defaultLayer.parameters.encoding.maxFramerate,
                ),
                dimension: RtcVideoDimension(
                  width: (dimension.width / scale).floor(),
                  height: (dimension.height / scale).floor(),
                ),
              ),
            );
          }).toList();
        }
      }

      videoLayers?.forEach((layer) {
        _logger.v(() => '[getPublisherTrackInfos] layer: $layer');
      });

      return RtcTrackInfo(
        trackId: it.mediaTrack.id,
        trackType: it.trackType,
        mid: it.transceiver?.mid,
        layers: videoLayers,
      );
    }).toList();
  }

  /// Removes all tracks from the publisher with the given [trackIdPrefix].
  Future<void> removeSubscriber(String trackIdPrefix) async {
    final tracks = getTracks(trackIdPrefix);
    for (final track in tracks) {
      await unpublishTrack(trackId: track.trackId);
    }
  }

  Future<Result<RtcLocalTrack>> publishTrack(RtcLocalTrack track) async {
    if (track is RtcLocalAudioTrack) return publishAudioTrack(track: track);
    if (track is RtcLocalVideoTrack) return publishVideoTrack(track: track);

    return Result.error('Unsupported track type: ${track.runtimeType}');
  }

  Future<Result<RtcLocalAudioTrack>> publishAudioTrack({
    required RtcLocalAudioTrack track,
    bool stopTrackOnMute = true,
  }) async {
    // Add publisherId to the trackIdPrefix if it's a local track.
    if (track.trackIdPrefix == kLocalTrackIdPrefix) {
      track = track.copyWith(trackIdPrefix: publisherId);
    }

    // Adding early as we need to access it in the onPublisherNegotiationNeeded
    // callback.
    _logger.i(() => '[publishAudioTrack] track: $track');
    publishedTracks[track.trackId] = track;

    final transceiverResult = await _publisher.addAudioTransceiver(
      stream: track.mediaStream,
      track: track.mediaTrack,
      encodings: [
        rtc.RTCRtpEncoding(rid: 'a', maxBitrate: AudioBitrate.music),
      ],
    );

    // Return early if the transceiver could not be added.
    if (transceiverResult is Failure) return transceiverResult;

    final transceiver = transceiverResult.getDataOrNull()!;

    _logger.v(() => '[publishAudioTrack] transceiver: $transceiver');

    // Update track with the added transceiver.
    final updatedTrack = track.copyWith(
      receiver: transceiver.receiver,
      transceiver: transceiver,
      stopTrackOnMute: stopTrackOnMute,
    );

    // Notify listeners.
    onLocalTrackPublished?.call(updatedTrack);
    publishedTracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalVideoTrack>> publishVideoTrack({
    required RtcLocalVideoTrack track,
    bool stopTrackOnMute = true,
  }) async {
    // Add publisherId to the trackIdPrefix if it's a local track.
    if (track.trackIdPrefix == kLocalTrackIdPrefix) {
      track = track.copyWith(trackIdPrefix: publisherId);
    }

    // Adding early as we need to access it in the onPublisherNegotiationNeeded
    // callback.
    _logger.i(() => '[publishVideoTrack] track: $track');
    publishedTracks[track.trackId] = track;

    // use constraints passed to getUserMedia by default
    final dimension = track.getVideoDimension();

    _logger.v(() => '[publishVideoTrack] dimension: $dimension');

    final encodings = codecs.computeVideoEncodings(
      dimension: dimension,
      isScreenShare: track.trackType == SfuTrackType.screenShare,
    );

    for (final encoding in encodings) {
      _logger.v(() => '[publishVideoTrack] encoding: ${encoding.toMap()}');
    }

    final transceiverResult = await _publisher.addVideoTransceiver(
      stream: track.mediaStream,
      track: track.mediaTrack,
      encodings: encodings,
    );

    // Return early if the transceiver could not be added.
    if (transceiverResult is Failure) return transceiverResult;

    final transceiver = transceiverResult.getDataOrNull()!;

    _logger.v(() => '[publishAudioTrack] transceiver: $transceiver');

    // Update track with the added transceiver.
    final updatedTrack = track.copyWith(
      receiver: transceiver.receiver,
      transceiver: transceiver,
      videoDimension: dimension,
      stopTrackOnMute: stopTrackOnMute,
    );

    // Notify listeners.
    onLocalTrackPublished?.call(updatedTrack);
    publishedTracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalTrack>> muteTrack({required String trackId}) async {
    final track = publishedTracks[trackId];
    if (track == null) {
      _logger.w(() => 'muteTrack: track not found');
      return Result.error('Track not found');
    }

    if (track is! RtcLocalTrack) {
      _logger.w(() => 'muteTrack: track is not local');
      return Result.error('Track is not local');
    }

    track.disable();
    if (track.stopTrackOnMute) {
      // Releases the track and stops the permission indicator.
      await track.stop();
    }

    onLocalTrackMuted?.call(track, true);
    return Result.success(track);
  }

  Future<Result<RtcLocalTrack>> unmuteTrack({required String trackId}) async {
    final track = publishedTracks[trackId];
    if (track == null) {
      _logger.w(() => 'unmuteTrack: track not found');
      return Result.error('Track not found');
    }

    if (track is! RtcLocalTrack) {
      _logger.w(() => 'unmuteTrack: track is not local');
      return Result.error('Track is not local');
    }

    // If the track was released before, restart it.
    if (track.stopTrackOnMute) {
      final updatedTrack = await track.recreate();
      publishedTracks[trackId] = updatedTrack;
      onLocalTrackMuted?.call(updatedTrack, false);

      return Result.success(updatedTrack);
    }

    // Otherwise simply enable it again
    track.enable();
    onLocalTrackMuted?.call(track, false);

    return Result.success(track);
  }

  Future<Result<RtcLocalAudioTrack>> createAudioTrack({
    AudioConstraints constraints = const AudioConstraints(),
  }) async {
    _logger.d(() => '[createAudioTrack] constraints: ${constraints.toMap()}');
    try {
      final audioTrack = await RtcLocalTrack.audio(
        trackIdPrefix: publisherId,
        constraints: constraints,
      );

      return Result.success(audioTrack);
    } catch (e, stk) {
      _logger.e(() => '[createAudioTrack] rejected: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<RtcLocalCameraTrack>> createCameraTrack({
    CameraConstraints constraints = const CameraConstraints(),
  }) async {
    _logger.d(() => '[createCameraTrack] constraints: ${constraints.toMap()}');
    try {
      final videoTrack = await RtcLocalTrack.camera(
        trackIdPrefix: publisherId,
        constraints: constraints,
      );

      return Result.success(videoTrack);
    } catch (e, stk) {
      _logger.e(() => '[createCameraTrack] rejected: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<RtcLocalScreenShareTrack>> createScreenShareTrack({
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
  }) async {
    _logger.d(
      () => '[createScreenShareTrack] constraints: ${constraints.toMap()}',
    );
    try {
      final screenShareTrack = await RtcLocalTrack.screenShare(
        trackIdPrefix: publisherId,
        constraints: constraints,
      );

      return Result.success(screenShareTrack);
    } catch (e, stk) {
      _logger.e(() => '[createScreenShareTrack] rejected: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<RtcLocalCameraTrack>> setTrackFacingMode({
    required FacingMode facingMode,
  }) async {
    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) return Result.error('Track not found');

    if (track is! RtcLocalCameraTrack) {
      _logger.w(() => '[setTrackFacingMode] rejected (track is not camera)');
      return Result.error('Track is not camera');
    }

    final updatedTrack = await track.recreate(
      mediaConstraints: track.mediaConstraints.copyWith(
        facingMode: facingMode,
      ),
    );

    publishedTracks[updatedTrack.trackId] = updatedTrack;
    return Result.success(updatedTrack);
  }
}

extension RtcManagerTrackHelper on RtcManager {
  Future<Result<RtcLocalCameraTrack>> flipCamera() async {
    if (CurrentPlatform.isWeb) {
      _logger.e(() => '[switchCamera] rejected (not supported on web)');
      return Result.error('Not supported on web');
    }

    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) {
      _logger.e(() => '[switchCamera] rejected (track is null)');
      return Result.error('Track is null');
    }

    if (track is! RtcLocalCameraTrack) {
      _logger.e(() => '[switchCamera] rejected (track is not camera)');
      return Result.error('Track is not camera');
    }

    final updatedTrack = await track.flipCamera();
    publishedTracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalCameraTrack>> setVideoInputDevice({
    required RtcMediaDevice device,
  }) async {
    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) {
      _logger.w(() => '[setCameraDeviceId] rejected (track is null)');
      return Result.error('Track is null');
    }

    if (track is! RtcLocalCameraTrack) {
      _logger.w(() => '[setCameraDeviceId] rejected (track is not camera)');
      return Result.error('Track is not camera');
    }

    final updatedTrack = await track.selectVideoInput(device);
    publishedTracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalAudioTrack>> setAudioInputDevice({
    required RtcMediaDevice device,
  }) async {
    final track = getPublisherTrackByType(SfuTrackType.audio);
    if (track == null) {
      _logger.w(() => '[setMicrophoneDeviceId] rejected (track is null)');
      return Result.error('Track is null');
    }

    if (track is! RtcLocalAudioTrack) {
      _logger.w(() => '[setMicrophoneDeviceId] rejected (track is not audio)');
      return Result.error('Track is not audio');
    }

    final updatedTrack = await track.selectAudioInput(device);
    publishedTracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<None>> setAudioOutputDevice({
    required RtcMediaDevice device,
  }) async {
    // Get all remote audio tracks.
    final audioTracks = publishedTracks.values
        .whereType<RtcRemoteTrack>()
        .where((it) => it.trackType == SfuTrackType.audio);

    // If the platform is web, set the sink id for all remote audio tracks
    // to the selected device.
    if (CurrentPlatform.isWeb) {
      for (final audioTrack in audioTracks) {
        final updatedTrack = audioTrack.setSinkId(device.id);
        publishedTracks[updatedTrack.trackId] = updatedTrack;
      }

      return const Result.success(none);
    }

    try {
      // Change the audio output device for all remote audio tracks.
      await rtc.Helper.selectAudioOutput(device.id);
      for (final audioTrack in audioTracks) {
        final updatedTrack = audioTrack.copyWith(audioSinkId: device.id);
        publishedTracks[updatedTrack.trackId] = updatedTrack;
      }

      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[setAudioOutputDevice] rejected: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<RtcLocalCameraTrack>> setCameraPosition({
    required CameraPosition cameraPosition,
  }) {
    final facingMode = cameraPosition.toFacingMode();
    return setTrackFacingMode(facingMode: facingMode);
  }

  Future<Result<RtcLocalTrack>> setCameraEnabled({bool enabled = true}) {
    return _setTrackEnabled(
      trackType: SfuTrackType.video,
      enabled: enabled,
    );
  }

  Future<Result<RtcLocalTrack>> setMicrophoneEnabled({bool enabled = true}) {
    return _setTrackEnabled(
      trackType: SfuTrackType.audio,
      enabled: enabled,
    );
  }

  Future<Result<RtcLocalTrack>> setScreenShareEnabled({bool enabled = true}) {
    return _setTrackEnabled(
      trackType: SfuTrackType.screenShare,
      enabled: enabled,
    );
  }

  Future<Result<RtcLocalTrack>> _setTrackEnabled({
    required SfuTrackType trackType,
    required bool enabled,
  }) async {
    final track = getPublisherTrackByType(trackType);

    // Track found, mute/unmute it.
    if (track != null) {
      final toggledTrack = await _toggleTrackMuteState(
        track: track,
        muted: !enabled,
      );

      return Result.success(toggledTrack);
    }

    // Track not found, create a new one and publish it if enabled is true.
    if (enabled) {
      return _createAndPublishTrack(trackType: trackType);
    }

    // Track not found and enabled is false, return error.
    return Result.error('Track not found and enabled is false');
  }

  Future<RtcLocalTrack> _toggleTrackMuteState({
    required RtcLocalTrack track,
    required bool muted,
  }) async {
    if (muted) {
      await muteTrack(trackId: track.trackId);

      // If the track is a screen share track, mute the audio track as well.
      if (track.trackType == SfuTrackType.screenShare) {
        final screenShareAudioTrack = getPublisherTrackByType(
          SfuTrackType.screenShareAudio,
        );
        if (screenShareAudioTrack != null) {
          await muteTrack(trackId: screenShareAudioTrack.trackId);
        }
      }
    } else {
      await unmuteTrack(trackId: track.trackId);

      // If the track is a screen share track, unmute the audio track as well.
      if (track.trackType == SfuTrackType.screenShare) {
        final screenShareAudioTrack = getPublisherTrackByType(
          SfuTrackType.screenShareAudio,
        );
        if (screenShareAudioTrack != null) {
          await unmuteTrack(trackId: screenShareAudioTrack.trackId);
        }
      }
    }

    return track;
  }

  Future<Result<RtcLocalTrack>> _createAndPublishTrack({
    required SfuTrackType trackType,
  }) async {
    if (trackType == SfuTrackType.video) {
      final cameraTrackResult = await createCameraTrack();
      return cameraTrackResult.fold(
        success: (it) => publishVideoTrack(track: it.data),
        failure: (it) => it,
      );
    } else if (trackType == SfuTrackType.audio) {
      final audioTrackResult = await createAudioTrack();
      return audioTrackResult.fold(
        success: (it) => publishAudioTrack(track: it.data),
        failure: (it) => it,
      );
    } else if (trackType == SfuTrackType.screenShare) {
      final screenShareTrackResult = await createScreenShareTrack();
      return screenShareTrackResult.fold(
        success: (it) => publishVideoTrack(track: it.data),
        failure: (it) => it,
      );
    }

    _logger.e(() => 'Unsupported trackType $trackType');
    return Result.error('Unsupported trackType $trackType');
  }
}

extension on RtcLocalTrack<VideoConstraints> {
  RtcVideoDimension getVideoDimension() {
    // use constraints passed to getUserMedia by default
    var dimension = mediaConstraints.params.dimension;

    if (CurrentPlatform.isWeb) {
      // getSettings() is only implemented for Web
      try {
        // try to use getSettings for more accurate resolution
        final settings = mediaTrack.getSettings();
        streamLog.v(_tag, () => '[publishVideoTrack] settings: $settings');
        if (settings['width'] is int) {
          dimension = dimension.copyWith(width: settings['width'] as int);
        }
        if (settings['height'] is int) {
          dimension = dimension.copyWith(height: settings['height'] as int);
        }
      } catch (_) {
        streamLog.w(
          _tag,
          () => '[publishVideoTrack] `mediaStreamTrack.getSettings()` failed',
        );
      }
    }
    return dimension;
  }
}
