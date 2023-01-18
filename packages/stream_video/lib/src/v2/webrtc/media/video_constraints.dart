import '../model/rtc_video_parameters.dart';
import 'media_constraints.dart';

/// Base class for options when creating a video track.
abstract class VideoConstraints extends MediaConstraints {
  const VideoConstraints({
    super.deviceId,
    this.maxFrameRate,
    this.params = RtcVideoParametersPresets.h540_169,
  });

  /// Limit the maximum frameRate of the capture device.
  final double? maxFrameRate;

  final RtcVideoParameters params;
}
