import '../../action/participant_action.dart';
import '../../models/viewport_visibility.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../webrtc/media/constraints/camera_position.dart';
import '../../webrtc/model/rtc_video_dimension.dart';
import '../../webrtc/rtc_media_device/rtc_media_device.dart';
import '../call.dart';

extension ParticipantExtensions on Call {
  Future<Result<None>> setParticipantPinned({
    required String sessionId,
    required bool pinned,
  }) {
    return apply(
      SetParticipantPinned(
        sessionId: sessionId,
        pinned: pinned,
      ),
    );
  }

  Future<Result<None>> setParticipantViewportVisibility({
    required String sessionId,
    required ViewportVisibility visibility,
  }) {
    return apply(
      SetParticipantViewportVisibility(
        sessionId: sessionId,
        visibility: visibility,
      ),
    );
  }
}

extension LocalParticipantExtensions on Call {
  Future<Result<None>> setCameraPosition(CameraPosition cameraPosition) {
    return apply(
      LocalParticipantAction.setCameraPosition(cameraPosition: cameraPosition),
    );
  }

  Future<Result<None>> flipCamera() {
    return apply(const LocalParticipantAction.flipCamera());
  }

  Future<Result<None>> setVideoInputDevice(RtcMediaDevice device) {
    return apply(LocalParticipantAction.setVideoInputDevice(device: device));
  }

  Future<Result<None>> setCameraEnabled({required bool enabled}) {
    return apply(LocalParticipantAction.setCameraEnabled(enabled: enabled));
  }

  Future<Result<None>> setMicrophoneEnabled({required bool enabled}) {
    return apply(LocalParticipantAction.setMicrophoneEnabled(enabled: enabled));
  }

  Future<Result<None>> setScreenShareEnabled({required bool enabled}) {
    return apply(
      LocalParticipantAction.setScreenShareEnabled(enabled: enabled),
    );
  }

  Future<Result<None>> setAudioInputDevice(RtcMediaDevice device) {
    return apply(LocalParticipantAction.setAudioInputDevice(device: device));
  }

  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) {
    return apply(LocalParticipantAction.setAudioOutputDevice(device: device));
  }
}

extension RemoteParticipantExtensions on Call {
  Future<Result<None>> setSubscriptions(List<SetSubscription> actions) {
    return apply(RemoteParticipantAction.setSubscriptions(actions));
  }

  Future<Result<None>> updateSubscriptions(List<SubscriptionAction> actions) {
    return apply(RemoteParticipantAction.updateSubscriptions(actions));
  }

  Future<Result<None>> setSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required Map<SfuTrackTypeVideo, RtcVideoDimension> trackTypes,
  }) {
    return apply(
      RemoteParticipantAction.setSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackTypes: trackTypes,
      ),
    );
  }

  Future<Result<None>> updateSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) {
    return apply(
      RemoteParticipantAction.updateSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        videoDimension: videoDimension,
      ),
    );
  }

  Future<Result<None>> removeSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) {
    return apply(
      RemoteParticipantAction.removeSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
      ),
    );
  }
}
