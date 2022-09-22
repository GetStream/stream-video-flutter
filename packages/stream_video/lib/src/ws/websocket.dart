import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:protobuf/protobuf.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pbserver.dart';
import 'package:stream_video/protobuf/video/coordinator/push_v1/push.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pbserver.dart';
import 'package:stream_video/src/core/http/token.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/state/state.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  WebSocketClient({Logger? logger, required ClientState state})
      : _logger = logger,
        _state = state;
  static const pingTimeInterval = Duration(seconds: 20);
  static const pongTimeoutTimeInterval = Duration(seconds: 3);
  late final String _connectionId;
  final ClientState _state;
  late final IOWebSocketChannel? _channel;
  // late final Uri? uri;

  late final Timer pingTimer;
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
    _sendPayload(authPayload);
  }

  void _schedulePing() {
    pingTimer = Timer.periodic(pingTimeInterval, (s) {
      _sendHealthcheck();

      Future.delayed(pongTimeoutTimeInterval, () {
        if (_state.connectionStatus.pingOK == PingOK.notReceived) {
          _state.connectionStatus = ConnectionStatus.disconnected;
          pingTimer.cancel();
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
        // case WebsocketEvent_Event.callRinging:
        //   {
        //     return _handleCallRinging(receivedEvent.callRinging);
        //   }
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
        // case WebsocketEvent_Event.participantInvited:
        //   {
        //     return _handleParticipantInvited(receivedEvent.participantInvited);
        //   }
        // case WebsocketEvent_Event.participantUpdated:
        //   {
        //     return _handleParticipantUpdated(receivedEvent.participantUpdated);
        //   }
        // case WebsocketEvent_Event.participantDeleted:
        //   {
        //     return _handleParticipantDeleted(receivedEvent.participantDeleted);
        //   }
        // case WebsocketEvent_Event.participantJoined:
        //   {
        //     return _handleParticipantJoined(receivedEvent.participantJoined);
        //   }
        // case WebsocketEvent_Event.participantLeft:
        //   {
        //     return _handleParticipantLeft(receivedEvent.participantLeft);
        //   }
        // case WebsocketEvent_Event.broadcastStarted:
        //   {
        //     return _handleBroadcastStarted(receivedEvent.broadcastStarted);
        //   }
        // case WebsocketEvent_Event.broadcastEnded:
        //   {
        //     return _handleBroadcastEnded(receivedEvent.broadcastEnded);
        //   }
        // case WebsocketEvent_EventPayload.authPayload:
        //   {
        //     return _handleAuthPayload(receivedEvent.authPayload);
        //   }

        // case WebsocketEvent_Event.audioMuted:
        //   {
        //     return _handleAudioMuted(receivedEvent.audioMuted);
        //   }
        // case WebsocketEvent_Event.audioUnmuted:
        //   {
        //     return _handleAudioUnmuted(receivedEvent.audioUnmuted);
        //   }
        // case WebsocketEvent_Event.videoStarted:
        //   {
        //     return _handleVideoStarted(receivedEvent.videoStarted);
        //   }
        // case WebsocketEvent_Event.videoStopped:
        //   {
        //     return _handleVideoStopped(receivedEvent.videoStopped);
        //   }
        // case WebsocketEvent_Event.screenshareStarted:
        //   {
        //     return _handleScreenshareStarted(receivedEvent.screenshareStarted);
        //   }
        // case WebsocketEvent_Event.screenshareStopped:
        //   {
        //     return _handleScreenshareStopped(receivedEvent.screenshareStopped);
        //   }
        // case WebsocketEvent_Event.recordingStarted:
        //   {
        //     return _handleRecordingStarted(receivedEvent.recordingStarted);
        //   }
        // case WebsocketEvent_Event.recordingStopped:
        //   {
        //     return _handleRecordingStopped(receivedEvent.recordingStopped);
        //   }
        case WebsocketEvent_Event.notSet:
          // TODO: Handle this case.
          break;
        case WebsocketEvent_Event.callStarted:
          {
            return _handleCallStarted(receivedEvent.callStarted);
          }
      }

      // handler.call(receivedEvent);
    } catch (e, s) {
      print("error occured $e");
      print("stacktrace $s");
    }
  }

  void _onConnectionError(error) {
    // _state.connectionStatus = const ConnectionStatus(error:" e");
    print("received $error");
  }

  void _onConnectionClosed() {
    print("connection closed");
  }

  WebsocketAuthRequest _getAuthPayload(UserInfo user, Token token) {
    const jsonEncoder = JsonEncoder();
    final authPayload = WebsocketAuthRequest(
        user: UserInput(
          // id: user.id,
          customJson: utf8.encode(jsonEncoder.convert(user.extraData)),
          name: user.name,
          imageUrl: user.imageUrl,
        ),
        token: token.rawValue,
        //TODO: remove hardcoded value
        device: DeviceInput(id: "1", pushProviderId: "firebase"));
    return authPayload;
  }

  void _sendPayload(GeneratedMessage generatedMessage) {
    _channel!.sink.add(generatedMessage.writeToBuffer().buffer.asUint8List());
  }

  Uri _buildUri() => Uri.parse('ws://192.168.1.17:8989');

  void _handleHealthCheckEvent(WebsocketHealthcheck event) {
    _logger?.info('HealthCheck received : ${event.toString()}');
    _state.connectionStatus = ConnectionStatus.connected;
    print(event.clientId);
    // _connectionId = event.clientId;
    // connectionStatus = ConnectionStatus.connected;
    _state.healthcheck = event;
  }

  // void _handleCallRinging(CallRinging event) {
  //   _logger?.info('CallRinging event received : ${event.toString()}');
  //   _state.calls.emitRinging(event);
  // }

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

   void _handleCallStarted(CallStarted event) {
       _logger?.info('CallStarted event received : ${event.toString()}');
    _state.calls.emitStarted(event);
  }

  void _handleUserUpdated(UserUpdated event) {
    _logger?.info('UserUpdated event received : ${event.toString()}');
    _state.userUpdated = event;
  }

  // void _handleParticipantInvited(CallMembersUpdated event) {
  //   _logger?.info(
  //       'ParticipantInvited event received : ${event.participant.toString()}');
  //   _state.participants.emitInvited(event);
  // }

  // void _handleParticipantUpdated(CallMembersUpdated event) {
  //   _logger?.info('ParticipantUpdated event received : ${event.toString()}');
  //   _state.participants.emitUpdated(event);
  // }

  // void _handleParticipantDeleted(CallMembersDeleted event) {
  //   _logger?.info('ParticipantDeleted event received : ${event.toString()}');
  //   _state.participants.emitDeleted(event);
  // }

  // void _handleParticipantJoined(ParticipantJoined event) {
  //   _logger?.info(
  //       'ParticipantJoined event received : ${event.toString()}');
  //   _state.participants.emitJoined(event);
  // }

  // void _handleParticipantLeft(ParticipantLeft event) {
  //   _logger?.info(
  //       'ParticipantLeft event received : ${event.toString()}');
  //   _state.participants.emitLeft(event);
  // }

  // void _handleBroadcastStarted(BroadcastStarted event) {
  //   _logger?.info('BroadcastStarted event received : ${event.toString()}');
  //   _state.broadcasts.emitStarted(event);
  // }

  // void _handleBroadcastEnded(BroadcastEnded event) {
  //   _logger?.info('BroadcastEnded event received : ${event.toString()}');
  //   _state.broadcasts.emitEnded(event);
  // }

  // void _handleAuthPayload(WebsocketAuthRequest event) {
  //   _logger?.info('AuthPayload event received : ${event.toString()}');
  //   _state.authPayload = event;
  // }

  // void _handleAudioMuted(AudioMuted event) {
  //   _logger?.info('AudioMuted event received : ${event.toString()}');
  //   _state.audios.emitMuted(event);
  // }

  // void _handleAudioUnmuted(AudioUnmuted event) {
  //   _logger?.info('AudioUnmuted event received : ${event.toString()}');
  //   _state.audios.emitUnmuted(event);
  // }

  // void _handleVideoStarted(VideoStarted event) {
  //   _logger?.info('VideoStarted event received : ${event.toString()}');
  //   _state.videos.emitStarted(event);
  // }

  // void _handleVideoStopped(VideoStopped event) {
  //   _logger?.info('VideoStopped event received : ${event.toString()}');
  //   _state.videos.emitStopped(event);
  // }

  // void _handleScreenshareStarted(ScreenshareStarted event) {
  //   _logger?.info('ScreenshareStarted event received : ${event.toString()}');
  //   _state.screenshares.emitStarted(event);
  // }

  // void _handleScreenshareStopped(ScreenshareStopped event) {
  //   _logger?.info('ScreenshareStopped event received : ${event.toString()}');
  //   _state.screenshares.emitStopped(event);
  // }

  // void _handleRecordingStarted(RecordingStarted event) {
  //   _logger?.info('RecordingStarted event received : ${event.toString()}');
  //   _state.recordings.emitStarted(event);
  // }

  // void _handleRecordingStopped(RecordingStopped event) {
  //   _logger?.info('RecordingStopped event received : ${event.toString()}');
  //   _state.recordings.emitStopped(event);
  // }

  void _handleCallMembersUpdated(CallMembersUpdated event) {
    _logger?.info('CallMembersUpdated event received : ${event.toString()}');
    _state.callMembers.emitUpdated(event);
  }

  void _handleCallMembersDeleted(CallMembersDeleted event) {
     _logger?.info('CallMembersDeleted event received : ${event.toString()}');
    _state.callMembers.emitDeleted(event);
  }
  
 
}

