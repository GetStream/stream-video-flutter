import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import '../../stream_video_flutter.dart';
import 'indicators/connection_quality_indicator.dart';
import 'participant_label.dart';

/// Builder function used to build a video placeholder.
typedef VideoPlaceholderBuilder =
    Widget Function(
      BuildContext context,
      Call call,
      CallParticipantState participant,
    );

/// Builder function used to build a video renderer.
typedef VideoRendererBuilder =
    Widget Function(
      BuildContext context,
      Call call,
      CallParticipantState participant,
    );

/// A widget that represents a single participant in a call.
///
/// The rendering can be replaced app-wide by registering a `participantTile`
/// builder with [streamVideoComponentBuilders] on a [StreamComponentFactory].
/// When no builder is registered, [DefaultStreamParticipantTile] is used.
class StreamParticipantTile extends StatelessWidget {
  /// Creates a new instance of [StreamParticipantTile].
  StreamParticipantTile({
    super.key,
    required Call call,
    required CallParticipantState participant,
    String? rendererScopePrefix,
    VideoFit? videoFit,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    StreamUserAvatarThemeData? userAvatarTheme,
    bool? showSpeakerBorder,
    double? speakerBorderThickness,
    Color? speakerBorderColor,
    bool? showParticipantLabel,
    TextStyle? participantLabelTextStyle,
    AlignmentGeometry? participantLabelAlignment,
    Color? audioLevelIndicatorColor,
    Color? enabledMicrophoneColor,
    Color? disabledMicrophoneColor,
    Color? pausedVideoIndicatorColor,
    bool? showConnectionQualityIndicator,
    Color? connectionLevelActiveColor,
    Color? connectionLevelInactiveColor,
    AlignmentGeometry? connectionLevelAlignment,
    VideoPlaceholderBuilder? videoPlaceholderBuilder,
    VideoRendererBuilder? videoRendererBuilder,
    ValueSetter<Size>? onSizeChanged,
  }) : props = .new(
         call: call,
         participant: participant,
         rendererScopePrefix: rendererScopePrefix,
         videoFit: videoFit,
         backgroundColor: backgroundColor,
         borderRadius: borderRadius,
         userAvatarTheme: userAvatarTheme,
         showSpeakerBorder: showSpeakerBorder,
         speakerBorderThickness: speakerBorderThickness,
         speakerBorderColor: speakerBorderColor,
         showParticipantLabel: showParticipantLabel,
         participantLabelTextStyle: participantLabelTextStyle,
         participantLabelAlignment: participantLabelAlignment,
         audioLevelIndicatorColor: audioLevelIndicatorColor,
         enabledMicrophoneColor: enabledMicrophoneColor,
         disabledMicrophoneColor: disabledMicrophoneColor,
         pausedVideoIndicatorColor: pausedVideoIndicatorColor,
         showConnectionQualityIndicator: showConnectionQualityIndicator,
         connectionLevelActiveColor: connectionLevelActiveColor,
         connectionLevelInactiveColor: connectionLevelInactiveColor,
         connectionLevelAlignment: connectionLevelAlignment,
         videoPlaceholderBuilder: videoPlaceholderBuilder,
         videoRendererBuilder: videoRendererBuilder,
         onSizeChanged: onSizeChanged,
       );

  /// The properties that configure this participant tile.
  final StreamParticipantTileProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.videoComponentBuilder<StreamParticipantTileProps>();
    return builder?.call(context, props) ??
        DefaultStreamParticipantTile(props: props);
  }
}

