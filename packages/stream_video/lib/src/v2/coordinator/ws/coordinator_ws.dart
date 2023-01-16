import 'dart:convert';
import 'dart:math' as math;

import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart'
    as coordinator;
import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pb.dart'
    as coordinator_user;
import 'package:stream_video/src/core/video_error.dart';
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/token/token_manager.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/v2/coordinator/ws/mapper_extensions.dart';
import 'package:stream_video/src/v2/coordinator/ws/coordinator_socket_listener.dart';
import 'package:stream_video/src/ws/keep_alive.dart';
import 'package:stream_video/src/ws/ws.dart';

import '../../shared_emitter.dart';
import 'coordinator_events.dart';

// TODO: The class needs further refactor. Some parts can be abstracted.

class CoordinatorWebSocketV2 extends StreamWebSocket
    with KeepAlive, ConnectionStateMixin {
  CoordinatorWebSocketV2(
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

  SharedEmitter<CoordinatorEventV2> get events => _events;
  final _events = MutableSharedEmitterImpl<CoordinatorEventV2>();

  String? _userId;
  String? _clientId;

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
    logger.info('Authenticating user with $url');

    final token = await tokenManager.loadToken();
    final authPayload = coordinator.WebsocketAuthRequest(
      apiKey: apiKey,
      token: token.rawValue,
      user: coordinator_user.UserInput(
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

    return send(coordinator.WebsocketClientEvent(
      authRequest: authPayload,
    ));
  }

  @override
  void onOpen() {
    logger.info('Websocket connection opened: $url');

    // Reset the reconnect attempts.
    _reconnectAttempt = 0;

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
    coordinator.WebsocketEvent? event;
    try {
      event = coordinator.WebsocketEvent.fromBuffer(message);
    } catch (e, stk) {
      logger
        ..warning('Error parsing an event: $e')
        ..warning('Stack trace: $stk');
    }

    if (event == null) {
      logger.warning('Event is null!');
      return;
    }

    final eventType = event.whichEvent();
    logger.info('Event received: $eventType');

    if (eventType == coordinator.WebsocketEvent_Event.healthcheck) {
      _handleHealthCheckEvent(event.healthcheck);
    }

    // Parsing
    _events.emit(event.toEvent());
  }

  void _handleHealthCheckEvent(coordinator.WebsocketHealthcheck event) {
    if (!isKeepAliveStarted) {
      connectionState = ConnectionState.connected;

      logger.info('Starting ping pong timer');
      startPingPong();
    }
    ackPong(event);
    _userId = event.userId;
    _clientId = event.clientId;
  }

  @override
  Future<void> disconnect([int? closeCode, String? closeReason]) async {
    // return if already disconnected.
    if (connectionState == ConnectionState.disconnected) return;
    await _events.close();
    // Stop sending keep alive messages.
    stopPingPong();

    // If no close code is provided,
    // means we are manually closing the connection.
    if (closeCode == null) _manuallyClosed = true;

    return super.disconnect(closeCode, closeReason);
  }

  @override
  void send(coordinator.WebsocketClientEvent event) {
    logger.info('Sending ws event: $event');
    super.send(event.writeToBuffer());
  }

  @override
  void sendPing() {
    final healthCheck = coordinator.WebsocketHealthcheck(
      userId: _userId,
      clientId: _clientId,
      callType: _callInfo?.callType,
      callId: _callInfo?.callId,
    );

    return send(coordinator.WebsocketClientEvent(
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
