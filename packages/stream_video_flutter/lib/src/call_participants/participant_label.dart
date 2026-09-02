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
    bool showName = true,
    StreamParticipantLabelStyle? style,
  }) : props = .new(
         name: name,
         isAudioEnabled: isAudioEnabled,
         isSpeaking: isSpeaking,
         isVideoEnabled: isVideoEnabled,
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

  /// Whether [name] is shown.
  ///
  /// A tile too narrow to fit a readable name drops it and keeps the icons,
  /// which stay meaningful at any size.
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
    bool? showName,
    StreamParticipantLabelStyle? style,
  }) {
    return StreamParticipantLabelProps(
      name: name ?? this.name,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
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
        spacing: style?.spacing ?? defaults.spacing,
        children: [
          if (props.showName)
            // Flexible, not Expanded: the pill is only as wide as it needs to
            // be, up to whatever its parent allows. Combined with the parent's
            // bound this is what makes a long name ellipsize instead of
            // sliding under whatever sits next to the pill.
            Flexible(
              child: Text(
                props.name,
                style: nameTextStyle,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
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

    // Without this the pill's height comes from whatever is tallest inside it,
    // which is the sound indicator — so a pill drawing icons in its place, or
    // nothing at all, would collapse onto its text and lose the padding around
    // it. It also keeps the tile's chrome arithmetic holding across states.
    content = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: style?.minHeight ?? defaults.minHeight,
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
