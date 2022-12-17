import 'dart:convert';
import 'dart:math' as math;

import '../protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart'
    as coordinator;
import '../protobuf/video/coordinator/user_v1/user.pb.dart' as coordinator_user;
import 'core/video_error.dart';
import 'event_emitter.dart';
import 'events.dart';
import 'internal/events.dart';
import 'logger/logger.dart';
import 'models/user_info.dart';
import 'token/token_manager.dart';
import 'types/other.dart';
import 'ws/keep_alive.dart';
import 'ws/ws.dart';

class CoordinatorWebSocket extends StreamWebSocket
    with KeepAlive, ConnectionStateMixin, EventEmittable<CoordinatorEvent> {
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
  OnConnectionStateUpdated get onConnectionStateUpdated => events.emit;

  @override
  Future<void> connect({bool reconnect = false}) {
    connectionState = reconnect //
        ? ConnectionState.reconnecting
        : ConnectionState.connecting;

    return super.connect();
  }

  Future<void> _authenticateUser() async {
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

    return send(
      coordinator.WebsocketClientEvent(
        authRequest: authPayload,
      ),
    );
  }

  @override
  void onOpen() {
    logger.info('Websocket connection opened: $url');

    // Reset the reconnect attempts.
    _reconnectAttempt = 0;

    // Waiting for the first health check to start the keep alive.
    // This is to avoid sending keep alive messages before the connection is
    // established.
    events.on<CoordinatorHealthCheckEvent>(limit: 1, (data) {
      // Mark connected once we receives the first healthcheck.
      connectionState = ConnectionState.connected;

      logger.info('Starting ping pong timer');
      startPingPong();
    });

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
    if (message is! List<int>) {
      logger.warning('Received message is not a list of bytes');
      return;
    }

    coordinator.WebsocketEvent? event;
    try {
      event = coordinator.WebsocketEvent.fromBuffer(message);
    } catch (e, stk) {
      logger.warning('Error parsing an event: $e');
      logger.warning('Stack trace: $stk');
    }

    if (event == null) return;

    final eventType = event.whichEvent();
    logger.info('Event received: $eventType');

    if (eventType == coordinator.WebsocketEvent_Event.healthcheck) {
      _handleHealthCheckEvent(event.healthcheck);
    }

    return events.emitCoordinatorEventFromSfu(event);
  }

  void _handleHealthCheckEvent(coordinator.WebsocketHealthcheck event) {
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

    return send(
      coordinator.WebsocketClientEvent(
        healthcheck: healthCheck,
      ),
    );
  }

  int _reconnectAttempt = 0;

  Future<void> _reconnect({bool refreshToken = false}) async {
    if (isConnecting || isReconnecting) return;

    logger.info('Reconnecting: $_reconnectAttempt');
    _reconnectAttempt += 1;

    final delay = _getReconnectInterval(_reconnectAttempt);

    Future.delayed(
      Duration(milliseconds: delay),
      () async {
        if (refreshToken) await tokenManager.refreshToken();
        await connect(reconnect: true);
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

extension on EventEmitter<CoordinatorEvent> {
  void emitCoordinatorEventFromSfu(coordinator.WebsocketEvent event) {
    final eventType = event.whichEvent();
    switch (eventType) {
      case coordinator.WebsocketEvent_Event.error:
        final error = event.error;
        return emit(CoordinatorErrorEvent(error: error));
      case coordinator.WebsocketEvent_Event.healthcheck:
        final healthCheck = event.healthcheck;
        return emit(CoordinatorHealthCheckEvent(healthcheck: healthCheck));
      case coordinator.WebsocketEvent_Event.callCreated:
        final callCreated = event.callCreated;
        return emit(CoordinatorCallCreatedEvent(callCreated: callCreated));
      case coordinator.WebsocketEvent_Event.callUpdated:
        final callUpdated = event.callUpdated;
        return emit(CoordinatorCallUpdatedEvent(callUpdated: callUpdated));
      case coordinator.WebsocketEvent_Event.callDeleted:
        final callDeleted = event.callDeleted;
        return emit(CoordinatorCallDeletedEvent(callDeleted: callDeleted));
      case coordinator.WebsocketEvent_Event.callMembersCreated:
        final callMembersCreated = event.callMembersCreated;
        return emit(
          CoordinatorCallMembersCreatedEvent(
            callMembersCreated: callMembersCreated,
          ),
        );
      case coordinator.WebsocketEvent_Event.callMembersUpdated:
        final callMembersUpdated = event.callMembersUpdated;
        return emit(
          CoordinatorCallMembersUpdatedEvent(
            callMembersUpdated: callMembersUpdated,
          ),
        );
      case coordinator.WebsocketEvent_Event.callMembersDeleted:
        final callMembersDeleted = event.callMembersDeleted;
        return emit(
          CoordinatorCallMembersDeletedEvent(
            callMembersDeleted: callMembersDeleted,
          ),
        );
      case coordinator.WebsocketEvent_Event.callEnded:
        final callEnded = event.callEnded;
        return emit(CoordinatorCallEndedEvent(callEnded: callEnded));
      case coordinator.WebsocketEvent_Event.callAccepted:
        final callAccepted = event.callAccepted;
        return emit(CoordinatorCallAcceptedEvent(callAccepted: callAccepted));
      case coordinator.WebsocketEvent_Event.callRejected:
        final callRejected = event.callRejected;
        return emit(CoordinatorCallRejectedEvent(callRejected: callRejected));
      case coordinator.WebsocketEvent_Event.callCancelled:
        final callCancelled = event.callCancelled;
        return emit(
          CoordinatorCallCancelledEvent(
            callCancelled: callCancelled,
          ),
        );
      case coordinator.WebsocketEvent_Event.userUpdated:
        final userUpdated = event.userUpdated;
        return emit(CoordinatorUserUpdatedEvent(userUpdated: userUpdated));
      case coordinator.WebsocketEvent_Event.callCustom:
        final callCustom = event.callCustom;
        return emit(CoordinatorCallCustomEvent(callCustom: callCustom));
      case coordinator.WebsocketEvent_Event.notSet:
        logger.info('Received an coordinator event with no payload');
        break;
    }
  }
}
