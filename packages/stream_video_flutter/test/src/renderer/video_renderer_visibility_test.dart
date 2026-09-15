import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

// A VisibilityDetector reports what changed about itself, once. Everything the
// SDK knows about which tiles are on screen rests on those reports arriving, so
// a renderer showing a participant the call state does not have as visible
// says so again — and one that is off screen keeps quiet, so two renderers
// disagreeing settle instead of arguing.

void main() {
  setUpAll(() {
    registerFallbackValue(ViewportVisibility.unknown);
    registerFallbackValue(SfuTrackType.video);
  });

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  CallParticipantState participant({
    required ViewportVisibility visibility,
    double audioLevel = 0,
  }) {
    return CallParticipantState(
      name: 'Alice',
      userId: 'alice',
      sessionId: 'alice-session',
      custom: const {},
      roles: const [],
      trackIdPrefix: 'alice',
      audioLevel: audioLevel,
      viewportVisibility: visibility,
    );
  }

  MockCall callRecordingVisibility() {
    final call = MockCall();
    final state = MockCallState();

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

  List<ViewportVisibility> reported(MockCall call) {
    return verify(
      () => call.updateViewportVisibility(
        sessionId: any(named: 'sessionId'),
        userId: any(named: 'userId'),
        visibility: captureAny(named: 'visibility'),
        trackType: any(named: 'trackType'),
      ),
    ).captured.cast<ViewportVisibility>();
  }

  Future<void> pumpTile(
    WidgetTester tester, {
    required Call call,
    required CallParticipantState participant,
    bool offScreen = false,
  }) async {
    final tile = SizedBox(
      width: 300,
      height: 200,
      child: StreamParticipantTile(call: call, participant: participant),
    );

    await tester.pumpWidget(
      TestWrapper(
        child: offScreen
            // Laid out past the right edge of the test surface, so the
            // detector measures none of it.
            ? Stack(children: [Positioned(left: 5000, top: 0, child: tile)])
            : tile,
      ),
    );

    // The detector defers its callbacks to the end of a frame, and the report
    // is asynchronous from there.
    await tester.pump();
    await tester.pump();
  }

  // The report writes call state, and the SDK's state emitter is synchronous:
  // anything listening for participants — the participants view, through
  // `CallParticipantsSortingMixin` — is asked to rebuild on the emitting stack.
  // Made while this renderer is being rebuilt, that lands in the middle of a
  // frame whose build has already passed the listener, and Flutter throws
  // `setState() or markNeedsBuild() called during build`.
  testWidgets('a report from a rebuild is made after the frame, not in it', (
    tester,
  ) async {
    final call = callRecordingVisibility();
    final phases = <SchedulerPhase>[];

    when(
      () => call.updateViewportVisibility(
        sessionId: any(named: 'sessionId'),
        userId: any(named: 'userId'),
        visibility: any(named: 'visibility'),
        trackType: any(named: 'trackType'),
      ),
    ).thenAnswer((_) async {
      phases.add(SchedulerBinding.instance.schedulerPhase);
      return const Result.success(none);
    });

    // The state still says unknown on the next build, so the renderer
    // re-asserts what it measures from `didUpdateWidget`.
    await pumpTile(
      tester,
      call: call,
      participant: participant(visibility: ViewportVisibility.unknown),
    );
    await pumpTile(
      tester,
      call: call,
      participant: participant(
        visibility: ViewportVisibility.unknown,
        audioLevel: 0.4,
      ),
    );

    expect(phases, isNotEmpty);
    expect(
      phases,
      everyElement(isNot(SchedulerPhase.persistentCallbacks)),
      reason: 'a report was made while the frame was being built',
    );
  });

  testWidgets('a tile on screen is reported as visible', (tester) async {
    final call = callRecordingVisibility();

    await pumpTile(
      tester,
      call: call,
      participant: participant(visibility: ViewportVisibility.unknown),
    );

    expect(reported(call), [ViewportVisibility.visible]);
  });

  testWidgets('a visible tile the call state does not have is reported again', (
    tester,
  ) async {
    final call = callRecordingVisibility();

    // The state still says unknown on the next build: the first report was
    // dropped — the call was reconnecting, or another renderer of the same
    // participant reported zero as it went away.
    await pumpTile(
      tester,
      call: call,
      participant: participant(visibility: ViewportVisibility.unknown),
    );
    await pumpTile(
      tester,
      call: call,
      participant: participant(
        visibility: ViewportVisibility.unknown,
        audioLevel: 0.4,
      ),
    );

    expect(reported(call), [
      ViewportVisibility.visible,
      ViewportVisibility.visible,
    ]);
  });

  testWidgets('nothing more is reported once the call state agrees', (
    tester,
  ) async {
    final call = callRecordingVisibility();

    await pumpTile(
      tester,
      call: call,
      participant: participant(visibility: ViewportVisibility.unknown),
    );
    await pumpTile(
      tester,
      call: call,
      participant: participant(visibility: ViewportVisibility.visible),
    );

    expect(reported(call), [ViewportVisibility.visible]);
  });

  testWidgets('a tile scrolled off screen is reported hidden once and left '
      'alone', (tester) async {
    final call = callRecordingVisibility();

    final scroll = ScrollController();
    addTearDown(scroll.dispose);

    // The state says visible throughout, as it would while a second renderer
    // has the participant on screen. This one must not insist on hidden.
    final current = ValueNotifier(
      participant(visibility: ViewportVisibility.visible),
    );
    addTearDown(current.dispose);

    await tester.pumpWidget(
      TestWrapper(
        child: SizedBox(
          height: 400,
          child: ListView(
            controller: scroll,
            children: [
              SizedBox(
                height: 200,
                child: ValueListenableBuilder(
                  valueListenable: current,
                  builder: (context, participant, child) =>
                      StreamParticipantTile(
                        call: call,
                        participant: participant,
                      ),
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

    // On screen and recorded as such: there is nothing to report.
    verifyNever(
      () => call.updateViewportVisibility(
        sessionId: any(named: 'sessionId'),
        userId: any(named: 'userId'),
        visibility: any(named: 'visibility'),
        trackType: any(named: 'trackType'),
      ),
    );

    // Only 30 of the tile's 200 pixels are left in the viewport.
    scroll.jumpTo(170);
    await tester.pump();
    await tester.pump();

    // A rebuild while the state still disagrees: this is where a renderer
    // showing the participant would insist, and this one may not.
    current.value = participant(
      visibility: ViewportVisibility.visible,
      audioLevel: 0.4,
    );
    await tester.pump();
    await tester.pump();

    expect(reported(call), [ViewportVisibility.hidden]);
  });
}
