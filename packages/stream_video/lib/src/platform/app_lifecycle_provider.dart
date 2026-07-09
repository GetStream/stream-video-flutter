import '../lifecycle/lifecycle_state.dart';

/// Provides app lifecycle transitions (foreground/background) used to react
/// to the host app going to background/foreground.
///
/// The default implementation never emits, which is correct for web/Jaspr
/// (no single "app" lifecycle concept). `stream_video_flutter` registers a
/// `WidgetsBinding`-backed implementation via
/// `StreamVideoFlutter.ensureInitialized()`.
abstract class AppLifecycleProvider {
  /// The active provider. Assign a platform-specific implementation to
  /// override the default (e.g. from `StreamVideoFlutter.ensureInitialized()`).
  static AppLifecycleProvider instance = const NoopAppLifecycleProvider();

  Stream<LifecycleState> get appState;
}

class NoopAppLifecycleProvider implements AppLifecycleProvider {
  const NoopAppLifecycleProvider();

  @override
  Stream<LifecycleState> get appState => const Stream.empty();
}
