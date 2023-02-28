import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:webrtc_interface/src/rtc_session_description.dart';

import '../disposable.dart';
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
import 'peer_connection.dart';
import 'peer_type.dart';
import 'rtc_parser.dart';
import 'rtc_track/rtc_track.dart';

/// {@template OnPublisherTrackMuted}
/// Callback for when a publisher track is muted.
/// {@endtemplate}
typedef OnPublisherTrackMuted = void Function(RtcLocalTrack track, bool muted);

/// {@template OnSubscriberTrackPublished}
/// Called when a subscriber track is received.
/// {@endtemplate}
typedef OnSubscriberTrackReceived = void Function(
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
    _subscriber.onTrack = _onSubscriberTrack;
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

  set onPublisherNegotiationNeeded(OnRenegotiationNeeded? cb) {
    _publisher.onRenegotiationNeeded = cb;
  }

  OnPublisherTrackMuted? onPublisherTrackMuted;
  OnSubscriberTrackReceived? onSubscriberTrackReceived;

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
    final result = _subscriber.setRemoteOffer(offerSdp);
    if (result is Failure) return null;

    final rtcAnswer = await _subscriber.createAnswer();
    if (rtcAnswer is! Success<RTCSessionDescription>) return null;

    final answerSdp = rtcAnswer.data.sdp;
    return answerSdp;
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

  void _onSubscriberTrack(StreamPeerConnection pc, rtc.RTCTrackEvent event) {
    _logger.d(
      () => '[onSubscriberTrack] event.streams.length: ${event.streams.length}',
    );

    final stream = event.streams.firstOrNull;
    if (stream == null) {
      _logger.w(() => '[onSubscriberTrack] stream is null');
      return;
    }
    _logger.v(() => '[onSubscriberTrack] stream.id: ${stream.id}');

    event.track.onEnded = () {
      _logger.w(() => '[onSubscriberTrack] #onTrackEnded; no args');
    };
    stream.onRemoveTrack = (_) {
      _logger.w(() => '[onSubscriberTrack] #onRemoveTrack; no args');
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

    // Start the track.
    remoteTrack.start();

    publishedTracks[remoteTrack.trackId] = remoteTrack;
    _logger.v(() => '[onSubscriberTrack] published: ${remoteTrack.trackId}');
    onSubscriberTrackReceived?.call(pc, remoteTrack);
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

  @override
  Future<void> dispose() async {
    for (final trackSid in [...publishedTracks.keys]) {
      await unpublishTrack(trackId: trackSid);
    }

    publishedTracks.clear();

    onPublisherTrackMuted = null;
    onSubscriberTrackReceived = null;

    await _publisher.dispose();
    await _subscriber.dispose();

    return super.dispose();
  }

  RtcTrack? getTrack(String trackId) {
    _logger.d(() => '[getTrack] trackId: $trackId');
    _logger.v(() => '[getTrack] publishedTracks: ${publishedTracks.keys}');
    final result = publishedTracks[trackId];
    _logger.v(() => '[getTrack] result: $result');
    return result;
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
      _logger.e(
        () => 'getPublisherTrackByType: track with $trackType not found',
      );
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
        if (encodings == null) {
          videoLayers = [
            RtcVideoLayer(
              rid: 'f',
              bitrate: 0,
              videoDimension: RtcVideoDimension(
                width: dimension.width,
                height: dimension.height,
              ),
            ),
          ];
        } else {
          videoLayers = encodings.map((e) {
            final scale = e.scaleResolutionDownBy ?? 1;
            return RtcVideoLayer(
              rid: e.rid ?? 'f',
              bitrate: e.maxBitrate ?? 0,
              videoDimension: RtcVideoDimension(
                width: (dimension.width / scale).floor(),
                height: (dimension.height / scale).floor(),
              ),
            );
          }).toList();
        }
      }

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

  Future<RtcLocalTrack<AudioConstraints>> publishAudioTrack({
    required RtcLocalTrack<AudioConstraints> track,
    bool stopTrackOnMute = true,
  }) async {
    // Add publisherId to the trackIdPrefix if it's a local track.
    if (track.trackIdPrefix == kLocalTrackIdPrefix) {
      track = track.copyWith(trackIdPrefix: publisherId);
    }

    // Adding early as we need to access it in the onPublisherNegotiationNeeded
    // callback.
    _logger.d(() => '[publishAudioTrack] track: $track');
    publishedTracks[track.trackId] = track;

    final transceiver = await _publisher.addAudioTransceiver(
      stream: track.mediaStream,
      track: track.mediaTrack,
      encodings: [
        rtc.RTCRtpEncoding(rid: 'a', maxBitrate: AudioBitrate.music),
      ],
    );
    _logger.v(() => '[publishAudioTrack] transceiver: $transceiver');

    // Start the track.
    await track.start();

    // Update track with the added transceiver.
    return publishedTracks[track.trackId] = track.copyWith(
      receiver: transceiver.receiver,
      transceiver: transceiver,
      stopTrackOnMute: stopTrackOnMute,
    );
  }

  Future<RtcLocalTrack<VideoConstraints>> publishVideoTrack({
    required RtcLocalTrack<VideoConstraints> track,
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

    final transceiver = await _publisher.addVideoTransceiver(
      stream: track.mediaStream,
      track: track.mediaTrack,
      encodings: encodings,
    );
    _logger.v(() => '[publishVideoTrack] transceiver: $transceiver');

    // Start the track.
    await track.start();

    // Update track with the added transceiver and dimension.
    return publishedTracks[track.trackId] = track.copyWith(
      receiver: transceiver.receiver,
      transceiver: transceiver,
      videoDimension: dimension,
      stopTrackOnMute: stopTrackOnMute,
    );
  }

  Future<void> muteTrack({required String trackId}) async {
    final track = publishedTracks[trackId];
    if (track == null) {
      _logger.w(() => 'muteTrack: track not found');
      return;
    }

    if (track is! RtcLocalTrack) {
      _logger.w(() => 'muteTrack: track is not local');
      return;
    }

    track.disable();
    if (track.stopTrackOnMute) {
      // Releases the track and stops the permission indicator.
      await track.stop();
    }

    return onPublisherTrackMuted?.call(track, true);
  }

  Future<void> unmuteTrack({required String trackId}) async {
    final track = publishedTracks[trackId];
    if (track == null) {
      _logger.w(() => 'unmuteTrack: track not found');
      return;
    }

    if (track is! RtcLocalTrack) {
      _logger.w(() => 'unmuteTrack: track is not local');
      return;
    }

    // If the track was released before, restart it.
    if (track.stopTrackOnMute) {
      final updatedTrack = await restartTrack(track: track);
      return onPublisherTrackMuted?.call(updatedTrack!, false);
    }

    // Otherwise simply enable it again
    track.enable();
    return onPublisherTrackMuted?.call(track, false);
  }

  Future<RtcLocalTrack<AudioConstraints>?> createAudioTrack({
    AudioConstraints constraints = const AudioConstraints(),
  }) async {
    _logger.d(() => '[createAudioTrack] constraints: ${constraints.toMap()}');
    final audioTrack = await RtcLocalTrack.audio(
      trackIdPrefix: publisherId,
      constraints: constraints,
    );

    if (audioTrack == null) {
      _logger.w(() => '[createAudioTrack] rejected (track is null)');
      return null;
    }

    return audioTrack;
  }

  Future<RtcLocalTrack<CameraConstraints>?> createCameraTrack({
    CameraConstraints constraints = const CameraConstraints(),
  }) async {
    _logger.d(() => '[createCameraTrack] constraints: ${constraints.toMap()}');
    final videoTrack = await RtcLocalTrack.camera(
      trackIdPrefix: publisherId,
      constraints: constraints,
    );

    if (videoTrack == null) {
      _logger.w(() => '[createCameraTrack] rejected (track is null)');
      return null;
    }

    return videoTrack;
  }

  Future<RtcLocalTrack<ScreenShareConstraints>?> createScreenShareTrack({
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
  }) async {
    _logger.d(
      () => '[createScreenShareTrack] constraints: ${constraints.toMap()}',
    );
    final screenShareTrack = await RtcLocalTrack.screenShare(
      trackIdPrefix: publisherId,
      constraints: constraints,
    );

    if (screenShareTrack == null) {
      _logger.w(() => '[createScreenShareTrack] rejected (track is null)');
      return null;
    }

    return screenShareTrack;
  }

  Future<RtcLocalTrack?> restartTrack({
    required RtcLocalTrack track,
    MediaConstraints? mediaConstraints,
  }) async {
    final sender = track.transceiver?.sender;
    if (sender == null) {
      _logger.w(() => '[restartTrack] rejected (sender is null)');
      return null;
    }

    final constraints = mediaConstraints ?? track.mediaConstraints;

    // stop if not already stopped...
    await track.stop();

    final newStream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final newTrack = newStream.getTracks().first;

    // replace track on sender
    try {
      await sender.replaceTrack(newTrack);
    } catch (error) {
      _logger.e(() => '[restartTrack] `replaceTrack(...)` failed: $error');
    }

    // Update new stream, track and constraints.
    return publishedTracks[track.trackId] = track.copyWith(
      mediaTrack: newTrack,
      mediaStream: newStream,
      mediaConstraints: constraints,
    );
  }

  Future<RtcLocalTrack?> setTrackFacingMode({
    required FacingMode facingMode,
  }) async {
    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) return null;

    final constraints = track.mediaConstraints;
    if (constraints is! CameraConstraints) {
      _logger.e(() => 'Cannot set facingMode on non-camera track');
      return null;
    }

    // restart with new constraints.
    return restartTrack(
      track: track,
      mediaConstraints: constraints.copyWith(facingMode: facingMode),
    );
  }

  Future<RtcLocalTrack?> setCameraDeviceId({required String deviceId}) async {
    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) {
      _logger.w(() => '[setCameraDeviceId] rejected (track is null)');
      return null;
    }

    final constraints = track.mediaConstraints;
    if (constraints is! CameraConstraints) {
      _logger.e(() => 'Cannot set camera deviceId on non-camera track');
      return null;
    }

    return restartTrack(
      track: track,
      mediaConstraints: constraints.copyWith(
        deviceId: deviceId,
        // Always going to be user on browser which don't supports facingMode.
        facingMode: FacingMode.user,
      ),
    );
  }
}

extension RtcManagerTrackHelper on RtcManager {
  Future<RtcLocalTrack?> flipCamera() async {
    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) {
      _logger.e(() => '[switchCamera] rejected (track is null)');
      return null;
    }

    final constraints = track.mediaConstraints;
    if (constraints is! CameraConstraints) {
      _logger.e(() => 'Cannot switch camera on non-camera track');
      return null;
    }

    if (CurrentPlatform.isWeb) {
      final supported = rtc.navigator.mediaDevices.getSupportedConstraints();
      if (supported.facingMode) {
        final currentFacingMode = constraints.facingMode;
        final flippedFacingMode = currentFacingMode.flip();

        return setTrackFacingMode(facingMode: flippedFacingMode);
      }

      _logger.e(
        () {
          return '''Cannot switch camera facingMode not supported, Use `setCameraDeviceId` instead''';
        },
      );
      return null;
    }

    // Use the native switchCamera method.
    final isFrontCamera = await rtc.Helper.switchCamera(track.mediaTrack);
    return publishedTracks[track.trackId] = track.copyWith(
      mediaConstraints: constraints.copyWith(
        facingMode: isFrontCamera ? FacingMode.user : FacingMode.environment,
      ),
    );
  }

  Future<RtcLocalTrack?> setCameraPosition({
    required CameraPosition cameraPosition,
  }) {
    final facingMode = cameraPosition.toFacingMode();
    return setTrackFacingMode(facingMode: facingMode);
  }

  Future<RtcLocalTrack?> setCameraEnabled({bool enabled = true}) {
    return _setTrackEnabled(
      trackType: SfuTrackType.video,
      enabled: enabled,
    );
  }

  Future<RtcLocalTrack?> setMicrophoneEnabled({bool enabled = true}) {
    return _setTrackEnabled(
      trackType: SfuTrackType.audio,
      enabled: enabled,
    );
  }

  Future<RtcLocalTrack?> setScreenShareEnabled({bool enabled = true}) {
    return _setTrackEnabled(
      trackType: SfuTrackType.screenShare,
      enabled: enabled,
    );
  }

  Future<RtcLocalTrack?> _setTrackEnabled({
    required SfuTrackType trackType,
    required bool enabled,
  }) async {
    final track = getPublisherTrackByType(trackType);

    // Track found, mute/unmute it.
    if (track != null) {
      return _toggleTrackMuteState(track: track, muted: !enabled);
    }

    // Track not found, create a new one and publish it if enabled is true.
    if (enabled) {
      return _createAndPublishTrack(trackType: trackType);
    }

    return null;
  }

  Future<RtcLocalTrack> _toggleTrackMuteState({
    required RtcLocalTrack track,
    required bool muted,
  }) async {
    if (muted) {
      // ScreenShare cannot be muted, Un-publish instead
      if (track.trackType == SfuTrackType.screenShare) {
        await unpublishTrack(trackId: track.trackId);

        // Also un-publish the audio track if it was published
        final screenShareAudioTrack = getPublisherTrackByType(
          SfuTrackType.screenShareAudio,
        );
        if (screenShareAudioTrack != null) {
          await unpublishTrack(trackId: screenShareAudioTrack.trackId);
        }
      } else {
        await muteTrack(trackId: track.trackId);
      }
    } else {
      await unmuteTrack(trackId: track.trackId);
    }

    return track;
  }

  Future<RtcLocalTrack?> _createAndPublishTrack({
    required SfuTrackType trackType,
  }) async {
    if (trackType == SfuTrackType.video) {
      final videoTrack = await createCameraTrack();
      return publishVideoTrack(track: videoTrack!);
    } else if (trackType == SfuTrackType.audio) {
      final audioTrack = await createAudioTrack();
      return publishAudioTrack(track: audioTrack!);
    } else if (trackType == SfuTrackType.screenShare) {
      final screenShareTrack = await createScreenShareTrack();
      return publishVideoTrack(track: screenShareTrack!);
    }

    _logger.e(() => 'Unsupported trackType $trackType');
    return null;
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
