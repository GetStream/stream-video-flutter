import 'package:uuid/uuid.dart';

import '../../../../protobuf/video/coordinator/edge_v1/edge.pb.dart' as edge;
import '../../../core/utils.dart';
import '../../call_state_manager.dart';
import 'call_session.dart';
import 'call_session_config.dart';

class CallSessionFactory {
  CallSessionFactory({
    required this.currentUserId,
    required this.callCid,
  });

  final String currentUserId;
  final String callCid;

  Future<CallSession> makeCallSession({
    required edge.Credentials credentials,
    required CallStateManager stateManager,
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
      currentUserId: currentUserId,
      callCid: callCid,
      sessionId: sessionId,
      config: sessionConfig,
      stateManager: stateManager,
    );
  }
}
