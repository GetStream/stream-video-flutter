/// Registry of platform-specific providers that `stream_video` depends on.
///
/// Each provider is an overridable singleton with a pure-Dart/web default.
/// `stream_video_flutter` registers plugin-backed native implementations via
/// `StreamVideoFlutter.ensureInitialized()`; web/Jaspr consumers register
/// nothing and get the working defaults. Partial registration is safe — an
/// unregistered provider degrades to its default rather than crashing.
///
/// See `JASPR_SUPPORT_PLAN.md` at the repo root for the full rollout plan.
/// `NetworkMonitor` (already defined in `ws/health/network_monitor.dart`) is
/// promoted into this same registry pattern in Phase 4.
library;

export 'app_lifecycle_provider.dart';
export 'device_state_provider.dart';
export 'display_metrics_provider.dart';
export 'environment_info_provider.dart';
export 'stream_web_rtc.dart';
