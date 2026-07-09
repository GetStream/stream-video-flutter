import 'package:stream_video/stream_video.dart';

import 'flutter_app_lifecycle_provider.dart';
import 'flutter_device_state_provider.dart';
import 'flutter_display_metrics_provider.dart';
import 'flutter_environment_info_provider.dart';

/// Registers the plugin-backed native implementations of `stream_video`'s
/// platform providers (telemetry, lifecycle, display metrics).
///
/// Call once, early in `main()`, before constructing [StreamVideo]. Safe to
/// call more than once (idempotent).
// ignore: avoid_classes_with_only_static_members
abstract final class StreamVideoFlutter {
  static bool _initialized = false;

  static void ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    DeviceStateProvider.instance = const FlutterDeviceStateProvider();
    EnvironmentInfoProvider.instance = const FlutterEnvironmentInfoProvider();
    AppLifecycleProvider.instance = const FlutterAppLifecycleProvider();
    DisplayMetricsProvider.instance = const FlutterDisplayMetricsProvider();
  }
}
