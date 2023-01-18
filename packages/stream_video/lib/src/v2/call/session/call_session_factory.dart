import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/protobuf/video/coordinator/edge_v1/edge.pb.dart'
    as edge;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/logger/stream_logger.dart';
import 'package:stream_video/src/options.dart';
import 'package:stream_video/src/v2/call_state.dart';
import 'package:stream_video/src/v2/state_emitter.dart';
import 'package:stream_video/src/v2/utils/result.dart';
import 'package:uuid/uuid.dart';

import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import '../../../../protobuf/video/coordinator/edge_v1/edge.pb.dart' as edge;
import '../../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../core/utils.dart';
import '../../../disposable.dart';
import '../../../latency_service/latency.dart';
import '../../../logger/stream_logger.dart';
import '../../../sfu-client/sfu_client.dart';
import '../../coordinator/coordinator_client.dart';
import '../../coordinator/ws/coordinator_ws.dart';
import '../../errors/video_error.dart';
import '../../errors/video_error_composer.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_call_state.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/data/models/sfu_model_parser.dart';
import '../../sfu/sfu_client.dart';
import '../../sfu/sfu_client_impl.dart';
import '../../sfu/ws/sfu_event_listener.dart';
import '../../sfu/ws/sfu_ws.dart';
import '../../shared_emitter.dart';
import '../../utils/result.dart';
import '../../utils/result_converters.dart';
import '../../webrtc/model/rtc_tracks_info.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/peer_type.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_manager_factory.dart';
import '../call_settings.dart';
import 'call_session.dart';
import 'call_session_config.dart';

class CallSessionFactory {
  CallSessionFactory({
    required this.callCid,
  });

  final String callCid;

  Future<CallSession> makeCallSession({
    required edge.Credentials credentials,
  }) async {
    final sessionId = const Uuid().v4();

    final sfuUrl = credentials.server.url;
    final sfuToken = credentials.token;
    final iceServers = credentials.iceServers;

    final rtcConfig = rtcConfigurationFromICEServers(iceServers) ??
        defaultRtcConfiguration(sfuUrl);
    final sessionConfig = CallSessionConfig(
      sfuUrl: sfuUrl,
      sfuToken: sfuToken,
      rtcConfig: rtcConfig,
    );

    return CallSession(
      callCid: callCid,
      sessionId: sessionId,
      config: sessionConfig,
    );
  }
}
