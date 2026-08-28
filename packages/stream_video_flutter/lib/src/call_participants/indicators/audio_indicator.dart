import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import 'audio_level_indicator.dart';

/// Reports a participant's audio state in a fixed-size box.
///
/// Shows one of three things, never two at once: animated level bars while the
/// participant is speaking, a microphone icon while their microphone is on but
/// silent, and a crossed-out microphone while it is off.
///
/// The design system shows the level bars and the muted icon side by side. That
/// is deliberately not followed: a muted participant is not speaking, so the two
/// states cannot both be true, and showing an icon per state keeps the pill from
/// changing width as someone talks.
class StreamAudioIndicator extends StatelessWidget {
  /// Creates an audio indicator.
  const StreamAudioIndicator({
    super.key,
    required this.isAudioEnabled,
    required this.isSpeaking,
    this.style,
  });

  /// Whether the participant's microphone is on.
  final bool isAudioEnabled;

  /// Whether the participant is currently speaking.
  final bool isSpeaking;

  /// Overrides for this indicator's appearance.
  final StreamParticipantLabelStyle? style;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final radius = context.streamRadius;

    final size = style?.audioIndicatorSize ?? 24;
    final iconSize = style?.audioIndicatorIconSize ?? 16;

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              style?.audioIndicatorBackgroundColor ??
              style?.backgroundColor ??
              colorScheme.backgroundOverlayDarkStrong,
          borderRadius:
              style?.audioIndicatorBorderRadius ?? BorderRadius.all(radius.md),
        ),
        child: Center(
          child: switch ((isAudioEnabled, isSpeaking)) {
            (true, true) => StreamAudioLevelIndicator(
              size: iconSize,
              color: style?.speakingColor ?? colorScheme.brand.shade300,
            ),
            (true, false) => Icon(
              context.streamIcons.voiceFill,
              size: iconSize,
              color: style?.microphoneOnColor ?? colorScheme.textOnAccent,
            ),
            (false, _) => Icon(
              context.streamIcons.voiceOffFill,
              size: iconSize,
              color: style?.microphoneOffColor ?? colorScheme.accentError,
            ),
          },
        ),
      ),
    );
  }
}
