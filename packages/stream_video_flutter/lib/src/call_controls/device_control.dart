import 'package:flutter/foundation.dart';

import '../../stream_video_flutter.dart';

final _logger = taggedLogger(tag: 'SV:DeviceControl');

/// Awaits [operation] and reports a refusal instead of dropping it.
///
/// A device control takes its on/off state from the call's own participant
/// state, and that does not change when the call refuses — so a dropped
/// `Result` leaves the button visibly doing nothing, with nothing in the log
/// either. A viewer without `sendAudio` is the case that matters: pressing the
/// microphone is a legitimate thing to try, and the refusal is the answer.
///
/// [description] completes "Could not …", so phrase it as the thing that was
/// attempted: `'turn the microphone on'`.
///
/// `Object` rather than the `VideoError` behind it, matching
/// [StreamMediaDevicesController.enumerationError]: the error type is not
/// nameable from outside `stream_video`, which exports the `Result` that
/// carries it but not the class.
Future<void> applyDeviceChange(
  Future<Result<None>> operation, {
  required String description,
  ValueChanged<Object>? onError,
}) async {
  final result = await operation;
  if (result case Failure(:final error, :final stackTrace)) {
    _logger.e(() => 'Could not $description: $error\n$stackTrace');
    onError?.call(error);
  }
}

extension StreamDeviceAvailability on StreamMediaDevicesController {
  /// Whether the platform has been asked and named nothing in [devices].
  ///
  /// Waits for [StreamMediaDevicesController.hasEnumerated]: the lists are
  /// empty before the first enumeration because nothing has been asked, and a
  /// control that read them straight away would badge itself on startup.
  bool reportsNo(List<RtcMediaDevice> devices) =>
      hasEnumerated && devices.isEmpty;
}
