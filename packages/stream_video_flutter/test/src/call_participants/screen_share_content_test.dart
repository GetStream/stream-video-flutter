import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/src/call_participants/screen_share_call_participants_content.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

void main() {
  // Process-wide, so it goes back to what it was for whatever runs next.
  late Duration updateInterval;

  setUp(() {
    updateInterval = VisibilityDetectorController.instance.updateInterval;
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval = updateInterval;
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

  /// A call whose viewport registry hands every answer it reaches to
  /// [aggregates], instead of writing call state and subscriptions.
  MockCall mockCall([List<ViewportAggregate>? aggregates]) {
    final call = MockCall();

    when(() => call.viewportVisibility).thenReturn(
      ViewportVisibilityRegistry(
        releaseGrace: Duration.zero,
        onAggregate: (aggregate) async {
          aggregates?.add(aggregate);
          return true;
        },
      ),
    );

    return call;
  }

  /// Whether any answer in [aggregates] would have the call drop the
  /// subscription: hidden, with no viewport asking to keep it.
  bool unsubscribed(List<ViewportAggregate> aggregates) {
    return aggregates.any(
      (aggregate) =>
          !aggregate.visibility.isVisible && !aggregate.persistWhenHidden,
    );
  }

  bool keepsTrack(WidgetTester tester) {
    return tester
        .widget<StreamVideoRenderer>(find.byType(StreamVideoRenderer))
        .persistTrackIfNotVisible;
  }

  Future<void> settle(WidgetTester tester) async {
    // The detector defers its callbacks to the end of a frame.
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

  /// Sends [event] at the centre of the share, as a mouse or trackpad would.
  Future<void> signal(
    WidgetTester tester,
    PointerSignalEvent Function(Offset position) event,
  ) async {
    final center = tester.getCenter(find.byType(ScreenShareContent));
    tester.binding.handlePointerEvent(event(center));
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
    final call = mockCall(aggregates);
    await pumpScreenShare(tester, call);

    // Zoomed to 3x: a ninth of the share is left on screen, so hidden, and
    // kept because it is zoomed.
    await pinch(tester, from: 30, to: 90);

    expect(keepsTrack(tester), isTrue);

    // A one-finger pan, still at 3x.
    await tester.drag(
      find.byType(ScreenShareContent),
      const Offset(40, 0),
      touchSlopX: 0,
    );
    await tester.pumpAndSettle();
    await settle(tester);

    expect(keepsTrack(tester), isTrue);

    // Partly pinched out, to 2x: still zoomed.
    await pinch(tester, from: 90, to: 60);

    expect(keepsTrack(tester), isTrue);
    expect(unsubscribed(aggregates), isFalse);
  });

  testWidgets('a screen share zoomed back out is no longer kept', (
    tester,
  ) async {
    await pumpScreenShare(tester, mockCall());

    await pinch(tester, from: 30, to: 90);
    expect(keepsTrack(tester), isTrue);

    await pinch(tester, from: 90, to: 30);

    expect(keepsTrack(tester), isFalse);
  });

  testWidgets('a screen share zoomed with a mouse or trackpad is kept while '
      'it is panned or zoomed partly out', (tester) async {
    final aggregates = <ViewportAggregate>[];
    final call = mockCall(aggregates);
    await pumpScreenShare(tester, call);

    // A trackpad pinch to 3x.
    await signal(
      tester,
      (position) => PointerScaleEvent(position: position, scale: 3),
    );

    expect(keepsTrack(tester), isTrue);

    // A two-finger trackpad scroll, which pans.
    await signal(
      tester,
      (position) => PointerScrollEvent(
        kind: PointerDeviceKind.trackpad,
        position: position,
        scrollDelta: const Offset(40, 20),
      ),
    );

    expect(keepsTrack(tester), isTrue);

    // A step back out, to 2.4x.
    await signal(
      tester,
      (position) => PointerScaleEvent(position: position, scale: 0.8),
    );

    expect(keepsTrack(tester), isTrue);
    expect(unsubscribed(aggregates), isFalse);

    // Mouse wheel steps back out to 1x or below.
    for (var i = 0; i < 3; i++) {
      await signal(
        tester,
        (position) => PointerScrollEvent(
          position: position,
          scrollDelta: const Offset(0, 200),
        ),
      );
    }

    expect(keepsTrack(tester), isFalse);
  });

  group('ScreenShareCallParticipantsContent', () {
    Future<ParticipantsBarAlignment> barAlignmentIn(
      WidgetTester tester,
      Size box,
    ) async {
      // A window the other way round from the box, so only the box can be
      // what decides.
      tester.view
        ..devicePixelRatio = 1
        ..physicalSize = Size(box.height * 2, box.width * 2);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        TestWrapper(
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox.fromSize(
              size: box,
              child: ScreenShareCallParticipantsContent(
                call: mockCall(),
                screenSharingParticipant: sharer,
                participants: const [],
                screenShareContentBuilder: (_, _, _) => const SizedBox(),
              ),
            ),
          ),
        ),
      );
      await settle(tester);

      return tester
          .widget<CallParticipantsSpotlightView>(
            find.byType(CallParticipantsSpotlightView),
          )
          .barAlignment;
    }

    testWidgets('a box wider than the share puts the strip beside it', (
      tester,
    ) async {
      expect(
        await barAlignmentIn(tester, const Size(1000, 300)),
        ParticipantsBarAlignment.right,
      );
    });

    testWidgets('a box taller than the share puts the strip under it', (
      tester,
    ) async {
      expect(
        await barAlignmentIn(tester, const Size(300, 600)),
        ParticipantsBarAlignment.bottom,
      );
    });
  });
}
