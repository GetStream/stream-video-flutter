import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/goldens.dart';
import '../../../test_utils/test_wrapper.dart';

void main() {
  testWidgets('StreamContextMenuHeading is not interactive', (tester) async {
    await tester.pumpWidget(
      const TestWrapper(
        child: StreamContextMenuHeading(label: Text('Microphone')),
      ),
    );

    // The heading shares the row metrics of a menu item, so it is easy to
    // mistake for one; nothing in it should respond to a press.
    expect(
      find.descendant(
        of: find.byType(StreamContextMenuHeading),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'StreamContextMenuHeading renders a tertiary label on a menu-item row',
      fileName: 'stream_context_menu_heading',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          GoldenTestScenario(
            name: 'heading',
            child: const StreamContextMenuHeading(label: Text('Microphone')),
          ),
        ],
      ),
    );
  }
}
