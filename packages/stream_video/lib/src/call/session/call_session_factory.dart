import 'dart:math';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../stream_video.dart';
import '../../core/utils.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/sdp/editor/sdp_editor.dart';
import '../state/call_state_notifier.dart';
import '../stats/trace_record.dart';
import '../stats/tracer.dart';
import 'call_session.dart';
import 'call_session_config.dart';

class CallSessionFactory {
  CallSessionFactory({
    required this.callCid,
    required this.sdpEditor,
  });

  late final _logger = taggedLogger(tag: 'SV:CallSessionFactory');

  final StreamCallCid callCid;
  final SdpEditor sdpEditor;

  /// Creates a new [CallSession] instance.
  /// If [sessionId] is not provided, a new UUID will be generated.
  /// [sessionSeq] is used for logging and tracing purposes. It should be incremented
  /// for each new session created for the same call.
  /// [credentials] are required to connect to the SFU.
  /// [stateManager] manages the state of the call.
  /// [dynascaleManager] manages dynascale operations.
  /// [onReconnectionNeeded] is a callback invoked when reconnection is needed
  /// because of PeerConnection issues.
  /// [networkMonitor] monitors the internet connection.
  /// [statsOptions] configures the statistics reporting.
  /// [streamVideo] is the main StreamVideo instance.
  /// [clientPublishOptions] are optional publish options for the client.
  /// [leftoverTraceRecords] are trace records from previous sessions that were not sent
  /// before the session ended. They will be included in the new session's trace.
  Future<CallSession> makeCallSession({
    String? sessionId,
    int sessionSeq = 0,
    required CallCredentials credentials,
    required CallStateNotifier stateManager,
    required DynascaleManager dynascaleManager,
    required OnReconnectionNeeded onReconnectionNeeded,
    required InternetConnection networkMonitor,
    required StatsOptions statsOptions,
    required StreamVideo streamVideo,
    ClientPublishOptions? clientPublishOptions,
    List<TraceRecord> leftoverTraceRecords = const [],
  }) async {
    final finalSessionId = sessionId ?? const Uuid().v4();
    _logger.d(() => '[makeCallSession] sessionId: $finalSessionId($sessionId)');

    final rtcConfig =
        _makeRtcConfig(credentials.iceServers) ??
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

    final tracer = Tracer('$sessionSeq-$sfuName')
      ..setEnabled(statsOptions.enableRtcStats)
      ..traceMultiple(
        leftoverTraceRecords
            .map(
              (r) => r.copyWith(
                id: '${max(0, sessionSeq - 1)}-$sfuName',
              ),
            )
            .toList(),
      );

    return CallSession(
      sessionSeq: sessionSeq,
      callCid: callCid,
      sessionId: finalSessionId,
      config: sessionConfig,
      stateManager: stateManager,
      dynascaleManager: dynascaleManager,
      sdpEditor: sdpEditor,
      onReconnectionNeeded: onReconnectionNeeded,
      clientPublishOptions: clientPublishOptions,
      networkMonitor: networkMonitor,
      statsOptions: statsOptions,
      streamVideo: streamVideo,
      tracer: tracer,
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
