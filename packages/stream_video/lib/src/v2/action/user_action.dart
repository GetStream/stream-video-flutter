abstract class UserAction {
  const UserAction();
}

class AcceptCall extends UserAction {}

class WaitWhenAccepted extends UserAction {}

class RejectCall extends UserAction {}

class SwitchCamera extends UserAction {}

class SetCameraEnabled extends UserAction {
  const SetCameraEnabled({required this.enabled});
  final bool enabled;
}

class SetMicrophoneEnabled extends UserAction {
  const SetMicrophoneEnabled({required this.enabled});
  final bool enabled;
}

class SetScreenShareEnabled extends UserAction {
  const SetScreenShareEnabled({required this.enabled});
  final bool enabled;
}
