import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Resolves the style a [StreamDesktopScreenShareSelector] draws itself with.
///
/// Merges the ambient [StreamDesktopScreenShareSelectorTheme] with [style] and fills
/// in whatever neither supplied, so callers can read every property without a
/// fallback of their own.
@internal
StreamDesktopScreenShareSelectorStyleDefaults
resolveDesktopScreenShareSelectorStyle(
  BuildContext context,
  StreamDesktopScreenShareSelectorStyle? style,
) {
  final themeStyle = StreamDesktopScreenShareSelectorTheme.of(context).style;
  return StreamDesktopScreenShareSelectorStyleDefaults(
    context,
    themeStyle?.merge(style) ?? style,
  );
}

/// Default style values for [StreamDesktopScreenShareSelector].
///
/// Shared with the thumbnails the grid is built from, so a default lives in
/// one place rather than once per widget that draws it. Deliberately not
/// exported; reach it through [resolveDesktopScreenShareSelectorStyle].
@internal
class StreamDesktopScreenShareSelectorStyleDefaults
    extends StreamDesktopScreenShareSelectorStyle {
  /// Resolves the selector's defaults from the theme on the given context,
  /// letting [_style] win wherever it has a value.
  StreamDesktopScreenShareSelectorStyleDefaults(this._context, [this._style]);

  final BuildContext _context;
  final StreamDesktopScreenShareSelectorStyle? _style;

  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;
  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;

  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ?? EdgeInsets.all(_spacing.xxl);

  @override
  int get crossAxisCount => _style?.crossAxisCount ?? 3;

  @override
  double get spacing => _style?.spacing ?? _spacing.md;

  @override
  double get tileHeight => _style?.tileHeight ?? 164;

  @override
  EdgeInsetsGeometry get tilePadding =>
      _style?.tilePadding ?? EdgeInsets.all(_spacing.xs);

  @override
  double get tileSpacing => _style?.tileSpacing ?? _spacing.xs;

  @override
  BorderRadius get tileBorderRadius =>
      _style?.tileBorderRadius ?? BorderRadius.all(_radius.xl);

  @override
  BorderRadius get imageBorderRadius =>
      _style?.imageBorderRadius ?? BorderRadius.all(_radius.md);

  @override
  Color get borderColor => _style?.borderColor ?? _colorScheme.borderDefault;

  @override
  double get borderWidth => _style?.borderWidth ?? 1;

  @override
  Color get selectedBorderColor =>
      _style?.selectedBorderColor ?? _colorScheme.accentPrimary;

  @override
  double get selectedBorderWidth => _style?.selectedBorderWidth ?? 2;

  @override
  Color get placeholderColor =>
      _style?.placeholderColor ?? _colorScheme.backgroundSurfaceSubtle;

  @override
  TextStyle get labelTextStyle =>
      _style?.labelTextStyle ?? _textTheme.captionEmphasis;

  @override
  Color get labelColor => _style?.labelColor ?? _colorScheme.textTertiary;

  @override
  Color get selectedLabelColor =>
      _style?.selectedLabelColor ?? _colorScheme.accentPrimary;
}
