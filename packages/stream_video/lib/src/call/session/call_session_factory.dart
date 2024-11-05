import 'package:uuid/uuid.dart';

import '../../core/utils.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/call_cid.dart';
import '../../models/call_credentials.dart';
import '../../types/other.dart';
import '../../webrtc/sdp/editor/sdp_editor.dart';
import '../state/call_state_notifier.dart';
import 'call_session.dart';
import 'call_session_config.dart';
import 'dynascale_manager.dart';

int _sessionSeq = 1;

class CallSessionFactory {
  CallSessionFactory({
    required this.callCid,
    required this.sdpEditor,
  });

  late final _logger = taggedLogger(tag: 'SV:CallSessionFactory');

  final StreamCallCid callCid;
  final SdpEditor sdpEditor;

  Future<CallSession> makeCallSession({
    String? sessionId,
    required CallCredentials credentials,
    required CallStateNotifier stateManager,
    required DynascaleManager dynascaleManager,
    required OnPeerConnectionIssue onPeerConnectionFailure,
  }) async {
    final finalSessionId = sessionId ?? const Uuid().v4();
    _logger.d(() => '[makeCallSession] sessionId: $finalSessionId($sessionId)');

    final rtcConfig = _makeRtcConfig(credentials.iceServers) ??
        defaultRtcConfiguration(credentials.sfuServer.url);

    final sessionConfig = CallSessionConfig(
      sfuName: credentials.sfuServer.name,
      sfuUrl: credentials.sfuServer.url,
      sfuWsEndpoint: credentials.sfuServer.wsEndpoint,
      sfuToken: credentials.sfuToken,
      rtcConfig: rtcConfig,
    );

    final sfuName = sessionConfig.sfuName;
    final sfuUrl = sessionConfig.sfuUrl;
    _logger.v(() => '[makeCallSession] sfuName: $sfuName, sfuUrl: $sfuUrl');

    return CallSession(
      sessionSeq: _sessionSeq++,
      callCid: callCid,
      sessionId: finalSessionId,
      config: sessionConfig,
      stateManager: stateManager,
      dynascaleManager: dynascaleManager,
      sdpEditor: sdpEditor,
      onPeerConnectionIssue: onPeerConnectionFailure,
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
