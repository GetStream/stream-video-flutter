import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

void main() {
  StreamVideoTheme themeWith(StreamParticipantTileStyle tileStyle) =>
      StreamVideoTheme.light().copyWith(
        pictureInPictureTheme: StreamPictureInPictureThemeData(
          style: StreamPictureInPictureStyle(tileStyle: tileStyle),
        ),
      );

  Widget app({required StreamVideoTheme theme, required Widget home}) =>
      MaterialApp(
        theme: streamTestTheme().copyWith(
          extensions: [StreamTheme.light(), theme],
        ),
        home: home,
      );

  group('StreamPictureInPictureTheme', () {
    testWidgets('resolves the global theme when no ancestor is present', (
      tester,
    ) async {
      late StreamPictureInPictureThemeData resolved;

      await tester.pumpWidget(
        app(
          theme: themeWith(
            const StreamParticipantTileStyle(showParticipantLabel: false),
          ),
          home: Builder(
            builder: (context) {
              resolved = StreamPictureInPictureTheme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved.style?.tileStyle?.showParticipantLabel, isFalse);
    });

    testWidgets('merges a local override over the global theme', (
      tester,
    ) async {
      late StreamPictureInPictureThemeData resolved;

      await tester.pumpWidget(
        app(
          theme: themeWith(
            const StreamParticipantTileStyle(
              showParticipantLabel: false,
              showMoreButton: false,
            ),
          ),
          home: StreamPictureInPictureTheme(
            data: const StreamPictureInPictureThemeData(
              style: StreamPictureInPictureStyle(
                tileStyle: StreamParticipantTileStyle(showMoreButton: true),
              ),
            ),
            child: Builder(
              builder: (context) {
                resolved = StreamPictureInPictureTheme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // The local value wins, and the global one it did not mention survives.
      expect(resolved.style?.tileStyle?.showMoreButton, isTrue);
      expect(resolved.style?.tileStyle?.showParticipantLabel, isFalse);
    });

    testWidgets('wrap carries the theme into another subtree', (tester) async {
      const data = StreamPictureInPictureThemeData(
        style: StreamPictureInPictureStyle(
          tileStyle: StreamParticipantTileStyle(showMoreButton: true),
        ),
      );

      late StreamPictureInPictureThemeData resolved;

      await tester.pumpWidget(
        app(
          theme: StreamVideoTheme.light(),
          home: Builder(
            builder: (context) =>
                const StreamPictureInPictureTheme(
                  data: data,
                  child: SizedBox.shrink(),
                ).wrap(
                  context,
                  Builder(
                    builder: (context) {
                      resolved = StreamPictureInPictureTheme.of(context);
                      return const SizedBox.shrink();
                    },
                  ),
                ),
          ),
        ),
      );

      expect(resolved.style?.tileStyle?.showMoreButton, isTrue);
    });

    test('updateShouldNotify follows the data', () {
      const a = StreamPictureInPictureTheme(
        data: StreamPictureInPictureThemeData(
          style: StreamPictureInPictureStyle(
            tileStyle: StreamParticipantTileStyle(showMoreButton: true),
          ),
        ),
        child: SizedBox.shrink(),
      );
      const same = StreamPictureInPictureTheme(
        data: StreamPictureInPictureThemeData(
          style: StreamPictureInPictureStyle(
            tileStyle: StreamParticipantTileStyle(showMoreButton: true),
          ),
        ),
        child: SizedBox.shrink(),
      );
      const other = StreamPictureInPictureTheme(
        data: StreamPictureInPictureThemeData(),
        child: SizedBox.shrink(),
      );

      expect(a.updateShouldNotify(same), isFalse);
      expect(a.updateShouldNotify(other), isTrue);
    });

    test('lerp interpolates the tile style it carries', () {
      const a = StreamPictureInPictureThemeData(
        style: StreamPictureInPictureStyle(
          tileStyle: StreamParticipantTileStyle(
            labelStyle: StreamParticipantLabelStyle(blurSigma: 0),
          ),
        ),
      );
      const b = StreamPictureInPictureThemeData(
        style: StreamPictureInPictureStyle(
          tileStyle: StreamParticipantTileStyle(
            labelStyle: StreamParticipantLabelStyle(blurSigma: 10),
          ),
        ),
      );

      final mid = StreamPictureInPictureThemeData.lerp(a, b, 0.5);

      expect(mid?.style?.tileStyle?.labelStyle?.blurSigma, 5);
    });
  });

  group('StreamVideoTheme', () {
    test('carries the picture-in-picture theme through copyWith', () {
      final theme = themeWith(
        const StreamParticipantTileStyle(showConnectionQualityIndicator: false),
      );

      expect(
        theme
            .pictureInPictureTheme
            .style
            ?.tileStyle
            ?.showConnectionQualityIndicator,
        isFalse,
      );
    });

    test('defaults the picture-in-picture theme to an empty instance', () {
      expect(StreamVideoTheme.light().pictureInPictureTheme.style, isNull);
    });

    test('lerp interpolates the picture-in-picture theme', () {
      final a = themeWith(
        const StreamParticipantTileStyle(
          labelStyle: StreamParticipantLabelStyle(blurSigma: 0),
        ),
      );
      final b = themeWith(
        const StreamParticipantTileStyle(
          labelStyle: StreamParticipantLabelStyle(blurSigma: 10),
        ),
      );

      final mid = a.lerp(b, 0.5) as StreamVideoTheme;

      expect(
        mid.pictureInPictureTheme.style?.tileStyle?.labelStyle?.blurSigma,
        5,
      );
    });
  });
}
