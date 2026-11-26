import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

const _window = Size(951, 669);

DisplayFeature _feature(
  Rect bounds, {
  DisplayFeatureType type = DisplayFeatureType.fold,
  DisplayFeatureState state = DisplayFeatureState.postureHalfOpened,
}) => DisplayFeature(bounds: bounds, type: type, state: state);

Future<StreamDisplayFold?> _foldIn(
  WidgetTester tester,
  List<DisplayFeature> features, {
  StreamFoldPosture? posture,
}) async {
  StreamDisplayFold? fold;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: _window, displayFeatures: features),
      child: Builder(
        builder: (context) {
          fold = StreamDisplayFold.maybeOf(context, posture: posture);
          return const SizedBox();
        },
      ),
    ),
  );
  return fold;
}

/// Sets the test window to 800 x 600 with [fold] as its only feature.
void _foldWindow(WidgetTester tester, Rect fold) {
  tester.view.physicalSize = const Size(800, 600);
  tester.view.devicePixelRatio = 1;
  tester.view.displayFeatures = [_feature(fold)];
  addTearDown(tester.view.reset);
}

void main() {
  group('StreamDisplayFold.maybeOf', () {
    testWidgets('finds a half-open fold down the middle', (tester) async {
      const bounds = Rect.fromLTWH(475, 0, 0, 669);

      expect(
        await _foldIn(tester, [_feature(bounds)]),
        const StreamDisplayFold(
          bounds: bounds,
          posture: StreamFoldPosture.book,
        ),
      );
    });

    testWidgets('finds a half-open fold across the middle', (tester) async {
      const bounds = Rect.fromLTWH(0, 334, 951, 0);

      final fold = await _foldIn(tester, [_feature(bounds)]);

      expect(fold?.posture, StreamFoldPosture.tabletop);
      expect(fold?.axis, Axis.vertical);
      expect(fold?.span, (334.0, 334.0));
    });

    testWidgets('finds a hinge with a width', (tester) async {
      const bounds = Rect.fromLTWH(465, 0, 20, 669);

      final fold = await _foldIn(tester, [
        _feature(
          bounds,
          type: DisplayFeatureType.hinge,
          state: DisplayFeatureState.unknown,
        ),
      ]);

      expect(fold?.bounds, bounds);
      expect(fold?.extent, 20);
    });

    testWidgets('filters by posture', (tester) async {
      expect(
        await _foldIn(
          tester,
          [_feature(const Rect.fromLTWH(0, 334, 951, 0))],
          posture: StreamFoldPosture.book,
        ),
        isNull,
      );
    });

    testWidgets('ignores a flat fold', (tester) async {
      expect(
        await _foldIn(tester, [
          _feature(
            const Rect.fromLTWH(475, 0, 0, 669),
            state: DisplayFeatureState.postureFlat,
          ),
        ]),
        isNull,
      );
    });

    testWidgets('ignores a cutout', (tester) async {
      expect(
        await _foldIn(tester, [
          _feature(
            const Rect.fromLTWH(400, 0, 150, 30),
            type: DisplayFeatureType.cutout,
            state: DisplayFeatureState.unknown,
          ),
        ]),
        isNull,
      );
    });
  });

  group('StreamLocalFold.clearance', () {
    const fold = StreamDisplayFold(
      bounds: Rect.fromLTWH(400, 0, 0, 600),
      posture: StreamFoldPosture.book,
    );

    test('centres the gap on a fold with no width', () {
      const local = StreamLocalFold(
        fold: fold,
        size: Size(800, 600),
        start: 400,
        end: 400,
      );

      expect(local.clearance(8), (396.0, 404.0));
    });

    test('centres a gutter on a hinge, ignoring its width', () {
      const local = StreamLocalFold(
        fold: fold,
        size: Size(800, 600),
        start: 390,
        end: 410,
      );

      expect(local.gutter(8), (396.0, 404.0));
    });

    test('keeps out of a hinge wider than the gap', () {
      const local = StreamLocalFold(
        fold: fold,
        size: Size(800, 600),
        start: 390,
        end: 410,
      );

      expect(local.clearance(8), (390.0, 410.0));
    });
  });

  group('SplitAtFold', () {
    for (final direction in TextDirection.values) {
      testWidgets('keeps both sides off a book fold in ${direction.name}', (
        tester,
      ) async {
        _foldWindow(tester, const Rect.fromLTWH(475, 0, 0, 600));

        await tester.pumpWidget(
          Directionality(
            textDirection: direction,
            child: const Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 50,
                child: Padding(
                  // Off centre, so the halves of the box are not the halves of
                  // the window.
                  padding: EdgeInsets.only(left: 40, right: 100),
                  child: SplitAtFold(
                    gap: 32,
                    start: SizedBox(key: Key('start')),
                    end: SizedBox(key: Key('end')),
                  ),
                ),
              ),
            ),
          ),
        );
        // The first frame measures where the fold falls; the next lays out
        // around it.
        await tester.pump();

        final start = tester.getRect(find.byKey(const Key('start')));
        final end = tester.getRect(find.byKey(const Key('end')));
        final (left, right) = direction == TextDirection.ltr
            ? (start, end)
            : (end, start);

        expect(left.left, 40);
        expect(left.right, 475 - 16);
        expect(right.left, 475 + 16);
        expect(right.right, 800 - 100);
      });
    }

    testWidgets('splits a column at a tabletop fold', (tester) async {
      _foldWindow(tester, const Rect.fromLTWH(0, 280, 800, 0));

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: SplitAtFold(
            posture: StreamFoldPosture.tabletop,
            gap: 8,
            start: SizedBox(key: Key('start')),
            end: SizedBox(key: Key('end')),
          ),
        ),
      );
      await tester.pump();

      final start = tester.getRect(find.byKey(const Key('start')));
      final end = tester.getRect(find.byKey(const Key('end')));

      expect(start.top, 0);
      expect(start.bottom, 276);
      expect(end.top, 284);
      expect(end.bottom, 600);
    });

    testWidgets('keeps its children through the measurement', (tester) async {
      _foldWindow(tester, const Rect.fromLTWH(475, 0, 0, 600));

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: SplitAtFold(
            gap: 32,
            start: _Counter(key: Key('start')),
            end: SizedBox(),
          ),
        ),
      );
      final state = tester.state(find.byKey(const Key('start')));

      // The second frame lays out around the measured fold.
      await tester.pump();

      expect(tester.state(find.byKey(const Key('start'))), same(state));
      expect(tester.getRect(find.byKey(const Key('start'))).right, 475 - 16);
    });

    testWidgets('splits evenly when the fold is outside it', (tester) async {
      _foldWindow(tester, const Rect.fromLTWH(600, 0, 0, 600));

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              height: 50,
              child: SplitAtFold(
                gap: 32,
                start: SizedBox(key: Key('start')),
                end: SizedBox(key: Key('end')),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.getRect(find.byKey(const Key('start'))).width, 184);
      expect(tester.getRect(find.byKey(const Key('end'))).width, 184);
    });
  });

  group('StreamFoldBuilder', () {
    testWidgets('is pending only until the first measurement', (tester) async {
      _foldWindow(tester, const Rect.fromLTWH(400, 0, 0, 600));
      final measurements = <StreamFoldMeasurement>[];

      await tester.pumpWidget(
        StreamFoldBuilder(
          builder: (context, measurement) {
            measurements.add(measurement);
            return const SizedBox();
          },
        ),
      );
      await tester.pump();

      expect(measurements.first.pending, isTrue);
      expect(measurements.last.pending, isFalse);
      expect(measurements.last.local?.center, 400);
    });

    testWidgets('is never pending without a fold', (tester) async {
      final measurements = <StreamFoldMeasurement>[];

      await tester.pumpWidget(
        StreamFoldBuilder(
          builder: (context, measurement) {
            measurements.add(measurement);
            return const SizedBox();
          },
        ),
      );

      expect(measurements.single.pending, isFalse);
      expect(measurements.single.window, isNull);
    });
  });
}

class _Counter extends StatefulWidget {
  const _Counter({super.key});

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  @override
  Widget build(BuildContext context) => const SizedBox();
}
