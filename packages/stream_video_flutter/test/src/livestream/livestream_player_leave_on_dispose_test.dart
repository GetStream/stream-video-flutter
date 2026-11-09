import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

/// A player that joins the livestream by itself leaves it when it closes, as
/// the Swift and JS players do. A call the app joined is the app's to leave.
void main() {
  const leftByApp = DisconnectReason.left(initiator: LeaveInitiator.app);

  late MockCall call;
  late MockCallState callState;
  late GlobalKey<NavigatorState> navigatorKey;

  setUp(() {
    call = MockCall();
    callState = MockCallState();
    final state = MockStateEmitter<CallState>();

    // Idle, so an auto-join has something to join.
    when(() => callState.status).thenReturn(CallStatus.idle());
    when(() => callState.isBackstage).thenReturn(false);
    when(() => callState.endedAt).thenReturn(DateTime.now());
    when(() => callState.ownCapabilities).thenReturn(const []);
    when(() => state.value).thenReturn(callState);

    when(() => call.state).thenAnswer((_) => state);
    when(() => call.callCid).thenReturn(StreamCallCid(cid: 'livestream:test'));
    when(
      () => call.join(connectOptions: any(named: 'connectOptions')),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => call.leave(reason: any(named: 'reason')),
    ).thenAnswer((_) async => const Result.success(none));

    when(
      () => call.partialState<CallStatus>(any()),
    ).thenAnswer((_) => const Stream<CallStatus>.empty());
    // No scheduled start, so joining early is never what lets it join.
    when(
      () => call.partialState<({int? joinAheadSeconds, DateTime? startsAt})>(
        any(),
      ),
    ).thenAnswer(
      (_) => Stream.value((joinAheadSeconds: null, startsAt: null)),
    );
    // The stream is live, which is what the auto-join waits for.
    when(
      () =>
          call.partialState<
            ({bool canJoinBackstage, bool isLive, CallStatus status})
          >(any()),
    ).thenAnswer(
      (_) => Stream.value((
        canJoinBackstage: false,
        isLive: true,
        status: CallStatus.idle(),
      )),
    );
    when(
      () => call.partialState<({bool hasEnded, bool isBackstage})>(any()),
    ).thenAnswer(
      (_) => const Stream<({bool hasEnded, bool isBackstage})>.empty(),
    );
  });

  Future<void> pumpPlayerRoute(
    WidgetTester tester, {
    LivestreamJoinBehaviour joinBehaviour =
        LivestreamJoinBehaviour.autoJoinAsap,
    bool leaveCallOnDispose = true,
  }) async {
    navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: const Scaffold(body: Text('home')),
      ),
    );

    unawaited(
      navigatorKey.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            body: LivestreamPlayer(
              call: call,
              joinBehaviour: joinBehaviour,
              leaveCallOnDispose: leaveCallOnDispose,
              // Rendering a livestream needs far more of a client than these
              // tests are about, and the state above reports it as ended.
              livestreamEndedWidgetBuilder: (_, _) => const Text('stream'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  Future<void> popPlayer(WidgetTester tester) async {
    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
  }

  testWidgets('leaves a call it joined when its route is popped', (
    tester,
  ) async {
    await pumpPlayerRoute(tester);
    verify(
      () => call.join(connectOptions: any(named: 'connectOptions')),
    ).called(1);

    await popPlayer(tester);

    verify(() => call.leave(reason: leftByApp)).called(1);
  });

  testWidgets('keeps the call when leaveCallOnDispose is false', (
    tester,
  ) async {
    await pumpPlayerRoute(tester, leaveCallOnDispose: false);

    await popPlayer(tester);

    verifyNever(() => call.leave(reason: any(named: 'reason')));
  });

  testWidgets('leaves a manually joined call to the app', (tester) async {
    await pumpPlayerRoute(
      tester,
      joinBehaviour: LivestreamJoinBehaviour.manualJoin,
    );

    await popPlayer(tester);

    verifyNever(
      () => call.join(connectOptions: any(named: 'connectOptions')),
    );
    verifyNever(() => call.leave(reason: any(named: 'reason')));
  });

  testWidgets('leaves a call the app had already joined to the app', (
    tester,
  ) async {
    when(() => callState.status).thenReturn(CallStatus.connected());

    await pumpPlayerRoute(tester);
    await popPlayer(tester);

    verifyNever(
      () => call.join(connectOptions: any(named: 'connectOptions')),
    );
    verifyNever(() => call.leave(reason: any(named: 'reason')));
  });
}
