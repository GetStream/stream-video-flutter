import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(SfuTrackType.video);
    registerFallbackValue(ViewportVisibility.visible);
  });

  // Process-wide, so it goes back to what it was for whatever runs next.
  late Duration updateInterval;

  setUp(() {
    updateInterval = VisibilityDetectorController.instance.updateInterval;
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval = updateInterval;
  });

  final participant = CallParticipantState(
    name: 'alice',
    userId: 'alice',
    sessionId: 'alice-session',
    custom: const {},
    roles: const [],
    trackIdPrefix: 'alice',
    isLocal: true,
  );

  testWidgets(
    'the default local participant fills the view instead of letterboxing',
    (tester) async {
      final call = MockCall();
      when(
        () => call.updateViewportVisibility(
          sessionId: any(named: 'sessionId'),
          userId: any(named: 'userId'),
          visibility: any(named: 'visibility'),
          trackType: any(named: 'trackType'),
        ),
      ).thenAnswer((_) async => const Result.success(none));

      await tester.pumpWidget(
        TestWrapper(
          child: StreamLocalVideo(
            call: call,
            participant: participant,
            child: const SizedBox.expand(),
          ),
        ),
      );

      final callParticipant = tester.widget<StreamCallParticipant>(
        find.byType(StreamCallParticipant),
      );
      expect(callParticipant.videoFit, VideoFit.cover);
    },
  );
}
