import 'package:meta/meta.dart';

/// The first decoded frame of a remote video, reported by
/// `WebRtcEngine.watchFirstFrame`.
@immutable
final class FirstVideoFrame {
  const FirstVideoFrame({required this.width, required this.height});

  /// The width of the frame in pixels, or 0 when the platform does not say.
  final int width;

  /// The height of the frame in pixels, or 0 when the platform does not say.
  final int height;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirstVideoFrame &&
          other.width == width &&
          other.height == height;

  @override
  int get hashCode => Object.hash(width, height);

  @override
  String toString() => 'FirstVideoFrame(${width}x$height)';
}

/// Watches a remote video stream, without showing it, for its first frame.
/// Built by `WebRtcEngine.watchFirstFrame`.
///
/// Implemented by the WebRTC packages only.
@sealed
abstract class FirstFrameWatcher {
  /// Stops watching and releases what the watch holds.
  Future<void> dispose();
}
