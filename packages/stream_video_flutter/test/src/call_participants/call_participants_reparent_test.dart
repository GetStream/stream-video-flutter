import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// The SDK exports a log `Finder`, which is not the one these look widgets up
// with.
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

// A participant moving between layouts — out of the spotlight and into the bar
// below it — is a tile in a new place. Rebuilt there it costs a new video
// renderer, and draws nothing until the first frame reaches it. These are
// about the element making the move with them.

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    ViewportVisibilityRegistry.defaultReleaseGrace = Duration.zero;
  });

  CallParticipantState participant(String id, {bool speaking = false}) {
    return CallParticipantState(
      name: id,
      userId: id,
      sessionId: id,
      custom: const {},
      roles: const [],
      trackIdPrefix: id,
      isDominantSpeaker: speaking,
      isSpeaking: speaking,
      // Hidden, so the sort is free to reorder: it leaves the tiles that are
      // on screen where they are, which is the whole point of it.
      viewportVisibility: ViewportVisibility.hidden,
    );
  }

  MockCall mockCall() {
    final call = MockCall();
    final state = MockCallState();

    when(() => state.callParticipants).thenReturn(const []);
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(state, sync: true),
    );

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
          child: StreamCallParticipants(
            call: call,
            participants: participants,
            // Bar below the speaker, so the spotlight is the first tile
            // in tree order.
            layoutMode: ParticipantLayoutMode.speakerTop,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Finder tileOf(String userId) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is DefaultStreamParticipantTile &&
          widget.props.participant.userId == userId,
    );
  }

  /// The [State] the tile draws its video through. Identical across a move
  /// means the element was carried over rather than built again.
  State videoStateOf(WidgetTester tester, String userId) {
    return tester.state(
      find.descendant(
        of: tileOf(userId),
        matching: find.byType(ViewportVisibilityReporter),
      ),
    );
  }

  List<String> order(WidgetTester tester) {
    return tester
        .widgetList<DefaultStreamParticipantTile>(
          find.byType(DefaultStreamParticipantTile),
        )
        .map((it) => it.props.participant.userId)
        .toList();
  }

  testWidgets('a tile leaving the spotlight for the bar keeps its element', (
    tester,
  ) async {
    final call = mockCall();

    await pumpCall(tester, call, [
      participant('a', speaking: true),
      participant('b'),
      participant('c'),
    ]);
    expect(order(tester).first, 'a', reason: 'a is spotlighted');

    final before = videoStateOf(tester, 'a');

    await pumpCall(tester, call, [
      participant('a'),
      participant('b', speaking: true),
      participant('c'),
    ]);
    expect(order(tester).first, 'b', reason: 'b took the spotlight');

    expect(
      videoStateOf(tester, 'a'),
      same(before),
      reason: 'a moved to the bar carrying the element that draws them',
    );
  });

  testWidgets('a tile taken into the spotlight keeps its element', (
    tester,
  ) async {
    final call = mockCall();

    await pumpCall(tester, call, [
      participant('a', speaking: true),
      participant('b'),
      participant('c'),
    ]);

    final before = videoStateOf(tester, 'b');

    await pumpCall(tester, call, [
      participant('a'),
      participant('b', speaking: true),
      participant('c'),
    ]);
    expect(order(tester).first, 'b');

    expect(videoStateOf(tester, 'b'), same(before));
  });

  // The keys are minted on first sight, so something has to let go of them.
  testWidgets('a participant who leaves and comes back gets a new element', (
    tester,
  ) async {
    final call = mockCall();

    await pumpCall(tester, call, [participant('a'), participant('b')]);
    final before = videoStateOf(tester, 'b');

    await pumpCall(tester, call, [participant('a')]);
    expect(tileOf('b'), findsNothing);

    await pumpCall(tester, call, [participant('a'), participant('b')]);

    expect(videoStateOf(tester, 'b'), isNot(same(before)));
  });
}
