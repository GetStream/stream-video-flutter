import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

// The order the tiles are drawn in is the order this widget last drew them in,
// re-sorted — which is what makes "a tile on screen stays where it is" mean
// anything. These drive the participants through the call state the widget
// listens to, and read the order back off the tiles.

void main() {
  setUpAll(() {
    registerFallbackValue(ViewportVisibility.unknown);
    registerFallbackValue(SfuTrackType.video);
  });

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  CallParticipantState participant(
    String id, {
    bool speaking = false,
    bool onScreen = true,
  }) {
    return CallParticipantState(
      name: id,
      userId: id,
      sessionId: id,
      custom: const {},
      roles: const [],
      trackIdPrefix: id,
      // Nothing published, so the tiles draw their placeholder and no track
      // subscription is negotiated: this is about the order they come in.
      isDominantSpeaker: speaking,
      isSpeaking: speaking,
      viewportVisibility: onScreen
          ? ViewportVisibility.visible
          : ViewportVisibility.hidden,
    );
  }

  // Every tile in a widget test is laid out on screen and reports as much, so
  // the reports go nowhere: what each participant's viewport visibility is
  // stays the test's to say.
  MockCall mockCall() {
    final call = MockCall();
    final state = MockCallState();

    when(() => state.callParticipants).thenReturn(const []);
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(state, sync: true),
    );
    when(
      () => call.updateViewportVisibility(
        sessionId: any(named: 'sessionId'),
        userId: any(named: 'userId'),
        visibility: any(named: 'visibility'),
        trackType: any(named: 'trackType'),
      ),
    ).thenAnswer((_) async => const Result.success(none));

    return call;
  }

  Future<void> pumpCall(
    WidgetTester tester,
    Call call,
    List<CallParticipantState> participants,
  ) async {
    await tester.pumpWidget(
      TestWrapper(
        child: SizedBox(
          width: 900,
          height: 600,
          child: StreamCallParticipants(call: call, participants: participants),
        ),
      ),
    );
    await tester.pump();
  }

  List<String> order(WidgetTester tester) {
    return tester
        .widgetList<DefaultStreamParticipantTile>(
          find.byType(DefaultStreamParticipantTile),
        )
        .map((it) => it.props.participant.userId)
        .toList();
  }

  testWidgets('a tile on screen does not move when its participant speaks', (
    tester,
  ) async {
    final call = mockCall();

    await pumpCall(tester, call, [
      participant('a'),
      participant('b'),
      participant('c'),
      participant('d'),
    ]);
    expect(order(tester), ['a', 'b', 'c', 'd']);

    await pumpCall(tester, call, [
      participant('a'),
      participant('b'),
      participant('c', speaking: true),
      participant('d'),
    ]);

    expect(order(tester), ['a', 'b', 'c', 'd']);
  });

  testWidgets('a participant off screen who speaks takes the last tile', (
    tester,
  ) async {
    final call = mockCall();

    await pumpCall(tester, call, [
      participant('a'),
      participant('b'),
      participant('c'),
      participant('d', onScreen: false),
    ]);
    expect(order(tester), ['a', 'b', 'c', 'd']);

    await pumpCall(tester, call, [
      participant('a'),
      participant('b'),
      participant('c'),
      participant('d', onScreen: false, speaking: true),
    ]);

    // 'd' and 'c' trade places; 'a' and 'b' are untouched.
    expect(order(tester), ['a', 'b', 'd', 'c']);
  });
}
