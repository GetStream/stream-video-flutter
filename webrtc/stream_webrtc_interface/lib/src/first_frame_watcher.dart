/// Watches a remote video stream, without showing it, for its first frame.
/// Built by `WebRtcEngine.watchFirstFrame`.
abstract class FirstFrameWatcher {
  /// Stops watching and releases what the watch holds.
  Future<void> dispose();
}
