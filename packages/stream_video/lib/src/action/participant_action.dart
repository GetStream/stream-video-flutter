import 'package:equatable/equatable.dart';

import '../models/viewport_visibility.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../webrtc/media/constraints/camera_position.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import '../webrtc/rtc_media_device/rtc_media_device.dart';
import 'external_action.dart';

abstract class ParticipantAction extends StreamExternalAction
    with EquatableMixin {
  const ParticipantAction();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class SetParticipantPinned extends ParticipantAction {
  const SetParticipantPinned({
    required this.sessionId,
    required this.pinned,
  });

  final String sessionId;
  final bool pinned;

  @override
  List<Object?> get props => [sessionId, pinned];
}

class UpdateViewportVisibility extends ParticipantAction {
  const UpdateViewportVisibility({
    required this.sessionId,
    required this.visibility,
  });

  final String sessionId;
  final ViewportVisibility visibility;

  @override
  List<Object?> get props => [sessionId, visibility];
}

class UpdateViewportVisibilities extends ParticipantAction {
  const UpdateViewportVisibilities(this.actions);

  final List<UpdateViewportVisibility> actions;

  @override
  List<Object?> get props => [actions];
}

abstract class LocalParticipantAction extends ParticipantAction {
  const LocalParticipantAction();

  const factory LocalParticipantAction.setCameraPosition({
    required CameraPosition cameraPosition,
  }) = SetCameraPosition;

  const factory LocalParticipantAction.flipCamera() = FlipCamera;

  const factory LocalParticipantAction.setVideoInputDevice({
    required RtcMediaDevice device,
  }) = SetVideoInputDevice;

  const factory LocalParticipantAction.setCameraEnabled({
    required bool enabled,
  }) = SetCameraEnabled;

  const factory LocalParticipantAction.setAudioInputDevice({
    required RtcMediaDevice device,
  }) = SetAudioInputDevice;

  const factory LocalParticipantAction.setMicrophoneEnabled({
    required bool enabled,
  }) = SetMicrophoneEnabled;

  const factory LocalParticipantAction.setScreenShareEnabled({
    required bool enabled,
  }) = SetScreenShareEnabled;

  const factory LocalParticipantAction.setAudioOutputDevice({
    required RtcMediaDevice device,
  }) = SetAudioOutputDevice;
}

class SetCameraPosition extends LocalParticipantAction {
  const SetCameraPosition({required this.cameraPosition});

  final CameraPosition cameraPosition;

  @override
  List<Object?> get props => [cameraPosition];
}

class FlipCamera extends LocalParticipantAction {
  const FlipCamera();
}

class SetVideoInputDevice extends LocalParticipantAction {
  const SetVideoInputDevice({required this.device});

  final RtcMediaDevice device;

  @override
  List<Object?> get props => [device];
}

class SetCameraEnabled extends LocalParticipantAction {
  const SetCameraEnabled({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class SetAudioInputDevice extends LocalParticipantAction {
  const SetAudioInputDevice({required this.device});

  final RtcMediaDevice device;

  @override
  List<Object?> get props => [device];
}

class SetMicrophoneEnabled extends LocalParticipantAction {
  const SetMicrophoneEnabled({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class SetScreenShareEnabled extends LocalParticipantAction {
  const SetScreenShareEnabled({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class SetAudioOutputDevice extends LocalParticipantAction {
  const SetAudioOutputDevice({required this.device});

  final RtcMediaDevice device;

  @override
  List<Object?> get props => [device];
}

abstract class RemoteParticipantAction extends ParticipantAction {
  const RemoteParticipantAction();

  const factory RemoteParticipantAction.setSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required Map<SfuTrackTypeVideo, RtcVideoDimension> trackTypes,
  }) = SetSubscription;

  const factory RemoteParticipantAction.setSubscriptions(
    List<SetSubscription> actions,
  ) = SetSubscriptions;

  const factory RemoteParticipantAction.updateSubscriptions(
    List<SubscriptionAction> actions,
  ) = UpdateSubscriptions;

  const factory RemoteParticipantAction.updateSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) = UpdateSubscription;

  const factory RemoteParticipantAction.removeSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
  }) = RemoveSubscription;
}

class SetSubscription extends RemoteParticipantAction {
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

class SetSubscriptions extends RemoteParticipantAction {
  const SetSubscriptions(this.actions);

  final List<SetSubscription> actions;

  @override
  List<Object?> get props => [actions];
}

class UpdateSubscriptions extends RemoteParticipantAction {
  const UpdateSubscriptions(this.actions);

  final List<SubscriptionAction> actions;

  @override
  List<Object?> get props => [actions];
}

abstract class SubscriptionAction extends RemoteParticipantAction {
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
