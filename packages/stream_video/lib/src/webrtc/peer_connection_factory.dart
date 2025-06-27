import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../open_api/video/coordinator/api.dart';
import '../../protobuf/video/sfu/models/models.pb.dart';
import '../call/session/call_session_config.dart';
import '../call/stats/tracer.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../sfu/sfu_client.dart';
import '../types/other.dart';
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
    SfuClient sfuClient,
    RTCConfiguration configuration,
    ClientDetails? clientDetails, [
    String? tracerIdPrefix,
    Map<String, dynamic> mediaConstraints = const {},
    StatsOptions? statsOptions,
    CallSessionConfig? callSessionConfig,
  ]) async {
    return makePeerConnection(
      sfuClient: sfuClient,
      type: StreamPeerType.subscriber,
      configuration: configuration,
      clientDetails: clientDetails,
      tracerIdPrefix: tracerIdPrefix,
      mediaConstraints: mediaConstraints,
      statsOptions: statsOptions,
      callSessionConfig: callSessionConfig,
    );
  }

  Future<TracedStreamPeerConnection> makePublisher(
    SfuClient sfuClient,
    RTCConfiguration configuration,
    ClientDetails? clientDetails, [
    String? tracerIdPrefix,
    Map<String, dynamic> mediaConstraints = const {},
    StatsOptions? statsOptions,
    CallSessionConfig? callSessionConfig,
  ]) async {
    return makePeerConnection(
      sfuClient: sfuClient,
      type: StreamPeerType.publisher,
      configuration: configuration,
      clientDetails: clientDetails,
      tracerIdPrefix: tracerIdPrefix,
      mediaConstraints: mediaConstraints,
      statsOptions: statsOptions,
      callSessionConfig: callSessionConfig,
    );
  }

  Future<TracedStreamPeerConnection> makePeerConnection({
    required SfuClient sfuClient,
    required StreamPeerType type,
    required RTCConfiguration configuration,
    required ClientDetails? clientDetails,
    String? tracerIdPrefix,
    Map<String, dynamic> mediaConstraints = const {},
    StatsOptions? statsOptions,
    CallSessionConfig? callSessionConfig,
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

    tracer.setEnabled(statsOptions?.enableRtcStats ?? false);

    tracer.trace(
      'create',
      configuration.toMap()
        ..addAll(
          {
            'url': callSessionConfig?.sfuName,
          },
        ),
    );

    return TracedStreamPeerConnection(
      sfuClient: sfuClient,
      sessionId: sessionId,
      callCid: callCid,
      type: type,
      pc: pc,
      sdpEditor: sdpEditor,
      tracer: tracer,
    );
  }
}
