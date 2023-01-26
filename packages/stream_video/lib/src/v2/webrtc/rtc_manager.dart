import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import "package:webrtc_interface/src/rtc_session_description.dart";

import '../../disposable.dart';
import '../../logger/stream_logger.dart';
import '../../platform_detector/platform_detector.dart';
import '../model/call_cid.dart';
import '../sfu/data/models/sfu_model_parser.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../utils/result.dart';
import 'codecs_helper.dart' as codecs;
import 'media/constraints/camera_position.dart';
import 'media/constraints/facing_mode.dart';
import 'media/media_constraints.dart';
import 'model/rtc_tracks_info.dart';
import 'model/rtc_video_dimension.dart';
import 'peer_connection.dart';
import 'peer_type.dart';
import 'rtc_parser.dart';
import 'rtc_track.dart';
import 'rtc_track_publish_options.dart';

/// {@template OnPublisherTrackMuted}
/// Callback for when a publisher track is muted.
/// {@endtemplate}
typedef OnPublisherTrackMuted = void Function(RtcLocalTrack track, bool muted);

/// {@template OnSubscriberTrackPublished}
/// Called when a subscriber track is published.
/// {@endtemplate}
typedef OnSubscriberTrackPublished = void Function(
  StreamPeerConnection pc,
  RtcRemoteTrack track,
);

class RtcManager extends Disposable {
  RtcManager({
    required this.sessionId,
    required this.callCid,
    required this.publisherId,
    required StreamPeerConnection publisher,
    required StreamPeerConnection subscriber,
  })  : _publisher = publisher,
        _subscriber = subscriber {
    _publisher
      ..onIceCandidate = onPublisherIceCandidate
      ..onRenegotiationNeeded = onPublisherNegotiationNeeded;
    _subscriber
      ..onIceCandidate = onSubscriberIceCandidate
      ..onTrack = _onSubscriberTrack;
  }

  final _logger = taggedLogger(tag: 'SV:RtcManager');

  final String sessionId;
  final StreamCallCid callCid;
  final String publisherId;
  final StreamPeerConnection _publisher;
  final StreamPeerConnection _subscriber;

  final publishedTracks = < /*trackSid*/ String, RtcTrack>{};

  OnIceCandidate? onPublisherIceCandidate;
  OnIceCandidate? onSubscriberIceCandidate;
  OnRenegotiationNeeded? onPublisherNegotiationNeeded;
  OnPublisherTrackMuted? onPublisherTrackMuted;
  OnSubscriberTrackPublished? onSubscriberTrackPublished;

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

  void onRemoteIceCandidate({
    required StreamPeerType peerType,
    required String iceCandidate,
  }) {
    final candidate = RtcIceCandidateParser.fromJsonString(iceCandidate);
    if (peerType == StreamPeerType.publisher) {
      _publisher.addIceCandidate(candidate);
    } else if (peerType == StreamPeerType.subscriber) {
      _subscriber.addIceCandidate(candidate);
    }
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
      trackId: trackId,
      trackType: SfuTrackTypeParser.parseSfuName(trackType),
      track: track,
      stream: stream,
      receiver: receiver,
      transceiver: transceiver,
    );

    publishedTracks[remoteTrack.trackSid] = remoteTrack;
    _logger.v(() => '[onSubscriberTrack] published: ${remoteTrack.trackSid}');
    onSubscriberTrackPublished?.call(pc, remoteTrack);
  }

  Future<void> unpublishTrack({required String trackSid}) async {
    final publishedTrack = publishedTracks.remove(trackSid);
    if (publishedTrack == null) {
      _logger.w(() => 'unpublishTrack: track not found');
      return;
    }

    publishedTrack.track.enabled = false;
    if (publishedTrack is RtcLocalTrack) {
      await publishedTrack.track.stop();
      await publishedTrack.stream.dispose();
    }

    final sender = publishedTrack.transceiver?.sender;
    if (sender != null) {
      try {
        await _publisher.pc.removeTrack(sender);
      } catch (_) {
        _logger.w(() => 'unpublishTrack: removeTrack failed');
      }
    }
  }

  @override
  Future<void> dispose() async {
    for (final trackSid in publishedTracks.keys) {
      await unpublishTrack(trackSid: trackSid);
    }

    publishedTracks.clear();

    onPublisherTrackMuted = null;

    _publisher
      ..onIceCandidate = null
      ..onRenegotiationNeeded = null;
    await _publisher.dispose();

    _subscriber
      ..onTrack = null
      ..onIceCandidate = null;
    await _subscriber.dispose();

    return super.dispose();
  }

  RtcTrack? getTrack(String trackSid) {
    _logger.d(() => '[getTrack] trackSid: $trackSid');
    _logger.v(() => '[getTrack] publishedTracks: ${publishedTracks.keys}');
    return publishedTracks[trackSid];
  }

  List<RtcTrack> getTracks(String trackId) {
    return [
      ...publishedTracks.values.where((track) {
        return track.trackId == trackId;
      }),
    ];
  }
}

