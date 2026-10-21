import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  group('StreamScreenSize.fromWidth', () {
    test('buckets widths by breakpoint', () {
      expect(StreamScreenSize.fromWidth(0), StreamScreenSize.small);
      expect(StreamScreenSize.fromWidth(375), StreamScreenSize.small);
      expect(StreamScreenSize.fromWidth(900), StreamScreenSize.medium);
      expect(StreamScreenSize.fromWidth(1440), StreamScreenSize.large);
    });

    test('treats each breakpoint as the first width of the larger bucket', () {
      expect(StreamScreenSize.fromWidth(767.9), StreamScreenSize.small);
      expect(StreamScreenSize.fromWidth(768), StreamScreenSize.medium);
      expect(StreamScreenSize.fromWidth(1279.9), StreamScreenSize.medium);
      expect(StreamScreenSize.fromWidth(1280), StreamScreenSize.large);
    });
  });

  group('StreamScreenSize.fromSize', () {
    test('is small below the height breakpoint, whatever the width', () {
      expect(
        StreamScreenSize.fromSize(const Size(1440, 599.9)),
        StreamScreenSize.small,
      );
      expect(
        StreamScreenSize.fromSize(const Size(1440, 600)),
        StreamScreenSize.large,
      );
    });

    test('buckets a tall enough window by its width', () {
      expect(
        StreamScreenSize.fromSize(const Size(767.9, 900)),
        StreamScreenSize.small,
      );
      expect(
        StreamScreenSize.fromSize(const Size(768, 900)),
        StreamScreenSize.medium,
      );
      expect(
        StreamScreenSize.fromSize(const Size(1280, 900)),
        StreamScreenSize.large,
      );
    });

    test('buckets the poses of a foldable phone', () {
      // Outer display, portrait and landscape.
      expect(
        StreamScreenSize.fromSize(const Size(466, 678)),
        StreamScreenSize.small,
      );
      expect(
        StreamScreenSize.fromSize(const Size(678, 466)),
        StreamScreenSize.small,
      );
      // Inner display, portrait and landscape.
      expect(
        StreamScreenSize.fromSize(const Size(669, 951)),
        StreamScreenSize.small,
      );
      expect(
        StreamScreenSize.fromSize(const Size(951, 669)),
        StreamScreenSize.medium,
      );
      // Half of the inner display in Split View.
      expect(
        StreamScreenSize.fromSize(const Size(475, 669)),
        StreamScreenSize.small,
      );
    });

    test('puts a phone in landscape in small', () {
      expect(
        StreamScreenSize.fromSize(const Size(932, 430)),
        StreamScreenSize.small,
      );
    });
  });

  testWidgets('context.streamScreenSize reads the window, not the widget', (
    tester,
  ) async {
    late StreamScreenSize size;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(1440, 900)),
        // A narrow box inside a wide window still reports `large`: the
        // breakpoint describes the room the app has, not the room this
        // particular widget was given.
        child: SizedBox(
          width: 320,
          child: Builder(
            builder: (context) {
              size = context.streamScreenSize;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(size, StreamScreenSize.large);
    expect(size.isLarge, isTrue);
    expect(size.isSmall, isFalse);
  });
}
