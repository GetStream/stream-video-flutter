import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../protobuf/video/sfu/models/models.pb.dart';
import '../call/stats/tracer.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../sfu/sfu_extensions.dart';
import '../types/other.dart';
import 'peer_connection.dart';
import 'peer_type.dart';
import 'sdp/editor/sdp_editor.dart';
import 'traced_peer_connection.dart';

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

  Future<TracedStreamPeerConnection> makeSubscriber(
    RTCConfiguration configuration,
    ClientDetails? clientDetails, [
    String? tracerIdPrefix,
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    return makePeerConnection(
      type: StreamPeerType.subscriber,
      configuration: configuration,
      clientDetails: clientDetails,
      tracerIdPrefix: tracerIdPrefix,
      mediaConstraints: mediaConstraints,
    );
  }

  Future<TracedStreamPeerConnection> makePublisher(
    RTCConfiguration configuration,
    ClientDetails? clientDetails, [
    String? tracerIdPrefix,
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    return makePeerConnection(
      type: StreamPeerType.publisher,
      configuration: configuration,
      clientDetails: clientDetails,
      tracerIdPrefix: tracerIdPrefix,
      mediaConstraints: mediaConstraints,
    );
  }

  Future<TracedStreamPeerConnection> makePeerConnection({
    required StreamPeerType type,
    required RTCConfiguration configuration,
    required ClientDetails? clientDetails,
    String? tracerIdPrefix,
    Map<String, dynamic> mediaConstraints = const {},
  }) async {
    _logger.i(
      () => '[createPeerConnection] #$type; configuration: '
          '${configuration.toMap()}, mediaConstraints: $mediaConstraints',
    );
    final pc = await rtc.createPeerConnection(
      configuration.toMap(),
      mediaConstraints,
    );

    final tracer = Tracer(
      "$tracerIdPrefix-${type == StreamPeerType.publisher ? 'pub' : 'sub'}",
    );

    if (clientDetails != null) {
      tracer.trace('clientDetails', clientDetails.toJson());
    }

    tracer.trace('create', configuration.toMap());

    return TracedStreamPeerConnection(
      sessionId: sessionId,
      callCid: callCid,
      type: type,
      pc: pc,
      sdpEditor: sdpEditor,
      tracer: tracer,
    );
  }
}