extension PublisherRtcManager on RtcManager {
  List<RtcLocalTrack> getPublisherTracks() {
    return [...publishedTracks.values.whereType<RtcLocalTrack>()];
  }

  RtcLocalTrack? getPublisherTrackByType(SfuTrackType trackType) {
    final audioTrack = getPublisherTracks().firstWhereOrNull((track) {
      return track.trackType == trackType;
    });

    if (audioTrack == null) {
      _logger.e(
        () => 'getPublisherTrackByType: track with $trackType not found',
      );
      return null;
    }

    return audioTrack;
  }

  List<RtcTrackInfo> getPublisherTrackInfos() {
    return getPublisherTracks().map((it) {
      List<RtcVideoLayer>? videoLayers;

      // Calculate video layers for video tracks.
      if (it.isVideoTrack) {
        final dimension = it.videoDimension!;
        final encodings = it.transceiver?.sender.parameters.encodings;

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
        trackId: it.track.id,
        trackType: it.trackType,
        mid: it.transceiver?.mid,
        layers: videoLayers,
      );
    }).toList();
  }

  Future<RtcLocalTrack<AudioConstraints>> publishAudioTrack({
    required RtcLocalTrack<AudioConstraints> track,
    AudioTrackPublishOptions options = const AudioTrackPublishOptions(),
  }) async {
    final transceiver = await _publisher.addAudioTransceiver(
      stream: track.stream,
      track: track.track,
      encodings: [
        if (options.audioBitrate > 0)
          rtc.RTCRtpEncoding(maxBitrate: options.audioBitrate),
      ],
    );

    final publishedTrack = track.copyWith(
      receiver: transceiver.receiver,
      transceiver: transceiver,
    );

    publishedTracks[publishedTrack.trackSid] = publishedTrack;

    return publishedTrack;
  }

  Future<RtcLocalTrack<VideoConstraints>> publishVideoTrack({
    required RtcLocalTrack<VideoConstraints> track,
    VideoTrackPublishOptions options = const VideoTrackPublishOptions(),
  }) async {
    // use constraints passed to getUserMedia by default
    var dimension = track.mediaConstraints.params.dimension;

    if (CurrentPlatform.isWeb) {
      // getSettings() is only implemented for Web
      try {
        // try to use getSettings for more accurate resolution
        final settings = track.track.getSettings();
        if (settings['width'] is int) {
          dimension = dimension.copyWith(width: settings['width'] as int);
        }
        if (settings['height'] is int) {
          dimension = dimension.copyWith(height: settings['height'] as int);
        }
      } catch (_) {
        _logger.w(() => 'Failed to call `mediaStreamTrack.getSettings()`');
      }
    }

    _logger.i(() {
      return 'Compute encodings with resolution: $dimension, options: $options';
    });

    // Video encodings and simulcasts
    final encodings = codecs.computeVideoEncodings(
      isScreenShare: track.trackType == SfuTrackType.screenShare,
      dimension: dimension,
      options: options,
    );

    final transceiver = await _publisher.addVideoTransceiver(
      stream: track.stream,
      track: track.track,
      encodings: encodings,
    );

    final publishedTrack = track.copyWith(
      receiver: transceiver.receiver,
      transceiver: transceiver,
      videoDimension: dimension,
    );

    publishedTracks[publishedTrack.trackSid] = publishedTrack;

    return publishedTrack;
  }

  Future<void> muteTrack({required String trackSid}) async {
    final track = publishedTracks[trackSid];
    if (track == null) {
      _logger.w(() => 'muteTrack: track not found');
      return;
    }

    if (track is! RtcLocalTrack) {
      _logger.w(() => 'muteTrack: track is not local');
      return;
    }

    final updatedTrack = track.copyWith(muted: true);
    updatedTrack.track.enabled = false;
    await updatedTrack.track.stop();
    await updatedTrack.stream.dispose();

    publishedTracks[trackSid] = updatedTrack;

    return onPublisherTrackMuted?.call(updatedTrack, true);
  }

