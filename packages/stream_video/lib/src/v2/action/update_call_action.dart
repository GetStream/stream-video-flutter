import 'action.dart';

abstract class UpdateCallAction extends StreamAction {
  const UpdateCallAction();
}

class SwitchCamera extends UpdateCallAction {}

class SetCameraEnabled extends UpdateCallAction {
  const SetCameraEnabled({required this.enabled});
  final bool enabled;
}

class SetMicrophoneEnabled extends UpdateCallAction {
  const SetMicrophoneEnabled({required this.enabled});
  final bool enabled;
}

class SetScreenShareEnabled extends UpdateCallAction {
  const SetScreenShareEnabled({required this.enabled});
  final bool enabled;
}
