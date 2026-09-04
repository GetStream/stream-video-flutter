import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  group('StreamCallParticipantThemeData', () {
    test('copyWith replaces the speaker border properties', () {
      const theme = StreamCallParticipantThemeData();

      final copy = theme.copyWith(
        showSpeakerBorder: false,
        speakerBorderThickness: 2,
        speakerBorderColor: const Color(0xFF00FF00),
      );

      expect(copy.showSpeakerBorder, isFalse);
      expect(copy.speakerBorderThickness, 2);
      expect(copy.speakerBorderColor, const Color(0xFF00FF00));
    });

    test('copyWith keeps properties it was not given', () {
      const theme = StreamCallParticipantThemeData(
        speakerBorderThickness: 6,
        speakerBorderColor: Color(0xFF0000FF),
      );

      final copy = theme.copyWith(showSpeakerBorder: false);

      expect(copy.speakerBorderThickness, 6);
      expect(copy.speakerBorderColor, const Color(0xFF0000FF));
    });

    test('merge carries every property of the other theme', () {
      const theme = StreamCallParticipantThemeData();
      const other = StreamCallParticipantThemeData(
        speakerBorderThickness: 2,
        speakerBorderColor: Color(0xFF00FF00),
        // Regression: merge used to drop this one silently.
        pausedVideoIndicatorColor: Color(0xFFFF0000),
        connectionLevelActiveColor: Color(0xFF123456),
      );

      final merged = theme.merge(other);

      expect(merged.speakerBorderThickness, 2);
      expect(merged.speakerBorderColor, const Color(0xFF00FF00));
      expect(merged.pausedVideoIndicatorColor, const Color(0xFFFF0000));
      expect(merged.connectionLevelActiveColor, const Color(0xFF123456));
    });
  });

  group('StreamVideoTheme', () {
    test('merge carries the call controls theme of the other theme', () {
      final theme = StreamVideoTheme.light();
      final other = theme.copyWith(
        callControlsTheme: const StreamCallControlsThemeData(elevation: 12),
      );

      // Regression: merge passed its own callControlsTheme to itself, so the
      // other theme's value was discarded.
      expect(theme.merge(other).callControlsTheme.elevation, 12);
    });

    test('merge carries the local video theme of the other theme', () {
      final theme = StreamVideoTheme.light();
      final other = theme.copyWith(
        localVideoTheme: const StreamLocalVideoThemeData(localVideoWidth: 200),
      );

      // Regression: localVideoTheme was missing from merge entirely.
      expect(theme.merge(other).localVideoTheme.localVideoWidth, 200);
    });
  });
}
