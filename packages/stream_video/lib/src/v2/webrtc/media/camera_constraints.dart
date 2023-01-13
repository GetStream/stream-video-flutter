import '../../../../stream_video.dart';
import '../../../platform_detector/platform_detector.dart';
import '../../../types/video_parameters.dart';
import 'media_constraints.dart';

/// Options used when creating a video track that captures the camera.
class CameraConstraints extends MediaConstraints {
  const CameraConstraints({
    super.deviceId,
    this.cameraPosition = CameraPosition.front,
    this.maxFrameRate,
    this.params = VideoParametersPresets.h540_169,
  });

  CameraConstraints.from({required VideoCaptureOptions captureOptions})
      : cameraPosition = CameraPosition.front,
        params = captureOptions.params,
        maxFrameRate = captureOptions.maxFrameRate,
        super(
          deviceId: captureOptions.deviceId,
        );

  final VideoParameters params;

  /// Limit the maximum frameRate of the capture device.
  final double? maxFrameRate;

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
      'audio': constraints,
      'video': false,
    };
  }

  @override
  CameraConstraints copyWith({
    VideoParameters? params,
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
