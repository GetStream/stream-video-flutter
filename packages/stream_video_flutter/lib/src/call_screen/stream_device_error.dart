import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Why a microphone or camera could not be used.
enum StreamDeviceFailureReason {
  /// The user has not granted access to the device.
  ///
  /// A retry only helps once they have changed their mind in system settings,
  /// so this is the one worth pointing them there for.
  permissionDenied,

  /// Another application is holding the device.
  ///
  /// Worth retrying: the other application may let go.
  deviceBusy,

  /// The platform reports no such device.
  noDevice,

  /// Anything else, including a failure this SDK could not classify.
  unknown,
}

/// A microphone, camera or enumeration failure, with what the platform said.
///
/// Carries a [reason] so an app can act on the difference — offering system
/// settings for a refused permission, and a retry for a device another
/// application is holding — without matching on message strings itself.
@immutable
class StreamDeviceError implements Exception {
  /// Creates a new instance of [StreamDeviceError].
  const StreamDeviceError({
    required this.reason,
    required this.cause,
    this.stackTrace,
  });

  /// Classifies [cause], falling back to
  /// [StreamDeviceFailureReason.unknown].
  ///
  /// Reads a [PlatformException]'s code and message and a browser
  /// `DOMException`'s name, which is as much as either platform offers: there
  /// is no typed failure to switch on underneath.
  factory StreamDeviceError.from(Object cause, [StackTrace? stackTrace]) =>
      StreamDeviceError(
        reason: _reasonOf(cause),
        cause: cause,
        stackTrace: stackTrace,
      );

  /// Why the device could not be used.
  final StreamDeviceFailureReason reason;

  /// The failure the platform reported.
  final Object cause;

  /// Where it was thrown, when that was captured.
  final StackTrace? stackTrace;

  /// Whether the user has refused access.
  bool get isPermissionDenied =>
      reason == StreamDeviceFailureReason.permissionDenied;

  /// Whether something else is holding the device.
  bool get isDeviceBusy => reason == StreamDeviceFailureReason.deviceBusy;

  /// Whether the platform reports no such device.
  bool get isNoDevice => reason == StreamDeviceFailureReason.noDevice;

  static StreamDeviceFailureReason _reasonOf(Object cause) {
    final text = switch (cause) {
      PlatformException(:final code, :final message) =>
        '$code ${message ?? ''}',
      _ => '$cause',
    }.toLowerCase();

    bool has(List<String> needles) => needles.any(text.contains);

    // The browser reports a DOMException name; flutter_webrtc a
    // PlatformException whose code and message vary by platform, so both are
    // matched on the words they have in common.
    if (has(const [
      'notallowederror',
      'permissiondeniederror',
      'securityerror',
      'permission denied',
      'permission_denied',
      'not permitted',
    ])) {
      return StreamDeviceFailureReason.permissionDenied;
    }

    if (has(const [
      'notreadableerror',
      'trackstarterror',
      'aborterror',
      'in use',
      'busy',
      'already captur',
    ])) {
      return StreamDeviceFailureReason.deviceBusy;
    }

    if (has(const [
      'notfounderror',
      'devicesnotfounderror',
      'overconstrainederror',
      'no devices found',
      'no device',
    ])) {
      return StreamDeviceFailureReason.noDevice;
    }

    return StreamDeviceFailureReason.unknown;
  }

  @override
  String toString() => 'StreamDeviceError(${reason.name}): $cause';
}
