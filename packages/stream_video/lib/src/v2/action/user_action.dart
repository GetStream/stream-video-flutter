abstract class UserAction {}

class AcceptCall extends UserAction {}

class WaitWhenAccepted extends UserAction {}

class RejectCall extends UserAction {}

class SwitchCamera extends UserAction {}

class UpdateMuted extends UserAction {
  UpdateMuted({required this.muted});

  final bool muted;
}
