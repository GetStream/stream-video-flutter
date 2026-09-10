import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

void main() {
  const small = CallControlBarLayout(leading: [Text('small')]);
  const medium = CallControlBarLayout(leading: [Text('medium')]);
  const large = CallControlBarLayout(leading: [Text('large')]);

  /// Pumps [bar] in a window [width] wide, which is what picks its layout.
  ///
  /// [width] is required rather than defaulted: every case here turns on which
  /// breakpoint it lands in, so none of them should have to be inferred.
  Future<void> pumpBar(
    WidgetTester tester,
    CallControlBar bar, {
    required double width,
  }) async {
    tester.view
      ..devicePixelRatio = 1.0
      ..physicalSize = Size(width, 800);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TestWrapper(
        child: Align(alignment: Alignment.bottomCenter, child: bar),
      ),
    );
  }

  group('layoutFor', () {
    test('falls back to the next smaller layout that was given', () {
      const bar = CallControlBar(small: small, medium: medium, large: large);

      expect(bar.layoutFor(StreamScreenSize.small), small);
      expect(bar.layoutFor(StreamScreenSize.medium), medium);
      expect(bar.layoutFor(StreamScreenSize.large), large);
    });

    test('a missing medium does not stop large being used', () {
      // The case the API exists for: an app that draws a phone bar up to the
      // desktop breakpoint, and a wide bar past it.
      const bar = CallControlBar(small: small, large: large);

      expect(bar.layoutFor(StreamScreenSize.medium), small);
      expect(bar.layoutFor(StreamScreenSize.large), large);
    });

    test('large falls back through medium, not straight to small', () {
      const bar = CallControlBar(small: small, medium: medium);

      expect(bar.layoutFor(StreamScreenSize.large), medium);
    });

    // `layoutFor` being right is only half of it: the bar has to ask it with
    // the window's own size. Hard-coding one there leaves every case above
    // green and only shifts the goldens.
    testWidgets('the bar draws the layout for the window it is in', (
      tester,
    ) async {
      const bar = CallControlBar(small: small, medium: medium, large: large);

      for (final (width, expected) in const [
        (402.0, 'small'),
        (900.0, 'medium'),
        (1440.0, 'large'),
      ]) {
        await pumpBar(tester, bar, width: width);

        expect(find.text(expected), findsOneWidget, reason: 'at $width');
      }
    });

    testWidgets('a window with no layout of its own falls back on screen', (
      tester,
    ) async {
      const bar = CallControlBar(small: small, large: large);

      await pumpBar(tester, bar, width: 900);

      expect(find.text('small'), findsOneWidget);
      expect(find.text('large'), findsNothing);
    });
  });

  group('geometry', () {
    // One height and one padding at every size: a bar that changed either
    // across a breakpoint jumped as a desktop window was dragged over it.
    testWidgets('is 72 tall at every breakpoint', (tester) async {
      const bar = CallControlBar(small: small);

      await tester.pumpBarAndExpectHeight(bar, width: 402, height: 72);
      await tester.pumpBarAndExpectHeight(bar, width: 900, height: 72);
      await tester.pumpBarAndExpectHeight(bar, width: 1440, height: 72);
    });

    testWidgets('heightOf agrees with what the bar renders', (tester) async {
      late double reported;

      tester.view
        ..devicePixelRatio = 1.0
        ..physicalSize = const Size(1440, 800);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        TestWrapper(
          child: Builder(
            builder: (context) {
              reported = CallControlBar.heightOf(context);
              return const Align(
                alignment: Alignment.bottomCenter,
                child: CallControlBar(small: small),
              );
            },
          ),
        ),
      );

      expect(reported, tester.getSize(find.byType(CallControlBar)).height);
    });

    // The case the assertion above cannot fail on: with no bottom inset the
    // safe area is zero either way, so `heightOf` agreed with the bar whether
    // or not it accounted for one.
    group('over a bottom inset', () {
      const inset = 34.0;

      Future<double> pumpAndReport(
        WidgetTester tester, {
        required bool primary,
      }) async {
        late double reported;

        tester.view
          ..devicePixelRatio = 1.0
          ..physicalSize = const Size(402, 800)
          ..padding = const FakeViewPadding(bottom: inset);
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          TestWrapper(
            child: Builder(
              builder: (context) {
                reported = CallControlBar.heightOf(context, primary: primary);
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: CallControlBar(small: small, primary: primary),
                );
              },
            ),
          ),
        );

        return reported;
      }

      testWidgets('a primary bar clears the inset and says so', (tester) async {
        final reported = await pumpAndReport(tester, primary: true);

        expect(tester.getSize(find.byType(CallControlBar)).height, 72 + inset);
        expect(reported, 72 + inset);
      });

      // Something below it has already taken the inset, so taking it again
      // would pad the bar twice.
      testWidgets('a non-primary bar takes no inset', (tester) async {
        final reported = await pumpAndReport(tester, primary: false);

        expect(tester.getSize(find.byType(CallControlBar)).height, 72);
        expect(reported, 72);
      });
    });

    testWidgets('pads its edges by 12 at every breakpoint', (tester) async {
      const bar = CallControlBar(
        small: CallControlBarLayout(leading: [Text('leading')]),
      );

      for (final width in [402.0, 900.0, 1440.0]) {
        await pumpBar(tester, bar, width: width);

        expect(
          tester.getTopLeft(find.text('leading')).dx -
              tester.getTopLeft(find.byType(CallControlBar)).dx,
          12,
          reason: 'at $width',
        );
      }
    });

    // What the design specifies is the visible inset, not the padding: a
    // control is 40 wide inside a 48 tap target, so the box starts 12 in and
    // the glyph 16.
    testWidgets('puts the visible edge of a control 16 in', (tester) async {
      await pumpBar(
        tester,
        const CallControlBar(
          small: CallControlBarLayout(
            leading: [CallControlButton(icon: Icon(Icons.mic))],
          ),
        ),
        width: 402,
      );

      final button = tester.getRect(find.byType(CallControlButton));
      final bar = tester.getRect(find.byType(CallControlBar));

      // The tap target's box, then the visible circle inside it.
      expect(button.left - bar.left, 12);
      expect(button.width, 48);
      expect(button.height, 48);
      // 72 tall, slots centred: (72 - 48) / 2.
      expect(button.top - bar.top, 12);
    });

    testWidgets('centres the centre slot however lopsided the sides are', (
      tester,
    ) async {
      // The requirement the bar exists for: four controls on one side and none
      // on the other still leaves the centre row in the middle of the bar,
      // rather than in the middle of what is left of it.
      await pumpBar(
        tester,
        const CallControlBar(
          small: CallControlBarLayout(
            leading: [
              SizedBox.square(dimension: 48),
              SizedBox.square(dimension: 48),
              SizedBox.square(dimension: 48),
              SizedBox.square(dimension: 48),
            ],
            center: [SizedBox.square(dimension: 48, key: Key('center'))],
          ),
        ),
        width: 1440,
      );

      expect(
        tester.getCenter(find.byKey(const Key('center'))).dx,
        tester.getCenter(find.byType(CallControlBar)).dx,
      );
    });

    testWidgets('an empty slot reserves no room', (tester) async {
      // An empty leading is not drawn at all, so it cannot be the wider side
      // the centre reserves space against.
      await pumpBar(
        tester,
        const CallControlBar(
          small: CallControlBarLayout(
            center: [SizedBox(width: 1200, height: 48, key: Key('center'))],
          ),
        ),
        width: 1440,
      );

      expect(tester.getSize(find.byKey(const Key('center'))).width, 1200);
      expect(tester.takeException(), isNull);
    });

    testWidgets('fits a phone-sized bar on a 375pt window', (tester) async {
      await pumpBar(
        tester,
        const CallControlBar(
          small: CallControlBarLayout(
            leading: [
              SizedBox.square(dimension: 48),
              SizedBox.square(dimension: 48),
              SizedBox.square(dimension: 48),
              SizedBox.square(dimension: 48),
            ],
            trailing: [
              SizedBox.square(dimension: 48),
              SizedBox.square(dimension: 48),
            ],
          ),
        ),
        width: 375,
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('surface', () {
    Iterable<BoxDecoration> decorations(WidgetTester tester) => tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(CallControlBar),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((it) => it.decoration)
        .whereType<BoxDecoration>();

    testWidgets('docked paints a flat fill and no separator', (tester) async {
      // No line along the top edge, unlike core's bars: a call has nothing to
      // separate the controls from, and the design draws none.
      await pumpBar(tester, const CallControlBar(small: small), width: 402);

      expect(
        decorations(tester),
        contains(
          isA<BoxDecoration>()
              .having((it) => it.color, 'color', isNotNull)
              .having((it) => it.gradient, 'gradient', isNull),
        ),
      );
      expect(
        decorations(tester).map((it) => it.border),
        everyElement(isNull),
      );
    });

    testWidgets('floating swaps the fill for a fade', (tester) async {
      await pumpBar(
        tester,
        const CallControlBar(
          small: small,
          style: CallControlBarStyle(surfaceStyle: StreamSurfaceStyle.floating),
        ),
        width: 402,
      );

      expect(
        decorations(tester),
        contains(
          isA<BoxDecoration>()
              .having((it) => it.gradient, 'gradient', isNotNull)
              .having((it) => it.color, 'color', isNull),
        ),
      );
    });

    testWidgets('publishes its resolved surface to the slots', (tester) async {
      late StreamSurfaceStyle scoped;

      await pumpBar(
        tester,
        CallControlBar(
          small: CallControlBarLayout(
            leading: [
              Builder(
                builder: (context) {
                  scoped = StreamToolbarScope.of(context);
                  return const SizedBox.square(dimension: 48);
                },
              ),
            ],
          ),
          style: const CallControlBarStyle(
            surfaceStyle: StreamSurfaceStyle.floating,
          ),
        ),
        width: 402,
      );

      expect(scoped, StreamSurfaceStyle.floating);
    });
  });

  testWidgets('a subtree theme overrides the global one field by field', (
    tester,
  ) async {
    tester.view
      ..devicePixelRatio = 1.0
      ..physicalSize = const Size(402, 800);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const TestWrapper(
        child: CallControlBarTheme(
          data: CallControlBarThemeData(
            style: CallControlBarStyle(height: 96),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CallControlBar(small: small),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(CallControlBar)).height, 96);
  });
}

extension on WidgetTester {
  Future<void> pumpBarAndExpectHeight(
    CallControlBar bar, {
    required double width,
    required double height,
  }) async {
    view
      ..devicePixelRatio = 1.0
      ..physicalSize = Size(width, 800);
    addTearDown(view.reset);

    await pumpWidget(
      TestWrapper(
        child: Align(alignment: Alignment.bottomCenter, child: bar),
      ),
    );

    expect(getSize(find.byType(CallControlBar)).height, height);
  }
}
