import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  // Process-wide, so it goes back to what it was for whatever runs next.
  late Duration updateInterval;

  setUp(() {
    updateInterval = VisibilityDetectorController.instance.updateInterval;
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval = updateInterval;
  });

  Widget buttonAt(Alignment alignment, MockCall call) => TestWrapper(
    child: Padding(
      // Clear of the bottom of the window, as a control bar over the home
      // indicator would be.
      padding: const EdgeInsets.only(bottom: 40),
      child: Align(
        alignment: alignment,
        child: StreamAddReactionButton(call: call),
      ),
    ),
  );

  Rect reactions(WidgetTester tester) => tester.getRect(
    find
        .descendant(
          of: find.byType(CompositedTransformFollower),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );

  testWidgets('the reactions open above the button and follow it', (
    tester,
  ) async {
    final call = MockCall();

    await tester.pumpWidget(buttonAt(Alignment.bottomRight, call));
    await tester.tap(find.byType(StreamAddReactionButton));
    await tester.pump();

    var button = tester.getRect(find.byType(StreamAddReactionButton));
    var rect = reactions(tester);
    expect(rect.bottom, button.top - 16);
    expect(rect.center.dx, closeTo(button.center.dx, 0.01));

    // The window changes under it, as it does when a foldable is folded.
    await tester.pumpWidget(buttonAt(Alignment.bottomLeft, call));
    await tester.pump();

    button = tester.getRect(find.byType(StreamAddReactionButton));
    rect = reactions(tester);
    expect(rect.bottom, button.top - 16);
    expect(rect.center.dx, closeTo(button.center.dx, 0.01));
  });
}
