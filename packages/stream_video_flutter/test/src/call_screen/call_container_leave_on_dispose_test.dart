import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

/// The container joins its call, so closing it leaves that call: otherwise the
/// call keeps publishing audio and video behind a screen that is gone.
void main() {
  const leftByApp = DisconnectReason.left(initiator: LeaveInitiator.app);

  late GlobalKey<NavigatorState> navigatorKey;

  /// The call the container is showing, swappable in place so that changing it
  /// reaches `didUpdateWidget` rather than rebuilding the whole tree.
  late ValueNotifier<Call> shown;

  /// A call in [status] whose join and leave succeed.
  MockCall stubbedCall({CallStatus? status}) {
    final call = MockCall();
    final state = MockStateEmitter<CallState>();
    final callState = MockCallState();

    when(() => callState.status).thenReturn(status ?? CallStatus.connected());
    when(() => state.value).thenReturn(callState);
    when(() => call.state).thenAnswer((_) => state);
    when(() => call.callCid).thenReturn(StreamCallCid(cid: 'default:test'));
    when(
      () => call.partialState<CallStatus>(any()),
    ).thenAnswer((_) => const Stream<CallStatus>.empty());
    when(
      () => call.join(connectOptions: any(named: 'connectOptions')),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => call.leave(reason: any(named: 'reason')),
    ).thenAnswer((_) async => const Result.success(none));

    return call;
  }

  /// Puts the container on the stack, over a home route.
  Future<void> pumpContainerRoute(
    WidgetTester tester, {
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
            body: ValueListenableBuilder<Call>(
              valueListenable: shown,
              builder: (_, current, _) => StreamCallContainer(
                call: current,
                leaveCallOnDispose: leaveCallOnDispose,
                // Rendering a call needs far more of a client than these
                // tests are about.
                callContentWidgetBuilder: (_, _) => const Text('call'),
                incomingCallWidgetBuilder: (_, _) => const Text('call'),
                outgoingCallWidgetBuilder: (_, _) => const Text('call'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  Future<void> popContainer(WidgetTester tester) async {
    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
  }

  testWidgets('leaves the call when its route is popped', (tester) async {
    final call = stubbedCall();
    shown = ValueNotifier<Call>(call);
    await pumpContainerRoute(tester);

    verifyNever(() => call.leave(reason: any(named: 'reason')));

    await popContainer(tester);

    verify(() => call.leave(reason: leftByApp)).called(1);
  });

  testWidgets('keeps the call when leaveCallOnDispose is false', (
    tester,
  ) async {
    final call = stubbedCall();
    shown = ValueNotifier<Call>(call);
    await pumpContainerRoute(tester, leaveCallOnDispose: false);

    await popContainer(tester);

    verifyNever(() => call.leave(reason: any(named: 'reason')));
  });

  testWidgets('does not leave a call that is already disconnected', (
    tester,
  ) async {
    final call = stubbedCall(
      status: CallStatus.disconnected(const DisconnectReason.ended()),
    );
    shown = ValueNotifier<Call>(call);
    await pumpContainerRoute(tester);

    await popContainer(tester);

    verifyNever(() => call.leave(reason: any(named: 'reason')));
  });

  testWidgets('leaves the call it joined, not one it was given later', (
    tester,
  ) async {
    final joined = stubbedCall();
    final later = stubbedCall();
    shown = ValueNotifier<Call>(joined);
    await pumpContainerRoute(tester);

    shown.value = later;
    await tester.pumpAndSettle();
    await popContainer(tester);

    verify(() => joined.leave(reason: leftByApp)).called(1);
    verifyNever(() => later.leave(reason: any(named: 'reason')));
  });
}
