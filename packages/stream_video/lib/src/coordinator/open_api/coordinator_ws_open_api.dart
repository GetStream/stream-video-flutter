import 'dart:convert';
import 'dart:math' as math;

import 'package:uuid/uuid.dart';

import '../../core/video_error.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/user_info.dart';
import '../../shared_emitter.dart';
import '../../token/token_manager.dart';
import '../../types/other.dart';
import '../../utils/standard.dart';
import '../../ws/base_ws.dart';
import '../../ws/keep_alive.dart';
import '../coordinator_ws.dart';
import '../models/coordinator_events.dart';
import 'generated/event_dto.dart';
import 'generated/health_check_event_dto.dart';
import 'open_api_event_parser.dart';
import 'open_api_mapper_extensions.dart';

// TODO: The class needs further refactor. Some parts can be abstracted.

String buildUrl(String baseUrl, String apiKey) {
  return '$baseUrl?api_key=$apiKey&stream-auth-type=jwt&X-Stream-Client=stream-video-flutter';
}

class CoordinatorWebSocketOpenApi extends CoordinatorWebSocket
    with KeepAlive, ConnectionStateMixin {
  CoordinatorWebSocketOpenApi(
    String url, {
    Iterable<String>? protocols,
    required this.apiKey,
    required this.userInfo,
    required this.tokenManager,
  }) : super(buildUrl(url, apiKey), protocols: protocols);

  late final _logger = taggedLogger(tag: 'SV:CoordinatorWS');

  /// The API key used to authenticate the user.
  final String apiKey;

  /// The user to authenticate.
  final UserInfo userInfo;

  /// The token manager used to fetch or refresh token.
  final TokenManager tokenManager;

  late final OpenApiEventParser eventParser = OpenApiEventParser();

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
  Future<void> connect({bool reconnect = false}) {
    connectionState = reconnect //
        ? ConnectionState.reconnecting
        : ConnectionState.connecting;

    return super.connect();
  }

  void _authenticateUser() async {
    _logger.i(() => '[authenticateUser] url: $url');

    final token = await tokenManager.loadToken();

    final authMessage = {
      'token': token.rawValue,
      'user_details': {
        'id': userInfo.id,
        'name': userInfo.name,
        'imageUrl': userInfo.imageUrl,
        'role': userInfo.role,
        'teams': userInfo.teams,
        'customJson': json.encode(userInfo.extraData),
      },
    };
    return send(
      json.encode(authMessage),
    );
  }

  @override
  void onOpen() {
    _logger.i(() => '[onOpen] url: $url');

    // Reset the reconnect attempts.
    _reconnectAttempt = 0;

    // Authenticate the user.
    _authenticateUser();
  }

  // TODO: Handle invalid api key or token expired error once implemented.
  // https://www.notion.so/stream-wiki/WS-Auth-write-error-message-before-closing-the-connection-a2d51f8c05ef401c9dfd206f87188322
  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    _logger.e(() => '[onError] error: $error, stackTrace: $stackTrace');

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
   _logger.i(() => '[onMessage] message: $message');
    EventDto? dtoEvent;
    try {
      dtoEvent = eventParser.parse(message);
    } catch (e, stk) {
      _logger.e(
        () => '[onMessage] msg parsing failed: "$e"; stk: $stk',
      );
    }

    if (dtoEvent == null) {
      _logger.w(() => '[onMessage] event is null');
      return;
    }

    _logger.v(() => '[onMessage] dtoEvent: ${dtoEvent?.toJson()}');

    if (dtoEvent is HealthCheckEventDto) {
      _handleHealthCheckEvent(dtoEvent);
    }

    // Parsing
    dtoEvent.toCoordinatorEvent()?.let(_events.emit);
  }

  void _handleHealthCheckEvent(HealthCheckEventDto event) {
    if (!isKeepAliveStarted) {
      connectionState = ConnectionState.connected;

      _logger.d(() => '[handleHealthCheckEvent] starting ping pong timer');
      startPingPong();
    }
    ackPong(event);
    userId ??= event.me?.id;
    clientId ??= event.connectionId;
  }

  @override
  Future<void> disconnect([int? closeCode, String? closeReason]) async {
    _logger.d(
      () => '[disconnect] closeCode: "$closeCode", closeReason: "$closeReason"',
    );
    // return if already disconnected.
    if (connectionState == ConnectionState.disconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return;
    }
    await _events.close();
    // Stop sending keep alive messages.
    stopPingPong();

    // If no close code is provided,
    // means we are manually closing the connection.
    if (closeCode == null) _manuallyClosed = true;

    return super.disconnect(closeCode, closeReason);
  }

  @override
  void send(String message) {
    _logger.d(() => '[send] message: $message');
    super.send(message);
  }

  @override
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

  int _reconnectAttempt = 0;

  void _reconnect({bool refreshToken = false}) async {
    if (isConnecting || isReconnecting) return;

    _logger.i(() => '[reconnect] reconnectAttempt: $_reconnectAttempt');
    _reconnectAttempt += 1;

    final delay = _getReconnectInterval(_reconnectAttempt);

    Future.delayed(
      Duration(milliseconds: delay),
      () async {
        if (refreshToken) await tokenManager.refreshToken();
        connect(reconnect: true);
      },
    );
  }

  // returns the reconnect interval based on `reconnectAttempt` in milliseconds
  int _getReconnectInterval(int reconnectAttempt) {
    // try to reconnect in 0.25-25 seconds
    // (random to spread out the load from failures)
    final max = math.min(500 + reconnectAttempt * 2000, 25000);
    final min = math.min(math.max(250, (reconnectAttempt - 1) * 2000), 25000);
    return (math.Random().nextDouble() * (max - min) + min).floor();
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
