import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pb.dart';
import 'package:stream_video/src/core/error/video_error.dart';
import 'package:stream_video/src/core/http/token_manager.dart';
import 'package:stream_video/src/state/state.dart' show ClientState;
import 'package:stream_video/src/ws/connection_status.dart';
import 'package:stream_video/src/ws/timer_helper.dart';
import 'package:stream_video/stream_video.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

/// Typedef which exposes an [WebsocketEvent] as the only parameter.
typedef EventHandler = void Function(WebsocketEvent);

/// Typedef used for connecting to a websocket. Method returns a
/// [WebSocketChannel] and accepts a connection [uri] and an optional
/// [Iterable] of `protocols`.
typedef WebSocketChannelProvider = WebSocketChannel Function(
  Uri uri, {
  Iterable<String>? protocols,
});

// All are in seconds.
const _kDefaultHealthCheckInterval = 30;
const _kDefaultReconnectionMonitorInterval = 10;
const _kDefaultReconnectionMonitorTimeout = 40;
const _kDefaultMaxReconnectAttempts = null;

const _kReconnectTimerId = 'reconnectTimer';
const _kHealthCheckTimerId = 'healthCheckTimer';

/// A class which is responsible for authenticating the user and connecting
/// to the Stream Video websocket.
class WebSocketClient with TimerHelper {
  /// Creates a new websocket client.
  WebSocketClient({
    required this.state,
    required this.apiKey,
    required this.baseUrl,
    required this.tokenManager,
    this.protocols,
    this.handler,
    Logger? logger,
    this.webSocketChannelProvider,
    this.reconnectionMonitorInterval = _kDefaultReconnectionMonitorInterval,
    this.healthCheckInterval = _kDefaultHealthCheckInterval,
    this.reconnectionMonitorTimeout = _kDefaultReconnectionMonitorTimeout,
    this.maxReconnectAttempts = _kDefaultMaxReconnectAttempts,
    this.queryParameters = const {},
  }) : _logger = logger;

  // TODO: Replace with a subset of the state.
  final ClientState state;

  /// The API key used to authenticate the user.
  final String apiKey;

  /// Additional query parameters to be added to the websocket url.
  final Map<String, Object?> queryParameters;

  /// Websocket base url.
  final String baseUrl;

  /// Specify the subprotocols the WS is willing to speak.
  final Iterable<String>? protocols;

  /// The token manager used to fetch or refresh token.
  final TokenManager tokenManager;

  /// The handler used to handle incoming events.
  final EventHandler? handler;

  final Logger? _logger;

  /// Connection function
  /// Used only for testing purpose
  @visibleForTesting
  final WebSocketChannelProvider? webSocketChannelProvider;

  /// Interval of the reconnection monitor timer
  /// This checks that it received a new event in the last
  /// [reconnectionMonitorTimeout] seconds, otherwise it considers the
  /// connection unhealthy and reconnects the WS
  final int reconnectionMonitorInterval;

  /// Interval of the health event sending timer
  /// This sends a health event every [healthCheckInterval] seconds in order to
  /// make the server aware that the client is still listening
  final int healthCheckInterval;

  /// The timeout that uses the reconnection monitor timer to consider the
  /// connection unhealthy.
  final int reconnectionMonitorTimeout;

  /// The maximum number of reconnect attempts.
  ///
  /// If the number of reconnect attempts exceeds this value, the
  /// [_webSocketChannel] will stop reconnecting.
  ///
  /// Defaults to `null`, which means that the [_webSocketChannel] will
  /// reconnect indefinitely.
  final int? maxReconnectAttempts;

  UserInfo? _user;
  String? _clientId;
  DateTime? _lastEventAt;
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketChannelSubscription;

  /// The client id used to authenticate the user.
  String? get clientId => _clientId;

  final _connectionStatusController =
      BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set _connectionStatus(ConnectionStatus status) =>
      _connectionStatusController.add(status);

  /// The current connection status value
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  /// This notifies of connection status changes
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream.distinct();

  void _initWebSocketChannel(Uri uri) {
    _logger?.info('Initiating connection with $baseUrl');
    if (_webSocketChannel != null) {
      _closeWebSocketChannel();
    }
    _webSocketChannel =
        webSocketChannelProvider?.call(uri, protocols: protocols) ??
            WebSocketChannel.connect(uri, protocols: protocols);
    _subscribeToWebSocketChannel();
  }

  void _closeWebSocketChannel() async {
    _logger?.info('Closing connection with $baseUrl');
    if (_webSocketChannel != null) {
      await _webSocketChannel
          ?.close(_manuallyClosed ? status.normalClosure : status.goingAway);
      _webSocketChannel = null;
      _unsubscribeFromWebSocketChannel();
    }
  }

