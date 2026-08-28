import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import 'connection_quality_indicator_defaults.dart';

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
    final defaults = StreamConnectionQualityIndicatorStyleDefaults(context);

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

// Paints three bars of increasing height, `level` of them in [activeColor].
//
// The geometry is the design system's `Connection Indicator` icon, expressed in
// its own 24-unit space and scaled to whatever size it is drawn at: three
// 2-thick strokes at x 7, 12 and 17, rising from a shared baseline at y 16 to
// 14, 11 and 8. Unlike the sound indicator's bars these grow from the bottom —
// they report a level, not activity.
class _ConnectionQualityIndicatorPainter extends CustomPainter {
  const _ConnectionQualityIndicatorPainter({
    required this.level,
    required this.activeColor,
    required this.inactiveColor,
  });

  static const _viewBox = 24.0;
  static const _strokeWidth = 2.0;
  static const _baseline = 16.0;
  static const _bars = [
    (x: 7.0, top: 14.0),
    (x: 12.0, top: 11.0),
    (x: 17.0, top: 8.0),
  ];

  final int level;
  final Color activeColor;
  final Color inactiveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _viewBox;

    for (final (index, bar) in _bars.indexed) {
      canvas.drawLine(
        Offset(bar.x * scale, bar.top * scale),
        Offset(bar.x * scale, _baseline * scale),
        Paint()
          ..color = level > index ? activeColor : inactiveColor
          ..strokeWidth = _strokeWidth * scale
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
