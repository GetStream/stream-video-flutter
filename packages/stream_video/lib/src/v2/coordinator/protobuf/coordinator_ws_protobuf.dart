import 'dart:convert';
import 'dart:math' as math;

import '../../../../protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart'
    as coordinator;
import '../../../../protobuf/video/coordinator/user_v1/user.pb.dart'
    as coordinator_user;
import '../../../core/video_error.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/user_info.dart';
import '../../../token/token_manager.dart';
import '../../../types/other.dart';
import '../../../ws/keep_alive.dart';
import '../../../ws/ws.dart';
import '../../shared_emitter.dart';
import '../coordinator_ws.dart';
import '../models/coordinator_events.dart';
import 'mapper_extensions.dart';

// TODO: The class needs further refactor. Some parts can be abstracted.

class CoordinatorWebSocketProtobuf extends CoordinatorWebSocketV2
    with KeepAlive, ConnectionStateMixin {
  CoordinatorWebSocketProtobuf(
    super.url, {
    super.protocols,
    required this.apiKey,
    required this.userInfo,
    required this.tokenManager,
  });

  late final _logger = taggedLogger(tag: 'SV:CoordinatorWS');

  /// The API key used to authenticate the user.
  final String apiKey;

  /// The user to authenticate.
  final UserInfo userInfo;

  /// The token manager used to fetch or refresh token.
  final TokenManager tokenManager;

  @override
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
    _logger.i(() => '[authenticateUser] url: $url');

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
      _logger.e(
        () => '[onMessage] msg parsing failed: "$e"; stk: $stk',
      );
    }

    if (event == null) {
      _logger.w(() => '[onMessage] event is null');
      return;
    }

    final eventType = event.whichEvent();
    _logger.v(() => '[onMessage] eventType: $eventType');

    if (eventType == coordinator.WebsocketEvent_Event.healthcheck) {
      _handleHealthCheckEvent(event.healthcheck);
    }

    // Parsing
    _events.emit(event.toEvent());
  }

  void _handleHealthCheckEvent(coordinator.WebsocketHealthcheck event) {
    if (!isKeepAliveStarted) {
      connectionState = ConnectionState.connected;

      _logger.d(() => '[handleHealthCheckEvent] starting ping pong timer');
      startPingPong();
    }
    ackPong(event);
    _userId = event.userId;
    _clientId = event.clientId;
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
  void send(coordinator.WebsocketClientEvent message) {
    _logger.d(() => '[send] message: $message');
    super.send(message.writeToBuffer());
  }

  @override
  void sendPing() {
    _logger.d(() => '[sendPing] no args');
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
