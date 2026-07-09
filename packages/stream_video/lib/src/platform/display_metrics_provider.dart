/// A platform-neutral 2D size, mirroring `dart:ui`'s `Size` without
/// depending on it.
class StreamDisplaySize {
  const StreamDisplaySize(this.width, this.height);

  final double width;
  final double height;

  @override
  String toString() => 'StreamDisplaySize($width, $height)';
}

/// Provides the physical screen size, used to size screen-share tracks.
///
/// The default returns `null`, meaning callers should fall back to the
/// track's own reported dimensions. `stream_video_flutter` registers a
/// `WidgetsBinding`-backed implementation via
/// `StreamVideoFlutter.ensureInitialized()`.
abstract class DisplayMetricsProvider {
  /// The active provider. Assign a platform-specific implementation to
  /// override the default (e.g. from `StreamVideoFlutter.ensureInitialized()`).
  static DisplayMetricsProvider instance = const NoopDisplayMetricsProvider();

  StreamDisplaySize? get physicalScreenSize;
}

class NoopDisplayMetricsProvider implements DisplayMetricsProvider {
  const NoopDisplayMetricsProvider();

  @override
  StreamDisplaySize? get physicalScreenSize => null;
}
