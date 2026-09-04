// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  group('StreamCallParticipantThemeData migration', () {
    test('an app that sets no participant theme gets the redesign', () {
      final theme = StreamVideoTheme.light();

      // Nothing populates the deprecated theme any more, so the tile and its
      // parts fall through to their own context-derived defaults.
      expect(theme.callParticipantTheme, isNull);
      expect(theme.participantTileTheme.style, isNull);
      expect(theme.participantLabelTheme.style, isNull);
      expect(theme.connectionQualityIndicatorTheme.style, isNull);
      expect(theme.callParticipantsGridTheme.padding, isNull);
    });

    test('a participant theme carries across in full', () {
      final theme = StreamVideoTheme(
        brightness: Brightness.light,
        callParticipantTheme: const StreamCallParticipantThemeData(
          backgroundColor: Color(0xFF112233),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      );

      final style = theme.participantTileTheme.style;
      expect(style?.backgroundColor, const Color(0xFF112233));
      expect(style?.borderRadius, const BorderRadius.all(Radius.circular(16)));
      // Setting the theme at all means keeping its shape, so the properties it
      // did not name come across at their old defaults rather than picking up
      // the redesign's.
      expect(style?.showParticipantLabel, isTrue);
      expect(theme.callParticipantsGridTheme.padding, const EdgeInsets.all(8));
    });

    test('folds the speaker border colour and width into one border', () {
      final theme = StreamVideoTheme(
        brightness: Brightness.light,
        callParticipantTheme: const StreamCallParticipantThemeData(
          speakerBorderColor: Color(0xFF00FF00),
          speakerBorderThickness: 6,
        ),
      );

      final border =
          theme.participantTileTheme.style?.speakingBorder as Border?;
      expect(border?.top.color, const Color(0xFF00FF00));
      expect(border?.top.width, 6);
    });

    test('spreads one connection colour across all three levels', () {
      final theme = StreamVideoTheme(
        brightness: Brightness.light,
        callParticipantTheme: const StreamCallParticipantThemeData(
          connectionLevelActiveColor: Color(0xFF00FF00),
        ),
      );

      final style = theme.connectionQualityIndicatorTheme.style;
      expect(style?.poorColor, const Color(0xFF00FF00));
      expect(style?.fairColor, const Color(0xFF00FF00));
      expect(style?.greatColor, const Color(0xFF00FF00));
    });

    test('ignores the legacy theme entirely once the new one is given', () {
      final theme = StreamVideoTheme(
        brightness: Brightness.light,
        callParticipantTheme: const StreamCallParticipantThemeData(
          backgroundColor: Color(0xFF112233),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        participantTileTheme: const StreamParticipantTileThemeData(
          style: StreamParticipantTileStyle(
            backgroundColor: Color(0xFF445566),
          ),
        ),
      );

      final style = theme.participantTileTheme.style;
      expect(style?.backgroundColor, const Color(0xFF445566));
      // Not blended: the radius the legacy theme carried is gone rather than
      // showing through underneath.
      expect(style?.borderRadius, isNull);
      // The themes the new shape said nothing about still come from the legacy
      // one — each is replaced on its own, not as a set.
      expect(theme.callParticipantsGridTheme.padding, const EdgeInsets.all(8));
    });

    test('carries the avatar configuration onto the placeholder', () {
      final theme = StreamVideoTheme(
        brightness: Brightness.light,
        callParticipantTheme: const StreamCallParticipantThemeData(
          userAvatarTheme: StreamUserAvatarThemeData(
            constraints: BoxConstraints.tightFor(height: 48, width: 48),
            initialsBackground: Color(0xFF223344),
          ),
        ),
      );

      final avatar =
          theme.participantTileTheme.style?.placeholderStyle?.avatarTheme;
      // Box constraints round up to the nearest design-system diameter.
      expect(avatar?.size, StreamAvatarSize.xl);
      expect(avatar?.backgroundColor, const Color(0xFF223344));
    });

    test('maps every property an app is likely to have set', () {
      final theme = StreamVideoTheme(
        brightness: Brightness.light,
        callParticipantTheme: const StreamCallParticipantThemeData(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          backgroundColor: Color(0xFF223344),
          audioLevelIndicatorColor: Color(0xFF334455),
          participantLabelTextStyle: TextStyle(fontSize: 11),
          disabledMicrophoneColor: Color(0xFF445566),
          pausedVideoIndicatorColor: Color(0xFF556677),
          connectionLevelActiveColor: Color(0xFF00FF00),
          connectionLevelInactiveColor: Color(0xFF667788),
          participantsGridPadding: EdgeInsets.all(4),
          participantsGridMainAxisSpacing: 4,
          participantsGridCrossAxisSpacing: 4,
        ),
      );

      expect(
        theme.participantTileTheme.style?.borderRadius,
        const BorderRadius.all(Radius.circular(16)),
      );
      expect(
        theme.participantTileTheme.style?.backgroundColor,
        const Color(0xFF223344),
      );

      final label = theme.participantLabelTheme.style;
      expect(label?.nameTextStyle?.fontSize, 11);
      expect(label?.speakingColor, const Color(0xFF334455));
      expect(label?.microphoneOffColor, const Color(0xFF445566));
      expect(label?.videoOffIconColor, const Color(0xFF556677));

      expect(
        theme.connectionQualityIndicatorTheme.style?.inactiveColor,
        const Color(0xFF667788),
      );

      final grid = theme.callParticipantsGridTheme;
      expect(grid.padding, const EdgeInsets.all(4));
      expect(grid.mainAxisSpacing, 4);
      expect(grid.crossAxisSpacing, 4);
    });
  });
}
