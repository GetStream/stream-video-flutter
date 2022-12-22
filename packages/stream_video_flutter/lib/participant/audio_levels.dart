import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_video_flutter/theme/stream_video_theme.dart';

/// Widget used to indicate the audio levels of a given participant.
class AudioLevels extends StatelessWidget {
  const AudioLevels({
    super.key,
    required this.audioLevel,
    this.audioLevelActiveColor,
    this.audioLevelInactiveColor,
  });

  /// The active level of audio of the participant.
  final double audioLevel;

  /// The color of an active audio level.
  final Color? audioLevelActiveColor;

  /// The color of an inactive audio level.
  final Color? audioLevelInactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context).callParticipantTheme;

    return SizedBox(
      width: 24.0,
      height: 24.0,
      child: CustomPaint(
        size: const Size.square(24.0),
        painter: AudioLevelsPainter(
          audioLevel: audioLevel,
          audioLevelActiveColor:
              audioLevelActiveColor ?? theme.audioLevelActiveColor,
          audioLevelInactiveColor:
              audioLevelInactiveColor ?? theme.audioLevelInactiveColor,
        ),
      ),
    );
  }
}

/// Painter widget for an audio levels indicator.
class AudioLevelsPainter extends CustomPainter {
  /// Constructor for creating a [AudioLevelsPainter].
  const AudioLevelsPainter({
    required this.audioLevel,
    required this.audioLevelActiveColor,
    required this.audioLevelInactiveColor,
  });

  /// The active level of audio of the participant.
  final double audioLevel;

  /// The color of an active audio level.
  final Color audioLevelActiveColor;

  /// The color of an inactive audio level.
  final Color audioLevelInactiveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final activePaint = Paint()
      ..color = audioLevelActiveColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final inactivePaint = Paint()
      ..color = audioLevelInactiveColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      const Offset(7, 14),
      const Offset(7, 17),
      audioLevel > 0 ? activePaint : inactivePaint,
    );

    canvas.drawLine(
      const Offset(12, 11),
      const Offset(12, 17),
      audioLevel > 0.25 ? activePaint : inactivePaint,
    );

    canvas.drawLine(
      const Offset(17, 8),
      const Offset(17, 17),
      audioLevel > 0.5 ? activePaint : inactivePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
