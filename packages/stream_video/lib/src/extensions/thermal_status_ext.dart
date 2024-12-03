import 'package:thermal/thermal.dart';
import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;

extension TherlalStatusExt on ThermalStatus {
  sfu_models.AndroidThermalState toAndroidThermalState() {
    return switch (this) {
      ThermalStatus.none =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_NONE,
      ThermalStatus.light =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_LIGHT,
      ThermalStatus.moderate =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_MODERATE,
      ThermalStatus.severe =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_SEVERE,
      ThermalStatus.critical =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_CRITICAL,
      ThermalStatus.emergency =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_EMERGENCY,
      ThermalStatus.shutdown =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_SHUTDOWN,
    };
  }

  sfu_models.AppleThermalState toAppleThermalState() {
    return switch (this) {
      ThermalStatus.none =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_NOMINAL,
      ThermalStatus.light =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_FAIR,
      ThermalStatus.moderate =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_FAIR,
      ThermalStatus.severe =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_SERIOUS,
      ThermalStatus.critical =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_CRITICAL,
      ThermalStatus.emergency =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_CRITICAL,
      ThermalStatus.shutdown =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_CRITICAL,
    };
  }
}
