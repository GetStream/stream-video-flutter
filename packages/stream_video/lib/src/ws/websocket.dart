import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:protobuf/protobuf.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pbserver.dart';
import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pbserver.dart';
import 'package:stream_video/src/core/http/token.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/state/state.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  WebSocketClient({
    Logger? logger,
    required ClientState state,
    required this.apiKey,
    required this.endpoint,
  })  : _logger = logger,
        _state = state;
  static const pingTimeInterval = Duration(seconds: 20);
  static const pongTimeoutTimeInterval = Duration(seconds: 3);
  late final String _connectionId;
  final ClientState _state;
  final String apiKey;
  IOWebSocketChannel? _channel;
  // late final Uri? uri;
  final String endpoint;
  Timer? pingTimer;
  final Logger? _logger;

  void connect({required UserInfo user, required Token token}) {
    final uri = _buildUri();
    _channel = IOWebSocketChannel.connect(uri);
    _state.connectionStatus = ConnectionStatus.connecting;
    _sendAuthPayload(user, token);
    _state.connectionStatus = ConnectionStatus.initialized;
    _listen();
    _schedulePing();
  }

  void _sendAuthPayload(UserInfo user, Token token) {
    _state.connectionStatus = ConnectionStatus.authenticating;
    final authPayload = _getAuthPayload(user, token);
    _sendPayload(WebsocketClientEvent(authRequest: authPayload));
  }

  void _schedulePing() {
    pingTimer = Timer.periodic(pingTimeInterval, (s) {
      _sendHealthcheck();

      Future.delayed(pongTimeoutTimeInterval, () {
        if (_state.connectionStatus.pingOK == PingOK.notReceived) {
          _state.connectionStatus = ConnectionStatus.disconnected;
          pingTimer?.cancel();
        }
      });
    });
  }

  void _sendHealthcheck() {
    _sendPayload(WebsocketHealthcheck(
      userId: _state.callState.userId,
      clientId: _state.callState.clientId,
      callType: _state.callState.callType,
      callId: _state.callState.callId,
      video: _state.callState.video,
      audio: _state.callState.audio,
    ));
  }

  void _listen() {
    _channel!.stream.listen(
      _onDataReceived,
      onError: _onConnectionError,
      onDone: _onConnectionClosed,
    );
  }

  void _onDataReceived(dynamic data) {
    try {
      final receivedEvent = WebsocketEvent.fromBuffer(data);
      switch (receivedEvent.whichEvent()) {
        case WebsocketEvent_Event.healthcheck:
          {
            return _handleHealthCheckEvent(receivedEvent.healthcheck);
          }
        case WebsocketEvent_Event.callCreated:
          {
            return _handleCallCreated(receivedEvent.callCreated);
          }

        case WebsocketEvent_Event.callUpdated:
          {
            return _handlerCallUpdated(receivedEvent.callUpdated);
          }
        case WebsocketEvent_Event.callEnded:
          {
            return _handleCallEnded(receivedEvent.callEnded);
          }
        case WebsocketEvent_Event.callDeleted:
          {
            return _handleCallDeleted(receivedEvent.callDeleted);
          }
        case WebsocketEvent_Event.userUpdated:
          {
            return _handleUserUpdated(receivedEvent.userUpdated);
          }
        case WebsocketEvent_Event.callMembersUpdated:
          {
            return _handleCallMembersUpdated(receivedEvent.callMembersUpdated);
          }

        case WebsocketEvent_Event.callMembersDeleted:
          {
            return _handleCallMembersDeleted(receivedEvent.callMembersDeleted);
          }

        case WebsocketEvent_Event.notSet:
          // TODO: Handle this case.
          break;

        case WebsocketEvent_Event.callAccepted:
          {
            return _handleCallAccepted(receivedEvent.callAccepted);
          }
        case WebsocketEvent_Event.callRejected:
          {
            return _handleCallRejected(receivedEvent.callRejected);
          }
        case WebsocketEvent_Event.callCancelled:
          {
            return _handleCallCancelled(receivedEvent.callCancelled);
          }
      }

      // handler.call(receivedEvent);
    } catch (e, s) {
      _logger?.severe("error occured $e");
      _logger?.severe("stacktrace $s");
    }
  }

  void _onConnectionError(error) {
    // _state.connectionStatus = const ConnectionStatus(error:" e");
    _logger?.severe("received $error");
  }

  void _onConnectionClosed() {
    _logger?.warning("connection closed");
  }

  WebsocketAuthRequest _getAuthPayload(UserInfo user, Token token) {
    const jsonEncoder = JsonEncoder();
    _logger?.info("getAuthPayload apiKey $apiKey");
    final authPayload = WebsocketAuthRequest(
      token: token.rawValue,
      user: UserInput(
        // id: user.id,
        customJson: utf8.encode(jsonEncoder.convert(user.extraData)),
        name: user.name,
        imageUrl: user.imageUrl,
      ),
      apiKey: apiKey,
      //TODO: remove hardcoded value
      // device: DeviceInput(id: "1", pushProviderId: "firebase"),
    );
    return authPayload;
  }

  void _sendPayload(GeneratedMessage generatedMessage) {
    _channel!.sink.add(generatedMessage.writeToBuffer().buffer.asUint8List());
  }

  Uri _buildUri() => Uri.parse(endpoint);

  void _handleHealthCheckEvent(WebsocketHealthcheck event) {
    _logger?.info('HealthCheck received : ${event.toString()}');
    _state.connectionStatus = ConnectionStatus.connected;
    _logger?.info("client id ${event.clientId}");
    // _connectionId = event.clientId;
    // connectionStatus = ConnectionStatus.connected;
    _state.healthcheck = event;
  }

  void _handleCallCreated(CallCreated event) {
    _logger?.info('CallCreated event received : ${event.toString()}');
    _state.calls.emitCreated(event);
  }

  void _handlerCallUpdated(CallUpdated event) {
    _logger?.info('CallUpdated event received : ${event.toString()}');
    _state.calls.emitUpdated(event);
  }

  void _handleCallEnded(CallEnded event) {
    _logger?.info('CallEnded event received : ${event.toString()}');
    _state.calls.emitEnded(event);
  }

  void _handleCallDeleted(CallDeleted event) {
    _logger?.info('CallDeleted event received : ${event.toString()}');
    _state.calls.emitDeleted(event);
  }

  void _handleCallAccepted(CallAccepted event) {
    _logger?.info('CallAccepted event received : ${event.toString()}');
    _state.calls.emitAccepted(event);
  }

  void _handleCallRejected(CallRejected event) {
    _logger?.info('CallRejected event received : ${event.toString()}');
    _state.calls.emitRejected(event);
  }

  void _handleCallCancelled(CallCancelled event) {
    _logger?.info('CallCancelled event received : ${event.toString()}');
    _state.calls.emitCancelled(event);
  }

  void _handleUserUpdated(UserUpdated event) {
    _logger?.info('UserUpdated event received : ${event.toString()}');
    _state.userUpdated = event;
  }

  void _handleCallMembersUpdated(CallMembersUpdated event) {
    _logger?.info('CallMembersUpdated event received : ${event.toString()}');
    _state.callMembers.emitUpdated(event);
  }

  void _handleCallMembersDeleted(CallMembersDeleted event) {
    _logger?.info('CallMembersDeleted event received : ${event.toString()}');
    _state.callMembers.emitDeleted(event);
  }
}
