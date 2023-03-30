import 'package:equatable/equatable.dart';

import '../call_permission.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../webrtc/media/constraints/camera_position.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import '../webrtc/rtc_media_device/rtc_media_device.dart';
import 'action.dart';

abstract class CallControlAction extends StreamAction with EquatableMixin {
  const CallControlAction();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
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

class EndCall extends CallControlAction {
  const EndCall();
}

class RequestPermissions extends CallControlAction {
  const RequestPermissions({
    required this.permissions,
  });

  final List<CallPermission> permissions;

  @override
  List<Object?> get props => [permissions];
}

class UpdateUserPermissions extends CallControlAction {
  const UpdateUserPermissions({
    required this.userId,
    this.grantPermissions = const [],
    this.revokePermissions = const [],
  });

  final String userId;
  final List<CallPermission> grantPermissions;
  final List<CallPermission> revokePermissions;

  @override
  List<Object?> get props => [userId, grantPermissions, revokePermissions];
}

class BlockUser extends CallControlAction {
  const BlockUser({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class UnblockUser extends CallControlAction {
  const UnblockUser({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class MuteUsers extends CallControlAction {
  const MuteUsers({
    required this.userIds,
  });

  final List<String> userIds;

  @override
  List<Object?> get props => [userIds];
}

class StartTranscription extends CallControlAction {
  const StartTranscription();
}

class StopTranscription extends CallControlAction {
  const StopTranscription();
}

class StartRecording extends CallControlAction {
  const StartRecording();
}

class StopRecording extends CallControlAction {
  const StopRecording();
}

class StartBroadcasting extends CallControlAction {
  const StartBroadcasting();
}

class StopBroadcasting extends CallControlAction {
  const StopBroadcasting();
}

abstract class SessionControlAction extends CallControlAction {
  const SessionControlAction();
}

class SetCameraPosition extends SessionControlAction {
  const SetCameraPosition({required this.cameraPosition});
  final CameraPosition cameraPosition;

  @override
  List<Object?> get props => [cameraPosition];
}

class FlipCamera extends SessionControlAction {
  const FlipCamera();
}

class SetVideoInputDevice extends SessionControlAction {
  const SetVideoInputDevice({required this.device});
  final RtcMediaDevice device;

  @override
  List<Object?> get props => [device];
}

class SetCameraEnabled extends SessionControlAction {
  const SetCameraEnabled({required this.enabled});
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class SetAudioInputDevice extends SessionControlAction {
  const SetAudioInputDevice({required this.device});
  final RtcMediaDevice device;

  @override
  List<Object?> get props => [device];
}

class SetMicrophoneEnabled extends SessionControlAction {
  const SetMicrophoneEnabled({required this.enabled});
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class SetScreenShareEnabled extends SessionControlAction {
  const SetScreenShareEnabled({required this.enabled});
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class SetAudioOutputDevice extends SessionControlAction {
  const SetAudioOutputDevice({required this.device});
  final RtcMediaDevice device;

  @override
  List<Object?> get props => [device];
}

class SetSubscription extends SessionControlAction {
  const SetSubscription({
    required this.userId,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.trackTypes,
  });

  final String userId;
  final String sessionId;
  final String trackIdPrefix;
  final Map<SfuTrackTypeVideo, RtcVideoDimension> trackTypes;

  @override
  List<Object?> get props => [userId, sessionId, trackIdPrefix, trackTypes];
}

class SetSubscriptions extends SessionControlAction {
  const SetSubscriptions(this.actions);

  final List<SetSubscription> actions;

  @override
  List<Object?> get props => [actions];
}

class UpdateSubscriptions extends SessionControlAction {
  const UpdateSubscriptions(this.actions);

  final List<SubscriptionAction> actions;

  @override
  List<Object?> get props => [actions];
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

class UpdateSubscription extends SubscriptionAction {
  const UpdateSubscription({
    required super.userId,
    required super.sessionId,
    required super.trackIdPrefix,
    required super.trackType,
    this.videoDimension,
  });

  final RtcVideoDimension? videoDimension;

  @override
  List<Object?> get props => [
        userId,
        sessionId,
        trackIdPrefix,
        trackType,
        videoDimension,
      ];
}

class RemoveSubscription extends SubscriptionAction {
  const RemoveSubscription({
    required super.userId,
    required super.sessionId,
    required super.trackIdPrefix,
    required super.trackType,
  });

  @override
  List<Object?> get props => [
        userId,
        sessionId,
        trackIdPrefix,
        trackType,
      ];
}
