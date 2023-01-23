import 'action.dart';

abstract class CallControlAction extends StreamAction {
  const CallControlAction();
}

class SwitchCamera extends CallControlAction {}

class SetCameraEnabled extends CallControlAction {
  const SetCameraEnabled({required this.enabled});
  final bool enabled;
}

class SetMicrophoneEnabled extends CallControlAction {
  const SetMicrophoneEnabled({required this.enabled});
  final bool enabled;
}

class SetScreenShareEnabled extends CallControlAction {
  const SetScreenShareEnabled({required this.enabled});
  final bool enabled;
}
