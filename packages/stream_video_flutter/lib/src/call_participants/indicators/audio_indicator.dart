import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import 'audio_level_indicator.dart';

/// The sound indicator shown at the end of a participant's name pill.
///
/// Always present, so the pill keeps its shape as someone starts and stops
/// talking: the bars animate while [isSpeaking] and rest as three dots
/// otherwise. Whether the participant is muted is reported separately, by the
/// microphone icon the pill draws next to this.
class StreamAudioIndicator extends StatelessWidget {
  /// Creates a sound indicator.
  const StreamAudioIndicator({
    super.key,
    required this.isSpeaking,
    this.style,
  });

  /// Whether the participant is currently speaking.
  final bool isSpeaking;

  /// Overrides for this indicator's appearance.
  final StreamParticipantLabelStyle? style;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final radius = context.streamRadius;

    return SizedBox.square(
      dimension: style?.audioIndicatorSize ?? 24,
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
          child: StreamAudioLevelIndicator(
            isSpeaking: isSpeaking,
            size: style?.audioIndicatorIconSize ?? 10,
            color: style?.speakingColor ?? colorScheme.brand.shade300,
          ),
        ),
      ),
    );
  }
}
