import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/src/widgets/floating_view/floating_view_alignment.dart';
import 'package:stream_video_flutter/src/widgets/floating_view/floating_view_container.dart';

const _floatingKey = Key('floating');

// A rail along the right edge, as on a foldable's outer display, and a cutout
// along the top.
const _safeArea = EdgeInsets.only(top: 20, right: 84);

Future<void> _pump(
  WidgetTester tester, {
  required bool snapping,
  required FloatingViewAlignment alignment,
}) => tester.pumpWidget(
  MediaQuery(
    data: const MediaQueryData(size: Size(800, 600), padding: _safeArea),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: FloatingViewContainer(
        enableSnappingBehavior: snapping,
        floatingViewWidth: 100,
        floatingViewHeight: 150,
        floatingViewAlignment: alignment,
        floatingView: const SizedBox(
          key: _floatingKey,
          width: 100,
          height: 150,
          child: ColoredBox(color: Color(0xFF000000)),
        ),
        child: const SizedBox.expand(),
      ),
    ),
  ),
);

void main() {
  for (final snapping in [true, false]) {
    group(snapping ? 'snapping' : 'simple', () {
      testWidgets('the top right corner clears the insets', (tester) async {
        await _pump(
          tester,
          snapping: snapping,
          alignment: FloatingViewAlignment.topRight,
        );

        final rect = tester.getRect(find.byKey(_floatingKey));
        expect(rect.top, 20 + 16);
        expect(rect.right, 800 - 84 - 16);
      });

      testWidgets('an edge without an inset keeps the plain padding', (
        tester,
      ) async {
        await _pump(
          tester,
          snapping: snapping,
          alignment: FloatingViewAlignment.bottomLeft,
        );

        final rect = tester.getRect(find.byKey(_floatingKey));
        expect(rect.left, 16);
        expect(rect.bottom, 600 - 16);
      });
    });
  }

  testWidgets('a drag past the inset stops at it', (tester) async {
    await _pump(
      tester,
      snapping: false,
      alignment: FloatingViewAlignment.topLeft,
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(_floatingKey)),
    );
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(100, -100));
      await tester.pump();
    }
    await gesture.up();
    await tester.pump();

    final rect = tester.getRect(find.byKey(_floatingKey));
    expect(rect.right, 800 - 84 - 16);
    expect(rect.top, 20 + 16);
  });
}
