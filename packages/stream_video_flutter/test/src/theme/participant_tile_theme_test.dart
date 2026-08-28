import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

void main() {
  group('StreamParticipantTileTheme', () {
    testWidgets('resolves the global theme when no ancestor is present', (
      tester,
    ) async {
      late StreamParticipantTileThemeData resolved;

      await tester.pumpWidget(
        MaterialApp(
          theme: streamTestTheme().copyWith(
            extensions: [
              StreamTheme.light(),
              StreamVideoTheme.light().copyWith(
                participantTileTheme: const StreamParticipantTileThemeData(
                  style: StreamParticipantTileStyle(
                    showParticipantLabel: false,
                  ),
                ),
              ),
            ],
          ),
          home: Builder(
            builder: (context) {
              resolved = StreamParticipantTileTheme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved.style?.showParticipantLabel, isFalse);
    });

    testWidgets('merges a local override over the global theme', (
      tester,
    ) async {
      late StreamParticipantTileThemeData resolved;

      await tester.pumpWidget(
        MaterialApp(
          theme: streamTestTheme().copyWith(
            extensions: [
              StreamTheme.light(),
              StreamVideoTheme.light().copyWith(
                participantTileTheme: const StreamParticipantTileThemeData(
                  style: StreamParticipantTileStyle(
                    showParticipantLabel: false,
                    showMoreButton: false,
                  ),
                ),
              ),
            ],
          ),
          home: StreamParticipantTileTheme(
            data: const StreamParticipantTileThemeData(
              style: StreamParticipantTileStyle(showMoreButton: true),
            ),
            child: Builder(
              builder: (context) {
                resolved = StreamParticipantTileTheme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // The local value wins...
      expect(resolved.style?.showMoreButton, isTrue);
      // ...and the global one it did not mention survives, rather than being
      // replaced wholesale the way the deprecated theme behaved.
      expect(resolved.style?.showParticipantLabel, isFalse);
    });
  });

  group('StreamVideoTheme', () {
    test('carries the new component themes through copyWith', () {
      final theme = StreamVideoTheme.light().copyWith(
        participantLabelTheme: const StreamParticipantLabelThemeData(
          style: StreamParticipantLabelStyle(blurSigma: 4),
        ),
        connectionQualityIndicatorTheme:
            const StreamConnectionQualityIndicatorThemeData(
              style: StreamConnectionQualityIndicatorStyle(size: 40),
            ),
        callParticipantsGridTheme: const StreamCallParticipantsGridThemeData(
          mainAxisSpacing: 2,
        ),
        floatingParticipantTileTheme:
            const StreamFloatingParticipantTileThemeData(
              style: StreamFloatingParticipantTileStyle(elevation: 9),
            ),
      );

      expect(theme.participantLabelTheme.style?.blurSigma, 4);
      expect(theme.connectionQualityIndicatorTheme.style?.size, 40);
      expect(theme.callParticipantsGridTheme.mainAxisSpacing, 2);
      expect(theme.floatingParticipantTileTheme.style?.elevation, 9);
    });

    test('defaults every new component theme to an empty instance', () {
      final theme = StreamVideoTheme.light();

      // Empty means "no overrides": the widgets fall back to their own
      // context-derived defaults rather than to values baked into the theme.
      expect(theme.participantTileTheme.style, isNull);
      expect(theme.participantLabelTheme.style, isNull);
      expect(theme.connectionQualityIndicatorTheme.style, isNull);
      expect(theme.floatingParticipantTileTheme.style, isNull);
      expect(theme.callParticipantsGridTheme.padding, isNull);
    });

    test('lerp interpolates the new component themes', () {
      final a = StreamVideoTheme.light().copyWith(
        connectionQualityIndicatorTheme:
            const StreamConnectionQualityIndicatorThemeData(
              style: StreamConnectionQualityIndicatorStyle(size: 20),
            ),
      );
      final b = StreamVideoTheme.light().copyWith(
        connectionQualityIndicatorTheme:
            const StreamConnectionQualityIndicatorThemeData(
              style: StreamConnectionQualityIndicatorStyle(size: 40),
            ),
      );

      final mid = a.lerp(b, 0.5) as StreamVideoTheme;

      expect(mid.connectionQualityIndicatorTheme.style?.size, 30);
    });
  });
}
