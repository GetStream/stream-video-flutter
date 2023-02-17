import 'package:uuid/uuid.dart';

import '../../../core/utils.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../types/other.dart';
import '../../call_state_manager.dart';
import '../../model/call_cid.dart';
import '../../model/call_credentials.dart';
import 'call_session.dart';
import 'call_session_config.dart';
import 'call_session_impl.dart';

class CallSessionFactory {
  CallSessionFactory({
    required this.callCid,
  });

  late final _logger = taggedLogger(tag: 'SV:CallSessionFactory');

  final StreamCallCid callCid;

  Future<CallSession> makeCallSession({
    required CallCredentials credentials,
    required CallStateManager stateManager,
  }) async {
    final sessionId = const Uuid().v4();
    _logger.d(() => '[makeCallSession] sessionId: $sessionId');
    final rtcConfig = _makeRtcConfig(credentials.iceServers) ??
        defaultRtcConfiguration(credentials.sfuServer.url);
    final sessionConfig = CallSessionConfig(
      sfuUrl: credentials.sfuServer.url,
      sfuToken: credentials.sfuToken,
      rtcConfig: rtcConfig,
    );
    _logger.v(() => '[makeCallSession] sfuUrl: ${sessionConfig.sfuUrl}');
    return CallSessionImpl(
      callCid: callCid,
      sessionId: sessionId,
      config: sessionConfig,
      stateManager: stateManager,
    );
  }

  RTCConfiguration? _makeRtcConfig(
    Iterable<CallIceServer>? config,
  ) {
    if (config == null || config.isEmpty) return null;
    return RTCConfiguration(
      iceServers: [
        ...config.map(
          (it) => RTCIceServer(
            urls: it.urls,
            username: it.username,
            credential: it.password,
          ),
        ),
      ],
    );
  }
}
