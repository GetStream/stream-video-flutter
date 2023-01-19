import 'action.dart';

abstract class UserAction extends StreamAction {
  const UserAction();
}

abstract class EstablishCall extends UserAction {
  const EstablishCall();
}

class AcceptCall extends EstablishCall {}

class RejectCall extends EstablishCall {}

class WaitWhenAccepted extends EstablishCall {}

class CancelCall extends EstablishCall {}

abstract class UpdateCall extends UserAction {
  const UpdateCall();
}

class SwitchCamera extends UpdateCall {}

class SetCameraEnabled extends UpdateCall {
  const SetCameraEnabled({required this.enabled});
  final bool enabled;
}

class SetMicrophoneEnabled extends UpdateCall {
  const SetMicrophoneEnabled({required this.enabled});
  final bool enabled;
}

class SetScreenShareEnabled extends UpdateCall {
  const SetScreenShareEnabled({required this.enabled});
  final bool enabled;
}
