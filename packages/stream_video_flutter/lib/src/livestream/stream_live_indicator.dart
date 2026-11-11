import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// A pill telling whether a livestream is live or still in backstage.
///
/// While the call is live it shows a dot and "LIVE" on the accent colour;
/// in backstage it shows "BACKSTAGE" on a neutral surface.
class StreamLiveIndicator extends StatelessWidget {
  /// Creates a [StreamLiveIndicator].
  const StreamLiveIndicator({
    super.key,
    required this.call,
    this.style,
  });

  /// The livestream whose state is shown.
  final Call call;

  /// Overrides the style from [StreamLiveIndicatorTheme].
  final StreamLiveIndicatorStyle? style;

  static bool _isBackstage(CallState state) => state.isBackstage;

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamLiveIndicatorTheme.of(context).style;
    final resolved = _StreamLiveIndicatorStyleDefaults(
      context,
      themeStyle?.merge(style) ?? style,
    );
    final translations = context.translations;

    return PartialCallStateBuilder(
      call: call,
      selector: _isBackstage,
      builder: (context, isBackstage) {
        final foreground = isBackstage
            ? resolved.backstageForegroundColor
            : resolved.liveForegroundColor;
        final label = isBackstage
            ? translations.livestreamBackstage
            : translations.livestreamLive;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: isBackstage
                ? resolved.backstageBackgroundColor
                : resolved.liveBackgroundColor,
            borderRadius: resolved.borderRadius,
          ),
          child: Padding(
            padding: resolved.padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: resolved.spacing,
              children: [
                if (!isBackstage)
                  SizedBox.square(
                    dimension: resolved.dotSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: foreground,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                Text(
                  label.toUpperCase(),
                  style: resolved.textStyle.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Default style values for [StreamLiveIndicator], resolved against the
// ambient tokens.
class _StreamLiveIndicatorStyleDefaults extends StreamLiveIndicatorStyle {
  _StreamLiveIndicatorStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final StreamLiveIndicatorStyle? _style;

  late final StreamSpacing _spacing = _context.streamSpacing;
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  // The label's 16 line box plus 8 above and below is the design's 32 tall
  // pill, the height of the buttons next to it.
  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ??
      EdgeInsets.symmetric(
        horizontal: _spacing.sm,
        vertical: _spacing.xxs + _spacing.xxs,
      );

  @override
  double get spacing => _style?.spacing ?? _spacing.xs;

  @override
  double get dotSize => _style?.dotSize ?? _spacing.xs;

  @override
  BorderRadiusGeometry get borderRadius =>
      _style?.borderRadius ?? BorderRadius.all(_context.streamRadius.xxxl);

  @override
  TextStyle get textStyle =>
      _context.streamTextTheme.metadataEmphasis.merge(_style?.textStyle);

  @override
  Color get liveBackgroundColor =>
      _style?.liveBackgroundColor ?? _colorScheme.accentPrimary;

  @override
  Color get liveForegroundColor =>
      _style?.liveForegroundColor ?? _colorScheme.textOnAccent;

  @override
  Color get backstageBackgroundColor =>
      _style?.backstageBackgroundColor ?? _colorScheme.backgroundSurface;

  @override
  Color get backstageForegroundColor =>
      _style?.backstageForegroundColor ?? _colorScheme.textPrimary;
}
