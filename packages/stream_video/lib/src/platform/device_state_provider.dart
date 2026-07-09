/// Platform-neutral thermal state, mirroring the `thermal` plugin's
/// `ThermalStatus` without depending on it.
enum StreamThermalStatus {
  none,
  light,
  moderate,
  severe,
  critical,
  emergency,
  shutdown,
}

/// Provides battery/thermal telemetry used for SFU stats reporting.
///
/// The default implementation is a no-op (no telemetry available), which is
/// correct for web/Jaspr. `stream_video_flutter` registers a plugin-backed
/// implementation via `StreamVideoFlutter.ensureInitialized()`.
abstract class DeviceStateProvider {
  /// The active provider. Assign a platform-specific implementation to
  /// override the default (e.g. from `StreamVideoFlutter.ensureInitialized()`).
  static DeviceStateProvider instance = const NoopDeviceStateProvider();

  /// Emits thermal status changes. Returns `null` if unsupported on this
  /// platform.
  Stream<StreamThermalStatus>? get thermalStatusStream;

  /// The most recently observed thermal status, if any.
  StreamThermalStatus? get lastThermalStatus;

  /// A fresh, one-shot read of the current thermal status. Returns `null` if
  /// unsupported on this platform.
  Future<StreamThermalStatus?> currentThermalStatus();

  /// Returns whether the device is in a battery/power saver mode, or `null`
  /// if unsupported/unknown on this platform.
  Future<bool?> isInBatterySaveMode();

  /// The current battery level as a percentage (0-100), or `null` if
  /// unsupported/unknown on this platform.
  Future<int?> batteryLevel();
}

class NoopDeviceStateProvider implements DeviceStateProvider {
  const NoopDeviceStateProvider();

  @override
  Stream<StreamThermalStatus>? get thermalStatusStream => null;

  @override
  StreamThermalStatus? get lastThermalStatus => null;

  @override
  Future<StreamThermalStatus?> currentThermalStatus() async => null;

  @override
  Future<bool?> isInBatterySaveMode() async => null;

  @override
  Future<int?> batteryLevel() async => null;
}
