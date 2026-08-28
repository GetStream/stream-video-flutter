import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Default style values for [StreamConnectionQualityIndicator].
///
/// The chip sits on top of video, so its fill is an overlay and its bars are
/// colored for legibility against that overlay rather than against a surface.
///
/// Shared with the tile, which has to know how much room the chip takes before
/// it decides what else fits beside it. Deliberately not exported.
@internal
class StreamConnectionQualityIndicatorStyleDefaults
    extends StreamConnectionQualityIndicatorStyle {
  /// Resolves the indicator's defaults from the theme on the given context.
  StreamConnectionQualityIndicatorStyleDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;

  @override
  double get size => 32;

  @override
  double get iconSize => 24;

  @override
  Color get backgroundColor => _colorScheme.backgroundOverlayDarkStrong;

  @override
  Color get poorColor => _colorScheme.accentError;

  @override
  Color get fairColor => _colorScheme.accentWarning;

  @override
  Color get greatColor => _colorScheme.accentSuccess;

  @override
  Color get inactiveColor => _colorScheme.textOnAccent.withValues(alpha: 0.4);
}

/// How much room a [StreamConnectionQualityIndicator] takes, in both axes.
///
/// Resolved the same way the indicator resolves it, so the tile lays out
/// against the chip that is actually going to be drawn rather than the default
/// one.
@internal
double connectionQualityIndicatorSize(
  BuildContext context, {
  StreamConnectionQualityIndicatorStyle? style,
}) {
  final themeStyle = StreamConnectionQualityIndicatorTheme.of(context).style;
  final resolved = themeStyle?.merge(style) ?? style;
  return resolved?.size ??
      StreamConnectionQualityIndicatorStyleDefaults(context).size;
}
