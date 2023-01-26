import '../webrtc/media/constraints/camera_position.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import 'action.dart';

abstract class CallControlAction extends StreamAction {
  const CallControlAction();
}

// Publisher actions

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

// Subscriber actions

class SubscribeCameraTrack extends CallControlAction {
  const SubscribeCameraTrack({
    required this.userId,
    required this.videoDimension,
  });

  final String userId;
  final RtcVideoDimension videoDimension;
}

class SubscribeScreenShareTrack extends CallControlAction {
  const SubscribeScreenShareTrack({
    required this.userId,
    required this.videoDimension,
  });

  final String userId;
  final RtcVideoDimension videoDimension;
}
