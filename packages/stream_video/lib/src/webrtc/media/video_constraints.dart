import 'package:stream_video/src/webrtc/media/media_constraints.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_parameters.dart';

/// Base class for options when creating a video track.
abstract class VideoConstraints extends MediaConstraints {
  const VideoConstraints({
    super.deviceId,
    this.maxFrameRate,
    this.params = RtcVideoParametersPresets.h720_16x9,
  });

  /// Limit the maximum frameRate of the capture device.
  final double? maxFrameRate;

  final RtcVideoParameters params;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'width': params.dimension.width,
      'height': params.dimension.height,
      'frameRate': params.encoding.maxFramerate,
    };
  }
}
