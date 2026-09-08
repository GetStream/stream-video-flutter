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
/// leaves the button doing nothing visible.
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

extension StreamDeviceAvailability on StreamMediaDevicesController {
  /// Whether the platform has been asked and named nothing in [devices].
  ///
  /// Waits for [StreamMediaDevicesController.hasEnumerated]: the lists are
  /// empty before the first enumeration because nothing has been asked, and a
  /// control that read them straight away would badge itself on startup.
  bool reportsNo(List<RtcMediaDevice> devices) =>
      hasEnumerated && devices.isEmpty;
}

/// Reads a local device's state without mistaking "not reported yet" for
/// "muted".
extension StreamLocalTrackState on CallParticipantState {
  /// Whether [trackType] is unmuted, or null while nothing has reported it.
  ///
  /// Null is the window between joining and the first track arriving, and any
  /// later one — a reconnect — where the track is gone again. The
  /// `isAudioEnabled` family collapses that into false, which is why a
  /// control reading it flashed the muted look on every join. Only the user
  /// gets false: muting keeps the entry and flags it.
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
