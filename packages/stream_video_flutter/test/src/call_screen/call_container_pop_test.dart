import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

/// `Navigator.maybePop` closes the topmost route, not the one the container is
/// in. The call ending is not the user asking to leave whatever happens to be
/// above it — a dialog, or the screen for the call they are actually on.
void main() {
  late MockCall call;
  late StreamController<CallStatus> status;
  late GlobalKey<NavigatorState> navigatorKey;

  /// The call the container is showing, swappable in place so that changing it
  /// reaches `didUpdateWidget` rather than rebuilding the whole tree.
  late ValueNotifier<Call> shown;

  /// Puts the container on the stack, over a home route.
  Future<void> pumpContainerRoute(WidgetTester tester) async {
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
                // The container's own content is not what these tests are
                // about, and rendering a call needs far more of a client than
                // a pop does.
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

  /// Puts something on top of the container, the way a dialog would sit over a
  /// live call.
  Future<void> pushOverIt(WidgetTester tester) async {
    unawaited(
      navigatorKey.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('above')),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  /// A call that is connected and reports its status changes on [statuses].
  MockCall stubbedCall(Stream<CallStatus> statuses) {
    final stub = MockCall();
    final state = MockStateEmitter<CallState>();
    final callState = MockCallState();

    when(() => callState.status).thenReturn(CallStatus.connected());
    when(() => state.value).thenReturn(callState);
    when(() => stub.state).thenAnswer((_) => state);
    when(
      () => stub.partialState<CallStatus>(any()),
    ).thenAnswer((_) => statuses);
    when(
      () => stub.join(connectOptions: any(named: 'connectOptions')),
    ).thenAnswer((_) async => const Result.success(none));

    return stub;
  }

  setUp(() {
    status = StreamController<CallStatus>.broadcast();
    call = stubbedCall(status.stream);
    shown = ValueNotifier<Call>(call);
  });

  tearDown(() => status.close());

  testWidgets('leaves a route above it alone when the call ends', (
    tester,
  ) async {
    await pumpContainerRoute(tester);
    await pushOverIt(tester);

    status.add(CallStatus.disconnected(DisconnectReason.ended()));
    await tester.pumpAndSettle();

    // Popping here would close the screen the user is actually looking at.
    expect(find.text('above'), findsOneWidget);
  });

  testWidgets('closes itself once it is the top route again', (tester) async {
    await pumpContainerRoute(tester);
    await pushOverIt(tester);

    status.add(CallStatus.disconnected(DisconnectReason.ended()));
    await tester.pumpAndSettle();

    // The pop it held back is still owed, and falls due the moment the
    // container is what a pop would close.
    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();

    expect(find.text('above'), findsNothing);
    expect(find.text('call'), findsNothing);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('drops a pending pop when it is given another call', (
    tester,
  ) async {
    await pumpContainerRoute(tester);
    await pushOverIt(tester);

    status.add(CallStatus.disconnected(DisconnectReason.ended()));
    await tester.pumpAndSettle();

    // A second call arrives before the owed pop falls due: the container has
    // something to show again, so the route has to stay.
    shown.value = stubbedCall(const Stream<CallStatus>.empty());
    await tester.pumpAndSettle();

    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();

    expect(find.text('call'), findsOneWidget);
  });

  testWidgets('pops straight away when it is the top route', (tester) async {
    await pumpContainerRoute(tester);

    status.add(CallStatus.disconnected(DisconnectReason.ended()));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });
}
