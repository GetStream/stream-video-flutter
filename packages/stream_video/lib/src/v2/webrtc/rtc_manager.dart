import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/src/logger/stream_logger.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/v2/errors/video_error.dart';
import 'package:stream_video/src/v2/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_model_parser.dart';
import 'package:stream_video/src/v2/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/v2/utils/result.dart';
import 'package:stream_video/src/v2/utils/result_converters.dart';
import 'package:stream_video/src/v2/utils/result_operators.dart';
import 'package:stream_video/src/v2/webrtc/peer_connection.dart';
import 'package:stream_video/src/v2/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/v2/webrtc/peer_type.dart';
import 'package:stream_video/src/v2/webrtc/rtc_parser.dart';
import 'package:stream_video/src/v2/webrtc/rtc_track.dart';
import 'package:webrtc_interface/src/rtc_session_description.dart';

class RtcManager {
  RtcManager(this.configuration);

  final _logger = taggedLogger(tag: 'SV:RtcManager');

  final RTCConfiguration configuration;

  late final StreamPeerConnectionFactory pcFactory;

  late StreamPeerConnection publisher;

  late StreamPeerConnection subscriber;

  final tracks = <String, List<RtcTrack>>{};

  Future<void> init(RTCConfiguration configuration) async {
    publisher = await pcFactory.makePublisher(configuration);
    subscriber = await pcFactory.makeSubscriber(configuration)
      ..onTrack = _onSubscriberTrack;
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

  void onRemoteIceCandidate(
    StreamPeerType peerType,
    String jsonIceCandidate,
  ) {
    final candidate = RtcIceCandidateParser.fromJsonString(jsonIceCandidate);
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

    final participantTracks = (tracks[trackId] ?? [])..add(remoteTrack);
    tracks[trackId] = participantTracks;
  }
}
