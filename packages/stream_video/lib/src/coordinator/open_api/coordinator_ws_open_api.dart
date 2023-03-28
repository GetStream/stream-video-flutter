import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import '../../../open_api/video/coordinator/api.dart' as open;
import '../../core/video_error.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/user_info.dart';
import '../../shared_emitter.dart';
import '../../token/token_manager.dart';
import '../../types/other.dart';
import '../../utils/result.dart';
import '../../utils/standard.dart';
import '../../ws/base_ws.dart';
import '../../ws/health/health_monitor.dart';
import '../coordinator_ws.dart';
import '../models/coordinator_events.dart';
import 'error/open_api_error.dart';
import 'event/open_api_event.dart';
import 'open_api_mapper_extensions.dart';

// TODO: The class needs further refactor. Some parts can be abstracted.

const _tag = 'SV:CoordinatorWS';

const _maxJitter = Duration(milliseconds: 500);
const _defaultDelay = Duration(milliseconds: 250);
const _retryMaxBackoff = Duration(seconds: 5);
final _rnd = math.Random();

String _buildUrl(String baseUrl, String apiKey) {
  return '$baseUrl'
      '?api_key=$apiKey'
      '&stream-auth-type=jwt'
      '&X-Stream-Client=stream-video-flutter';
}

class CoordinatorWebSocketOpenApi extends CoordinatorWebSocket
    with ConnectionStateMixin
    implements HealthListener {
  CoordinatorWebSocketOpenApi(
    String url, {
    Iterable<String>? protocols,
    required this.apiKey,
    required this.userInfo,
    required this.tokenManager,
  }) : super(_buildUrl(url, apiKey), protocols: protocols, tag: _tag);

  late final _logger = taggedLogger(tag: _tag);

  late final HealthMonitor healthMonitor = HealthMonitorImpl('Coord', this);

  /// The API key used to authenticate the user.
  final String apiKey;

  /// The user to authenticate.
  final UserInfo userInfo;

  /// The token manager used to fetch or refresh token.
  final TokenManager tokenManager;

  @override
  SharedEmitter<CoordinatorEvent> get events => _events;
  final _events = MutableSharedEmitterImpl<CoordinatorEvent>();

  String? userId;
  String? clientId;

  set callInfo(CallInfo? info) => _callInfo = info;
  CallInfo? _callInfo;

  // Do we need that? Cannot we just pass events to the listeners?
  // @override
  // OnConnectionStateUpdated get onConnectionStateUpdated => events.emit;

  @override
  Future<void> connect() {
    _logger.v(() => '[connect] no args');
    connectionState = ConnectionState.connecting;
    healthMonitor.start();
    return super.connect();
  }

  @override
  Future<void> disconnect([int? closeCode, String? closeReason]) async {
    _logger.i(
          () => '[disconnect] closeCode: "$closeCode", '
              'closeReason: "$closeReason"',
    );
    if (connectionState == ConnectionState.disconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return;
    }

    healthMonitor.stop();

    _manuallyClosed = true;

    return super.disconnect(closeCode, closeReason);
  }

  Future<void> _authenticateUser() async {
    _logger.i(() => '[authenticateUser] url: $url');

    final tokenResult = await tokenManager.getToken();
    if (tokenResult is! Success<String>) {
      unawaited(_reconnect());
      return;
    }
    final image = userInfo.image;

    final authMessage = {
      'token': tokenResult.data,
      'user_details': {
        'id': userInfo.id,
        // TODO BE requires "name" & "image" to be inside "custom" field
        // 'name': userInfo.name,
        // 'image': userInfo.image,
        'custom': <String, dynamic>{
          'name': userInfo.name,
          if (image != null) ...{'image': image},
          ...?userInfo.extraData,
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

    // Authenticate the user.
    _authenticateUser();
  }

  // TODO: Handle invalid api key or token expired error once implemented.
  // https://www.notion.so/stream-wiki/WS-Auth-write-error-message-before-closing-the-connection-a2d51f8c05ef401c9dfd206f87188322
  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    _logger.e(() => '[onError] error: $error');
    healthMonitor.onSocketError(error);
    connectionState = ConnectionState.failed;

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
    connectionState = ConnectionState.closed;

    // resetting connection
    userId = null;
    clientId = null;

    // check if we manually closed the connection
    if (_manuallyClosed) {
      connectionState = ConnectionState.disconnected;
      return;
    }

    _reconnect();
  }

  @override
  void onMessage(dynamic message) {
    _logger.i(() => '[onRawMessage] message: $message');
    OpenApiError? dtoError;
    OpenApiEvent? dtoEvent;
    try {
      final jsonDecoded = json.decode(message);
      dtoError = OpenApiError.fromJson(jsonDecoded);
      dtoEvent = OpenApiEvent.fromJson(jsonDecoded);
    } catch (e, stk) {
      _logger.e(() => '[onMessage] msg parsing failed: "$e"; stk: $stk');
    }

    if (dtoError != null) {
      _logger.e(() => '[onMessage] apiError: ${dtoError?.apiError}');
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
    dtoEvent.toCoordinatorEvent()?.let(_events.emit);
  }

  void _handleConnectedEvent(open.WSConnectedEvent event) {
    _logger.i(() => '[handleConnectedEvent] no args');
    _reconnectAttempt = 0;
    connectionState = ConnectionState.connected;
    healthMonitor.onPongReceived();
    userId ??= event.me.id;
    clientId ??= event.connectionId;
  }

  void _handleHealthCheckEvent(open.HealthCheckEvent event) {
    _logger.i(() => '[handleHealthCheckEvent] no args');
    healthMonitor.onPongReceived();
  }

  void sendPing() {
    _logger.d(() => '[sendPing] no args');
    final healthCheck = [
      {
        'type': 'health.check',
        // 'user_id': _userId,
        'client_id': clientId,
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
    _logger.d(() => '[send] message: $message');
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

    final delay = _calculateDelay(_reconnectAttempt);

    _logger.v(() => '[reconnect] delay: $delay ms');

    await Future.delayed(delay, () async {
      _logger.v(() => '[reconnect] triggered');
      // if (refreshToken) {
      //   await tokenManager.refreshToken();
      // }
      connectionState = ConnectionState.reconnecting;
      await super.connect();
      _logger.v(() => '[reconnect] completed');
    });
  }

  Duration get jitter {
    return Duration(milliseconds: _rnd.nextInt(_maxJitter.inMilliseconds));
  }

  Duration _calculateDelay(int retryAttempt) {
    if (retryAttempt == 0) {
      return Duration.zero;
    }
    final calculated = _defaultDelay * retryAttempt + jitter;
    if (calculated < _retryMaxBackoff) {
      return calculated;
    }
    return _retryMaxBackoff;
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
