import '../../stream_video_flutter.dart';

final _logger = taggedLogger(tag: 'SV:DeviceControl');

/// Called when a device control's change is refused.
///
/// [description] completes "Could not …" — `'turn the microphone on'` — so a
/// caller can name the action that failed rather than guessing at it.
typedef StreamDeviceErrorCallback =
    void Function(VideoError error, String description);

/// Awaits [operation] and reports a refusal instead of dropping it.
///
/// A refusal is always logged, and passed to [onError] if one is given. A
/// device control takes its on/off state from the call's own participant
/// state, which does not change when the call refuses, so a dropped `Result`
/// would leave the button doing nothing visible.
///
/// [description] completes "Could not …", so phrase it as the thing that was
/// attempted: `'turn the microphone on'`. [onError] receives that phrase
/// alongside the error, so a caller can say which action failed.
Future<void> applyDeviceChange(
  Future<Result<None>> operation, {
  required String description,
  StreamDeviceErrorCallback? onError,
}) async {
  final result = await operation;
  if (result case final Failure failure) {
    final error = failure.videoError;
    _logger.e(() => 'Could not $description: $error\n${failure.stackTrace}');
    onError?.call(error, description);
  }
}

/// Reads what a controller can say about the devices it lists.
extension StreamDeviceAvailability on StreamMediaDevicesController {
  /// Whether the platform has been asked and named nothing in [devices].
  ///
  /// Waits for [StreamMediaDevicesController.hasEnumerated]: the lists are
  /// empty before the first enumeration because nothing has been asked, and a
  /// control that read them straight away would badge itself on startup.
  ///
  /// True whenever the list is empty, whether the platform has no such device
  /// or could not list it at all — see [enumerationFailed] to tell the two
  /// apart.
  bool reportsNo(List<RtcMediaDevice> devices) =>
      hasEnumerated && devices.isEmpty;

  /// Whether the last enumeration failed for some reason other than there
  /// being no device.
  ///
  /// A refused permission, or a device another application is holding, leaves
  /// the lists as empty as absent hardware does.
  /// [StreamMediaDevicesController.enumerationError] says which, and
  /// [StreamMediaDevicesController.refreshDevices] retries — both of which
  /// need a controller the screen holds, so pass `devices` to a control rather
  /// than letting it build its own if you mean to offer either.
  bool get enumerationFailed {
    final error = enumerationError;
    return error != null && !error.isNoDevice;
  }
}

/// Reads a local device's state without mistaking "not reported yet" for
/// "muted".
extension StreamLocalTrackState on CallParticipantState {
  /// Whether [trackType] is unmuted, or null while nothing has reported it.
  ///
  /// Null covers the window between joining and the first track arriving, and
  /// any later one — a reconnect — where the track is gone again. A muted
  /// track keeps its entry with `muted` set, so false means muted rather than
  /// unreported; the `isAudioEnabled` family collapses the two into false.
  bool? trackEnabled(SfuTrackType trackType) {
    final track = publishedTracks[trackType];
    if (track == null) return null;
    return !track.muted;
  }
}

/// Reads the intent a call was joined with.
extension StreamTrackOptionIntent on TrackOption {
  /// Whether this asks for the device to be on.
  ///
  /// What a control draws while [StreamLocalTrackState.trackEnabled] is null.
  /// A provided track counts as on: the lobby only hands one over for a device
  /// it opened, so a camera turned off there arrives as [TrackDisabled].
  bool get wantsOn => this is! TrackDisabled;
}
