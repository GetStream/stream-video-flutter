import '../../platform_detector/platform_detector.dart';
import '../model/rtc_video_parameters.dart';
import 'constraints/facing_mode.dart';
import 'constraints/mirror_mode.dart';
import 'video_constraints.dart';

/// Options used when creating a video track that captures the camera.
/// [mirror]: Whether the video should be mirrored. If set to null, the default is true when facingMode is user and false when facingMode is environment.
class CameraConstraints extends VideoConstraints {
  const CameraConstraints({
    this.facingMode = FacingMode.user,
    this.mirrorMode = MirrorMode.defaultMode,
    super.deviceId,
    super.maxFrameRate,
    super.params = RtcVideoParametersPresets.h720_16x9,
  });

  CameraConstraints.from({required VideoConstraints constraints})
      : facingMode = FacingMode.user,
        mirrorMode = MirrorMode.defaultMode,
        super(
          deviceId: constraints.deviceId,
          maxFrameRate: constraints.maxFrameRate,
          params: constraints.params,
        );

  final FacingMode facingMode;
  final MirrorMode mirrorMode;

  @override
  Map<String, dynamic> toMap() {
    final constraints = <String, dynamic>{
      ...super.toMap(),
      'facingMode': facingMode.alias,
      'mirror': mirrorMode.name,
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
    MirrorMode? mirrorMode,
  }) =>
      CameraConstraints(
        params: params ?? this.params,
        facingMode: facingMode ?? this.facingMode,
        deviceId: deviceId ?? this.deviceId,
        maxFrameRate: maxFrameRate ?? this.maxFrameRate,
        mirrorMode: mirrorMode ?? this.mirrorMode,
      );
}
