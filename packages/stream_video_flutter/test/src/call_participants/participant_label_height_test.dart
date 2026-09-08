import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

final _icons = StreamTheme.light().icons;

// The pill's height used to come from whatever was tallest inside it, which
// was the sound indicator — so a pill without one collapsed onto its text and
// lost the padding around it. Two things leave it without one: a style that
// switched it off, and a muted participant.
void main() {
  Future<Rect> pill(
    WidgetTester tester, {
    bool isAudioEnabled = true,
    bool showAudioIndicator = true,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        child: Align(
          alignment: Alignment.topLeft,
          child: StreamParticipantLabel(
            name: 'Rene Floor',
            isAudioEnabled: isAudioEnabled,
            isSpeaking: false,
            isVideoEnabled: true,
            style: StreamParticipantLabelStyle(
              // The blur is a no-op under flutter test, but skipping it keeps
              // the tree to what is being measured.
              blurSigma: 0,
              showAudioIndicator: showAudioIndicator,
            ),
          ),
        ),
      ),
    );

    return tester.getRect(find.byType(StreamParticipantLabel));
  }

  group('height', () {
    testWidgets('holds when the style switches the indicator off', (
      tester,
    ) async {
      final withIndicator = await pill(tester);
      final without = await pill(tester, showAudioIndicator: false);

      expect(without.height, withIndicator.height);
      // 24 for the indicator's box plus 4 above and below it.
      expect(without.height, 32);
    });

    testWidgets('holds when muting takes the indicator away', (tester) async {
      final unmuted = await pill(tester);
      final muted = await pill(tester, isAudioEnabled: false);

      expect(muted.height, unmuted.height);
      expect(muted.height, 32);
    });

    testWidgets('minHeight overrides that', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: Align(
            alignment: Alignment.topLeft,
            child: StreamParticipantLabel(
              name: 'Rene Floor',
              isAudioEnabled: true,
              isSpeaking: false,
              isVideoEnabled: true,
              style: const StreamParticipantLabelStyle(
                blurSigma: 0,
                showAudioIndicator: false,
                minHeight: 48,
              ),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(StreamParticipantLabel)).height, 48);
    });
  });

  // The indicator's box carries its own padding; whatever stands in for it does
  // not, so the pill has to inset that edge itself or crowd it.
  group('trailing inset', () {
    testWidgets('is 4 behind the indicator, whose box supplies the rest', (
      tester,
    ) async {
      final rect = await pill(tester);
      final indicator = tester.getRect(find.byType(StreamAudioIndicator));

      expect(rect.right - indicator.right, 4);
    });

    testWidgets('is 12 behind a muted icon, matching the leading inset', (
      tester,
    ) async {
      final rect = await pill(tester, isAudioEnabled: false);
      final icon = tester.getRect(find.byIcon(_icons.voiceOffFill));

      expect(rect.right - icon.right, 12);
    });

    testWidgets('is 12 behind a name the style left on its own', (
      tester,
    ) async {
      final rect = await pill(tester, showAudioIndicator: false);
      final name = tester.getRect(find.text('Rene Floor'));

      expect(rect.right - name.right, 12);
      expect(find.byType(StreamAudioIndicator), findsNothing);
    });
  });
}
