import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../../test_utils/test_wrapper.dart';

void main() {
  const icons = StreamIcons();

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'CallFeatureButton takes its tone when selected',
      fileName: 'call_feature_button',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: 'unselected',
            child: CallFeatureButton(
              icon: Icon(icons.presentDesktopFill),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'selected',
            child: CallFeatureButton(
              icon: Icon(icons.presentDesktopFill),
              selected: true,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'unselected disabled',
            child: CallFeatureButton(icon: Icon(icons.captionFill)),
          ),
          GoldenTestScenario(
            name: 'selected disabled',
            child: CallFeatureButton(
              icon: Icon(icons.captionFill),
              selected: true,
            ),
          ),
          GoldenTestScenario(
            name: 'error badge',
            child: CallFeatureButton(
              icon: Icon(icons.recordingFill),
              badge: const CallControlErrorBadge(),
              onPressed: () {},
            ),
          ),
          // Recording: on is red rather than accent, because it is capturing
          // the call rather than merely running.
          GoldenTestScenario(
            name: 'destructive unselected',
            child: CallFeatureButton(
              icon: Icon(icons.recordingFill),
              tone: .destructive,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'destructive selected',
            child: CallFeatureButton(
              icon: Icon(icons.recordingStopFill),
              selected: true,
              tone: .destructive,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // The palette is StreamButton's, so the tone is asserted through the style
  // it resolves to rather than by sampling pixels the goldens already cover.
  group('style', () {
    Future<StreamButton> pump(
      WidgetTester tester, {
      required bool selected,
      required CallFeatureTone tone,
    }) async {
      await tester.pumpWidget(
        TestWrapper(
          child: CallFeatureButton(
            icon: Icon(icons.recordingFill),
            selected: selected,
            tone: tone,
            onPressed: () {},
          ),
        ),
      );

      return tester.widget<StreamButton>(find.byType(StreamButton));
    }

    testWidgets('accent selected is primary', (tester) async {
      final button = await pump(tester, selected: true, tone: .accent);

      expect(button.props.style, StreamButtonStyle.primary);
    });

    testWidgets('destructive selected is destructive', (tester) async {
      final button = await pump(tester, selected: true, tone: .destructive);

      expect(button.props.style, StreamButtonStyle.destructive);
    });

    testWidgets('selected marks the button selected', (tester) async {
      for (final tone in CallFeatureTone.values) {
        final selected = await pump(tester, selected: true, tone: tone);
        expect(selected.props.isSelected, isTrue, reason: 'tone $tone');

        final unselected = await pump(tester, selected: false, tone: tone);
        expect(unselected.props.isSelected, isFalse, reason: 'tone $tone');
      }
    });

    testWidgets('selected is announced as selected', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, selected: true, tone: .accent);

      expect(
        tester.getSemantics(find.byType(StreamButton)),
        matchesSemantics(
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
          hasSelectedState: true,
          isSelected: true,
        ),
      );
      handle.dispose();
    });

    // An unselected feature is the same grey whatever its tone, so a row of
    // them reads as one row until something is switched on.
    testWidgets('unselected is secondary whatever the tone', (tester) async {
      for (final tone in CallFeatureTone.values) {
        final button = await pump(tester, selected: false, tone: tone);

        expect(
          button.props.style,
          StreamButtonStyle.secondary,
          reason: 'tone $tone',
        );
      }
    });
  });
}
