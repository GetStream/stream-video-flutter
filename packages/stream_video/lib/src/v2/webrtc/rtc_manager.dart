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
import 'model/rtc_tracks_info.dart';
import 'model/rtc_video_codec.dart';

class RtcManager with Disposable {
  RtcManager({
    required this.sessionId,
    required this.callCid,
    required this.localTrackId,
    required StreamPeerConnection publisher,
    required StreamPeerConnection subscriber,
  })  : _publisher = publisher,
        _subscriber = subscriber {
    _publisher
      ..onIceCandidate = onLocalIceCandidate
      ..onRenegotiationNeeded = onPublisherNegotiationNeeded;
    _subscriber
      ..onIceCandidate = onLocalIceCandidate
      ..onTrack = _onSubscriberTrack;
  }

  final _logger = taggedLogger(tag: 'SV:RtcManager');

  final String sessionId;
  final String callCid;
  final String localTrackId;
  final StreamPeerConnection _publisher;
  final StreamPeerConnection _subscriber;

  final publishedTracks = <String, List<RtcTrack>>{};

  OnIceCandidate? onLocalIceCandidate;
  OnRenegotiationNeeded? onPublisherNegotiationNeeded;

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

    await tempPC.close();

    return sdp!;
  }

  Future<RtcTracksInfo> getPublisherTracks() async {
    return _publisher.getTracksInfo();
  }

  Future<Result<String>> onSubscriberOffer(String offerSdp) async {
    final result = _subscriber.setRemoteOffer(offerSdp);
    if (result is Failure) {
      return result as Failure;
    }
    final rtcAnswer = await _subscriber.createAnswer();
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
      final transceiver = await _publisher.addVideoTransceiver(
        stream: stream,
        track: videoTrack,
      );
      save(stream, videoTrack, transceiver);
    }
    final audioTrack = stream.getAudioTracks().firstOrNull;
    if (audioTrack != null) {
      final transceiver = await _publisher.addAudioTransceiver(
        stream: stream,
        track: audioTrack,
      );
      save(stream, audioTrack, transceiver);
    }
  }

  void save(
    rtc.MediaStream stream,
    rtc.MediaStreamTrack track,
    rtc.RTCRtpTransceiver transceiver,
  ) {
    final remoteTrack = RtcRemoteTrack(
      trackId: track.id ?? "",
      trackType: SfuTrackTypeParser.parseRtcName(track.kind),
      track: track,
      stream: stream,
      transceiver: transceiver,
    );
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
      trackType: SfuTrackTypeParser.parseSfuName(trackType),
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
    publishedTracks.clear();
    await _publisher.dispose();
    await _subscriber.dispose();
    return await super.dispose();
  }

  RtcTrack? getTrack(String trackId) {
    // TODO
    // publishedTracks

    return null;
  }
}
