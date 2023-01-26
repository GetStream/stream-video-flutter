import '../webrtc/media/constraints/camera_position.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import 'action.dart';

abstract class CallControlAction extends StreamAction {
  const CallControlAction();
}

class SetCameraPosition extends CallControlAction {
  const SetCameraPosition({required this.cameraPosition});
  final CameraPosition cameraPosition;
}

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
