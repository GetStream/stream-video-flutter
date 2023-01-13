import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/v2/errors/video_error.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_model_parser.dart';
import 'package:stream_video/src/v2/utils/result.dart';
import 'package:stream_video/src/v2/utils/result_converters.dart';
import 'package:stream_video/src/v2/webrtc/peer_connection.dart';
import 'package:stream_video/src/v2/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/v2/webrtc/peer_type.dart';
import 'package:stream_video/src/v2/webrtc/rtc_parser.dart';
import 'package:stream_video/src/v2/webrtc/rtc_track.dart';
import 'package:webrtc_interface/src/rtc_session_description.dart';

import '../../disposable.dart';
import '../../logger/stream_logger.dart';
import 'media/media_constraints.dart';

class RtcManager extends Disposable {
  RtcManager._({
    required this.sessionId,
    required this.callCid,
    required this.configuration,
  }) : pcFactory = StreamPeerConnectionFactory(
          sessionId: sessionId,
          callCid: callCid,
        );

  static Future<RtcManager> create({
    required String sessionId,
    required String callCid,
    required RTCConfiguration configuration,
  }) async {
    // Call the private constructor
    final instance = RtcManager._(
      sessionId: sessionId,
      callCid: callCid,
      configuration: configuration,
    );
    await instance._init();
    return instance;
  }

  final _logger = taggedLogger(tag: 'SV:RtcManager');

  final String sessionId;
  final String callCid;
  final RTCConfiguration configuration;
  final StreamPeerConnectionFactory pcFactory;

  late final StreamPeerConnection publisher;
  late final StreamPeerConnection subscriber;

  final publishedTracks = <String, List<RtcTrack>>{};

  Future<RtcManager> _init() async {
    publisher = await pcFactory.makePublisher(configuration);
    subscriber = await pcFactory.makeSubscriber(configuration)
      ..onTrack = _onSubscriberTrack;
    return this;
  }

  Future<Result<String>> onSubscriberOffer(String offerSdp) async {
    final result = subscriber.setRemoteOffer(offerSdp);
    if (result is Failure) {
      return result as Failure;
    }
    final rtcAnswer = await subscriber.createAnswer();
    if (rtcAnswer is! Success<RTCSessionDescription>) {
      return rtcAnswer as Failure;
    }
    final answerSdp = rtcAnswer.data.sdp;
    if (answerSdp == null) {
      return Failure(
        VideoError(message: '[onSubscriberOffer] answerSdp is null'),
      );
    }
    return answerSdp.toSuccess();
  }

  Future<void> publishTrack({
    required MediaConstraints mediaConstraints,
  }) async {
    final stream = await rtc.navigator.mediaDevices.getMedia(mediaConstraints);
    final videoTrack = stream.getVideoTracks().firstOrNull;
    if (videoTrack != null) {
      await publisher.addVideoTransceiver(
        stream: stream,
        track: videoTrack,
      );
    }
    final audioTrack = stream.getAudioTracks().firstOrNull;
    if (audioTrack != null) {
      await publisher.addAudioTransceiver(
        stream: stream,
        track: audioTrack,
      );
    }
  }

  void onRemoteIceCandidate({
    required StreamPeerType peerType,
    required String iceCandidate,
  }) {
    final candidate = RtcIceCandidateParser.fromJsonString(iceCandidate);
    if (peerType == StreamPeerType.publisher) {
      publisher.addIceCandidate(candidate);
    } else if (peerType == StreamPeerType.subscriber) {
      subscriber.addIceCandidate(candidate);
    }
  }

  void _onSubscriberTrack(StreamPeerConnection pc, rtc.RTCTrackEvent event) {
    _logger.d(() => '[onSubscriberTrack] event: $event');

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
      trackType: SfuTrackTypeParser.parse(trackType),
      track: track,
      stream: stream,
      receiver: receiver,
      transceiver: transceiver,
    );

    final participantTracks = (publishedTracks[trackId] ?? [])
      ..add(remoteTrack);
    publishedTracks[trackId] = participantTracks;
  }

  Future<void> dispose() async {
    await publisher.dispose();
    await subscriber.dispose();
    return await super.dispose();
  }
}
