import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/v2/webrtc/peer_connection.dart';
import 'package:stream_video/src/v2/webrtc/peer_type.dart';

class StreamPeerConnectionFactory {
  const StreamPeerConnectionFactory({
    required this.sessionId,
    required this.callCid,
  });

  final String sessionId;
  final String callCid;

  Future<StreamPeerConnection> makeSubscriber(
    RTCConfiguration configuration, [
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    return makePeerConnection(
      type: StreamPeerType.subscriber,
      configuration: configuration,
      mediaConstraints: mediaConstraints,
    );
  }

  Future<StreamPeerConnection> makePublisher(
    RTCConfiguration configuration, [
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    return makePeerConnection(
      type: StreamPeerType.publisher,
      configuration: configuration,
      mediaConstraints: mediaConstraints,
    );
  }

  Future<StreamPeerConnection> makePeerConnection({
    required StreamPeerType type,
    required RTCConfiguration configuration,
    Map<String, dynamic> mediaConstraints = const {},
  }) async {
    final pc = await rtc.createPeerConnection(
      configuration.toMap(),
      mediaConstraints,
    );

    return StreamPeerConnection(
      sessionId: sessionId,
      callCid: callCid,
      type: type,
      pc: pc,
    );
  }
}
