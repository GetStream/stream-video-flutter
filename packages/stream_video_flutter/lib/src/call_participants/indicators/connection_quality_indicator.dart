import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A round chip reporting how good a participant's connection is.
///
/// Three bars, of which as many are lit as the reported quality warrants. The
/// lit bars are also colored by level, so the state reads at a glance without
/// counting bars.
///
/// The rendering can be replaced app-wide by registering a
/// `connectionQualityIndicator` builder with [streamVideoComponentBuilders] on
/// a [StreamComponentFactory]. When no builder is registered,
/// [DefaultStreamConnectionQualityIndicator] is used.
///
/// See also:
///
///  * [StreamConnectionQualityIndicatorTheme], for customizing its appearance.
class StreamConnectionQualityIndicator extends StatelessWidget {
  /// Creates a connection quality indicator.
  StreamConnectionQualityIndicator({
    super.key,
    required SfuConnectionQuality connectionQuality,
    StreamConnectionQualityIndicatorStyle? style,
  }) : props = .new(connectionQuality: connectionQuality, style: style);

  /// The properties that configure this indicator.
  final StreamConnectionQualityIndicatorProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context
        .videoComponentBuilder<StreamConnectionQualityIndicatorProps>();
    return builder?.call(context, props) ??
        DefaultStreamConnectionQualityIndicator(props: props);
  }
}

/// Properties for configuring a [StreamConnectionQualityIndicator].
///
/// See also:
///
///  * [StreamConnectionQualityIndicator], which uses these properties.
///  * [DefaultStreamConnectionQualityIndicator], the default implementation.
@immutable
class StreamConnectionQualityIndicatorProps {
  /// Creates properties for a connection quality indicator.
  const StreamConnectionQualityIndicatorProps({
    required this.connectionQuality,
    this.style,
  });

  /// The connection quality being reported.
  final SfuConnectionQuality connectionQuality;

  /// Overrides for this indicator's appearance.
  ///
  /// Merged over the ambient [StreamConnectionQualityIndicatorTheme].
  final StreamConnectionQualityIndicatorStyle? style;

  /// Creates a copy of these properties with the given fields replaced.
  StreamConnectionQualityIndicatorProps copyWith({
    SfuConnectionQuality? connectionQuality,
    StreamConnectionQualityIndicatorStyle? style,
  }) {
    return StreamConnectionQualityIndicatorProps(
      connectionQuality: connectionQuality ?? this.connectionQuality,
      style: style ?? this.style,
    );
  }
}

/// The default implementation of [StreamConnectionQualityIndicator].
class DefaultStreamConnectionQualityIndicator extends StatelessWidget {
  /// Creates the default connection quality indicator.
  const DefaultStreamConnectionQualityIndicator({
    super.key,
    required this.props,
  });

  /// The properties that configure this indicator.
  final StreamConnectionQualityIndicatorProps props;

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamConnectionQualityIndicatorTheme.of(context).style;
    final style = themeStyle?.merge(props.style) ?? props.style;
    final defaults = _StreamConnectionQualityIndicatorStyleDefaults(context);

    final size = style?.size ?? defaults.size;
    final iconSize = style?.iconSize ?? defaults.iconSize;

    final activeColor = switch (props.connectionQuality) {
      SfuConnectionQuality.poor => style?.poorColor ?? defaults.poorColor,
      SfuConnectionQuality.good => style?.fairColor ?? defaults.fairColor,
      SfuConnectionQuality.excellent =>
        style?.greatColor ?? defaults.greatColor,
      // Nothing is lit, so the active color never gets painted.
      SfuConnectionQuality.unspecified =>
        style?.inactiveColor ?? defaults.inactiveColor,
    };

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style?.backgroundColor ?? defaults.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomPaint(
            size: Size.square(iconSize),
            painter: _ConnectionQualityIndicatorPainter(
              level: _levelOf(props.connectionQuality),
              activeColor: activeColor,
              inactiveColor: style?.inactiveColor ?? defaults.inactiveColor,
            ),
          ),
        ),
      ),
    );
  }

  static int _levelOf(SfuConnectionQuality quality) => switch (quality) {
    SfuConnectionQuality.poor => 1,
    SfuConnectionQuality.good => 2,
    SfuConnectionQuality.excellent => 3,
    SfuConnectionQuality.unspecified => 0,
  };
}

// Default style values for [StreamConnectionQualityIndicator].
//
// The chip sits on top of video, so its fill is an overlay and its bars are
// colored for legibility against that overlay rather than against a surface.
class _StreamConnectionQualityIndicatorStyleDefaults
    extends StreamConnectionQualityIndicatorStyle {
  _StreamConnectionQualityIndicatorStyleDefaults(this._context);

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

// Paints three bars of increasing height, `level` of them in [activeColor].
class _ConnectionQualityIndicatorPainter extends CustomPainter {
  const _ConnectionQualityIndicatorPainter({
    required this.level,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int level;
  final Color activeColor;
  final Color inactiveColor;

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 3;
    final strokeWidth = size.width / 8;
    final gap = size.width / 8;
    final baseline = size.height * (2 / 3);
    final shortest = size.height / 4;
    final tallest = size.height * (7 / 12);

    // Center the run of bars: each bar is a stroke, with a gap between them.
    final runWidth = barCount * strokeWidth + (barCount - 1) * gap;
    final firstX = (size.width - runWidth + strokeWidth) / 2;

    for (var i = 0; i < barCount; i++) {
      final height =
          shortest + (tallest - shortest) * (i / (barCount - 1).toDouble());
      final x = firstX + i * (strokeWidth + gap);

      canvas.drawLine(
        Offset(x, baseline - height),
        Offset(x, baseline),
        Paint()
          ..color = level > i ? activeColor : inactiveColor
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ConnectionQualityIndicatorPainter oldDelegate) =>
      oldDelegate.level != level ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.inactiveColor != inactiveColor;
}
