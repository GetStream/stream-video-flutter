import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/src/call_participants/screen_share_call_participants_content.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    ViewportVisibilityRegistry.defaultReleaseGrace = Duration.zero;
  });

  final sharer = CallParticipantState(
    name: 'alice',
    userId: 'alice',
    sessionId: 'alice-session',
    custom: const {},
    roles: const [],
    trackIdPrefix: 'alice',
    publishedTracks: {SfuTrackType.screenShare: TrackState.remote()},
  );

  /// A call whose registry hands every answer it reaches to [aggregates].
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

  Future<void> settle(WidgetTester tester) async {
    // The detector defers its callbacks to the end of a frame, and a report
    // from a rebuild is deferred again from there.
    await tester.pump();
    await tester.pump();
  }

  Future<void> pumpScreenShare(WidgetTester tester, Call call) async {
    await tester.pumpWidget(
      TestWrapper(
        child: Center(
          child: SizedBox(
            width: 400,
            height: 300,
            child: ScreenShareContent(call: call, participant: sharer),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  Future<void> pinch(
    WidgetTester tester, {
    required double from,
    required double to,
  }) async {
    final center = tester.getCenter(find.byType(ScreenShareContent));
    final first = await tester.startGesture(center - Offset(from, 0));
    final second = await tester.startGesture(center + Offset(from, 0));
    await tester.pump();

    const steps = 5;
    for (var i = 1; i <= steps; i++) {
      final spread = from + (to - from) * i / steps;
      await first.moveTo(center - Offset(spread, 0));
      await second.moveTo(center + Offset(spread, 0));
      await tester.pump();
    }

    await first.up();
    await second.up();
    await settle(tester);
  }

  testWidgets('a zoomed screen share is kept while it is panned', (
    tester,
  ) async {
    final aggregates = <ViewportAggregate>[];
    await pumpScreenShare(tester, callWithRegistry(aggregates));

    // Zoomed to 3x: a ninth of the share is left on screen, so hidden, and
    // kept because it is zoomed.
    await pinch(tester, from: 30, to: 90);

    expect(aggregates.last.visibility, ViewportVisibility.hidden);
    expect(aggregates.last.persistWhenHidden, isTrue);

    // A one-finger pan, still at 3x.
    await tester.drag(
      find.byType(ScreenShareContent),
      const Offset(40, 0),
      touchSlopX: 0,
    );
    await tester.pumpAndSettle();
    await settle(tester);

    expect(aggregates.last.persistWhenHidden, isTrue);

    // Partly pinched out, to 2x: still zoomed.
    await pinch(tester, from: 90, to: 60);

    expect(aggregates.last.persistWhenHidden, isTrue);
  });

  testWidgets('a screen share zoomed back out is no longer kept', (
    tester,
  ) async {
    final aggregates = <ViewportAggregate>[];
    await pumpScreenShare(tester, callWithRegistry(aggregates));

    await pinch(tester, from: 30, to: 90);
    expect(aggregates.last.persistWhenHidden, isTrue);

    await pinch(tester, from: 90, to: 30);

    expect(aggregates.last.visibility, ViewportVisibility.visible);
    expect(aggregates.last.persistWhenHidden, isFalse);
  });
}
