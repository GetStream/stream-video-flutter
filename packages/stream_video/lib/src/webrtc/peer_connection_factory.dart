import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/peer_type.dart';

import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import 'sdp/editor/sdp_editor.dart';

class StreamPeerConnectionFactory {
  StreamPeerConnectionFactory({
    required this.sessionId,
    required this.callCid,
    required this.sdpEditor,
  });

  final _logger = taggedLogger(tag: 'SV:PeerConnectionFactory');

  final String sessionId;
  final StreamCallCid callCid;
  final SdpEditor sdpEditor;

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
    _logger.i(() => '[createPeerConnection] #$type; configuration: '
        '${configuration.toMap()}, mediaConstraints: $mediaConstraints');
    final pc = await rtc.createPeerConnection(
      configuration.toMap(),
      mediaConstraints,
    );

    return StreamPeerConnection(
      sessionId: sessionId,
      callCid: callCid,
      type: type,
      pc: pc,
      sdpEditor: sdpEditor,
    );
  }
}
