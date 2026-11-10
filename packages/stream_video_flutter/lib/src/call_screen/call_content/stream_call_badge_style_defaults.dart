import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../stream_video_flutter.dart';
import '../../utils/device_segmentation.dart';

/// The shared [StreamCallBadgeStyle] the call badges fall back to, resolved
/// against the ambient [StreamCallBadgeTheme] and then the tokens.
///
/// Each badge is a 32 tall pill holding a 20 tall row. Desktop and web draw it
/// with `captionEmphasis` and 16px icons, iOS and Android with `bodyEmphasis`
/// and 20px icons.
@internal
class StreamCallBadgeStyleDefaults extends StreamCallBadgeStyle {
  /// Creates the shared defaults, resolved against [_context].
  StreamCallBadgeStyleDefaults(this._context)
    : _style = StreamCallBadgeTheme.of(_context).style;

  final BuildContext _context;
  final StreamCallBadgeStyle? _style;

  late final StreamSpacing _spacing = _context.streamSpacing;

  /// The shared [StreamCallBadgeStyle.spacing] when the theme sets one.
  ///
  /// For a badge whose own default gap differs from [spacing].
  double? get themeSpacing => _style?.spacing;

  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ??
      EdgeInsets.symmetric(
        horizontal: _spacing.xs,
        vertical: _spacing.xxs + _spacing.xxxs,
      );

  @override
  double get contentHeight => _style?.contentHeight ?? 20;

  @override
  double get spacing =>
      _style?.spacing ?? (isDesktopOrWeb ? _spacing.xxs : _spacing.xs);

  @override
  double get iconSize => _style?.iconSize ?? (isDesktopOrWeb ? 16 : 20);

  @override
  Color get backgroundColor =>
      _style?.backgroundColor ?? _context.streamColorScheme.backgroundSurface;

  @override
  BorderRadiusGeometry get borderRadius =>
      _style?.borderRadius ?? BorderRadius.all(_context.streamRadius.xxxl);

  @override
  TextStyle get textStyle => resolveTextStyle(
    color: _context.streamColorScheme.textPrimary,
  );

  /// A badge's text style: `captionEmphasis` on desktop and web and
  /// `bodyEmphasis` on mobile, in [color], with the shared [textStyle] and then
  /// [override] merged on top.
  ///
  /// `height: 1` so the text centres against the icons rather than sitting in
  /// the 20pt line box the style carries, and tabular figures so a pill
  /// showing a number holds still as it changes. Merging on top keeps both
  /// when a caller only names a size or a colour.
  TextStyle resolveTextStyle({required Color color, TextStyle? override}) {
    final textTheme = _context.streamTextTheme;
    final base = isDesktopOrWeb
        ? textTheme.captionEmphasis
        : textTheme.bodyEmphasis;

    return base
        .copyWith(
          color: color,
          height: 1,
          fontFeatures: const [FontFeature.tabularFigures()],
        )
        .merge(_style?.textStyle)
        .merge(override);
  }
}
