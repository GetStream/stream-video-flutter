import '../../../open_api/video/coordinator/api.dart';
import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../sfu/sfu_extensions.dart';

/// PerformanceStats represents the encoding/decoding statistics for a track.
class PerformanceStats {
  /// Creates a new instance of [PerformanceStats].
  PerformanceStats({
    required this.trackType,
    required this.avgFrameTimeMs,
    required this.avgFps,
    required this.videoDimension,
    this.codec,
  });

  /// The type of the track (e.g., video, audio, screen share)
  final sfu_models.TrackType trackType;

  /// The codec used for the track
  final sfu_models.Codec? codec;

  /// The average encode/decode time in milliseconds
  final double avgFrameTimeMs;

  /// The average fps for the track
  final double avgFps;

  /// The track dimensions
  final VideoDimension videoDimension;

  @override
  String toString() {
    return 'PerformanceStats{trackType: $trackType, codec: $codec, '
        'avgFrameTimeMs: $avgFrameTimeMs, avgFps: $avgFps, '
        'videoDimension: $videoDimension}';
  }

  Map<String, dynamic> toJson() {
    return {
      'trackType': trackType.name,
      'codec': codec?.toJson(),
      'avgFrameTimeMs': avgFrameTimeMs,
      'avgFps': avgFps,
      'videoDimension': videoDimension.toJson(),
    };
  }
}
