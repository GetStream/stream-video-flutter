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
  actionCallIncomingFailed,
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
  actionCallCustom;

  /// The event whose [EventX.wireName] is [wireName], or null for a name this
  /// version of the package does not know.
  ///
  /// Null rather than a throw: a newer native side may send an event an older
  /// Dart side has no case for, and that must not break the event stream.
  static Event? fromWireName(String? wireName) {
    for (final event in values) {
      if (event.wireName == wireName) return event;
    }
    return null;
  }
}

/// The names the native sides send on the event channel, one per [Event].
///
/// Kept as an explicit getter rather than shadowing `Enum.name` through an
/// extension, so the mapping does not depend on extension resolution rules.
/// The Swift and Kotlin constants these have to match are pinned by
/// `test/push_channel_contract_test.dart`.
extension EventX on Event {
  /// The event name on the wire, as emitted by Swift and Kotlin.
  String get wireName {
    switch (this) {
      case Event.actionDidUpdateDevicePushTokenVoip:
        return 'io.getstream.video.DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP';
      case Event.actionCallIncoming:
        return 'io.getstream.video.ACTION_CALL_INCOMING';
      case Event.actionCallIncomingFailed:
        return 'io.getstream.video.ACTION_CALL_INCOMING_FAILED';
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
