import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/src/utils/display_fold.dart';

const _window = Size(951, 669);

DisplayFeature _feature(
  Rect bounds, {
  DisplayFeatureType type = DisplayFeatureType.fold,
  DisplayFeatureState state = DisplayFeatureState.postureHalfOpened,
}) => DisplayFeature(bounds: bounds, type: type, state: state);

Future<Rect?> _foldIn(
  WidgetTester tester,
  List<DisplayFeature> features,
) async {
  Rect? fold;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: _window, displayFeatures: features),
      child: Builder(
        builder: (context) {
          fold = verticalFoldOf(context);
          return const SizedBox();
        },
      ),
    ),
  );
  return fold;
}

void main() {
  group('verticalFoldOf', () {
    testWidgets('finds a half-open fold down the middle', (tester) async {
      const bounds = Rect.fromLTWH(475, 0, 0, 669);

      expect(await _foldIn(tester, [_feature(bounds)]), bounds);
    });

    testWidgets('finds a hinge with a width', (tester) async {
      const bounds = Rect.fromLTWH(465, 0, 20, 669);

      expect(
        await _foldIn(tester, [
          _feature(
            bounds,
            type: DisplayFeatureType.hinge,
            state: DisplayFeatureState.unknown,
          ),
        ]),
        bounds,
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

    testWidgets('ignores a fold across the window', (tester) async {
      expect(
        await _foldIn(tester, [_feature(const Rect.fromLTWH(0, 334, 951, 0))]),
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

  group('SplitAtFold', () {
    for (final direction in TextDirection.values) {
      testWidgets('keeps both sides off the fold in ${direction.name}', (
        tester,
      ) async {
        const fold = Rect.fromLTWH(475, 0, 0, 669);

        await tester.pumpWidget(
          Directionality(
            textDirection: direction,
            child: const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                // Off centre, so the halves of the box are not the halves of
                // the window.
                padding: EdgeInsets.only(left: 40, right: 100),
                child: SplitAtFold(
                  fold: fold,
                  gap: 16,
                  start: SizedBox(key: Key('start'), height: 50),
                  end: SizedBox(key: Key('end'), height: 50),
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
  });
}
