import 'dart:convert';
import 'dart:math' as math;

import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pb.dart';
import 'package:stream_video/src/core/error/video_error.dart';
import 'package:stream_video/src/core/http/token_manager.dart';
import 'package:stream_video/src/core/logger/logger.dart';
import 'package:stream_video/src/core/utils/event_emitter.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/ws/keep_alive.dart';
import 'package:stream_video/src/ws/ws.dart';

class CoordinatorWebSocket extends StreamWebSocket
    with KeepAlive, ConnectionStateMixin, EventEmitterMixin<WebsocketEvent> {
  CoordinatorWebSocket(
    super.url, {
    super.protocols,
    required this.apiKey,
    required this.userInfo,
    required this.tokenManager,
  });

  /// The API key used to authenticate the user.
  final String apiKey;

  /// The user to authenticate.
  final UserInfo userInfo;

  /// The token manager used to fetch or refresh token.
  final TokenManager tokenManager;

  String? _userId;
  String? _clientId;

  set callInfo(CallInfo? info) => _callInfo = info;
  CallInfo? _callInfo;

  @override
  Future<void> connect({bool reconnect = false}) {
    connectionState = reconnect //
        ? ConnectionState.reconnecting
        : ConnectionState.connecting;

    return super.connect();
  }

  void _authenticateUser() async {
    logger.info('Authenticating user with $url');

    final token = await tokenManager.loadToken();
    final authPayload = WebsocketAuthRequest(
      apiKey: apiKey,
      token: token.rawValue,
      user: UserInput(
        id: userInfo.id,
        name: userInfo.name,
        imageUrl: userInfo.imageUrl,
        role: userInfo.role,
        teams: userInfo.teams,
        customJson: utf8.encode(
          json.encode(userInfo.extraData),
        ),
      ),
    );

    return send(WebsocketClientEvent(
      authRequest: authPayload,
    ));
  }

  @override
  void onOpen() {
    logger.info('Websocket connection opened: $url');

    // Reset the reconnect attempts.
    _reconnectAttempt = 0;

    // Waiting for the first health check to start the keep alive.
    // This is to avoid sending keep alive messages before the connection is
    // established.
    once(
      WebsocketEvent_Event.healthcheck.name,
      (_) {
        // Mark connected once we receives the first healthcheck.
        connectionState = ConnectionState.connected;

        logger.info('Starting ping pong timer');
        startPingPong();
      },
    );

    // Authenticate the user.
    _authenticateUser();
  }

  // TODO: Handle invalid api key or token expired error once implemented.
  // https://www.notion.so/stream-wiki/WS-Auth-write-error-message-before-closing-the-connection-a2d51f8c05ef401c9dfd206f87188322
  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    logger.warning('WebSocket connection error occurred', error, stackTrace);

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
    logger.warning('WebSocket connection closed: $url');

    // resetting connection
    _userId = null;
    _clientId = null;

    // check if we manually closed the connection
    if (_manuallyClosed) {
      connectionState = ConnectionState.disconnected;
      return;
    }

    _reconnect();
  }

  @override
  void onMessage(dynamic message) {
    WebsocketEvent? event;
    try {
      event = WebsocketEvent.fromBuffer(message);
    } catch (e, stk) {
      logger.warning('Error parsing an event: $e');
      logger.warning('Stack trace: $stk');
    }

    if (event == null) return;

    final eventType = event.whichEvent();
    logger.info('Event received: $eventType');

    if (eventType == WebsocketEvent_Event.healthcheck) {
      _handleHealthCheckEvent(event.healthcheck);
    }

    return emitter.emit(eventType.name, event);
  }

  void _handleHealthCheckEvent(WebsocketHealthcheck event) {
    ackPong(event);
    _userId = event.userId;
    _clientId = event.clientId;
  }

  @override
  Future<void> disconnect([int? closeCode, String? closeReason]) async {
    // return if already disconnected.
    if (connectionState == ConnectionState.disconnected) return;

    // Stop sending keep alive messages.
    stopPingPong();

    // If no close code is provided,
    // means we are manually closing the connection.
    if (closeCode == null) _manuallyClosed = true;

    return super.disconnect(closeCode, closeReason);
  }

  @override
  void send(WebsocketClientEvent event) {
    logger.info('Sending ws event: $event');
    super.send(event.writeToBuffer());
  }

  @override
  void sendPing() {
    final healthCheck = WebsocketHealthcheck(
      userId: _userId,
      clientId: _clientId,
      callType: _callInfo?.callType,
      callId: _callInfo?.callId,
    );

    return send(WebsocketClientEvent(
      healthcheck: healthCheck,
    ));
  }

  int _reconnectAttempt = 0;

  void _reconnect({bool refreshToken = false}) async {
    if (isConnecting || isReconnecting) return;

    logger.info('Reconnecting: $_reconnectAttempt');
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
