import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

final _icons = StreamTheme.light().icons;

void main() {
  Future<void> pumpLabel(
    WidgetTester tester, {
    String name = 'Rene Floor',
    bool isVideoEnabled = false,
    bool isAudioEnabled = true,
    StreamParticipantLabelStyle? style,
  }) => tester.pumpWidget(
    TestWrapper(
      // Unbounded, so the pill comes out the size it asks for rather than the
      // size of the surface.
      child: Align(
        alignment: Alignment.topLeft,
        child: StreamParticipantLabel(
          name: name,
          isAudioEnabled: isAudioEnabled,
          isSpeaking: false,
          isVideoEnabled: isVideoEnabled,
          style: const StreamParticipantLabelStyle(
            blurSigma: 0,
          ).merge(style),
        ),
      ),
    ),
  );

  group('StreamParticipantLabel', () {
    testWidgets('draws the camera-off icon while the camera is off', (
      tester,
    ) async {
      await pumpLabel(tester);

      expect(find.byIcon(_icons.videoOffFill), findsOneWidget);
    });

    testWidgets('leaves it out when the style switches it off', (tester) async {
      await pumpLabel(
        tester,
        style: const StreamParticipantLabelStyle(showVideoOffIcon: false),
      );

      expect(find.byIcon(_icons.videoOffFill), findsNothing);
      expect(find.text('Rene Floor'), findsOneWidget);
    });

    // A pill with nothing in it is a rounded rectangle of overlay sitting on
    // the video.
    testWidgets('draws nothing without a name or an indicator', (tester) async {
      await pumpLabel(
        tester,
        name: '',
        style: const StreamParticipantLabelStyle(
          showVideoOffIcon: false,
          showAudioIndicator: false,
        ),
      );

      expect(find.byType(DefaultStreamParticipantLabel), findsOneWidget);
      expect(tester.getSize(find.byType(StreamParticipantLabel)), Size.zero);
    });
  });
}
