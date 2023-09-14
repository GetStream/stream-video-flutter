part of 'push_notification_manager.dart';

sealed class CallKitEvent {
  const CallKitEvent(this.body);

  final Object? body;
}

class ActionDidUpdateDevicePushTokenVoip extends CallKitEvent {
  const ActionDidUpdateDevicePushTokenVoip(super.body);
}

class ActionCallIncoming extends CallKitEvent {
  const ActionCallIncoming(super.body);
}

class ActionCallStart extends CallKitEvent {
  const ActionCallStart(super.body);
}

class ActionCallAccept extends CallKitEvent {
  const ActionCallAccept(super.body);
}

class ActionCallDecline extends CallKitEvent {
  const ActionCallDecline(super.body);
}

class ActionCallEnded extends CallKitEvent {
  const ActionCallEnded(super.body);
}

class ActionCallTimeout extends CallKitEvent {
  const ActionCallTimeout(super.body);
}

class ActionCallCallback extends CallKitEvent {
  const ActionCallCallback(super.body);
}

class ActionCallToggleHold extends CallKitEvent {
  const ActionCallToggleHold(super.body);
}

class ActionCallToggleMute extends CallKitEvent {
  const ActionCallToggleMute(super.body);
}

class ActionCallToggleDmtf extends CallKitEvent {
  const ActionCallToggleDmtf(super.body);
}

class ActionCallToggleGroup extends CallKitEvent {
  const ActionCallToggleGroup(super.body);
}

class ActionCallToggleAudioSession extends CallKitEvent {
  const ActionCallToggleAudioSession(super.body);
}

class ActionCallCustom extends CallKitEvent {
  const ActionCallCustom(super.body);
}
