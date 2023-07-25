import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';
import 'indicators/connection_quality_indicator.dart';
import 'participant_label.dart';

/// Builder function used to build a video placeholder.
typedef VideoPlaceholderBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// Builder function used to build a video renderer.
typedef VideoRendererBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

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
    this.showSpeakerBorder,
    this.speakerBorderThickness,
    this.speakerBorderColor,
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
    this.videoPlaceholderBuilder,
    this.videoRendererBuilder,
    this.onSizeChanged,
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

  /// Whether to highlight the participant when he/she is speaking.
  final bool? showSpeakerBorder;

  /// The thickness of the speaker border.
  final double? speakerBorderThickness;

  /// The color of the speaker border.
  final Color? speakerBorderColor;

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

  /// Builder function used to build a video placeholder.
  final VideoPlaceholderBuilder? videoPlaceholderBuilder;

  /// Builder function used to build a video renderer.
  final VideoRendererBuilder? videoRendererBuilder;

  /// Callback that is called when the size of the participant widget changes.
  final ValueSetter<Size>? onSizeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallParticipantTheme.of(context);

    final backgroundColor = this.backgroundColor ?? theme.backgroundColor;
    final borderRadius = this.borderRadius ?? theme.borderRadius;
    final userAvatarTheme = this.userAvatarTheme ?? theme.userAvatarTheme;
    final showSpeakerBorder = this.showSpeakerBorder ?? theme.showSpeakerBorder;
    final speakerBorderThickness =
        this.speakerBorderThickness ?? theme.speakerBorderThickness;
    final speakerBorderColor =
        this.speakerBorderColor ?? theme.speakerBorderColor;
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
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: borderRadius,
          border: participant.isSpeaking && showSpeakerBorder
              ? Border.all(
                  color: speakerBorderColor,
                  width: speakerBorderThickness,
                )
              : null,
        ),
        child: Builder(
          builder: (context) {
            final theme = StreamVideoTheme.of(context);
            var videoPlaceholderBuilder = this.videoPlaceholderBuilder;
            videoPlaceholderBuilder ??= (context, call, participant) {
              return Center(
                child: StreamUserAvatarTheme(
                  data: userAvatarTheme,
                  child: StreamUserAvatar(
                    user: participant.toUserInfo(),
                  ),
                ),
              );
            };

            var videoRendererBuilder = this.videoRendererBuilder;
            videoRendererBuilder ??= (context, call, participant) {
              return Stack(
                children: [
                  StreamVideoRenderer(
                    call: call,
                    participant: participant,
                    videoTrackType: SfuTrackType.video,
                    onSizeChanged: onSizeChanged,
                    placeholderBuilder: (context) {
                      return videoPlaceholderBuilder!(
                        context,
                        call,
                        participant,
                      );
                    },
                  ),
                  if (participant.reaction != null)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          theme.callControlsTheme.callReactions
                                  .firstWhereOrNull((e) =>
                                      e.emojiCode ==
                                      participant.reaction?.emojiCode)
                                  ?.icon ??
                              '',
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            };

            return Stack(
              children: [
                videoRendererBuilder(context, call, participant),
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
                            participantLabelTextStyle:
                                participantLabelTextStyle,
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
            );
          },
        ),
      ),
    );
  }
}
