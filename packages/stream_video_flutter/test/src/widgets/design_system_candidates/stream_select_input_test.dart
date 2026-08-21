import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  final colorScheme = StreamTheme.light().colorScheme;

  // The field reads its colors off StreamTheme, so pin the light theme rather
  // than relying on StreamTheme.of's brightness fallback.
  Widget wrap(Widget child) => MaterialApp(
    theme: ThemeData(
      extensions: <ThemeExtension<dynamic>>[StreamTheme.light()],
    ),
    home: Scaffold(
      body: Center(child: SizedBox(width: 256, child: child)),
    ),
  );

  BorderSide? sideOfWidth(WidgetTester tester, double width) {
    for (final box in tester.widgetList<DecoratedBox>(
      find.byType(DecoratedBox),
    )) {
      final decoration = box.decoration;
      if (decoration is! ShapeDecoration) continue;
      final shape = decoration.shape;
      if (shape is! RoundedSuperellipseBorder) continue;
      if (shape.side.width == width) return shape.side;
    }
    return null;
  }

  BorderSide? border(WidgetTester tester) => sideOfWidth(tester, 1);
  BorderSide? ring(WidgetTester tester) => sideOfWidth(tester, 2);

  testWidgets('default has the default border and no ring', (tester) async {
    await tester.pumpWidget(
      wrap(StreamSelectInput(hintText: 'Default', onPressed: () {})),
    );

    expect(border(tester)?.color, colorScheme.borderDefault);
    expect(ring(tester), isNull);
  });

  testWidgets('expanded uses the active border', (tester) async {
    await tester.pumpWidget(
      wrap(
        StreamSelectInput(value: 'Mic', expanded: true, onPressed: () {}),
      ),
    );

    expect(border(tester)?.color, colorScheme.borderActive);
  });

  testWidgets('error state uses the error border', (tester) async {
    await tester.pumpWidget(
      wrap(
        StreamSelectInput(
          value: 'Mic',
          helperState: StreamHelperState.error,
          onPressed: () {},
        ),
      ),
    );

    expect(border(tester)?.color, colorScheme.borderError);
  });

  testWidgets('disabled uses the disabled border and ignores taps', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const StreamSelectInput(hintText: 'Default')));

    expect(border(tester)?.color, colorScheme.borderDisabled);

    await tester.tap(find.byType(StreamSelectInput));
    await tester.pump();

    expect(ring(tester), isNull);
  });

  testWidgets('hover draws the hover ring', (tester) async {
    // Flutter suppresses hover/focus highlights while the last interaction was
    // a touch, which is what a widget test starts out as.
    tester.binding.focusManager.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() {
      tester.binding.focusManager.highlightStrategy =
          FocusHighlightStrategy.automatic;
    });

    var pressed = 0;
    await tester.pumpWidget(
      wrap(StreamSelectInput(hintText: 'Default', onPressed: () => pressed++)),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(gesture.removePointer);
    await gesture.addPointer(
      location: tester.getCenter(find.byType(StreamSelectInput)),
    );
    await tester.pumpAndSettle();

    expect(ring(tester)?.color, colorScheme.borderHover);
    expect(border(tester)?.color, colorScheme.borderDefault);

    await tester.tap(find.byType(StreamSelectInput));
    await tester.pump();
    expect(pressed, 1);
  });

  testWidgets('focus draws the focus ring and Enter activates', (tester) async {
    tester.binding.focusManager.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() {
      tester.binding.focusManager.highlightStrategy =
          FocusHighlightStrategy.automatic;
    });

    var pressed = 0;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      wrap(
        StreamSelectInput(
          hintText: 'Default',
          focusNode: focusNode,
          onPressed: () => pressed++,
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pumpAndSettle();

    expect(ring(tester)?.color, colorScheme.borderFocus);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(pressed, 1);
  });

  testWidgets('ghost has no base border until a state applies', (tester) async {
    await tester.pumpWidget(
      wrap(
        StreamSelectInput(
          type: StreamSelectInputType.ghost,
          hintText: 'Default',
          onPressed: () {},
        ),
      ),
    );

    expect(border(tester)?.color, Colors.transparent);
  });
}
