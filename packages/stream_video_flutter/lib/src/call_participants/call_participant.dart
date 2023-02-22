import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';
import 'indicators/connection_quality_indicator.dart';
import 'participant_label.dart';

/// A widget that represents a single participant in a call.
class StreamCallParticipant extends StatelessWidget {
  /// Creates a new instance of [StreamCallParticipant].
  const StreamCallParticipant({
    super.key,
    required this.call,
    required this.participant,
    this.backgroundColor,
    this.borderRadius,
    this.userAvatarTheme,
    this.showDominantSpeakerBorder,
    this.dominantSpeakerBorderThickness,
    this.dominantSpeakerBorderColor,
    this.showParticipantLabel,
    this.participantLabelTextStyle,
    this.participantLabelAlignment,
    this.audioLevelIndicatorColor,
    this.enabledMicrophoneColor,
    this.disabledMicrophoneColor,
    this.showConnectionQualityIndicator,
    this.connectionLevelActiveColor,
    this.connectionLevelInactiveColor,
    this.connectionLevelAlignment,
  });

  /// Represents a call.
  final Call call;

  /// The participant to display.
  final CallParticipantState participant;

  /// The background color of the call participant.
  final Color? backgroundColor;

  /// The border radius of the call participant.
  final BorderRadius? borderRadius;

  /// The theme for the avatar.
  final StreamUserAvatarThemeData? userAvatarTheme;

  /// Whether to highlight the dominant speaker.
  final bool? showDominantSpeakerBorder;

  /// The thickness of the dominant speaker border.
  final double? dominantSpeakerBorderThickness;

  /// The color of the dominant speaker border.
  final Color? dominantSpeakerBorderColor;

  /// Whether to show the label with participant name and mute status.
  final bool? showParticipantLabel;

  /// Text style for the participant label.
  final TextStyle? participantLabelTextStyle;

  /// Alignment for the participant label.
  final AlignmentGeometry? participantLabelAlignment;

  /// The color of an audio level indicator.
  final Color? audioLevelIndicatorColor;

  /// The color of an enabled microphone icon.
  final Color? enabledMicrophoneColor;

  /// The color of a disabled microphone icon.
  final Color? disabledMicrophoneColor;

  /// Whether to show the connection quality indicator.
  final bool? showConnectionQualityIndicator;

  /// The color of an active connection quality level.
  final Color? connectionLevelActiveColor;

  /// The color of an inactive connection quality level.
  final Color? connectionLevelInactiveColor;

  /// Alignment for the connection level.
  final AlignmentGeometry? connectionLevelAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallParticipantTheme.of(context);

    final backgroundColor = this.backgroundColor ?? theme.backgroundColor;
    final borderRadius = this.borderRadius ?? theme.borderRadius;
    final userAvatarTheme = this.userAvatarTheme ?? theme.userAvatarTheme;
    final showDominantSpeakerBorder =
        this.showDominantSpeakerBorder ?? theme.showDominantSpeakerBorder;
    final dominantSpeakerBorderThickness =
        this.dominantSpeakerBorderThickness ??
            theme.dominantSpeakerBorderThickness;
    final dominantSpeakerBorderColor =
        this.dominantSpeakerBorderColor ?? theme.dominantSpeakerBorderColor;
    final showParticipantLabel =
        this.showParticipantLabel ?? theme.showParticipantLabel;
    final participantLabelTextStyle =
        this.participantLabelTextStyle ?? theme.participantLabelTextStyle;
    final participantLabelAlignment =
        this.participantLabelAlignment ?? theme.participantLabelAlignment;
    final audioLevelIndicatorColor =
        this.audioLevelIndicatorColor ?? theme.audioLevelIndicatorColor;
    final enabledMicrophoneColor =
        this.enabledMicrophoneColor ?? theme.enabledMicrophoneColor;
    final disabledMicrophoneColor =
        this.disabledMicrophoneColor ?? theme.disabledMicrophoneColor;
    final showConnectionQualityIndicator =
        this.showConnectionQualityIndicator ??
            theme.showConnectionQualityIndicator;
    final connectionLevelActiveColor =
        this.connectionLevelActiveColor ?? theme.connectionLevelActiveColor;
    final connectionLevelInactiveColor =
        this.connectionLevelInactiveColor ?? theme.connectionLevelInactiveColor;
    final connectionLevelAlignment =
        this.connectionLevelAlignment ?? theme.connectionLevelAlignment;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        foregroundDecoration: BoxDecoration(
          border: participant.isDominantSpeaker && showDominantSpeakerBorder
              ? Border.all(
                  width: dominantSpeakerBorderThickness,
                  color: dominantSpeakerBorderColor,
                )
              : null,
          borderRadius: theme.borderRadius,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Stack(
          children: [
            StreamVideoRenderer(
              call: call,
              participant: participant,
              videoTrackType: SfuTrackType.video,
              placeholderBuilder: (context) {
                return Center(
                  child: StreamUserAvatarTheme(
                    data: userAvatarTheme,
                    child: StreamUserAvatar(
                      user: participant.toUserInfo(),
                    ),
                  ),
                );
              },
            ),
            if (showParticipantLabel)
              Align(
                alignment: participantLabelAlignment,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: StreamParticipantLabel.fromParticipant(
                        participant: participant,
                        audioLevelIndicatorColor: audioLevelIndicatorColor,
                        disabledMicrophoneColor: disabledMicrophoneColor,
                        enabledMicrophoneColor: enabledMicrophoneColor,
                        participantLabelTextStyle: participantLabelTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            if (showConnectionQualityIndicator)
              Align(
                alignment: connectionLevelAlignment,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: StreamConnectionQualityIndicator(
                    connectionQuality: participant.connectionQuality,
                    activeColor: connectionLevelActiveColor,
                    inactiveColor: connectionLevelInactiveColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
