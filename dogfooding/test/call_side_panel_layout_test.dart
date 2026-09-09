import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/widgets/side_panel/call_side_panel_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Smaller than the 800x600 test surface, so the body is never clamped.
  const bodySize = Size(700, 500);

  const gridKey = ValueKey('grid');
  const panelKey = ValueKey('panel');

  /// A stand-in that fills whatever it is given, so the assertions below
  /// measure the layout rather than an intrinsic size.
  Widget filler(Key key) => SizedBox.expand(
    key: key,
    child: const ColoredBox(color: Color(0xFF000000)),
  );

  Widget wrap({
    required Animation<double> animation,
    required bool fullScreen,
    bool withPanel = true,
    double coveredTopExtent = 0,
  }) {
    return MaterialApp(
      home: Center(
        child: SizedBox.fromSize(
          size: bodySize,
          child: CallSidePanelLayout(
            animation: animation,
            fullScreen: fullScreen,
            coveredTopExtent: coveredTopExtent,
            panel: withPanel ? filler(panelKey) : null,
            child: filler(gridKey),
          ),
        ),
      ),
    );
  }

  Rect body(WidgetTester tester) =>
      tester.getRect(find.byType(CallSidePanelLayout));

  group('docked', () {
    testWidgets('an open panel takes its width from the grid', (tester) async {
      await tester.pumpWidget(
        wrap(animation: kAlwaysCompleteAnimation, fullScreen: false),
      );

      expect(tester.getSize(find.byKey(gridKey)).width, bodySize.width - 360);
      expect(tester.getSize(find.byKey(panelKey)).width, 360);
      // Stretched, not settled at an intrinsic height.
      expect(tester.getSize(find.byKey(panelKey)).height, bodySize.height);
    });

    testWidgets('a closed panel leaves the grid its full width', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(animation: kAlwaysDismissedAnimation, fullScreen: false),
      );

      expect(tester.getSize(find.byKey(gridKey)).width, bodySize.width);
    });

    testWidgets('the panel keeps its full width while clipped', (tester) async {
      final controller = AnimationController(
        vsync: tester,
        duration: const Duration(milliseconds: 250),
      )..value = 0.5;
      addTearDown(controller.dispose);

      await tester.pumpWidget(wrap(animation: controller, fullScreen: false));

      // Half the width is given up by the grid...
      expect(tester.getSize(find.byKey(gridKey)).width, bodySize.width - 180);
      // ...but the panel itself never reflows, it is only clipped.
      expect(tester.getSize(find.byKey(panelKey)).width, 360);
    });

    testWidgets('no panel means no divided width', (tester) async {
      await tester.pumpWidget(
        wrap(
          animation: kAlwaysCompleteAnimation,
          fullScreen: false,
          withPanel: false,
        ),
      );

      expect(tester.getSize(find.byKey(gridKey)).width, bodySize.width);
      expect(find.byKey(panelKey), findsNothing);
    });
  });

  group('full screen', () {
    testWidgets('an open panel covers the whole body', (tester) async {
      await tester.pumpWidget(
        wrap(animation: kAlwaysCompleteAnimation, fullScreen: true),
      );

      expect(tester.getRect(find.byKey(panelKey)), body(tester));
    });

    testWidgets('a closed panel waits off the trailing edge', (tester) async {
      await tester.pumpWidget(
        wrap(animation: kAlwaysDismissedAnimation, fullScreen: true),
      );

      expect(tester.getRect(find.byKey(panelKey)).left, body(tester).right);
    });

    testWidgets('the grid keeps the height the covered chrome gave up', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          animation: kAlwaysCompleteAnimation,
          fullScreen: true,
          coveredTopExtent: 56,
        ),
      );

      final grid = tester.getRect(find.byKey(gridKey));

      expect(grid.height, bodySize.height - 56);
      expect(grid.top - body(tester).top, 56);
      // The grid keeps its full width — nothing is docked beside it.
      expect(grid.width, bodySize.width);
    });
  });
}