  void _subscribeToWebSocketChannel() {
    _logger?.info('Started listening to $baseUrl');
    if (_webSocketChannelSubscription != null) {
      _unsubscribeFromWebSocketChannel();
    }
    _webSocketChannelSubscription = _webSocketChannel?.stream.listen(
      _onDataReceived,
      onError: _onConnectionError,
      onDone: _onConnectionClosed,
    );
  }

  void _unsubscribeFromWebSocketChannel() {
    _logger?.info('Stopped listening to $baseUrl');
    if (_webSocketChannelSubscription != null) {
      _webSocketChannelSubscription?.cancel();
      _webSocketChannelSubscription = null;
    }
  }

  Uri _buildUri() {
    return Uri.parse(baseUrl);
  }

  void _authenticateUser({
    bool refreshToken = false,
  }) async {
    assert(_user != null, 'User must be set before authenticating');

    _logger?.info('Authenticating user with $baseUrl');
    final user = _user!;
    final token = await tokenManager.loadToken(refresh: refreshToken);
    final authPayload = WebsocketAuthRequest(
      apiKey: apiKey,
      token: token.rawValue,
      user: UserInput(
        name: user.name,
        imageUrl: user.imageUrl,
        role: user.role,
        teams: user.teams,
        customJson: utf8.encode(
          json.encode(user.extraData),
        ),
      ),
    );
    return _webSocketChannel?.authenticate(authPayload);
  }

  bool _connectRequestInProgress = false;

  /// Connect the [user] to the websocket.
  Future<void> connect(UserInfo user) async {
    if (_connectRequestInProgress) {
      return _logger?.info('Connect request already in progress');
    }
    _connectRequestInProgress = true;
    _manuallyClosed = false;

    _user = user;
    _connectionStatus = ConnectionStatus.connecting;

    try {
      final uri = _buildUri();
      _initWebSocketChannel(uri);
      _authenticateUser();
    } catch (e, stk) {
      _onConnectionError(e, stk);
    }
  }

  int _reconnectAttempt = 0;
  bool _reconnectRequestInProgress = false;

  void _reconnect({bool refreshToken = false}) async {
    _logger?.info('Retrying connection : $_reconnectAttempt');
    if (_reconnectRequestInProgress) return;
    _reconnectRequestInProgress = true;

    if (maxReconnectAttempts != null &&
        _reconnectAttempt > maxReconnectAttempts!) {
      _logger?.info('Max reconnect attempts reached');
      return disconnect();
    }

    _stopMonitoringEvents();
    // Closing any previously opened web-socket
    _closeWebSocketChannel();

    _reconnectAttempt += 1;
    _connectionStatus = ConnectionStatus.reconnecting;

    final delay = _getReconnectInterval(_reconnectAttempt);
    setTimer(
      Duration(milliseconds: delay),
      () async {
        final uri = _buildUri();
        try {
          _initWebSocketChannel(uri);
          _authenticateUser(refreshToken: refreshToken);
        } catch (e, stk) {
          _onConnectionError(e, stk);
        }
      },
    );
  }

  // returns the reconnect interval based on `reconnectAttempt` in milliseconds
  int _getReconnectInterval(int reconnectAttempt) {
    // try to reconnect in 0.25-25 seconds
    // (random to spread out the load from failures)
    final max = math.min(500 + reconnectAttempt * 2000, 25000);
    final min = math.min(
      math.max(250, (reconnectAttempt - 1) * 2000),
      25000,
    );
    return (math.Random().nextDouble() * (max - min) + min).floor();
  }

  void _startMonitoringEvents() {
    _logger?.info('Starting monitoring events');
    // cancel all previous timers
    cancelAllTimers();

    _startHealthCheck();
    _startReconnectionMonitor();
  }

  void _stopMonitoringEvents() {
    _logger?.info('Stopped monitoring events');
    // reset lastEvent
    _lastEventAt = null;

    cancelAllTimers();
  }

  void _handleHealthCheckEvent(WebsocketHealthcheck event) {
    _logger?.info('HealthCheck received: ${event.clientId}');

    _clientId = event.clientId;
    _connectionStatus = ConnectionStatus.connected;

    // start monitoring health-check events
    _startMonitoringEvents();
  }

  // void _handleStreamError(Map<String, Object?> errorResponse) {
  //   // resetting connect, reconnect request flag
  //   _resetRequestFlags();
  //
  //   final error = StreamWebSocketError.fromStreamError(errorResponse);
  //   final isTokenExpired = error.errorCode == ChatErrorCode.tokenExpired;
  //   if (isTokenExpired && !tokenManager.isStatic) {
  //     _logger?.warning('Connection failed, token expired');
  //     return _reconnect(refreshToken: true);
  //   }
  //
  //   _logger?.severe('Connection failed', error);
  //
  //   final completer = connectionCompleter;
  //   // complete with error if not yet completed
  //   if (completer != null && !completer.isCompleted) {
  //     // complete the connection with error
  //     completer.completeError(error);
  //     // disconnect the web-socket connection
  //     return disconnect();
  //   }
  //
  //   return _reconnect();
  // }

