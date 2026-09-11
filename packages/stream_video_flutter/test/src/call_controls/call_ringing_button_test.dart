import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core_flutter/core.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../../test_utils/test_wrapper.dart';

void main() {
  const icons = StreamIcons();

  group('CallRingingButton', () {
    for (final tone in [CallControlTone.positive, CallControlTone.negative]) {
      // `positive` is the interesting one: CallControlButton repaints it
      // through a StreamButtonTheme of its own, and only the nearest such
      // theme is read — so a size handed down as an outer theme would be
      // dropped for this tone alone.
      testWidgets('${tone.name} is ${CallRingingButton.diameter}px across', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestWrapper(
            child: Center(
              child: CallRingingButton(
                icon: Icon(icons.phoneFill),
                tone: tone,
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(
          tester.getSize(find.byType(StreamButton)),
          const Size.square(CallRingingButton.diameter),
        );
        // The size reaches the icon through ButtonStyle.iconSize, so it is the
        // rendered box that shows it, not the Icon widget's own `size`.
        expect(
          tester.getSize(find.byType(Icon)),
          const Size.square(CallRingingButton.iconSize),
        );
      });
    }

    testWidgets('a label sits under the button, not beside it', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: Center(
            child: CallRingingButton(
              icon: Icon(icons.phoneDownFill),
              tone: .negative,
              label: 'Decline',
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.getRect(find.byType(StreamButton));
      final label = tester.getRect(find.text('Decline'));

      expect(label.top, greaterThanOrEqualTo(button.bottom));
      expect(label.center.dx, moreOrLessEquals(button.center.dx, epsilon: 0.5));
    });
  });

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'CallRingingButton paints the ringing pair',
      fileName: 'call_ringing_button',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          GoldenTestScenario(
            name: 'decline',
            child: CallRingingButton(
              icon: Icon(icons.phoneDownFill),
              tone: .negative,
              label: 'Decline',
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'accept',
            child: CallRingingButton(
              icon: Icon(icons.phoneFill),
              tone: .positive,
              label: 'Accept',
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'unlabelled',
            child: CallRingingButton(
              icon: Icon(icons.phoneDownFill),
              tone: .negative,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
