import '../webrtc/media/constraints/camera_position.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import 'action.dart';

abstract class CallControlAction extends StreamAction {
  const CallControlAction();
}

class AcceptCall extends CallControlAction {
  const AcceptCall();
}

class RejectCall extends CallControlAction {
  const RejectCall();
}

class CancelCall extends CallControlAction {
  const CancelCall();
}

abstract class SessionControlAction extends CallControlAction {
  const SessionControlAction();
}

class SetCameraPosition extends SessionControlAction {
  const SetCameraPosition({required this.cameraPosition});
  final CameraPosition cameraPosition;
}

class SetCameraEnabled extends SessionControlAction {
  const SetCameraEnabled({required this.enabled});
  final bool enabled;
}

class SetMicrophoneEnabled extends SessionControlAction {
  const SetMicrophoneEnabled({required this.enabled});
  final bool enabled;
}

class SetScreenShareEnabled extends SessionControlAction {
  const SetScreenShareEnabled({required this.enabled});
  final bool enabled;
}
