import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../../globals.dart';
import '../../../stream_video.dart';
import '../../errors/video_error.dart';
import '../../telemetry/client_event_reporter.dart';
import '../../telemetry/client_event_types.dart';
import '../../token/token_manager_extension.dart';
import 'coordinator_message_codec.dart';

var _seq = 0;
const _tag = 'SV:CoordinatorWS';

String _buildUrl(String baseUrl, String apiKey) {
  return '$baseUrl'
      '?api_key=$apiKey'
      '&stream-auth-type=jwt'
      '&X-Stream-Client=${Uri.encodeQueryComponent(xStreamClientHeader)}';
}

class CoordinatorWebSocket {
  CoordinatorWebSocket(
    String url, {
    required this.apiKey,
    required this.userInfo,
    required this.tokenManager,
    this.includeUserDetails = false,
    this.clientEventReporter = const ClientEventReporter.noOp(),
    NetworkStateProvider? networkStateProvider,
    RetryPolicy? retryPolicy,
  }) {
    _wsUrl = _buildUrl(url, apiKey);

    _client = StreamWebSocketClient(
      optionsBuilder: () => WebSocketOptions(url: _wsUrl),
      messageCodec: const CoordinatorMessageCodec(),
      onAuthenticate: _authenticateUser,
      pingRequestBuilder: ([info]) =>
          HealthCheckPingEvent(connectionId: info?.connectionId),
    );

    _retryStrategy = retryPolicy != null
        ? _RetryPolicyStrategy(retryPolicy)
        : null;

    _recoveryHandler = ConnectionRecoveryHandler(
      client: _client,
      networkStateProvider: networkStateProvider,
      retryStrategy: _retryStrategy,
    );

    _client.connectionState.listen(_onConnectionStateChanged);
    _client.events.listen(_onWsEvent);
  }

  late final _logger = taggedLogger(tag: '$_tag-${++_seq}');

  final String apiKey;
  final UserInfo userInfo;
  final TokenManager tokenManager;
  final bool includeUserDetails;

  /// Reports the `CoordinatorWS` telemetry stage, which follows this socket's
  /// connection lifecycle.
  final ClientEventReporter clientEventReporter;

  late final StreamWebSocketClient _client;
  late final ConnectionRecoveryHandler _recoveryHandler;
  late final RetryStrategy? _retryStrategy;
  late final String _wsUrl;

  SharedEmitter<CoordinatorEvent> get events => _events;
  final _events = MutableSharedEmitter<CoordinatorEvent>();

  String? _userId;
  String? _connectionId;

  bool _isReconnecting = false;

  final _uuid = const Uuid();

  /// The in-flight `CoordinatorWS` stage id, if a connect attempt is pending.
  String? _coordinatorWsStageId;

  String? get connectionId => _connectionId;

  bool get isConnected => _client.connectionState.value.isConnected;
  bool get isDisconnected {
    final state = _client.connectionState.value;
    return state is Disconnected || state is Initialized;
  }

  Future<Result<None>> connect() async {
    _logger.v(() => '[connect] no args');
    await _client.connect();
    return const Result.success(none);
  }

  Future<Result<None>> disconnect() async {
    _logger.i(() => '[disconnect] no args');
    if (isDisconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return const Result.success(none);
    }
    await _client.disconnect();
    return const Result.success(none);
  }

  Future<void> dispose() => _recoveryHandler.dispose();

  Future<void> _authenticateUser(
    WsRequestSender send,
    StreamApiError? previousError,
  ) async {
    _logger.i(
      () => '[authenticateUser] url: $_wsUrl, previousError: $previousError',
    );

    final tokenRefused = previousError?.isTokenExpiredError ?? false;

    // Mirrors the RpcRetryManager guard: a static provider can only return
    // the token the server just refused, so the credentials cannot change.
    // Throwing fails the attempt for good (AuthenticationFailed) instead of
    // reconnecting with the same dead token.
    if (tokenRefused && tokenManager.usesStaticProvider) {
      _logger.e(
        () =>
            '[authenticateUser] token refused and cannot be refreshed '
            '(static token provider)',
      );
      throw const VideoError(
        message:
            'WS auth token refused and cannot be refreshed '
            '(static token provider)',
      );
    }

    final tokenResult = tokenRefused
        ? await tokenManager.refreshTokenAsResult()
        : await tokenManager.getTokenAsResult();
    final userToken = tokenResult.getDataOrNull();
    if (userToken == null) {
      _logger.e(
        () => '[authenticateUser] token fetch failed — disconnecting to retry',
      );
      unawaited(
        _client.disconnect(source: const DisconnectionSource.systemInitiated()),
      );
      return;
    }

    final sent = send(
      CoordinatorAuthRequest(
        token: userToken.rawValue,
        userId: userInfo.id,
        name: includeUserDetails ? userInfo.name : null,
        image: includeUserDetails ? userInfo.image : null,
        extraData: includeUserDetails
            ? userInfo.extraData
            : <String, dynamic>{},
      ),
    );

    if (sent is Failure) {
      _logger.e(() => '[authenticateUser] sending credentials failed: $sent');
      throw sent.videoError;
    }
  }

