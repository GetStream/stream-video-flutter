import 'dart:ui';

/// Configures how the SDK handles `call.moderation` events.
///
/// Convenience constructors [VideoModerationConfig.disabled],
/// [VideoModerationConfig.mute], and [VideoModerationConfig.blur] cover
/// the most common presets.
class VideoModerationConfig {
  const VideoModerationConfig({
    this.muteAudio = false,
    this.muteVideo = false,
    this.applyBlur = false,
    this.duration,
    this.onApply,
    this.onWarning,
    this.onClear,
  });

  /// No automatic action. The event is still emitted on the call's event
  /// stream for manual handling via `call.callEvents`.
  const VideoModerationConfig.disabled()
    : muteAudio = false,
      muteVideo = false,
      applyBlur = false,
      duration = null,
      onApply = null,
      onWarning = null,
      onClear = null;

  /// Mutes the local user's microphone and camera, and prevents re-enabling
  /// them for the configured [duration]. If [duration] is null, the mute
  /// persists until `call.clearModerationBlur()` is called.
  const VideoModerationConfig.mute({this.duration})
    : muteAudio = true,
      muteVideo = true,
      applyBlur = false,
      onApply = null,
      onWarning = null,
      onClear = null;

  /// Applies a full-frame native blur on the camera track via
  /// `StreamVideoEffectsManager` from the `stream_video_filters` package.
  /// The blur is visible to ALL participants because it modifies frames
  /// before encoding. Requires the `stream_video_filters` package.
  const VideoModerationConfig.blur({this.duration})
    : muteAudio = false,
      muteVideo = false,
      applyBlur = true,
      onApply = null,
      onWarning = null,
      onClear = null;

  final bool muteAudio;
  final bool muteVideo;
  final bool applyBlur;

  final Duration? duration;

  final VoidCallback? onApply;
  final void Function(String)? onWarning;
  final VoidCallback? onClear;

  /// Whether this config takes no automatic action.
  bool get isDisabled =>
      !muteAudio &&
      !muteVideo &&
      !applyBlur &&
      onApply == null &&
      onWarning == null &&
      onClear == null;
}
