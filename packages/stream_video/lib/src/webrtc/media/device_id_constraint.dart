import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// How a capture request names the device to capture from.
///
/// Native platforms take it as an optional `sourceId`, next to the other
/// optional constraints. Web takes an exact `deviceId`, which cannot be
/// combined with optional constraints.
@internal
// ignore: one_member_abstracts, one implementation per platform
abstract interface class DeviceIdConstraint {
  /// The form the current platform takes.
  factory DeviceIdConstraint.forPlatform() {
    if (rtc.webRtcCapabilities.usesExactDeviceIdConstraints) {
      return const ExactDeviceIdConstraint();
    }
    return const OptionalDeviceIdConstraint();
  }

  /// Adds [deviceId], when there is one, and the [optional] constraints to
  /// [constraints].
  void addTo(
    Map<String, dynamic> constraints, {
    required String? deviceId,
    List<Map<String, dynamic>> optional = const [],
  });
}

/// Names the device with an exact `deviceId`, leaving out the optional
/// constraints when it does.
@internal
class ExactDeviceIdConstraint implements DeviceIdConstraint {
  const ExactDeviceIdConstraint();

  @override
  void addTo(
    Map<String, dynamic> constraints, {
    required String? deviceId,
    List<Map<String, dynamic>> optional = const [],
  }) {
    if (deviceId != null) {
      constraints['deviceId'] = {'exact': deviceId};
    } else if (optional.isNotEmpty) {
      constraints['optional'] = optional;
    }
  }
}

/// Names the device with an optional `sourceId`.
@internal
class OptionalDeviceIdConstraint implements DeviceIdConstraint {
  const OptionalDeviceIdConstraint();

  @override
  void addTo(
    Map<String, dynamic> constraints, {
    required String? deviceId,
    List<Map<String, dynamic>> optional = const [],
  }) {
    final all = [
      ...optional,
      if (deviceId != null) <String, dynamic>{'sourceId': deviceId},
    ];
    if (all.isNotEmpty) constraints['optional'] = all;
  }
}
