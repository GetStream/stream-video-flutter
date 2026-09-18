import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

void main() {
  StreamVideoTheme themeWith(StreamCallParticipantsSpotlightStyle style) =>
      StreamVideoTheme.light().copyWith(
        callParticipantsSpotlightTheme:
            StreamCallParticipantsSpotlightThemeData(style: style),
      );

  Widget app({required StreamVideoTheme theme, required Widget home}) =>
      MaterialApp(
        theme: streamTestTheme().copyWith(
          extensions: [StreamTheme.light(), theme],
        ),
        home: home,
      );

  group('StreamCallParticipantsSpotlightTheme', () {
    testWidgets('resolves the global theme when no ancestor is present', (
      tester,
    ) async {
      late StreamCallParticipantsSpotlightThemeData resolved;

      await tester.pumpWidget(
        app(
          theme: themeWith(
            const StreamCallParticipantsSpotlightStyle(
              maxSpotlightAspectRatio: 4 / 3,
            ),
          ),
          home: Builder(
            builder: (context) {
              resolved = StreamCallParticipantsSpotlightTheme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved.style?.maxSpotlightAspectRatio, 4 / 3);
    });

    testWidgets('merges a local override over the global theme', (
      tester,
    ) async {
      late StreamCallParticipantsSpotlightThemeData resolved;

      await tester.pumpWidget(
        app(
          theme: themeWith(
            const StreamCallParticipantsSpotlightStyle(
              maxSpotlightAspectRatio: 4 / 3,
              barTileSize: Size(200, 120),
            ),
          ),
          home: StreamCallParticipantsSpotlightTheme(
            data: const StreamCallParticipantsSpotlightThemeData(
              style: StreamCallParticipantsSpotlightStyle(
                barTileSize: Size(240, 135),
              ),
            ),
            child: Builder(
              builder: (context) {
                resolved = StreamCallParticipantsSpotlightTheme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // The local value wins, and the global one it did not mention survives.
      expect(resolved.style?.barTileSize, const Size(240, 135));
      expect(resolved.style?.maxSpotlightAspectRatio, 4 / 3);
    });

    testWidgets('wrap carries the theme into another subtree', (tester) async {
      const data = StreamCallParticipantsSpotlightThemeData(
        style: StreamCallParticipantsSpotlightStyle(spacing: 24),
      );

      late StreamCallParticipantsSpotlightThemeData resolved;

      await tester.pumpWidget(
        app(
          theme: StreamVideoTheme.light(),
          home: Builder(
            builder: (context) =>
                const StreamCallParticipantsSpotlightTheme(
                  data: data,
                  child: SizedBox.shrink(),
                ).wrap(
                  context,
                  Builder(
                    builder: (context) {
                      resolved = StreamCallParticipantsSpotlightTheme.of(
                        context,
                      );
                      return const SizedBox.shrink();
                    },
                  ),
                ),
          ),
        ),
      );

      expect(resolved.style?.spacing, 24);
    });

    test('updateShouldNotify follows the data', () {
      const a = StreamCallParticipantsSpotlightTheme(
        data: StreamCallParticipantsSpotlightThemeData(
          style: StreamCallParticipantsSpotlightStyle(spacing: 24),
        ),
        child: SizedBox.shrink(),
      );
      const same = StreamCallParticipantsSpotlightTheme(
        data: StreamCallParticipantsSpotlightThemeData(
          style: StreamCallParticipantsSpotlightStyle(spacing: 24),
        ),
        child: SizedBox.shrink(),
      );
      const other = StreamCallParticipantsSpotlightTheme(
        data: StreamCallParticipantsSpotlightThemeData(),
        child: SizedBox.shrink(),
      );

      expect(a.updateShouldNotify(same), isFalse);
      expect(a.updateShouldNotify(other), isTrue);
    });

    test('lerp interpolates the style it carries', () {
      const a = StreamCallParticipantsSpotlightThemeData(
        style: StreamCallParticipantsSpotlightStyle(
          spacing: 0,
          compactBarTileSize: Size(100, 50),
        ),
      );
      const b = StreamCallParticipantsSpotlightThemeData(
        style: StreamCallParticipantsSpotlightStyle(
          spacing: 10,
          compactBarTileSize: Size(200, 150),
        ),
      );

      final mid = StreamCallParticipantsSpotlightThemeData.lerp(a, b, 0.5);

      expect(mid?.style?.spacing, 5);
      expect(mid?.style?.compactBarTileSize, const Size(150, 100));
    });
  });

  group('StreamVideoTheme', () {
    test('carries the spotlight theme through copyWith', () {
      final theme = themeWith(
        const StreamCallParticipantsSpotlightStyle(
          expandedBarTileSize: Size(320, 180),
        ),
      );

      expect(
        theme.callParticipantsSpotlightTheme.style?.expandedBarTileSize,
        const Size(320, 180),
      );
    });

    test('defaults the spotlight theme to an empty instance', () {
      expect(
        StreamVideoTheme.light().callParticipantsSpotlightTheme.style,
        isNull,
      );
    });

    test('lerp interpolates the spotlight theme', () {
      final a = themeWith(
        const StreamCallParticipantsSpotlightStyle(maxSpotlightAspectRatio: 1),
      );
      final b = themeWith(
        const StreamCallParticipantsSpotlightStyle(maxSpotlightAspectRatio: 2),
      );

      final mid = a.lerp(b, 0.5) as StreamVideoTheme;

      expect(
        mid.callParticipantsSpotlightTheme.style?.maxSpotlightAspectRatio,
        1.5,
      );
    });
  });
}
