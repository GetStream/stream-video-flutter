import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// A pill showing how many people are watching a livestream.
class StreamSpectatorsIndicator extends StatelessWidget {
  /// Creates a [StreamSpectatorsIndicator].
  const StreamSpectatorsIndicator({
    super.key,
    required this.call,
    this.includeAnonymousParticipants = true,
    this.style,
  });

  /// The livestream whose audience is counted.
  final Call call;

  /// Whether anonymous viewers are part of the count.
  ///
  /// Defaults to true.
  final bool includeAnonymousParticipants;

  /// Overrides the style from [StreamSpectatorsIndicatorTheme].
  final StreamSpectatorsIndicatorStyle? style;

  static int _allViewers(CallState state) =>
      state.participantCount + state.anonymousParticipantCount;

  static int _namedViewers(CallState state) => state.participantCount;

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamSpectatorsIndicatorTheme.of(context).style;
    final resolved = _StreamSpectatorsIndicatorStyleDefaults(
      context,
      themeStyle?.merge(style) ?? style,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolved.backgroundColor,
        borderRadius: resolved.borderRadius,
      ),
      child: Padding(
        padding: resolved.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: resolved.spacing,
          children: [
            Icon(
              context.streamIcons.eyeFill,
              size: resolved.iconSize,
              color: resolved.iconColor,
            ),
            PartialCallStateBuilder(
              call: call,
              selector: includeAnonymousParticipants
                  ? _allViewers
                  : _namedViewers,
              builder: (context, count) => Text(
                '$count',
                style: resolved.textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Default style values for [StreamSpectatorsIndicator], resolved against the
// ambient tokens.
class _StreamSpectatorsIndicatorStyleDefaults
    extends StreamSpectatorsIndicatorStyle {
  _StreamSpectatorsIndicatorStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final StreamSpectatorsIndicatorStyle? _style;

  late final StreamSpacing _spacing = _context.streamSpacing;
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  // The 20 icon plus 6 above and below is the design's 32 tall pill, the
  // height of the buttons next to it.
  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ??
      EdgeInsets.symmetric(
        horizontal: _spacing.xs,
        vertical: _spacing.xxs + _spacing.xxxs,
      );

  @override
  double get spacing => _style?.spacing ?? _spacing.xs;

  @override
  double get iconSize => _style?.iconSize ?? 20;

  @override
  BorderRadiusGeometry get borderRadius =>
      _style?.borderRadius ?? BorderRadius.all(_context.streamRadius.xxxl);

  @override
  Color get backgroundColor =>
      _style?.backgroundColor ?? _colorScheme.backgroundSurface;

  @override
  Color get iconColor => _style?.iconColor ?? _colorScheme.textPrimary;

  // `height: 1` so the count centres against the icon rather than sitting in
  // the 20pt line box `bodyEmphasis` carries, and tabular figures so the pill
  // holds still as the count changes.
  @override
  TextStyle get textStyle => _context.streamTextTheme.bodyEmphasis
      .copyWith(
        color: _colorScheme.textPrimary,
        height: 1,
        fontFeatures: const [FontFeature.tabularFigures()],
      )
      .merge(_style?.textStyle);
}