  Future<void> unmuteTrack({required String trackSid}) async {
    final track = publishedTracks[trackSid];
    if (track == null) {
      _logger.w(() => 'unmuteTrack: track not found');
      return;
    }

    if (track is! RtcLocalTrack) {
      _logger.w(() => 'unmuteTrack: track is not local');
      return;
    }

    final updatedTrack = track.copyWith(muted: false);
    updatedTrack.track.enabled = true;
    await restartTrack(track: updatedTrack);

    publishedTracks[trackSid] = updatedTrack;

    return onPublisherTrackMuted?.call(updatedTrack, false);
  }

  Future<RtcLocalTrack<AudioConstraints>?> createAudioTrack({
    AudioConstraints constraints = const AudioConstraints(),
  }) async {
    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final audioTrack = stream.getAudioTracks().firstOrNull;

    if (audioTrack == null) return null;

    final track = RtcLocalTrack(
      trackId: publisherId,
      trackType: SfuTrackType.audio,
      stream: stream,
      track: audioTrack,
      mediaConstraints: constraints,
    );

    return track;
  }

  Future<RtcLocalTrack<CameraConstraints>?> createCameraTrack({
    CameraConstraints constraints = const CameraConstraints(),
  }) async {
    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final videoTrack = stream.getVideoTracks().firstOrNull;

    if (videoTrack == null) return null;

    final track = RtcLocalTrack(
      trackId: publisherId,
      trackType: SfuTrackType.video,
      stream: stream,
      track: videoTrack,
      mediaConstraints: constraints,
    );

    return track;
  }

  Future<RtcLocalTrack<ScreenShareConstraints>?> createScreenShareTrack({
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
  }) async {
    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final videoTrack = stream.getVideoTracks().firstOrNull;

    if (videoTrack == null) return null;

    final track = RtcLocalTrack(
      trackId: publisherId,
      trackType: SfuTrackType.screenShare,
      stream: stream,
      track: videoTrack,
      mediaConstraints: constraints,
    );

    return track;
  }

  Future<List<RtcLocalTrack>> createScreenShareTrackWithAudio({
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
  }) async {
    final tracks = <RtcLocalTrack>[];

    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final videoTrack = stream.getVideoTracks().firstOrNull;

    if (videoTrack == null) return tracks;

    tracks.add(
      RtcLocalTrack(
        trackId: publisherId,
        trackType: SfuTrackType.screenShare,
        stream: stream,
        track: videoTrack,
        mediaConstraints: constraints,
      ),
    );

    final audioTrack = stream.getAudioTracks().firstOrNull;
    if (audioTrack != null) {
      tracks.add(
        RtcLocalTrack(
          trackId: publisherId,
          trackType: SfuTrackType.screenShareAudio,
          stream: stream,
          track: audioTrack,
          mediaConstraints: constraints,
        ),
      );
    }

    return tracks;
  }

  Future<RtcLocalTrack?> restartTrack({
    required RtcLocalTrack track,
    MediaConstraints? mediaConstraints,
  }) async {
    final sender = track.transceiver?.sender;
    if (sender == null) return null;

    final constraints = mediaConstraints ?? track.mediaConstraints;

    // stop if not already stopped...
    await track.track.stop();
    await track.stream.dispose();

    final newStream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final newTrack = newStream.getTracks().first;

    // replace track on sender
    try {
      await sender.replaceTrack(newTrack);
    } catch (error) {
      _logger.e(() => 'replaceTrack() did throw $error');
    }

    // Update new stream and track.
    return publishedTracks[track.trackSid] = track.copyWith(
      track: newTrack,
      stream: newStream,
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
}

extension SubscriberRtcManager on RtcManager {
  void subscribeTrack() {
    // TODO: implement subscribeTrack
  }

  void unsubscribeTrack() {
    // TODO: implement unsubscribeTrack
  }
}

extension RtcManagerTrackHelper on RtcManager {
  Future<RtcLocalTrack?> setCameraPosition({
    required CameraPosition cameraPosition,
  }) {
    final facingMode = cameraPosition == CameraPosition.front
        ? FacingMode.user
        : FacingMode.environment;

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
        await unpublishTrack(trackSid: track.trackSid);

        // Also un-publish the audio track if it was published
        final screenShareAudioTrack = getPublisherTrackByType(
          SfuTrackType.screenShareAudio,
        );
        if (screenShareAudioTrack != null) {
          await unpublishTrack(trackSid: screenShareAudioTrack.trackSid);
        }
      } else {
        await muteTrack(trackSid: track.trackSid);
      }
    } else {
      await unmuteTrack(trackSid: track.trackSid);
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