  void _onWsEvent(WsEvent wsEvent) {
    if (wsEvent is! CoordinatorWsEvent) return;
    final event = wsEvent.event;
    if (event == null) return; // suppressed

    if (event is CoordinatorConnectedEvent) {
      _logger.i(() => '[onWsEvent] connected: ${event.connectionId}');
      _userId ??= event.userId;
      _connectionId ??= event.connectionId;

      if (_isReconnecting) {
        _isReconnecting = false;
        _events.emit(event);
        _events.emit(
          CoordinatorReconnectedEvent(
            userId: _userId,
            connectionId: _connectionId,
          ),
        );
        return;
      }
    }

    if (event is CoordinatorUnknownEvent) {
      _logger.v(() => '[onWsEvent] unknown event');
      return;
    }

    _events.emit(event);
  }

  void _onConnectionStateChanged(WebSocketConnectionState state) {
    _logger.d(() => '[onConnectionStateChanged] state: $state');

    _reportCoordinatorWsStage(state);

    if (state is! Disconnected) return;

    final source = state.source;
    final wsException = source is ServerInitiated ? source.error : null;

    _events.emit(
      CoordinatorDisconnectedEvent(
        userId: _userId,
        connectionId: _connectionId,
        closeCode: wsException != null && wsException.code != 0
            ? wsException.code
            : null,
        closeReason: wsException != null && wsException.reason != 'Unknown'
            ? wsException.reason
            : null,
      ),
    );
    _userId = null;
    _connectionId = null;

    // Mark as reconnecting for non-user-initiated disconnects so that
    // CoordinatorReconnectedEvent is emitted when the handler reconnects.
    if (source is! UserInitiated) {
      _isReconnecting = true;
    }
  }

  /// Retry count captured when the in-flight `CoordinatorWS` stage began.
  int _coordinatorWsStageRetryCount = 0;

  void _reportCoordinatorWsStage(WebSocketConnectionState state) {
    switch (state) {
      case Connecting():
        if (_coordinatorWsStageId != null) break;
        _coordinatorWsStageRetryCount =
            _retryStrategy?.consecutiveFailuresCount ?? 0;
        final stageId = clientEventReporter.beginConnectionStage(
          ClientEventStage.coordinatorWs,
          connectId: _uuid.v4(),
        );
        _coordinatorWsStageId = stageId.isEmpty ? null : stageId;
      case Connected():
        final stageId = _coordinatorWsStageId;
        if (stageId == null) break;
        _coordinatorWsStageId = null;
        clientEventReporter.completeStage(
          stageId,
          outcome: ClientEventOutcome.success,
          retryCount: _coordinatorWsStageRetryCount,
        );
      case Disconnected(:final source):
        final stageId = _coordinatorWsStageId;
        if (stageId == null) break;
        _coordinatorWsStageId = null;
        clientEventReporter.failStage(
          stageId,
          failure: source is UserInitiated
              ? const ClientEventFailure.clientAborted(
                  'Coordinator WS disconnected',
                )
              : ClientEventFailure(
                  ClientEventStandardCode.serverError,
                  'Coordinator WS disconnected (${source.closeReason})',
                ),
          retryCount: _coordinatorWsStageRetryCount,
        );
      case Initialized() || Authenticating() || Disconnecting():
        break;
    }
  }
}

/// Bridges stream_video's [RetryPolicy] into stream_core's [RetryStrategy]
class _RetryPolicyStrategy implements RetryStrategy {
  _RetryPolicyStrategy(this._policy);

  final RetryPolicy _policy;

  @override
  int get consecutiveFailuresCount => _consecutiveFailuresCount;
  var _consecutiveFailuresCount = 0;

  @override
  void incrementConsecutiveFailures() => _consecutiveFailuresCount++;

  @override
  void resetConsecutiveFailures() => _consecutiveFailuresCount = 0;

  @override
  Duration getNextRetryDelay() => _policy.backoff(_consecutiveFailuresCount);
}

class CallInfo {
  const CallInfo({
    required this.callType,
    required this.callId,
  });

  final String callType;
  final String callId;

  String get callCid => '$callType:$callId';
}
