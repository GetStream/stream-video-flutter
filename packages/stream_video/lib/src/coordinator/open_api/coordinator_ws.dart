import 'dart:async';

import '../../../globals.dart';
import '../../../stream_video.dart';
import '../../token/token_manager.dart';
import 'coordinator_message_codec.dart';

var _seq = 0;
const _tag = 'SV:CoordinatorWS';

String _buildUrl(String baseUrl, String apiKey) {
  return '$baseUrl'
      '?api_key=$apiKey'
      '&stream-auth-type=jwt'
      '&X-Stream-Client=$xStreamClientHeader';
}

class CoordinatorWebSocket {
  CoordinatorWebSocket(
    String url, {
    Iterable<String>? protocols,
    required this.apiKey,
    required this.userInfo,
    required this.tokenManager,
    this.includeUserDetails = false,
    NetworkStateProvider? networkStateProvider,
    RetryPolicy? retryPolicy,
  }) {
    final wsUrl = _buildUrl(url, apiKey);

    _client = StreamWebSocketClient(
      options: WebSocketOptions(url: wsUrl, protocols: protocols),
      messageCodec: CoordinatorMessageCodec(
        onTokenError: () => _refreshToken = true,
      ),
      onConnectionEstablished: _authenticateUser,
      pingRequestBuilder: ([info]) =>
          HealthCheckPingEvent(connectionId: info?.connectionId),
    );

    _recoveryHandler = ConnectionRecoveryHandler(
      client: _client,
      networkStateProvider: networkStateProvider,
      retryStrategy: retryPolicy != null
          ? _RetryPolicyStrategy(retryPolicy)
          : null,
    );

    _client.connectionState.listen(_onConnectionStateChanged);
    _client.events.listen(_onWsEvent);
  }

  late final _logger = taggedLogger(tag: '$_tag-${++_seq}');

  final String apiKey;
  final UserInfo userInfo;
  final TokenManager tokenManager;
  final bool includeUserDetails;

  late final StreamWebSocketClient _client;
  late final ConnectionRecoveryHandler _recoveryHandler;

  SharedEmitter<CoordinatorEvent> get events => _events;
  final _events = MutableSharedEmitter<CoordinatorEvent>();

  String? _userId;
  String? _connectionId;

  bool _refreshToken = false;
  bool _isReconnecting = false;

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

  Future<void> _authenticateUser() async {
    _logger.i(() => '[authenticateUser] url: ${_client.options.url}');
    final tokenResult = await tokenManager.getToken(refresh: _refreshToken);
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
    final token = userToken.rawValue;
    _client.send(
      CoordinatorAuthRequest(
        token: token,
        userId: userInfo.id,
        name: includeUserDetails ? userInfo.name : null,
        image: includeUserDetails ? userInfo.image : null,
        extraData: includeUserDetails
            ? userInfo.extraData
            : <String, dynamic>{},
      ),
    );
  }

  void _onWsEvent(WsEvent wsEvent) {
    if (wsEvent is! CoordinatorWsEvent) return;
    final event = wsEvent.event;
    if (event == null) return; // suppressed

    if (event is CoordinatorConnectedEvent) {
      _logger.i(() => '[onWsEvent] connected: ${event.connectionId}');
      _refreshToken = false;
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
