import 'dart:ui';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'participant_label_defaults.dart';

/// The pill on a participant tile carrying their name and audio state.
///
/// Holds the participant's name followed by whatever their state contributes: a
/// microphone icon while they are muted, a camera-off icon while their video is
/// off, and a [StreamAudioIndicator] while their microphone is open. It is
/// meant to be laid out inside a bounded parent: the name shrinks and
/// ellipsizes rather than pushing the pill wider than the space it was given.
///
/// The rendering can be replaced app-wide by registering a `participantLabel`
/// builder with [streamVideoComponentBuilders] on a [StreamComponentFactory].
/// When no builder is registered, [DefaultStreamParticipantLabel] is used.
///
/// See also:
///
///  * [StreamParticipantLabelTheme], for customizing its appearance.
class StreamParticipantLabel extends StatelessWidget {
  /// Creates a participant label.
  StreamParticipantLabel({
    super.key,
    required String name,
    required bool isAudioEnabled,
    required bool isSpeaking,
    required bool isVideoEnabled,
    bool isTrackPaused = false,
    bool showName = true,
    StreamParticipantLabelStyle? style,
  }) : props = .new(
         name: name,
         isAudioEnabled: isAudioEnabled,
         isSpeaking: isSpeaking,
         isVideoEnabled: isVideoEnabled,
         isTrackPaused: isTrackPaused,
         showName: showName,
         style: style,
       );

  /// Creates a participant label describing [participant].
  StreamParticipantLabel.fromParticipant({
    super.key,
    required CallParticipantState participant,
    bool showName = true,
    StreamParticipantLabelStyle? style,
  }) : props = .new(
         name: participant.name,
         isAudioEnabled: participant.isAudioEnabled,
         isSpeaking: participant.isSpeaking,
         isVideoEnabled: participant.isVideoEnabled,
         isTrackPaused: participant.isTrackPaused(SfuTrackType.video),
         showName: showName,
         style: style,
       );

  /// The properties that configure this label.
  final StreamParticipantLabelProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context
        .videoComponentBuilder<StreamParticipantLabelProps>();
    return builder?.call(context, props) ??
        DefaultStreamParticipantLabel(props: props);
  }
}

/// Properties for configuring a [StreamParticipantLabel].
///
/// See also:
///
///  * [StreamParticipantLabel], which uses these properties.
///  * [DefaultStreamParticipantLabel], the default implementation.
@immutable
class StreamParticipantLabelProps {
  /// Creates properties for a participant label.
  const StreamParticipantLabelProps({
    required this.name,
    required this.isAudioEnabled,
    required this.isSpeaking,
    required this.isVideoEnabled,
    this.isTrackPaused = false,
    this.showName = true,
    this.style,
  });

  /// The participant's display name.
  final String name;

  /// Whether the participant's microphone is on.
  final bool isAudioEnabled;

  /// Whether the participant is currently speaking.
  final bool isSpeaking;

  /// Whether the participant's camera is on.
  final bool isVideoEnabled;

  /// Whether the SFU has paused this participant's inbound video.
  ///
  /// A different state from [isVideoEnabled]: the participant's camera is on
  /// and publishing, but the SFU has stopped sending it here to save
  /// bandwidth. The tile shows the placeholder either way, so without an
  /// indicator of its own the two are indistinguishable.
  final bool isTrackPaused;

  /// Whether [name] is shown.
  ///
  /// A pill without it is its indicators alone. Size is not a reason to switch
  /// it off: the name ellipsizes into whatever space the pill has, down to
  /// nothing.
  final bool showName;

  /// Overrides for this label's appearance.
  ///
  /// Merged over the ambient [StreamParticipantLabelTheme].
  final StreamParticipantLabelStyle? style;

  /// Creates a copy of these properties with the given fields replaced.
  StreamParticipantLabelProps copyWith({
    String? name,
    bool? isAudioEnabled,
    bool? isSpeaking,
    bool? isVideoEnabled,
    bool? isTrackPaused,
    bool? showName,
    StreamParticipantLabelStyle? style,
  }) {
    return StreamParticipantLabelProps(
      name: name ?? this.name,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isTrackPaused: isTrackPaused ?? this.isTrackPaused,
      showName: showName ?? this.showName,
      style: style ?? this.style,
    );
  }
}

/// The default implementation of [StreamParticipantLabel].
class DefaultStreamParticipantLabel extends StatelessWidget {
  /// Creates the default participant label.
  const DefaultStreamParticipantLabel({super.key, required this.props});

  /// The properties that configure this label.
  final StreamParticipantLabelProps props;

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamParticipantLabelTheme.of(context).style;
    final style = themeStyle?.merge(props.style) ?? props.style;
    // The trailing inset depends on whether the indicator is drawn, so that has
    // to be resolved before the defaults that describe the pill.
    final drawsAudioIndicator = participantLabelDrawsAudioIndicator(
      isAudioEnabled: props.isAudioEnabled,
      style: style,
    );
    final defaults = StreamParticipantLabelStyleDefaults(
      context,
      drawsAudioIndicator: drawsAudioIndicator,
    );

