import 'package:flutter/material.dart';

import '../../theme/call_participant_theme.dart';

/// Widget used to indicate the audio levels of a given participant.
class StreamAudioLevelIndicator extends StatefulWidget {
  /// Creates a new instance of [StreamAudioLevelIndicator].
  const StreamAudioLevelIndicator({
    super.key,
    this.color,
    this.size,
  });

  /// The color of an audio level.
  final Color? color;

  /// The size of the audio level indicator.
  ///
  /// Defaults to 24.
  final double? size;

  @override
  State<StreamAudioLevelIndicator> createState() =>
      _StreamAudioLevelIndicatorState();
}

class _StreamAudioLevelIndicatorState extends State<StreamAudioLevelIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallParticipantTheme.of(context);
    final color = widget.color ?? theme.audioLevelIndicatorColor;

    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _AudioLevelIndicatorPainter(
          controller: _controller,
          color: color,
        ),
      ),
    );
  }
}

/// Painter widget for an the audio level indicator widget.
class _AudioLevelIndicatorPainter extends CustomPainter {
  /// Constructor for creating a [_AudioLevelIndicatorPainter].
  const _AudioLevelIndicatorPainter({
    required this.controller,
    required this.color,
  }) : super(repaint: controller);

  /// The current value of the animation.
  final AnimationController controller;

  /// The color of an audio level.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final offset = 4 * controller.value;

    canvas.drawLine(
      Offset(7, 10 - offset),
      const Offset(7, 16),
      paint,
    );
    canvas.drawLine(
      Offset(12, 6 + offset),
      const Offset(12, 16),
      paint,
    );
    canvas.drawLine(
      Offset(17, 10 - offset),
      const Offset(17, 16),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
