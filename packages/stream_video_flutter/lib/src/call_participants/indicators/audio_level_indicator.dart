import 'package:flutter/widgets.dart';

/// Three bars reporting whether a participant is speaking.
///
/// While [isSpeaking] the bars rise and fall around their shared centre line;
/// otherwise they rest at their minimum, reading as three dots. The animation
/// is a free-running loop rather than a reading of the participant's audio
/// level: it says "this person is talking", not how loudly.
class StreamAudioLevelIndicator extends StatefulWidget {
  /// Creates an audio level indicator.
  const StreamAudioLevelIndicator({
    super.key,
    required this.color,
    required this.isSpeaking,
    this.size = 10,
  });

  /// The color of the bars.
  final Color color;

  /// Whether the bars animate.
  final bool isSpeaking;

  /// The side length of the square the bars are painted in.
  ///
  /// The bars and the gaps between them are each a fifth of it, so three bars
  /// and two gaps fill the width exactly.
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
    );
    if (widget.isSpeaking) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(StreamAudioLevelIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking == oldWidget.isSpeaking) return;
    if (widget.isSpeaking) {
      _controller.repeat(reverse: true);
    } else {
      // Back to rest rather than stopping wherever the loop happened to be.
      _controller.stop();
      _controller.value = 0;
    }
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
              isSpeaking: widget.isSpeaking,
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
    required this.isSpeaking,
    required this.color,
  });

  final double animationValue;
  final bool isSpeaking;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 3;
    // Three bars and two gaps, each a fifth of the width.
    final unit = size.width / 5;
    final centerY = size.height / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = unit
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < barCount; i++) {
      // The middle bar runs against the outer two, so the group reads as
      // movement rather than as one bar pulsing three times — but only while
      // there is movement to read. At rest every bar collapses, or the
      // inverted one would sit at full height with the others already down.
      final phase = switch ((isSpeaking, i)) {
        (false, _) => 0.0,
        (true, 1) => 1 - animationValue,
        (true, _) => animationValue,
      };
      // A collapsed line has no length at all: the round cap alone draws a dot
      // one stroke across, which is the design's resting state.
      final length = (size.height - unit) * phase;

      final x = unit / 2 + i * 2 * unit;
      canvas.drawLine(
        Offset(x, centerY - length / 2),
        Offset(x, centerY + length / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_AudioLevelIndicatorPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.isSpeaking != isSpeaking ||
      oldDelegate.color != color;
}
