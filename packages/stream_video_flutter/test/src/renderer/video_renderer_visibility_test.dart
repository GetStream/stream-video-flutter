import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

// A renderer reports only what it measures of itself, into the call's viewport
// registry. What the participant's visibility and subscription become is the
// registry's to decide, over every renderer drawing them — these tests are
// about what each renderer puts in, and that it goes in at a safe moment.

void main() {
  setUpAll(() {
    registerFallbackValue(ViewportVisibility.unknown);
    registerFallbackValue(SfuTrackType.video);
  });

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  CallParticipantState participant({
    String userId = 'alice',
    double audioLevel = 0,
    Map<SfuTrackType, TrackState> publishedTracks = const {},
  }) {
    return CallParticipantState(
      name: userId,
      userId: userId,
      sessionId: '$userId-session',
      custom: const {},
      roles: const [],
      trackIdPrefix: userId,
      audioLevel: audioLevel,
      publishedTracks: publishedTracks,
    );
  }

  /// A call whose registry hands every answer it reaches to [aggregates],
  /// instead of writing call state and subscriptions.
  MockCall callWithRegistry(List<ViewportAggregate> aggregates) {
    final call = MockCall();
    final state = MockCallState();

    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(state, sync: true),
    );
    when(() => call.viewportVisibility).thenReturn(
      ViewportVisibilityRegistry(onAggregate: aggregates.add),
    );

    return call;
  }

  Future<void> pumpTile(
    WidgetTester tester, {
    required Call call,
    required CallParticipantState participant,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        child: SizedBox(
          width: 300,
          height: 200,
          child: StreamParticipantTile(call: call, participant: participant),
        ),
      ),
    );

    // The detector defers its callbacks to the end of a frame, and a report
    // from a rebuild is deferred again from there.
    await tester.pump();
    await tester.pump();
  }

  testWidgets('a tile on screen is reported visible, at the size it draws', (
    tester,
  ) async {
    final aggregates = <ViewportAggregate>[];

    await pumpTile(
      tester,
      call: callWithRegistry(aggregates),
      participant: participant(),
    );

    expect(aggregates.single.visibility, ViewportVisibility.visible);
    expect(aggregates.single.dimension.isEmpty, isFalse);
  });

  // The case a single shared field could never hold: the same participant
  // drawn twice, in two places that do not agree.
  testWidgets('a second renderer leaving the screen does not hide the '
      'participant', (tester) async {
    final aggregates = <ViewportAggregate>[];
    final call = callWithRegistry(aggregates);
    final alice = participant();

    final scroll = ScrollController();
    addTearDown(scroll.dispose);

    await tester.pumpWidget(
      TestWrapper(
        child: Column(
          children: [
            // The grid, which shows the participant throughout.
            SizedBox(
              width: 300,
              height: 200,
              child: StreamParticipantTile(call: call, participant: alice),
            ),
            // The same participant in a strip that scrolls, as a livestream's
            // hosts or a filmstrip beside the speaker do.
            SizedBox(
              width: 300,
              height: 200,
              child: ListView(
                controller: scroll,
                children: [
                  SizedBox(
                    height: 200,
                    child: StreamParticipantTile(
                      call: call,
                      participant: alice,
                      rendererScopePrefix: 'strip',
                    ),
                  ),
                  const SizedBox(height: 2000),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    // Both are showing them, and the grid is the larger of the two.
    expect(aggregates.last.visibility, ViewportVisibility.visible);
    final sized = aggregates.last.dimension;

    // The strip scrolls away. It measures nothing, and says so.
    scroll.jumpTo(180);
    await tester.pump();
    await tester.pump();

    expect(
      aggregates.map((aggregate) => aggregate.visibility),
      everyElement(ViewportVisibility.visible),
      reason: 'a renderer spoke for a participant another one was showing',
    );
    expect(
      aggregates.last.dimension,
      sized,
      reason: 'the grid tile still needs the size it is drawing at',
    );
  });

  // Acting on a report writes call state, and the SDK's state emitter is
  // synchronous: anything listening for participants — the participants view,
  // through `CallParticipantsSortingMixin` — is asked to rebuild on the
  // emitting stack. Made while a renderer is being rebuilt, that lands in the
  // middle of a frame whose build has already passed the listener, and Flutter
  // throws `setState() or markNeedsBuild() called during build`.
  testWidgets('a report from a rebuild is made after the frame, not in it', (
    tester,
  ) async {
    final phases = <SchedulerPhase>[];
    final call = callWithRegistry([]);

    when(() => call.viewportVisibility).thenReturn(
      ViewportVisibilityRegistry(
        onAggregate: (_) =>
            phases.add(SchedulerBinding.instance.schedulerPhase),
      ),
    );

    // A track published under a tile that is already on screen: the report
    // comes out of `didUpdateWidget`, mid-build.
    await pumpTile(tester, call: call, participant: participant());
    await pumpTile(
      tester,
      call: call,
      participant: participant(
        publishedTracks: {SfuTrackType.video: TrackState.remote()},
      ),
    );

    expect(phases, isNotEmpty);
    expect(
      phases,
      everyElement(isNot(SchedulerPhase.persistentCallbacks)),
      reason: 'a report was made while the frame was being built',
    );
  });

  // Nothing the renderer measures changes when a track appears — it has been
  // drawing a placeholder the same size all along — so without asking for the
  // answer again, the track would never be subscribed at any size.
  testWidgets('a track published under a visible tile is sized again', (
    tester,
  ) async {
    final aggregates = <ViewportAggregate>[];
    final call = callWithRegistry(aggregates);

    await pumpTile(tester, call: call, participant: participant());
    aggregates.clear();

    await pumpTile(
      tester,
      call: call,
      participant: participant(
        publishedTracks: {SfuTrackType.video: TrackState.remote()},
      ),
    );

    expect(aggregates, hasLength(1));
    expect(aggregates.single.visibility, ViewportVisibility.visible);
    expect(aggregates.single.dimension.isEmpty, isFalse);
  });

  testWidgets('a renderer that is gone stops speaking for the track', (
    tester,
  ) async {
    final aggregates = <ViewportAggregate>[];
    final call = callWithRegistry(aggregates);

    await pumpTile(tester, call: call, participant: participant());
    aggregates.clear();

    await tester.pumpWidget(const TestWrapper(child: SizedBox()));
    await tester.pump();

    expect(aggregates.single.visibility, ViewportVisibility.hidden);
    expect(aggregates.single.dimension.isEmpty, isTrue);
  });

  testWidgets('a tile scrolled off screen is reported hidden once', (
    tester,
  ) async {
    final aggregates = <ViewportAggregate>[];
    final call = callWithRegistry(aggregates);

    final scroll = ScrollController();
    addTearDown(scroll.dispose);

    await tester.pumpWidget(
      TestWrapper(
        child: SizedBox(
          height: 400,
          child: ListView(
            controller: scroll,
            children: [
              SizedBox(
                height: 200,
                child: StreamParticipantTile(
                  call: call,
                  participant: participant(),
                ),
              ),
              const SizedBox(height: 2000),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    aggregates.clear();

    // Only 30 of the tile's 200 pixels are left in the viewport.
    scroll.jumpTo(170);
    await tester.pump();
    await tester.pump();

    expect(
      aggregates.map((aggregate) => aggregate.visibility),
      [ViewportVisibility.hidden],
    );
  });
}