  void _onDataReceived(dynamic data) {
    // resetting connect, reconnect request flag
    _resetRequestFlags(resetAttempts: true);

    WebsocketEvent? event;
    try {
      event = WebsocketEvent.fromBuffer(data);
    } catch (e, stk) {
      _logger?.warning('Error parsing an event: $e');
      _logger?.warning('Stack trace: $stk');
    }

    if (event == null) return;

    _lastEventAt = DateTime.now();

    final eventType = event.whichEvent();
    _logger?.info('Event received: $eventType');

    if (eventType == WebsocketEvent_Event.healthcheck) {
      return _handleHealthCheckEvent(event.healthcheck);
    }

    return handler?.call(event);
  }

  // TODO: Handle invalid api key or token expired error once implemented.
  // https://www.notion.so/stream-wiki/WS-Auth-write-error-message-before-closing-the-connection-a2d51f8c05ef401c9dfd206f87188322
  void _onConnectionError(error, [stacktrace]) {
    _logger?.warning('WebSocket connection error occurred', error, stacktrace);

    StreamVideoWebSocketError wsError;
    if (error is WebSocketChannelException) {
      wsError = StreamVideoWebSocketError.fromWebSocketChannelError(error);
    } else {
      wsError = StreamVideoWebSocketError(error.toString());
    }

    // resetting connect, reconnect request flag
    _resetRequestFlags();

    _reconnect();
  }

  bool _manuallyClosed = false;

  void _onConnectionClosed() {
    _logger?.warning('WebSocket connection closed : $clientId');

    // resetting connect, reconnect request flag
    _resetRequestFlags(resetAttempts: _manuallyClosed);

    // resetting connection
    _clientId = null;

    // check if we manually closed the connection
    if (_manuallyClosed) return;
    _reconnect();
  }

  bool get _needsToReconnect {
    final lastEventAt = _lastEventAt;
    // means not yet connected or disconnected
    if (lastEventAt == null) return false;

    // means we missed a health check
    final now = DateTime.now();
    return now.difference(lastEventAt).inSeconds > reconnectionMonitorTimeout;
  }

  void _resetRequestFlags({bool resetAttempts = false}) {
    _connectRequestInProgress = false;
    _reconnectRequestInProgress = false;
    if (resetAttempts) _reconnectAttempt = 0;
  }

  void _startReconnectionMonitor() {
    _logger?.info('Starting reconnection monitor');
    setPeriodicTimer(
      timerId: _kReconnectTimerId,
      Duration(seconds: reconnectionMonitorInterval),
      (_) {
        final needsToReconnect = _needsToReconnect;
        _logger?.info('Needs to reconnect : $needsToReconnect');
        if (needsToReconnect) _reconnect();
      },
      immediate: true,
    );
  }

  void _startHealthCheck() {
    _logger?.info('Starting health check monitor');
    setPeriodicTimer(
      timerId: _kHealthCheckTimerId,
      Duration(seconds: healthCheckInterval),
      (_) {
        _logger?.info('Sending HealthCheck Event');
        final healthCheckEvent = WebsocketHealthcheck(
          userId: state.callState.userId,
          clientId: state.callState.clientId,
          callType: state.callState.callType,
          callId: state.callState.callId,
          video: state.callState.video,
          audio: state.callState.audio,
        );
        _webSocketChannel?.ping(healthCheckEvent);
      },
    );
  }

  /// Disconnects the WS and releases eventual resources
  void disconnect() {
    _logger?.info('Disconnecting webSocket connection');

    if (connectionStatus == ConnectionStatus.disconnected) return;
    _connectionStatus = ConnectionStatus.disconnected;

    // resetting user
    _user = null;

    _stopMonitoringEvents();

    _manuallyClosed = true;

    _closeWebSocketChannel();
  }
}

extension on WebSocketChannel {
  /// Sends an [event] which can be encoded into a ByteString using proto.
  void send(GeneratedMessage event) => sink.add(event.writeToBuffer());

  /// Sends the [authPayload] as a Binary message to the socket, attempting to
  /// authenticate the currently logged in user.
  void authenticate(WebsocketAuthRequest authPayload) {
    return send(WebsocketClientEvent(authRequest: authPayload));
  }

  /// Pings the server with a [state] update.
  void ping(WebsocketHealthcheck state) => send(state);

  /// Closes the connection of the WebSocket with a given [closeCode]
  /// and [reason].
  Future<void> close([int? closeCode, String? closeReason]) {
    return sink.close(closeCode, closeReason);
  }
}
