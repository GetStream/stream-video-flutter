import 'dart:async';
import 'dart:convert';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../globals.dart';
import '../../../open_api/video/coordinator/api.dart' as open;
import '../../core/network_monitor_flutter.dart';
import '../../core/video_error.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/user_info.dart';
import '../../retry/retry_policy.dart';
import '../../shared_emitter.dart';
import '../../token/token_manager.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../ws/health/health_monitor.dart';
import '../../ws/ws.dart';
import '../models/coordinator_events.dart';
import 'error/open_api_error.dart';
import 'error/open_api_error_code.dart';
import 'event/open_api_event.dart';
import 'open_api_mapper_extensions.dart';

// TODO: The class needs further refactor. Some parts can be abstracted.

var _seq = 0;
const _tag = 'SV:CoordinatorWS';

String _buildUrl(String baseUrl, String apiKey) {
  return '$baseUrl'
      '?api_key=$apiKey'
      '&stream-auth-type=jwt'
      '&X-Stream-Client=$xStreamClientHeader';
}

class CoordinatorWebSocket extends StreamWebSocket implements HealthListener {
  CoordinatorWebSocket(
    String url, {
    Iterable<String>? protocols,
    required this.apiKey,
    required this.userInfo,
    required this.tokenManager,
    required this.retryPolicy,
    required this.networkMonitor,
    this.includeUserDetails = false,
  }) : super(
          _buildUrl(url, apiKey),
          protocols: protocols,
          tag: '$_tag-${++_seq}',
        ) {
    onConnectionStateUpdated = (event) {
      if (event.oldState == ConnectionState.reconnecting &&
          event.newState == ConnectionState.connected) {
        _events.emit(
          CoordinatorReconnectedEvent(
            userId: userId,
            connectionId: connectionId,
          ),
        );
      }
    };
  }

  late final _logger = taggedLogger(tag: '$_tag-$_seq');

  late final HealthMonitor healthMonitor = HealthMonitorImpl(
    'Coord',
    this,
    networkMonitor:
        NetworkMonitorFlutter.fromInternetConnection(networkMonitor),
  );

  /// The API key used to authenticate the user.
  final String apiKey;

  /// The user to authenticate.
  final UserInfo userInfo;

  /// The token manager used to fetch or refresh token.
  final TokenManager tokenManager;

  /// The retry policy is used for reconnection flow.
  final RetryPolicy retryPolicy;

  final InternetConnection networkMonitor;

  /// Decides whether to pass user details to backend when connecting the user.
  final bool includeUserDetails;

  bool _refreshToken = false;

  SharedEmitter<CoordinatorEvent> get events => _events;
  final _events = MutableSharedEmitterImpl<CoordinatorEvent>();

  String? userId;
  String? connectionId;

  @override
  Future<Result<None>> connect() {
    _logger.v(() => '[connect] no args');
    connectionState = ConnectionState.connecting;
    healthMonitor.start();
    return super.connect();
  }

  @override
  Future<Result<None>> disconnect([int? closeCode, String? closeReason]) async {
    _logger.i(
      () => '[disconnect] closeCode: "$closeCode", '
          'closeReason: "$closeReason"',
    );
    if (connectionState == ConnectionState.disconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return const Result.success(none);
    }
    connectionState = ConnectionState.disconnected;

    healthMonitor.stop();

    _manuallyClosed = true;

    return super.disconnect(closeCode, closeReason);
  }

  Future<void> _authenticateUser() async {
    _logger.i(() => '[authenticateUser] url: $url');

    final tokenResult = await tokenManager.getToken(refresh: _refreshToken);
    if (tokenResult.isFailure) {
      unawaited(_reconnect());
      return;
    }

    final authMessage = {
      'token': tokenResult.getDataOrNull()?.rawValue,
      'user_details': {
        'id': userInfo.id,
        if (includeUserDetails) ...{
          'name': userInfo.name,
          'image': userInfo.image,
          'custom': <String, dynamic>{
            ...userInfo.extraData,
          },
        },
      },
    };
    return send(
      json.encode(authMessage),
    );
  }

  @override
  void onOpen() {
    _logger.i(() => '[onOpen] url: $url');
    healthMonitor.onSocketOpen();
    _authenticateUser();
  }

  // TODO: Handle invalid api key or token expired error once implemented.
  // https://www.notion.so/stream-wiki/WS-Auth-write-error-message-before-closing-the-connection-a2d51f8c05ef401c9dfd206f87188322
  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    _logger.e(() => '[onError] error: $error');
    healthMonitor.onSocketError(error);
    connectionState = ConnectionState.failed;

    // ignore: unused_local_variable
    StreamVideoWebSocketError wsError;
    if (error is WebSocketChannelException) {
      wsError = StreamVideoWebSocketError.fromWebSocketChannelError(error);
    } else {
      wsError = StreamVideoWebSocketError(error.toString());
    }

