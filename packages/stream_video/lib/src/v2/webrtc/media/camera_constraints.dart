import '../../../platform_detector/platform_detector.dart';
import 'constraints/facing_mode.dart';
import 'media_constraints.dart';

/// Options used when creating a video track that captures the camera.
class CameraConstraints extends MediaConstraints {
  const CameraConstraints({
    super.deviceId,
    this.facingMode = FacingMode.user,
    this.maxFrameRate = 30,
    this.width = 960,
    this.height = 540,
  });

  /// Limit the maximum frameRate of the capture device.
  final double? maxFrameRate;

  final int? width;
  final int? height;

  final FacingMode facingMode;

  @override
  Map<String, dynamic> toMap() {
    final constraints = <String, dynamic>{
      'width': width,
      'height': height,
      'frameRate': maxFrameRate,
      'facingMode': facingMode.name,
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
    int? height,
    int? width,
    FacingMode? facingMode,
    String? deviceId,
    double? maxFrameRate,
  }) =>
      CameraConstraints(
        height: height ?? this.height,
        width: width ?? this.width,
        facingMode: facingMode ?? this.facingMode,
        deviceId: deviceId ?? this.deviceId,
        maxFrameRate: maxFrameRate ?? this.maxFrameRate,
      );
}
