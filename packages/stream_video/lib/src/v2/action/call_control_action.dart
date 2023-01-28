import '../sfu/data/models/sfu_track_type.dart';
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
  final CameraPositionV2 cameraPosition;
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

class UpdateSubscriptions extends SessionControlAction {
  const UpdateSubscriptions(this.actions);

  final List<SubscriptionAction> actions;
}

abstract class SubscriptionAction extends SessionControlAction {
  const SubscriptionAction({
    required this.userId,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.trackType,
  }) : trackId = '$trackIdPrefix:$trackType';

  final String userId;
  final String sessionId;
  final String trackIdPrefix;
  final SfuTrackTypeVideo trackType;

  final String trackId;
}

class SubscribeVideoTrack extends SubscriptionAction {
  const SubscribeVideoTrack({
    required super.userId,
    required super.sessionId,
    required super.trackIdPrefix,
    required super.trackType,
    this.videoDimension = RtcVideoDimensionPresets.h720_169,
  });

  final RtcVideoDimension videoDimension;
}

class UnsubscribeVideoTrack extends SubscriptionAction {
  const UnsubscribeVideoTrack({
    required super.userId,
    required super.sessionId,
    required super.trackIdPrefix,
    required super.trackType,
  });
}
