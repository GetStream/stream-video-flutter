import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/call/session/call_session_config.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/core/utils.dart';
import 'package:stream_video/src/logger/impl/tagged_logger.dart';
import 'package:stream_video/src/models/call_cid.dart';
import 'package:stream_video/src/models/call_credentials.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/webrtc/sdp/editor/sdp_editor.dart';
import 'package:uuid/uuid.dart';

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
    required OnFullReconnectNeeded onFullReconnectNeeded,
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
      sdpEditor: sdpEditor,
      onFullReconnectNeeded: onFullReconnectNeeded,
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