    final borderRadius = style?.borderRadius ?? defaults.borderRadius;
    final nameTextStyle = style?.nameTextStyle ?? defaults.nameTextStyle;
    final blurSigma = style?.blurSigma ?? defaults.blurSigma;

    final indicators = <Widget>[
      // Only the muted state gets an icon: an unmuted microphone is the norm.
      if (!props.isAudioEnabled)
        Icon(
          context.streamIcons.voiceOffFill,
          size: style?.microphoneIconSize ?? defaults.microphoneIconSize,
          color:
              style?.microphoneOffColor ??
              nameTextStyle.color ??
              defaults.microphoneOffColor,
        ),
      if (!props.isVideoEnabled)
        Icon(
          context.streamIcons.videoOffFill,
          size: style?.videoOffIconSize ?? defaults.videoOffIconSize,
          color:
              style?.videoOffIconColor ??
              nameTextStyle.color ??
              defaults.videoOffIconColor,
        ),
      // Paused is not the same as camera-off: the camera is publishing and the
      // SFU is holding the stream back, so the tile's placeholder needs
      // something beside it to say which of the two it is standing in for.
      if (props.isTrackPaused)
        Icon(
          context.streamIcons.lowBandwidthFill,
          size: style?.videoPausedIconSize ?? defaults.videoPausedIconSize,
          color:
              style?.videoPausedColor ??
              nameTextStyle.color ??
              defaults.videoPausedColor,
        ),
      // The sound indicator reports what is coming through an open microphone.
      // A muted participant has nothing for it to report, and the icon above
      // already says why.
      if (drawsAudioIndicator)
        StreamAudioIndicator(isSpeaking: props.isSpeaking, style: style),
    ];

    Widget content = Padding(
      padding: style?.padding ?? defaults.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // An empty name draws a zero-width Text that still claims the gap
          // before the indicators, leaving the pill padded for a name it is
          // not showing. A participant with no name set is not unusual.
          if (props.showName && props.name.isNotEmpty)
            // Flexible, not Expanded: the pill is only as wide as it needs to
            // be, up to whatever its parent allows. Combined with the parent's
            // bound this is what makes a long name ellipsize instead of
            // sliding under whatever sits next to the pill.
            Flexible(
              child: Padding(
                // The gap before the indicators sits inside the name's own
                // region rather than between the two children, so a name
                // squeezed to nothing takes the gap with it. Between them it
                // would survive the name and leave the pill holding 8px of
                // space for text it is no longer drawing.
                padding: indicators.isEmpty
                    ? EdgeInsets.zero
                    : EdgeInsetsDirectional.only(
                        end: style?.spacing ?? defaults.spacing,
                      ),
                child: Text(
                  props.name,
                  style: nameTextStyle,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          // Left out entirely when it would be empty: an empty child still
          // claims the gap after the name, which would leave the pill padded
          // for indicators it is not drawing.
          if (indicators.isNotEmpty)
            // The indicators sit closer to each other than to the name, so
            // they read as one group reporting this participant's state rather
            // than as separate items trailing the name.
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: style?.indicatorSpacing ?? defaults.indicatorSpacing,
              children: indicators,
            ),
        ],
      ),
    );

    // The minimum height keeps the pill from taking its height from whatever
    // is tallest inside it, which is the sound indicator — so a pill drawing
    // icons in its place, or nothing at all, is the size it would have been
    // with one rather than collapsing onto its text. It also keeps the tile's
    // chrome arithmetic holding across states.
    //
    // The maximum width is where the pill stops growing with the space it is
    // given; a name longer than that ellipsizes into it.
    content = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: style?.minHeight ?? defaults.minHeight,
        maxWidth: style?.maxWidth ?? defaults.maxWidth,
      ),
      child: content,
    );

    // Text scaling grows the pill, which on a small tile can swallow the video.
    // Clamping keeps it legible without letting it take the whole tile.
    content = MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: content,
    );

    return ClipRRect(
      // The pill needs its own clip: without one the backdrop filter blurs
      // everything up to the tile's clip rather than just what is behind it.
      borderRadius: borderRadius,
      child: _MaybeBlur(
        sigma: blurSigma,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: style?.backgroundColor ?? defaults.backgroundColor,
            borderRadius: borderRadius,
          ),
          child: content,
        ),
      ),
    );
  }
}

// Applies a backdrop blur, or nothing at all when [sigma] is null.
//
// A BackdropFilter costs a render layer even at sigma zero, and a full grid
// carries one pill per tile, so "no blur" has to mean "no filter".
class _MaybeBlur extends StatelessWidget {
  const _MaybeBlur({required this.sigma, required this.child});

  final double? sigma;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sigma = this.sigma;
    if (sigma == null || sigma <= 0) return child;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: child,
    );
  }
}
