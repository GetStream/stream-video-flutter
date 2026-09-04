import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Default style values for [StreamParticipantLabel].
///
/// Shared with the parts the pill is built from, so a default lives in one
/// place rather than once per widget that draws it. Deliberately not exported.
@internal
class StreamParticipantLabelStyleDefaults extends StreamParticipantLabelStyle {
  /// Resolves the label's defaults from the theme on the given context.
  ///
  /// [drawsAudioIndicator] is whether the pill these defaults describe ends up
  /// with a sound indicator, which its trailing inset depends on. That is not
  /// the same question as [showAudioIndicator]: a style that allows the
  /// indicator still leaves a muted participant without one. Resolve it with
  /// [participantLabelDrawsAudioIndicator].
  StreamParticipantLabelStyleDefaults(
    this._context, {
    bool drawsAudioIndicator = true,
  }) : _drawsAudioIndicator = drawsAudioIndicator;

  final BuildContext _context;
  final bool _drawsAudioIndicator;

  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;
  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;

  @override
  Color get backgroundColor => _colorScheme.backgroundOverlayDarkStrong;

  @override
  BorderRadius get borderRadius => BorderRadius.all(_radius.lg);

  @override
  EdgeInsetsGeometry get padding => EdgeInsetsDirectional.fromSTEB(
    _spacing.sm,
    _spacing.xxs,
    // The sound indicator's box carries its own padding, so the pill insets
    // less on that edge. Without it the trailing child is a bare icon, which
    // needs the same inset as the leading text or it crowds the edge.
    _drawsAudioIndicator ? _spacing.xxs : _spacing.sm,
    _spacing.xxs,
  );

  @override
  double get spacing => _spacing.xs;

  @override
  double get indicatorSpacing => _spacing.xxs;

  @override
  bool get showAudioIndicator => true;

  // Whatever the sound indicator would have made it, so a pill drawing
  // something shorter in its place is the size it would have been with it.
  @override
  double get minHeight => padding.vertical + audioIndicatorSize;

  @override
  double get blurSigma => 12.5;

  @override
  TextStyle get nameTextStyle =>
      _textTheme.metadataDefault.copyWith(color: _colorScheme.textOnAccent);

  @override
  Color get videoOffIconColor => _colorScheme.textOnAccent;

  @override
  double get videoOffIconSize => _spacing.md;

  @override
  double get microphoneIconSize => _spacing.md;

  @override
  Color get microphoneOffColor => _colorScheme.textOnAccent;

  @override
  double get audioIndicatorSize => 24;

  @override
  double get audioIndicatorIconSize => 10;

  @override
  Color get audioIndicatorBackgroundColor =>
      _colorScheme.backgroundOverlayDarkStrong;

  @override
  BorderRadius get audioIndicatorBorderRadius => BorderRadius.all(_radius.md);

  @override
  Color get speakingColor => _colorScheme.brand.shade300;
}

/// Whether a pill drawn for a participant in this state, under this style, ends
/// up with a sound indicator.
///
/// Two things suppress it: a style that switched it off — the lobby does, where
/// nothing reports a local audio level — and a muted participant, who has
/// nothing for it to report. The pill's trailing inset and its minimum width
/// both follow from the answer, so the widget and the measurements below
/// resolve it the same way rather than each spelling out the rule.
///
/// [style] is the style already merged over the ambient theme.
@internal
bool participantLabelDrawsAudioIndicator({
  required bool isAudioEnabled,
  required StreamParticipantLabelStyle? style,
}) => isAudioEnabled && (style?.showAudioIndicator ?? true);

/// The narrowest a [StreamParticipantLabel] can be laid out at, given what this
/// participant makes it draw.
///
/// The tile drops the pill rather than let it overflow, and to decide that it
/// needs the same number the pill lays itself out to: whichever indicators the
/// participant contributes, the padding around them and the gaps between them.
/// A name contributes no width of its own — it ellipsizes away to nothing — but
/// it still claims the gap before the indicators.
@internal
double participantLabelMinWidth(
  BuildContext context, {
  required bool showName,
  required bool showMicrophoneOff,
  required bool showVideoOff,
  StreamParticipantLabelStyle? style,
}) {
  // The same resolution order the label itself uses, so the two agree on what
  // the pill is going to be.
  final themeStyle = StreamParticipantLabelTheme.of(context).style;
  final resolved = themeStyle?.merge(style) ?? style;

  final drawsAudioIndicator = participantLabelDrawsAudioIndicator(
    isAudioEnabled: !showMicrophoneOff,
    style: resolved,
  );
  final defaults = StreamParticipantLabelStyleDefaults(
    context,
    drawsAudioIndicator: drawsAudioIndicator,
  );

  final padding = (resolved?.padding ?? defaults.padding).resolve(
    Directionality.maybeOf(context),
  );

  final indicators = <double>[
    if (showMicrophoneOff)
      resolved?.microphoneIconSize ?? defaults.microphoneIconSize,
    if (showVideoOff) resolved?.videoOffIconSize ?? defaults.videoOffIconSize,
    // The sound indicator stands in for the microphone icon rather than
    // joining it: the pill draws one or the other, never both.
    if (drawsAudioIndicator)
      resolved?.audioIndicatorSize ?? defaults.audioIndicatorSize,
  ];

  var width = padding.horizontal;

  // A pill can come down to a name alone — an unmuted, camera-on participant
  // under a style that switched the indicator off. There is then nothing for
  // the gap after the name to separate it from either.
  if (indicators.isNotEmpty) {
    width +=
        indicators.reduce((a, b) => a + b) +
        (indicators.length - 1) *
            (resolved?.indicatorSpacing ?? defaults.indicatorSpacing);
    if (showName) width += resolved?.spacing ?? defaults.spacing;
  }

  return width;
}

/// How tall a [StreamParticipantLabel] comes out.
///
/// The pill wraps its tallest part in its own padding, and never comes out
/// shorter than [StreamParticipantLabelStyle.minHeight]. Which indicators this
/// participant contributes does not enter into it: the pill holds one height
/// across every state so a row of tiles lines up.
///
/// The name is measured as its icons rather than with a [TextPainter]: at every
/// text scale the pill clamps to, an indicator is the tallest thing in the row,
/// and the tile only needs this to keep its two toolbars off each other.
@internal
double participantLabelHeight(
  BuildContext context, {
  StreamParticipantLabelStyle? style,
}) {
  final themeStyle = StreamParticipantLabelTheme.of(context).style;
  final resolved = themeStyle?.merge(style) ?? style;
  final defaults = StreamParticipantLabelStyleDefaults(context);

  final padding = (resolved?.padding ?? defaults.padding).resolve(
    Directionality.maybeOf(context),
  );

  final content = [
    resolved?.audioIndicatorSize ?? defaults.audioIndicatorSize,
    resolved?.microphoneIconSize ?? defaults.microphoneIconSize,
    resolved?.videoOffIconSize ?? defaults.videoOffIconSize,
  ].reduce(math.max);

  return math.max(
    resolved?.minHeight ?? defaults.minHeight,
    padding.vertical + content,
  );
}
