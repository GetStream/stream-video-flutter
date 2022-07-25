
import 'package:logging/logging.dart';
import 'package:protobuf/protobuf.dart';
import 'package:stream_video/protobuf/video_events/events.pbserver.dart';
import 'package:stream_video/protobuf/video_models/models.pb.dart';
import 'package:stream_video/src/core/http/token.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  WebSocketClient({Logger? logger}) : _logger = logger;
  late final IOWebSocketChannel? channel;
  late final Uri? uri;

  final Logger? _logger;

  void connect({required User user, required Token token}) {
    uri = _buildUri();
    channel = IOWebSocketChannel.connect(uri!);

    final authPayload = getAuthPayload(user, token);
    _sendPayload(authPayload);
    listen();
  }

  void listen() {
    channel!.stream.listen(
      (event) => _onDataReceived(event),
      onError: _onConnectionError,
      onDone: _onConnectionClosed,
    );
  }

  void _onDataReceived(dynamic data) {
    try {
      final receivedEvent = WebsocketEvent.fromBuffer(data);
      switch (receivedEvent.whichEventPayload()) {
        case WebsocketEvent_EventPayload.healthCheck:
          {
            return _handleHealthCheckEvent(receivedEvent.healthCheck);
          }
        case WebsocketEvent_EventPayload.callCreated:
          {
            return _handleCallCreated(receivedEvent.callCreated);
          }
        case WebsocketEvent_EventPayload.callRinging:
          {
            return _handleCallRinging(receivedEvent.callRinging);
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

  void _onConnectionError(error) {
    print("received $error");
  }

  void _onConnectionClosed() {
    print("connection closed");
  }

  AuthPayload getAuthPayload(User user, Token token) {
    final authPayload = AuthPayload(
        user: UserRequest(
          id: user.id, //TODO: ext for converting User to UserRequest
          // custom: Struct(
          //     fields: {"something": Value(stringValue: "something")})
        ),
        token: token.toString(),
        device: DeviceRequest(disabled: true));
    return authPayload;
  }

  void _sendPayload(GeneratedMessage generatedMessage) {
    channel!.sink.add(generatedMessage.writeToBuffer().buffer.asUint8List());
  }

  Uri _buildUri() => Uri.parse('ws://127.0.0.1:8989');

  void _handleHealthCheckEvent(Healthcheck event) {
    _logger?.info('HealthCheck received : ${event.toString()}');

    // _connectionId = event.clientId;

    // connectionStatus = ConnectionStatus.connected;
    // state.healthcheck = event;
  }

  void _handleCallRinging(CallRinging event) {
    _logger?.info('CallRinging event received : ${event.call.toString()}');
    // state.callRinging = event;
  }

  void _handleCallCreated(CallCreated event) {
    _logger?.info('CallCreated event received : ${event.call.toString()}');
    // state.callCreated = event;
  }

  void _handlerCallUpdated(CallUpdated event) {
    _logger?.info('CallUpdated event received : ${event.call.toString()}');
    // state.callUpdated = event;
  }

  void _handleCallEnded(CallEnded event) {
    _logger?.info('CallEnded event received : ${event.call.toString()}');
    // state.callEnded = event;
  }

  void _handleCallDeleted(CallDeleted event) {
    _logger?.info('CallDeleted event received : ${event.call.toString()}');
    // state.callDeleted = event;
  }

  void _handleUserUpdated(UserUpdated event) {
    _logger?.info('UserUpdated event received : ${event.user.toString()}');
    // state.userUpdated = event;
  }

  void _handleParticipantInvited(ParticipantInvited event) {
    _logger?.info(
        'ParticipantInvited event received : ${event.participant.toString()}');
    // state.participantInvited = event;
  }

  void _handleParticipantUpdated(ParticipantUpdated event) {
    _logger?.info(
        'ParticipantUpdated event received : ${event.participant.toString()}');
    // state.participantUpdated = event;
  }

  void _handleParticipantDeleted(ParticipantDeleted event) {
    _logger?.info('ParticipantDeleted event received : ${event.userId}');
    // state.participantDeleted = event;
  }

  void _handleParticipantJoined(ParticipantJoined event) {
    _logger?.info(
        'ParticipantJoined event received : ${event.participant.toString()}');
    // state.participantJoined = event;
  }

  void _handleParticipantLeft(ParticipantLeft event) {
    _logger?.info(
        'ParticipantLeft event received : ${event.participant.toString()}');
    // state.participantLeft = event;
  }

  void _handleBroadcastStarted(BroadcastStarted event) {
    _logger?.info(
        'BroadcastStarted event received : ${event.call.toString()}');
    // state.broadcastStarted = event;
  }

  void _handleBroadcastEnded(BroadcastEnded event) {
    _logger
        ?.info('BroadcastEnded event received : ${event.call.toString()}');
    // state.broadcastEnded = event;
  }

  void _handleAuthPayload(AuthPayload event) {
    _logger?.info('AuthPayload event received : ${event.toString()}');
    // state.authPayload = event;
  }
}
