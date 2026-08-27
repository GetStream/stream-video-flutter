import 'package:alchemist/alchemist.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/goldens.dart';
import '../../../test_utils/test_wrapper.dart';

void main() {
  final colorScheme = StreamTheme.light().colorScheme;

  // The field reads its colors off StreamTheme, and TestWrapper installs the
  // light one, rather than relying on StreamTheme.of's brightness fallback.
  Widget wrap(Widget child) => TestWrapper(
    child: Center(child: SizedBox(width: 256, child: child)),
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

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      "StreamSelectInput renders the design's type by state matrix",
      fileName: 'stream_select_input',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 2,
        scenarioConstraints: const BoxConstraints.tightFor(width: 220),
        children: [
          GoldenTestScenario(
            name: 'placeholder',
            child: StreamSelectInput(hintText: 'Default', onPressed: () {}),
          ),
          GoldenTestScenario(
            name: 'value with leading icon',
            child: Builder(
              builder: (context) => StreamSelectInput(
                leading: Icon(context.streamIcons.voiceFill),
                value: 'MacBook Pro Microphone',
                onPressed: () {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'label',
            child: StreamSelectInput(
              labelText: 'Microphone',
              value: 'Jabra Evolve2 65',
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'expanded',
            child: StreamSelectInput(
              value: 'Jabra Evolve2 65',
              expanded: true,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'error with helper text',
            child: StreamSelectInput(
              value: 'Jabra Evolve2 65',
              helperText: 'This device is no longer available',
              helperState: StreamHelperState.error,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'disabled',
            child: const StreamSelectInput(hintText: 'Default'),
          ),
          GoldenTestScenario(
            name: 'ghost',
            child: StreamSelectInput(
              type: StreamSelectInputType.ghost,
              value: 'Jabra Evolve2 65',
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'overflowing value',
            child: StreamSelectInput(
              value: 'Studio Display Microphone (Conference Room, 4th floor)',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );

    streamGoldenTest(
      // Hover draws the same ring in a different color, so this covers the
      // geometry of both: 2px, painted 1px outside the field.
      'StreamSelectInput draws the focus ring outside the field',
      fileName: 'stream_select_input_focused',
      brightness: brightness,
      constraints: const BoxConstraints.tightFor(width: 260, height: 80),
      // Tab both focuses the field and switches the focus highlight strategy
      // to the traditional one, which is what makes the ring visible — Flutter
      // suppresses it while the last interaction was a touch, as it is in a
      // freshly pumped widget test.
      pumpBeforeTest: (tester) async {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
      },
      builder: () => Center(
        child: SizedBox(
          width: 220,
          child: StreamSelectInput(value: 'Jabra Evolve2 65', onPressed: () {}),
        ),
      ),
    );
  }
}
