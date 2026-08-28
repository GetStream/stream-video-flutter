import 'package:flutter/widgets.dart';

/// Three bars that rise and fall while a participant is speaking.
///
/// The animation is a free-running loop rather than a reading of the
/// participant's actual audio level: it says "this person is talking", not how
/// loudly.
class StreamAudioLevelIndicator extends StatefulWidget {
  /// Creates an audio level indicator.
  const StreamAudioLevelIndicator({
    super.key,
    required this.color,
    this.size = 16,
  });

  /// The color of the bars.
  final Color color;

  /// The side length of the square the bars are painted in.
  final double size;

  @override
  State<StreamAudioLevelIndicator> createState() =>
      _StreamAudioLevelIndicatorState();
}

class _StreamAudioLevelIndicatorState extends State<StreamAudioLevelIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
    // The only thing on a tile repainting every frame. It sits above the label
    // pill's backdrop filter, so a boundary here does not rob that filter of
    // its backdrop.
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => CustomPaint(
            size: Size.square(widget.size),
            painter: _AudioLevelIndicatorPainter(
              animationValue: _controller.value,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}

class _AudioLevelIndicatorPainter extends CustomPainter {
  const _AudioLevelIndicatorPainter({
    required this.animationValue,
    required this.color,
  });

  final double animationValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 3;
    final strokeWidth = size.width / 8;
    final gap = size.width / 8;
    final center = size.height / 2;
    final shortest = size.height / 5;
    final tallest = size.height / 2;

    final runWidth = barCount * strokeWidth + (barCount - 1) * gap;
    final firstX = (size.width - runWidth + strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < barCount; i++) {
      // The outer bars lead the middle one, so the run reads as movement
      // rather than as one bar pulsing three times.
      final phase = i == 1 ? 1 - animationValue : animationValue;
      final half = shortest + (tallest - shortest) * phase;
      final x = firstX + i * (strokeWidth + gap);

      canvas.drawLine(
        Offset(x, center - half / 2),
        Offset(x, center + half / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_AudioLevelIndicatorPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.color != color;
}
