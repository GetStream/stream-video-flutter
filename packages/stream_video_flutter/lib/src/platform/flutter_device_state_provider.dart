import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:stream_video/stream_video.dart';
import 'package:thermal/thermal.dart' as plugin;

/// [DeviceStateProvider] backed by `battery_plus` + `thermal`, matching the
/// native SDK's existing telemetry behavior.
class FlutterDeviceStateProvider implements DeviceStateProvider {
  const FlutterDeviceStateProvider();

  @override
  Stream<StreamThermalStatus>? get thermalStatusStream {
    final available = CurrentPlatform.isAndroid || CurrentPlatform.isIos;
    if (!available) return null;
    _ThermalMonitor.ensureSubscribed();
    return _ThermalMonitor.controller?.stream.map(_toDomain);
  }

  @override
  StreamThermalStatus? get lastThermalStatus {
    final status = _ThermalMonitor.lastStatus;
    return status == null ? null : _toDomain(status);
  }

  @override
  Future<bool?> isInBatterySaveMode() async {
    final available =
        CurrentPlatform.isAndroid ||
        CurrentPlatform.isIos ||
        CurrentPlatform.isMacOS ||
        CurrentPlatform.isWindows;
    if (!available) return null;
    try {
      return await Battery().isInBatterySaveMode;
    } on PlatformException {
      return null;
    }
  }

  static StreamThermalStatus _toDomain(plugin.ThermalStatus status) {
    return switch (status) {
      plugin.ThermalStatus.none => StreamThermalStatus.none,
      plugin.ThermalStatus.light => StreamThermalStatus.light,
      plugin.ThermalStatus.moderate => StreamThermalStatus.moderate,
      plugin.ThermalStatus.severe => StreamThermalStatus.severe,
      plugin.ThermalStatus.critical => StreamThermalStatus.critical,
      plugin.ThermalStatus.emergency => StreamThermalStatus.emergency,
      plugin.ThermalStatus.shutdown => StreamThermalStatus.shutdown,
    };
  }
}

/// Shared, never-cancelled bridge to `Thermal().onThermalStatusChanged`.
class _ThermalMonitor {
  _ThermalMonitor._();

  static StreamController<plugin.ThermalStatus>? controller;
  static plugin.ThermalStatus? lastStatus;
  static bool _initialized = false;

  static void ensureSubscribed() {
    if (_initialized) return;
    _initialized = true;
    controller = StreamController<plugin.ThermalStatus>.broadcast();
    try {
      plugin.Thermal().onThermalStatusChanged.listen((status) {
        lastStatus = status;
        controller?.add(status);
      });
    } catch (_) {
      // Thermal plugin not available.
    }
  }
}
