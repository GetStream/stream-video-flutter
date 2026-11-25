import 'dart:ui';

import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

/// Configures how the SDK handles `call.moderation` events.
///
/// Convenience constructors [VideoModerationConfig.disabled],
/// [VideoModerationConfig.mute], and [VideoModerationConfig.blur] cover
/// the most common presets.
class VideoModerationConfig {
  const VideoModerationConfig({
    this.muteAudio = false,
    this.muteVideo = false,
    this.blurFilter,
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
      blurFilter = null,
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
      blurFilter = null,
      onApply = null,
      onWarning = null,
      onClear = null;

  /// Applies [filter] to the camera, after the call's own video filter, for
  /// the configured [duration]. If [duration] is null, the blur persists
  /// until `call.clearModerationBlur()` is called. The call's own filter is
  /// applied alone again afterwards.
  ///
  /// The blur is visible to all participants because it changes the frames
  /// before encoding. `FullFrameBlurFilter` from the `stream_video_filters`
  /// package blurs the whole frame.
  const VideoModerationConfig.blur({
    required VideoFilter filter,
    this.duration,
  }) : muteAudio = false,
       muteVideo = false,
       blurFilter = filter,
       onApply = null,
       onWarning = null,
       onClear = null;

  final bool muteAudio;
  final bool muteVideo;

  /// The filter applied to the camera while the call is moderated. Null
  /// applies none.
  final VideoFilter? blurFilter;

  final Duration? duration;

  final VoidCallback? onApply;
  final void Function(String)? onWarning;
  final VoidCallback? onClear;

  /// Whether this config takes no automatic action.
  bool get isDisabled =>
      !muteAudio &&
      !muteVideo &&
      blurFilter == null &&
      onApply == null &&
      onWarning == null &&
      onClear == null;
}
