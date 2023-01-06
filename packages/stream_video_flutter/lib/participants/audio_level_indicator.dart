import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_video_flutter/theme/stream_video_theme.dart';

/// Widget used to indicate the audio levels of a given participant.
class StreamAudioLevelIndicator extends StatelessWidget {
  const StreamAudioLevelIndicator({
    super.key,
    required this.audioLevel,
    this.activeColor,
    this.inactiveColor,
  });

  /// The audio level of the participant.
  final double audioLevel;

  /// The color of an active audio level.
  final Color? activeColor;

  /// The color of an inactive audio level.
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context).callParticipantTheme;

    return SizedBox(
      width: 24.0,
      height: 24.0,
      child: CustomPaint(
        size: const Size.square(24.0),
        painter: _AudioLevelIndicatorPainter(
          audioLevel: audioLevel,
          activeColor: activeColor ?? theme.audioLevelActiveColor,
          inactiveColor: inactiveColor ?? theme.audioLevelInactiveColor,
        ),
      ),
    );
  }
}

/// Painter widget for an the audio level indicator widget.
class _AudioLevelIndicatorPainter extends CustomPainter {
  /// Constructor for creating a [_AudioLevelIndicatorPainter].
  const _AudioLevelIndicatorPainter({
    required this.audioLevel,
    required this.activeColor,
    required this.inactiveColor,
  });

  /// The active level of audio of the participant.
  final double audioLevel;

  /// The color of an active audio level.
  final Color activeColor;

  /// The color of an inactive audio level.
  final Color inactiveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = _geAudioLevelPaint();

    canvas.drawLine(
      const Offset(7, 10),
      const Offset(7, 16),
      paint,
    );
    canvas.drawLine(
      const Offset(12, 6),
      const Offset(12, 16),
      paint,
    );
    canvas.drawLine(
      const Offset(17, 10),
      const Offset(17, 16),
      paint,
    );
  }

  Paint _geAudioLevelPaint() {
    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    return audioLevel <= 0 ? inactivePaint : activePaint;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
