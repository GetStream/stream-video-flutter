import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

// A renderer reports only what it measures of itself, through the
// `ViewportVisibilityReporter` it wraps its child in, into the call's viewport
// registry. What the participant's visibility and subscription become is the
// registry's to decide, over every renderer drawing them — these tests are
// about what each renderer puts in, and that it goes in at a safe moment.

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  CallParticipantState participant({
    String userId = 'alice',
    String? trackIdPrefix,
    double audioLevel = 0,
    Map<SfuTrackType, TrackState> publishedTracks = const {},
  }) {
    return CallParticipantState(
      name: userId,
      userId: userId,
      sessionId: '$userId-session',
      custom: const {},
      roles: const [],
      trackIdPrefix: trackIdPrefix ?? userId,
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
      ViewportVisibilityRegistry(
        onAggregate: (aggregate) async {
          aggregates.add(aggregate);
          return true;
        },
      ),
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
            // hosts or a filmstrip beside the speaker do. A quarter of the
            // grid's area, so what it asks for is not what the grid needs.
            SizedBox(
              width: 150,
              height: 100,
              child: ListView(
                controller: scroll,
                children: [
                  SizedBox(
                    height: 100,
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

    final dpr = tester.view.devicePixelRatio;
    final gridSize = RtcVideoDimension(
      width: (300 * dpr).toInt(),
      height: (200 * dpr).toInt(),
    );

    // Both are showing them, and the larger of the two sizes the track.
    expect(aggregates.last.visibility, ViewportVisibility.visible);
    expect(
      aggregates.last.dimension,
      gridSize,
      reason: 'the smaller strip pulled the grid tile down to its own size',
    );

    // The strip scrolls away. It measures nothing, and says so.
    scroll.jumpTo(90);
    await tester.pump();
    await tester.pump();

    expect(
      aggregates.map((aggregate) => aggregate.visibility),
      everyElement(ViewportVisibility.visible),
      reason: 'a renderer spoke for a participant another one was showing',
    );
    expect(
      aggregates.last.dimension,
      gridSize,
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
        onAggregate: (_) async {
          phases.add(SchedulerBinding.instance.schedulerPhase);
          return true;
        },
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
      everyElement(
        anyOf(SchedulerPhase.postFrameCallbacks, SchedulerPhase.idle),
      ),
      reason: 'a report was made from inside the frame',
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

    // A detector delivers one last, hidden report after it is gone, which
    // lands after the release has already taken this viewport out.
    await tester.pump();
    await tester.pump();

    expect(
      aggregates.single.visibility,
      ViewportVisibility.hidden,
      reason: 'the release is the last word for a viewport that is gone',
    );
    expect(aggregates.single.dimension.isEmpty, isTrue);
  });

  testWidgets('a renderer pointed at a new track speaks for that one', (
    tester,
  ) async {
    final aggregates = <ViewportAggregate>[];
    final call = callWithRegistry(aggregates);

    await pumpTile(tester, call: call, participant: participant());
    aggregates.clear();

    // A migration hands the same participant a new track prefix. The viewport
    // has not moved and measures exactly what it did before, so nothing but
    // the track it is about has changed.
    await pumpTile(
      tester,
      call: call,
      participant: participant(trackIdPrefix: 'alice-migrated'),
    );

    final spokenFor = aggregates.map((it) => it.track.trackIdPrefix).toSet();
    expect(
      spokenFor,
      contains('alice-migrated'),
      reason: 'the new track was never measured, so nothing subscribed it',
    );
    expect(
      aggregates
          .lastWhere((it) => it.track.trackIdPrefix == 'alice-migrated')
          .visibility,
      ViewportVisibility.visible,
    );
    expect(
      aggregates
          .lastWhere((it) => it.track.trackIdPrefix == 'alice')
          .visibility,
      ViewportVisibility.hidden,
      reason: 'the track it stopped drawing was left recorded as on screen',
    );
  });

  testWidgets('a detector reporting after its renderer is gone is ignored', (
    tester,
  ) async {
    // The timer path, which is what runs outside a test: a detector delivers
    // one last, hidden report once its render object is gone, after the
    // release has already taken this viewport out of the registry.
    VisibilityDetectorController.instance.updateInterval = const Duration(
      milliseconds: 500,
    );

    final aggregates = <ViewportAggregate>[];
    final call = callWithRegistry(aggregates);

    await tester.pumpWidget(
      TestWrapper(
        child: SizedBox(
          width: 300,
          height: 200,
          child: StreamParticipantTile(call: call, participant: participant()),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(aggregates.single.visibility, ViewportVisibility.visible);
    aggregates.clear();

    await tester.pumpWidget(const TestWrapper(child: SizedBox()));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(
      aggregates.single.visibility,
      ViewportVisibility.hidden,
      reason:
          'a report after the release put the viewport back, with nothing '
          'left alive to take it out again',
    );
  });

  testWidgets(
    'a renderer moved to another call stops speaking to the old one',
    (
      tester,
    ) async {
      final left = <ViewportAggregate>[];
      final joined = <ViewportAggregate>[];

      await pumpTile(
        tester,
        call: callWithRegistry(left),
        participant: participant(),
      );
      left.clear();

      await pumpTile(
        tester,
        call: callWithRegistry(joined),
        participant: participant(),
      );

      expect(
        left.single.visibility,
        ViewportVisibility.hidden,
        reason: 'the old call was left thinking the track is still on screen',
      );
      expect(joined.last.visibility, ViewportVisibility.visible);
      expect(joined.last.dimension.isEmpty, isFalse);
    },
  );

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
