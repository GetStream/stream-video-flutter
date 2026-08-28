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
  StreamParticipantLabelStyleDefaults(this._context);

  final BuildContext _context;

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
    _spacing.xxs,
    _spacing.xxs,
  );

  @override
  double get spacing => _spacing.xs;

  @override
  double get blurSigma => 12.5;

  @override
  TextStyle get nameTextStyle =>
      _textTheme.metadataDefault.copyWith(color: _colorScheme.textOnAccent);

  @override
  Color get videoOffIconColor => _colorScheme.textOnAccent;

  @override
  double get videoOffIconSize => _spacing.lg;

  @override
  double get microphoneIconSize => _spacing.lg;

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

/// The narrowest a [StreamParticipantLabel] can be laid out at, given what this
/// participant makes it draw.
///
/// The tile drops the pill rather than let it overflow, and to decide that it
/// needs the same number the pill lays itself out to: the sound indicator it
/// always draws, whichever state icons the participant contributes, the padding
/// around them and the gaps between them. A name contributes no width of its
/// own — it ellipsizes away to nothing — but it still claims one of the gaps.
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
  final defaults = StreamParticipantLabelStyleDefaults(context);

  final padding = (resolved?.padding ?? defaults.padding).resolve(
    Directionality.maybeOf(context),
  );

  var width =
      padding.horizontal +
      (resolved?.audioIndicatorSize ?? defaults.audioIndicatorSize);
  var children = 1;

  if (showName) children++;
  if (showMicrophoneOff) {
    width += resolved?.microphoneIconSize ?? defaults.microphoneIconSize;
    children++;
  }
  if (showVideoOff) {
    width += resolved?.videoOffIconSize ?? defaults.videoOffIconSize;
    children++;
  }

  return width + (children - 1) * (resolved?.spacing ?? defaults.spacing);
}

/// How tall a [StreamParticipantLabel] comes out.
///
/// The pill wraps its tallest part in its own padding. The name is measured as
/// its icons rather than with a [TextPainter]: at every text scale the pill
/// clamps to, the sound indicator is the tallest thing in the row, and the tile
/// only needs this to keep its two toolbars off each other.
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

  return padding.vertical + content;
}
