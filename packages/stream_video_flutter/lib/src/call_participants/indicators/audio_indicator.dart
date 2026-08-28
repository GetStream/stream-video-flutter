import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../participant_label_defaults.dart';
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
    // The pill's own defaults, rather than a second copy of them: the indicator
    // is one of the parts the pill is made of, and the two have to agree on how
    // big it is for the tile's own arithmetic to hold.
    final defaults = StreamParticipantLabelStyleDefaults(context);

    return SizedBox.square(
      dimension: style?.audioIndicatorSize ?? defaults.audioIndicatorSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              style?.audioIndicatorBackgroundColor ??
              style?.backgroundColor ??
              defaults.audioIndicatorBackgroundColor,
          borderRadius:
              style?.audioIndicatorBorderRadius ??
              defaults.audioIndicatorBorderRadius,
        ),
        child: Center(
          child: StreamAudioLevelIndicator(
            isSpeaking: isSpeaking,
            size:
                style?.audioIndicatorIconSize ??
                defaults.audioIndicatorIconSize,
            color: style?.speakingColor ?? defaults.speakingColor,
          ),
        ),
      ),
    );
  }
}