    _reconnect();
  }

  bool _manuallyClosed = false;

  @override
  void onClose(int? closeCode, String? closeReason) {
    _logger.i(
      () => '[onClose] closeCode: "$closeCode", closeReason: "$closeReason"',
    );
    healthMonitor.onSocketClose();

    _events.emit(
      CoordinatorDisconnectedEvent(
        userId: userId,
        connectionId: connectionId,
        closeCode: closeCode,
        closeReason: closeReason,
      ),
    );

    // resetting connection
    userId = null;
    connectionId = null;

    // check if we manually closed the connection
    if (_manuallyClosed) {
      connectionState = ConnectionState.disconnected;
      return;
    }
    connectionState = ConnectionState.closed;

    _reconnect();
  }

  @override
  void onMessage(dynamic message) {
    _logger.v(() => '[onRawMessage] message: $message');
    OpenApiError? dtoError;
    OpenApiEvent? dtoEvent;
    try {
      final jsonDecoded = json.decode(message) as Map<String, dynamic>;
      dtoError = OpenApiError.fromJson(jsonDecoded);
      dtoEvent = OpenApiEvent.fromJson(jsonDecoded);
    } catch (e, stk) {
      _logger.e(() => '[onMessage] msg parsing failed: "$e"; stk: $stk');
    }

    if (dtoError != null) {
      _logger.e(() => '[onMessage] apiError: ${dtoError?.apiError}');
      _handleApiError(dtoError.apiError);
      return;
    }

    if (dtoEvent == null) {
      _logger.w(() => '[onMessage] event is null');
      return;
    }

    _logger.v(() => '[onMessage] dtoEvent.type: ${dtoEvent?.type}');

    if (dtoEvent.connected != null) {
      _handleConnectedEvent(dtoEvent.connected!);
    } else if (dtoEvent.healthCheck != null) {
      _handleHealthCheckEvent(dtoEvent.healthCheck!);
    }

    // Parsing
    final domainEvent = dtoEvent.toCoordinatorEvent();
    if (domainEvent != null) {
      _logger.v(() => '[onMessage] domainEvent: $domainEvent');
      _events.emit(domainEvent);
    }
  }

  void _handleApiError(open.APIError apiError) {
    if (OpenApiErrorCode.tokenRelated.contains(apiError.code)) {
      _logger.i(() => '[handleApiError] token related error: ${apiError.code}');
      _refreshToken = true;
    }
  }

  void _handleConnectedEvent(open.ConnectedEvent event) {
    _logger.i(() => '[handleConnectedEvent] no args');
    _reconnectAttempt = 0;
    _refreshToken = false;
    connectionState = ConnectionState.connected;
    healthMonitor.onPongReceived();
    userId ??= event.me.id;
    connectionId ??= event.connectionId;
  }

  void _handleHealthCheckEvent(open.HealthCheckEvent event) {
    _logger.i(() => '[handleHealthCheckEvent] no args');
    healthMonitor.onPongReceived();
  }

  void sendPing() {
    _logger.v(() => '[sendPing] no args');
    final healthCheck = [
      {
        'type': 'health.check',
        // 'user_id': _userId,
        'client_id': connectionId,
        // 'call_type': _callInfo?.callType,
        // 'call_id': _callInfo?.callId,
      }
    ];

    return send(
      json.encode(healthCheck),
    );
  }

  @override
  void send(dynamic message) {
    _logger.v(() => '[send] message: $message');
    super.send(message);
  }

  int _reconnectAttempt = 0;

  Future<void> _reconnect() async {
    if (isConnecting || isReconnecting) {
      _logger.w(() => '[reconnect] rejected(already reconnecting/connecting)');
      return;
    }
    _logger.i(
      () => '[reconnect] isConnecting: $isConnecting, '
          'isReconnecting: $isReconnecting, '
          'reconnectAttempt: $_reconnectAttempt',
    );
    _reconnectAttempt += 1;

    final delay = retryPolicy.backoff(_reconnectAttempt);

    _logger.v(() => '[reconnect] delay: $delay ms');

    await Future.delayed(delay, () async {
      _logger.v(() => '[reconnect] triggered');
      connectionState = ConnectionState.reconnecting;
      await super.connect();
      _logger.v(() => '[reconnect] completed');
    });
  }

  @override
  Future<void> onPongTimeout(Duration timeout) async {
    _logger.d(() => '[onPongTimeout] timeout: $timeout');

    await super.disconnect();
    unawaited(_reconnect());
  }

  @override
  void onPingRequested() {
    _logger.d(() => '[onPingRequested] no args');
    sendPing();
  }

  @override
  void onNetworkDisconnected() {
    _logger.i(() => '[onNetworkDisconnected] no args');
  }

  @override
  void onNetworkConnected() {
    _logger.i(() => '[onNetworkConnected] no args');
  }
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
