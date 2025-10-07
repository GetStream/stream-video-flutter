/// Object CallEvent.
class CallEvent {
  CallEvent(this.body, this.event);

  final Event event;
  final dynamic body;

  @override
  String toString() => 'CallEvent( body: $body, event: $event)';
}

enum Event {
  actionDidUpdateDevicePushTokenVoip,
  actionCallIncoming,
  actionCallStart,
  actionCallAccept,
  actionCallDecline,
  actionCallEnded,
  actionCallTimeout,
  actionCallConnected,
  actionCallCallback,
  actionCallToggleHold,
  actionCallToggleMute,
  actionCallToggleDtmf,
  actionCallToggleGroup,
  actionCallToggleAudioSession,
  actionCallCustom,
}

/// Using extension for backward compatibility Dart SDK 2.17.0 and lower
extension EventX on Event {
  String get name {
    switch (this) {
      case Event.actionDidUpdateDevicePushTokenVoip:
        return 'io.getstream.video.DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP';
      case Event.actionCallIncoming:
        return 'io.getstream.video.ACTION_CALL_INCOMING';
      case Event.actionCallStart:
        return 'io.getstream.video.ACTION_CALL_START';
      case Event.actionCallAccept:
        return 'io.getstream.video.ACTION_CALL_ACCEPT';
      case Event.actionCallDecline:
        return 'io.getstream.video.ACTION_CALL_DECLINE';
      case Event.actionCallEnded:
        return 'io.getstream.video.ACTION_CALL_ENDED';
      case Event.actionCallTimeout:
        return 'io.getstream.video.ACTION_CALL_TIMEOUT';
      case Event.actionCallConnected:
        return 'io.getstream.video.ACTION_CALL_CONNECTED';
      case Event.actionCallCallback:
        return 'io.getstream.video.ACTION_CALL_CALLBACK';
      case Event.actionCallToggleHold:
        return 'io.getstream.video.ACTION_CALL_TOGGLE_HOLD';
      case Event.actionCallToggleMute:
        return 'io.getstream.video.ACTION_CALL_TOGGLE_MUTE';
      case Event.actionCallToggleDtmf:
        return 'io.getstream.video.ACTION_CALL_TOGGLE_DTMF';
      case Event.actionCallToggleGroup:
        return 'io.getstream.video.ACTION_CALL_TOGGLE_GROUP';
      case Event.actionCallToggleAudioSession:
        return 'io.getstream.video.ACTION_CALL_TOGGLE_AUDIO_SESSION';
      case Event.actionCallCustom:
        return 'io.getstream.video.ACTION_CALL_CUSTOM';
    }
  }
}