/// Properties for configuring a [StreamParticipantTile].
///
/// This class holds all the configuration options for a participant tile,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamParticipantTile], which uses these properties.
///  * [DefaultStreamParticipantTile], the default implementation.
class StreamParticipantTileProps {
  /// Creates properties for a participant tile.
  const StreamParticipantTileProps({
    required this.call,
    required this.participant,
    this.rendererScopePrefix,
    this.videoFit,
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
    this.pausedVideoIndicatorColor,
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

  /// Optional prefix to scope renderer keys (e.g. PiP vs main view).
  final String? rendererScopePrefix;

  /// The fit of the [VideoRenderer] widget
  final VideoFit? videoFit;

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

  /// The color of a paused video indicator.
  final Color? pausedVideoIndicatorColor;

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

  /// Creates a copy of these properties but with the given fields replaced
  /// with the new values.
  StreamParticipantTileProps copyWith({
    Call? call,
    CallParticipantState? participant,
    String? rendererScopePrefix,
    VideoFit? videoFit,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    StreamUserAvatarThemeData? userAvatarTheme,
    bool? showSpeakerBorder,
    double? speakerBorderThickness,
    Color? speakerBorderColor,
    bool? showParticipantLabel,
    TextStyle? participantLabelTextStyle,
    AlignmentGeometry? participantLabelAlignment,
    Color? audioLevelIndicatorColor,
    Color? enabledMicrophoneColor,
    Color? disabledMicrophoneColor,
    Color? pausedVideoIndicatorColor,
    bool? showConnectionQualityIndicator,
    Color? connectionLevelActiveColor,
    Color? connectionLevelInactiveColor,
    AlignmentGeometry? connectionLevelAlignment,
    VideoPlaceholderBuilder? videoPlaceholderBuilder,
    VideoRendererBuilder? videoRendererBuilder,
    ValueSetter<Size>? onSizeChanged,
  }) {
    return StreamParticipantTileProps(
      call: call ?? this.call,
      participant: participant ?? this.participant,
      rendererScopePrefix: rendererScopePrefix ?? this.rendererScopePrefix,
      videoFit: videoFit ?? this.videoFit,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      userAvatarTheme: userAvatarTheme ?? this.userAvatarTheme,
      showSpeakerBorder: showSpeakerBorder ?? this.showSpeakerBorder,
      speakerBorderThickness:
          speakerBorderThickness ?? this.speakerBorderThickness,
      speakerBorderColor: speakerBorderColor ?? this.speakerBorderColor,
      showParticipantLabel: showParticipantLabel ?? this.showParticipantLabel,
      participantLabelTextStyle:
          participantLabelTextStyle ?? this.participantLabelTextStyle,
      participantLabelAlignment:
          participantLabelAlignment ?? this.participantLabelAlignment,
      audioLevelIndicatorColor:
          audioLevelIndicatorColor ?? this.audioLevelIndicatorColor,
      enabledMicrophoneColor:
          enabledMicrophoneColor ?? this.enabledMicrophoneColor,
      disabledMicrophoneColor:
          disabledMicrophoneColor ?? this.disabledMicrophoneColor,
      pausedVideoIndicatorColor:
          pausedVideoIndicatorColor ?? this.pausedVideoIndicatorColor,
      showConnectionQualityIndicator:
          showConnectionQualityIndicator ?? this.showConnectionQualityIndicator,
      connectionLevelActiveColor:
          connectionLevelActiveColor ?? this.connectionLevelActiveColor,
      connectionLevelInactiveColor:
          connectionLevelInactiveColor ?? this.connectionLevelInactiveColor,
      connectionLevelAlignment:
          connectionLevelAlignment ?? this.connectionLevelAlignment,
      videoPlaceholderBuilder:
          videoPlaceholderBuilder ?? this.videoPlaceholderBuilder,
      videoRendererBuilder: videoRendererBuilder ?? this.videoRendererBuilder,
      onSizeChanged: onSizeChanged ?? this.onSizeChanged,
    );
  }
}

/// The default implementation of [StreamParticipantTile].
class DefaultStreamParticipantTile extends StatelessWidget {
  /// Creates a new instance of [DefaultStreamParticipantTile].
  const DefaultStreamParticipantTile({
    super.key,
    required this.props,
  });

  /// The properties that configure this participant tile.
  final StreamParticipantTileProps props;

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallParticipantTheme.of(context);

    final call = props.call;
    final participant = props.participant;
    final rendererScopePrefix = props.rendererScopePrefix;
    final onSizeChanged = props.onSizeChanged;

    final videoFit = props.videoFit ?? theme.videoFit;
    final backgroundColor = props.backgroundColor ?? theme.backgroundColor;
    final borderRadius = props.borderRadius ?? theme.borderRadius;
    final userAvatarTheme = props.userAvatarTheme ?? theme.userAvatarTheme;
    final showSpeakerBorder =
        props.showSpeakerBorder ?? theme.showSpeakerBorder;
    final speakerBorderThickness =
        props.speakerBorderThickness ?? theme.speakerBorderThickness;
    final speakerBorderColor =
        props.speakerBorderColor ?? theme.speakerBorderColor;
    final showParticipantLabel =
        props.showParticipantLabel ?? theme.showParticipantLabel;
    final participantLabelTextStyle =
        props.participantLabelTextStyle ?? theme.participantLabelTextStyle;
    final participantLabelAlignment =
        props.participantLabelAlignment ?? theme.participantLabelAlignment;
    final audioLevelIndicatorColor =
        props.audioLevelIndicatorColor ?? theme.audioLevelIndicatorColor;
    final enabledMicrophoneColor =
        props.enabledMicrophoneColor ?? theme.enabledMicrophoneColor;
    final disabledMicrophoneColor =
        props.disabledMicrophoneColor ?? theme.disabledMicrophoneColor;
    final pausedVideoIndicatorColor =
        props.pausedVideoIndicatorColor ?? theme.pausedVideoIndicatorColor;
    final showConnectionQualityIndicator =
        props.showConnectionQualityIndicator ??
        theme.showConnectionQualityIndicator;
    final connectionLevelActiveColor =
        props.connectionLevelActiveColor ?? theme.connectionLevelActiveColor;
    final connectionLevelInactiveColor =
        props.connectionLevelInactiveColor ??
        theme.connectionLevelInactiveColor;
    final connectionLevelAlignment =
        props.connectionLevelAlignment ?? theme.connectionLevelAlignment;

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
            var videoPlaceholderBuilder = props.videoPlaceholderBuilder;
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

            var videoRendererBuilder = props.videoRendererBuilder;
            videoRendererBuilder ??= (context, call, participant) {
              return Stack(
                children: [
                  StreamVideoRenderer(
                    key: ValueKey(
                      '${rendererScopePrefix ?? ''}${participant.uniqueParticipantKey}-video',
                    ),
                    rendererScopePrefix: rendererScopePrefix,
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
                    videoFit: videoFit,
                  ),
                  if (participant.reaction != null)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          theme.callControlsTheme.callReactions
                                  .firstWhereOrNull(
                                    (e) =>
                                        e.emojiCode ==
                                        participant.reaction?.emojiCode,
                                  )
                                  ?.icon ??
                              '',
                          style: const TextStyle(
                            fontSize: 24,
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
                        StreamParticipantLabel.fromParticipant(
                          participant: participant,
                          audioLevelIndicatorColor: audioLevelIndicatorColor,
                          disabledMicrophoneColor: disabledMicrophoneColor,
                          enabledMicrophoneColor: enabledMicrophoneColor,
                          pausedVideoIndicatorColor: pausedVideoIndicatorColor,
                          participantLabelTextStyle: participantLabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                if (showConnectionQualityIndicator)
                  Align(
                    alignment: connectionLevelAlignment,
                    child: StreamConnectionQualityIndicator(
                      connectionQuality: participant.connectionQuality,
                      activeColor: connectionLevelActiveColor,
                      inactiveColor: connectionLevelInactiveColor,
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

/// A widget that represents a single participant in a call.
///
/// Kept as a thin wrapper around [DefaultStreamParticipantTile] so existing
/// code keeps working; it takes the same parameters as before.
@Deprecated(
  'Use StreamParticipantTile instead. '
  'Will be removed in the next major version.',
)
class StreamCallParticipant extends StatelessWidget {
  /// Creates a new instance of [StreamCallParticipant].
  @Deprecated(
    'Use StreamParticipantTile instead. '
    'Will be removed in the next major version.',
  )
  StreamCallParticipant({
    super.key,
    required Call call,
    required CallParticipantState participant,
    String? rendererScopePrefix,
    VideoFit? videoFit,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    StreamUserAvatarThemeData? userAvatarTheme,
    bool? showSpeakerBorder,
    double? speakerBorderThickness,
    Color? speakerBorderColor,
    bool? showParticipantLabel,
    TextStyle? participantLabelTextStyle,
    AlignmentGeometry? participantLabelAlignment,
    Color? audioLevelIndicatorColor,
    Color? enabledMicrophoneColor,
    Color? disabledMicrophoneColor,
    Color? pausedVideoIndicatorColor,
    bool? showConnectionQualityIndicator,
    Color? connectionLevelActiveColor,
    Color? connectionLevelInactiveColor,
    AlignmentGeometry? connectionLevelAlignment,
    VideoPlaceholderBuilder? videoPlaceholderBuilder,
    VideoRendererBuilder? videoRendererBuilder,
    ValueSetter<Size>? onSizeChanged,
  }) : props = .new(
         call: call,
         participant: participant,
         rendererScopePrefix: rendererScopePrefix,
         videoFit: videoFit,
         backgroundColor: backgroundColor,
         borderRadius: borderRadius,
         userAvatarTheme: userAvatarTheme,
         showSpeakerBorder: showSpeakerBorder,
         speakerBorderThickness: speakerBorderThickness,
         speakerBorderColor: speakerBorderColor,
         showParticipantLabel: showParticipantLabel,
         participantLabelTextStyle: participantLabelTextStyle,
         participantLabelAlignment: participantLabelAlignment,
         audioLevelIndicatorColor: audioLevelIndicatorColor,
         enabledMicrophoneColor: enabledMicrophoneColor,
         disabledMicrophoneColor: disabledMicrophoneColor,
         pausedVideoIndicatorColor: pausedVideoIndicatorColor,
         showConnectionQualityIndicator: showConnectionQualityIndicator,
         connectionLevelActiveColor: connectionLevelActiveColor,
         connectionLevelInactiveColor: connectionLevelInactiveColor,
         connectionLevelAlignment: connectionLevelAlignment,
         videoPlaceholderBuilder: videoPlaceholderBuilder,
         videoRendererBuilder: videoRendererBuilder,
         onSizeChanged: onSizeChanged,
       );

  /// The properties that configure this participant tile.
  final StreamParticipantTileProps props;

  @override
  Widget build(BuildContext context) {
    return DefaultStreamParticipantTile(props: props);
  }
}
