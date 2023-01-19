import '../../../../stream_video.dart';
import '../../../platform_detector/platform_detector.dart';
import '../model/rtc_video_parameters.dart';
import 'video_constraints.dart';

/// Options used when creating a video track that captures the camera.
class CameraConstraints extends VideoConstraints {
  const CameraConstraints({
    super.deviceId,
    this.cameraPosition = CameraPosition.front,
    super.maxFrameRate,
    super.params = RtcVideoParametersPresets.h720_169,
  });

  CameraConstraints.from({required VideoConstraints constraints})
      : cameraPosition = CameraPosition.front,
        super(
          deviceId: constraints.deviceId,
          maxFrameRate: constraints.maxFrameRate,
          params: constraints.params,
        );

  final CameraPosition cameraPosition;

  @override
  Map<String, dynamic> toMap() {
    final constraints = <String, dynamic>{
      ...params.toMediaConstraintsMap(),
      'facingMode':
          cameraPosition == CameraPosition.front ? 'user' : 'environment',
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
    CameraPosition? cameraPosition,
    String? deviceId,
    double? maxFrameRate,
  }) =>
      CameraConstraints(
        params: params ?? this.params,
        cameraPosition: cameraPosition ?? this.cameraPosition,
        deviceId: deviceId ?? this.deviceId,
        maxFrameRate: maxFrameRate ?? this.maxFrameRate,
      );
}
