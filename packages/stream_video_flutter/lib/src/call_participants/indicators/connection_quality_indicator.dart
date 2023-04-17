import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Widget used to indicate the connection quality of a given participant.
class StreamConnectionQualityIndicator extends StatelessWidget {
  /// Creates a new instance of [StreamConnectionQualityIndicator].
  const StreamConnectionQualityIndicator({
    super.key,
    required this.connectionQuality,
    this.activeColor,
    this.inactiveColor,
    this.size,
  });

  /// The connection quality of the participant.
  final SfuConnectionQuality connectionQuality;

  /// The color of an active connection quality level.
  final Color? activeColor;

  /// The color of an inactive connection quality level.
  final Color? inactiveColor;

  /// The size of the indicator.
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallParticipantTheme.of(context);

    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _ConnectionQualityIndicatorPainter(
          connectionQuality: connectionQuality,
          activeColor: activeColor ?? theme.connectionLevelActiveColor,
          inactiveColor: inactiveColor ?? theme.connectionLevelInactiveColor,
        ),
      ),
    );
  }
}

/// Painter widget for the connection quality indicator widget.
class _ConnectionQualityIndicatorPainter extends CustomPainter {
  /// Constructor for creating a [_ConnectionQualityIndicatorPainter].
  const _ConnectionQualityIndicatorPainter({
    required this.connectionQuality,
    required this.activeColor,
    required this.inactiveColor,
  });

  /// The connection quality of the participant.
  final SfuConnectionQuality connectionQuality;

  /// The color of an active connection quality level.
  final Color activeColor;

  /// The color of an inactive connection quality level.
  final Color inactiveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 3; i++) {
      final offsetLeft = 7.0 + i * 5;
      final offsetTop = 14.0 - i * 3;

      canvas.drawLine(
        Offset(offsetLeft, offsetTop),
        Offset(offsetLeft, 16),
        connectionLevel > i ? activePaint : inactivePaint,
      );
    }
  }

  int get connectionLevel {
    switch (connectionQuality) {
      case SfuConnectionQuality.poor:
        return 1;
      case SfuConnectionQuality.good:
        return 2;
      case SfuConnectionQuality.excellent:
        return 3;
      case SfuConnectionQuality.unspecified:
        return 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
