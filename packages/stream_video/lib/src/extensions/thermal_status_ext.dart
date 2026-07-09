import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../platform/device_state_provider.dart';

extension ThermalStatusExt on StreamThermalStatus {
  sfu_models.AndroidThermalState toAndroidThermalState() {
    return switch (this) {
      StreamThermalStatus.none =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_NONE,
      StreamThermalStatus.light =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_LIGHT,
      StreamThermalStatus.moderate =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_MODERATE,
      StreamThermalStatus.severe =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_SEVERE,
      StreamThermalStatus.critical =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_CRITICAL,
      StreamThermalStatus.emergency =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_EMERGENCY,
      StreamThermalStatus.shutdown =>
        sfu_models.AndroidThermalState.ANDROID_THERMAL_STATE_SHUTDOWN,
    };
  }

  sfu_models.AppleThermalState toAppleThermalState() {
    return switch (this) {
      StreamThermalStatus.none =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_NOMINAL,
      StreamThermalStatus.light =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_FAIR,
      StreamThermalStatus.moderate =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_FAIR,
      StreamThermalStatus.severe =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_SERIOUS,
      StreamThermalStatus.critical =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_CRITICAL,
      StreamThermalStatus.emergency =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_CRITICAL,
      StreamThermalStatus.shutdown =>
        sfu_models.AppleThermalState.APPLE_THERMAL_STATE_CRITICAL,
    };
  }
}
