import 'package:stream_video/src/platform_detector/platform_detector.dart';
import 'package:stream_video/src/webrtc/media/constraints/facing_mode.dart';
import 'package:stream_video/src/webrtc/media/video_constraints.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_parameters.dart';

/// Options used when creating a video track that captures the camera.
class CameraConstraints extends VideoConstraints {
  const CameraConstraints({
    super.deviceId,
    this.facingMode = FacingMode.user,
    super.maxFrameRate,
    super.params = RtcVideoParametersPresets.h720_16x9,
  });

  CameraConstraints.from({required VideoConstraints constraints})
      : facingMode = FacingMode.user,
        super(
          deviceId: constraints.deviceId,
          maxFrameRate: constraints.maxFrameRate,
          params: constraints.params,
        );

  final FacingMode facingMode;

  @override
  Map<String, dynamic> toMap() {
    final constraints = <String, dynamic>{
      ...super.toMap(),
      'facingMode': facingMode.alias,
    };
    if (deviceId != null) {
      if (CurrentPlatform.isWeb) {
        constraints['deviceId'] = deviceId;
      } else {
        constraints['optional'] = [
          {'sourceId': deviceId},
        ];
      }
    }
    if (maxFrameRate != null) {
      constraints['frameRate'] = {'max': maxFrameRate};
    }
    return {
      'audio': false,
      'video': constraints,
    };
  }

  @override
  CameraConstraints copyWith({
    RtcVideoParameters? params,
    FacingMode? facingMode,
    String? deviceId,
    double? maxFrameRate,
  }) =>
      CameraConstraints(
        params: params ?? this.params,
        facingMode: facingMode ?? this.facingMode,
        deviceId: deviceId ?? this.deviceId,
        maxFrameRate: maxFrameRate ?? this.maxFrameRate,
      );
}
