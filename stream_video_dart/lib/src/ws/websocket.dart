import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:logging/logging.dart';
import 'package:rxdart/subjects.dart';
import 'package:stream_video_dart/protobuf/video_events/events.pbserver.dart';
import 'package:stream_video_dart/protobuf/video_models/models.pb.dart';
import 'package:stream_video_dart/src/client/state.dart';
import 'package:stream_video_dart/src/core/error/error.dart';
import 'package:stream_video_dart/src/core/http/token_manager.dart';
import 'package:stream_video_dart/src/ws/connection_status.dart';
import 'package:stream_video_dart/src/ws/timer_helper.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

/// Typedef which exposes an [Event] as the only parameter.
// typedef EventHandler = void Function(WebsocketEvent);

class WebSocket with TimerHelper {
  WebSocket({
    Logger? logger,
    required this.apiKey,
    required this.baseURL,
    // required this.handler,
    required this.tokenManager,
    required this.state,
    this.queryParameters = const {},
  }) : _logger = logger;

  final ClientState state;

  final String baseURL;
  // final EventHandler handler;
  final String apiKey;
  final Logger? _logger;
  final TokenManager tokenManager;

  final Map<String, Object?> queryParameters;

  User? _user;

  String? _connectionId;

  String? get connectionId => _connectionId;

  WebSocketChannel? _webSocketChannel;

  Completer<WebsocketEvent>? connectionCompleter;

  StreamSubscription? _webSocketChannelSubscription;

  final _connectionStatusController =
      BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set connectionStatus(ConnectionStatus status) =>
      _connectionStatusController.add(status);

  /// The current connection status value
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  /// This notifies of connection status changes
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream.distinct();

  bool _manuallyClosed = false;

  DateTime? _lastEventAt;

  bool _connectRequestInProgress = false;
  int _reconnectAttempt = 0;
  bool _reconnectRequestInProgress = false;

  /// Connect the WS using the parameters passed in the constructor
  Future<WebsocketEvent> connect(
    User user, {
    bool includeUserDetails = false,
  }) async {
    if (_connectRequestInProgress) {
      throw StreamWebSocketError('''
        You've called connect twice,
        can only attempt 1 connection at the time,
        ''');
    }
    _connectRequestInProgress = true;
    _manuallyClosed = false;

    _user = user;
    connectionStatus = ConnectionStatus.connecting;
    connectionCompleter = Completer<WebsocketEvent>();

    try {
      final uri = await _buildUri(
        includeUserDetails: includeUserDetails,
      );
      _initWebSocketChannel(uri);
    } catch (e, stk) {
      _onConnectionError(e, stk);
    }

    return connectionCompleter!.future;
  }

  void _initWebSocketChannel(Uri uri) {
    _logger?.info('Initiating connection with $baseURL');

    if (_webSocketChannel != null) {
      _closeWebSocketChannel();
    }
    _webSocketChannel = WebSocketChannel.connect(uri);
    _subscribeToWebSocketChannel();
  }

  void _closeWebSocketChannel() {
    _logger?.info('Closing connection with $baseURL');
    if (_webSocketChannel != null) {
      _unsubscribeFromWebSocketChannel();
      _webSocketChannel?.sink
          .close(_manuallyClosed ? status.normalClosure : status.goingAway);
      _webSocketChannel = null;
    }
  }

  void _unsubscribeFromWebSocketChannel() {
    _logger?.info('Stopped listening to $baseURL');
    if (_webSocketChannelSubscription != null) {
      _webSocketChannelSubscription?.cancel();
      _webSocketChannelSubscription = null;
    }
  }

  void _subscribeToWebSocketChannel() {
    _logger?.info('Started listening to $baseURL');
    if (_webSocketChannelSubscription != null) {
      _unsubscribeFromWebSocketChannel();
    }
    _webSocketChannelSubscription = _webSocketChannel?.stream.listen(
      _onDataReceived,
      onError: _onConnectionError,
      onDone: _onConnectionClosed,
    );
  }

  void _onConnectionClosed() {
    _logger?.warning('Connection closed : $connectionId');

    // resetting connect, reconnect request flag
    _resetRequestFlags();

    // resetting connection
    _connectionId = null;

    // check if we manually closed the connection
    if (_manuallyClosed) return;
    _reconnect();
  }

  void _resetRequestFlags({bool resetAttempts = false}) {
    _connectRequestInProgress = false;
    _reconnectRequestInProgress = false;
    if (resetAttempts) _reconnectAttempt = 0;
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

  void _reconnect({bool refreshToken = false}) async {
    _logger?.info('Retrying connection : $_reconnectAttempt');
    if (_reconnectRequestInProgress) return;
    _reconnectRequestInProgress = true;

    _stopMonitoringEvents();
    // Closing any previously opened web-socket
    _closeWebSocketChannel();

    _reconnectAttempt += 1;
    connectionStatus = ConnectionStatus.connecting;

    final delay = _getReconnectInterval(_reconnectAttempt);
    setTimer(
      Duration(milliseconds: delay),
      () async {
        final uri = await _buildUri(
          refreshToken: refreshToken,
          includeUserDetails: false,
        );
        try {
          _initWebSocketChannel(uri);
        } catch (e, stk) {
          _onConnectionError(e, stk);
        }
      },
    );
  }

  Future<Uri> _buildUri({
    bool refreshToken = false,
    bool includeUserDetails = true,
  }) async {
    final user = _user!;
    final token = await tokenManager.loadToken(refresh: refreshToken);
    final params = {
      'user_id': user.id,
      'user_details': includeUserDetails ? user : {'id': user.id},
      'user_token': token.rawValue,
      'server_determines_connection_id': true,
    };
    final qs = {
      'json': jsonEncode(params),
      'api_key': apiKey,
      'authorization': token.rawValue,
      'stream-auth-type': token.authType.name,
      ...queryParameters,
    };
    final scheme = baseURL.startsWith('https') ? 'wss' : 'ws';
    final host = baseURL.replaceAll(RegExp(r'(^\w+:|^)\/\/'), '');
    return Uri.parse('ws://localhost:1234'); //TODO: unhardcode this
    // return Uri(
    //   scheme: scheme,
    //   host: host,
    //   pathSegments: ['connect'],
    //   queryParameters: qs,
    // );
  }

  void _stopMonitoringEvents() {
    _logger?.info('Stopped monitoring events');
    // reset lastEvent
    _lastEventAt = null;

    cancelAllTimers();
  }

  void _onConnectionError(error, [stacktrace]) {
    _logger?.warning('Error occurred', error, stacktrace);

    StreamWebSocketError wsError;
    if (error is WebSocketChannelException) {
      wsError = StreamWebSocketError.fromWebSocketChannelError(error);
    } else {
      wsError = StreamWebSocketError(error.toString());
    }

    final completer = connectionCompleter;
    // complete with error if not yet completed
    if (completer != null && !completer.isCompleted) {
      // complete the connection with error
      completer.completeError(wsError);
    }

    // resetting connect, reconnect request flag
    _resetRequestFlags();

    _reconnect();
  }

  void _onDataReceived(dynamic data) {
    try {
      final receivedEvent = WebsocketEvent.fromBuffer(data);
      switch (receivedEvent.whichEventPayload()) {
        case WebsocketEvent_EventPayload.healthCheck:
          {
            return _handleHealthCheckEvent(receivedEvent.healthCheck);
          }
        case WebsocketEvent_EventPayload.callRinging:
          {
            return _handleCallRinging(receivedEvent.callRinging);
          }
        case WebsocketEvent_EventPayload.callCreated:
          {
            return _handleCallCreated(receivedEvent.callCreated);
          }
        case WebsocketEvent_EventPayload.callUpdated:
          {
            return _handlerCallUpdated(receivedEvent.callUpdated);
          }
        case WebsocketEvent_EventPayload.callEnded:
          {
            return _handleCallEnded(receivedEvent.callEnded);
          }
        case WebsocketEvent_EventPayload.callDeleted:
          {
            return _handleCallDeleted(receivedEvent.callDeleted);
          }
        case WebsocketEvent_EventPayload.userUpdated:
          {
            return _handleUserUpdated(receivedEvent.userUpdated);
          }
        case WebsocketEvent_EventPayload.participantInvited:
          {
            return _handleParticipantInvited(receivedEvent.participantInvited);
          }
        case WebsocketEvent_EventPayload.participantUpdated:
          {
            return _handleParticipantUpdated(receivedEvent.participantUpdated);
          }
        case WebsocketEvent_EventPayload.participantDeleted:
          {
            return _handleParticipantDeleted(receivedEvent.participantDeleted);
          }
        case WebsocketEvent_EventPayload.participantJoined:
          {
            return _handleParticipantJoined(receivedEvent.participantJoined);
          }
        case WebsocketEvent_EventPayload.participantLeft:
          {
            return _handleParticipantLeft(receivedEvent.participantLeft);
          }
        case WebsocketEvent_EventPayload.broadcastStarted:
          {
            return _handleBroadcastStarted(receivedEvent.broadcastStarted);
          }
        case WebsocketEvent_EventPayload.broadcastEnded:
          {
            return _handleBroadcastEnded(receivedEvent.broadcastEnded);
          }
        case WebsocketEvent_EventPayload.authPayload:
          {
            return _handleAuthPayload(receivedEvent.authPayload);
          }
        case WebsocketEvent_EventPayload.notSet:
          {
            _logger?.info("handle event payload not set");
          }
      }

      // handler.call(receivedEvent);
    } catch (e, s) {
      print("error occured $e");
      print("stacktrace $s");
    }
  }

  //close all controllers
  Future<void> close() async {
    await Future.wait([_connectionStatusController.close(), state.dispose()]);
  }

  void _handleHealthCheckEvent(Healthcheck event) {
    _logger?.info('HealthCheck received : ${event.toString()}');

    _connectionId = event.clientId;

    connectionStatus = ConnectionStatus.connected;
    state.healthcheck = event;
  }

  void _handleCallRinging(CallRinging event) {
    _logger?.info('CallRinging event received : ${event.call.toString()}');
    state.callRinging = event;
  }

  void _handleCallCreated(CallCreated event) {
    _logger?.info('CallCreated event received : ${event.call.toString()}');
    state.callCreated = event;
  }

  void _handlerCallUpdated(CallUpdated event) {
    _logger?.info('CallUpdated event received : ${event.call.toString()}');
    state.callUpdated = event;
  }

  void _handleCallEnded(CallEnded event) {
    _logger?.info('CallEnded event received : ${event.call.toString()}');
    state.callEnded = event;
  }

  void _handleCallDeleted(CallDeleted event) {
    _logger?.info('CallDeleted event received : ${event.call.toString()}');
    state.callDeleted = event;
  }

  void _handleUserUpdated(UserUpdated event) {
    _logger?.info('UserUpdated event received : ${event.user.toString()}');
    state.userUpdated = event;
  }

  void _handleParticipantInvited(ParticipantInvited event) {
    _logger?.info(
        'ParticipantInvited event received : ${event.participant.toString()}');
    state.participantInvited = event;
  }

  void _handleParticipantUpdated(ParticipantUpdated event) {
    _logger?.info(
        'ParticipantUpdated event received : ${event.participant.toString()}');
    state.participantUpdated = event;
  }

  void _handleParticipantDeleted(ParticipantDeleted event) {
    _logger?.info('ParticipantDeleted event received : ${event.userId}');
    state.participantDeleted = event;
  }

  void _handleParticipantJoined(ParticipantJoined event) {
    _logger?.info(
        'ParticipantJoined event received : ${event.participant.toString()}');
    state.participantJoined = event;
  }

  void _handleParticipantLeft(ParticipantLeft event) {
    _logger?.info(
        'ParticipantLeft event received : ${event.participant.toString()}');
    state.participantLeft = event;
  }

  void _handleBroadcastStarted(BroadcastStarted event) {
    _logger?.info(
        'BroadcastStarted event received : ${event.broadcast.toString()}');
    state.broadcastStarted = event;
  }

  void _handleBroadcastEnded(BroadcastEnded event) {
    _logger
        ?.info('BroadcastEnded event received : ${event.broadcast.toString()}');
    state.broadcastEnded = event;
  }

  void _handleAuthPayload(AuthPayload event) {
    _logger?.info('AuthPayload event received : ${event.toString()}');
    state.authPayload = event;
  }
}
