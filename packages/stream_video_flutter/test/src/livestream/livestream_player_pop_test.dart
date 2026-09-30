import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

/// `Navigator.maybePop` closes the topmost route, not the one the player is
/// in. The stream ending is not the user asking to leave whatever happens to
/// be above it.
void main() {
  late MockCall call;
  late StreamController<CallStatus> status;
  late GlobalKey<NavigatorState> navigatorKey;

  Future<void> pumpPlayerRoute(WidgetTester tester) async {
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
              // Rendering a livestream needs far more of a client than a pop
              // does, and the state below reports the stream as ended.
              livestreamEndedWidgetBuilder: (_, _) => const Text('stream'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

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

  setUp(() {
    call = MockCall();
    status = StreamController<CallStatus>.broadcast();

    final state = MockStateEmitter<CallState>();
    final callState = MockCallState();

    when(() => callState.status).thenReturn(CallStatus.connected());
    when(() => callState.isBackstage).thenReturn(false);
    when(() => callState.endedAt).thenReturn(DateTime.now());
    when(() => callState.ownCapabilities).thenReturn(const []);
    when(() => state.value).thenReturn(callState);

    when(() => call.state).thenAnswer((_) => state);
    when(
      () => call.leave(),
    ).thenAnswer((_) async => const Result.success(none));

    // The status stream is the one these tests drive; every other selector the
    // player watches just never changes.
    when(
      () => call.partialState<CallStatus>(any()),
    ).thenAnswer((_) => status.stream);
    // Each selector the player watches is its own generic, and mocktail
    // matches on the exact type. None of them ever changes here.
    when(
      () => call.partialState<({int? joinAheadSeconds, DateTime? startsAt})>(
        any(),
      ),
    ).thenAnswer(
      (_) =>
          const Stream<({int? joinAheadSeconds, DateTime? startsAt})>.empty(),
    );
    when(
      () =>
          call.partialState<
            ({bool canJoinBackstage, bool isLive, CallStatus status})
          >(
            any(),
          ),
    ).thenAnswer(
      (_) =>
          const Stream<
            ({bool canJoinBackstage, bool isLive, CallStatus status})
          >.empty(),
    );
    when(
      () => call.partialState<({bool hasEnded, bool isBackstage})>(any()),
    ).thenAnswer(
      (_) => const Stream<({bool hasEnded, bool isBackstage})>.empty(),
    );
  });

  tearDown(() => status.close());

  testWidgets('leaves a route above it alone when the stream ends', (
    tester,
  ) async {
    await pumpPlayerRoute(tester);
    await pushOverIt(tester);

    status.add(CallStatus.disconnected(DisconnectReason.ended()));
    await tester.pumpAndSettle();

    expect(find.text('above'), findsOneWidget);
    // Leaving the call itself is not deferred, only the route.
    verify(() => call.leave()).called(1);
  });

  testWidgets('closes itself once it is the top route again', (tester) async {
    await pumpPlayerRoute(tester);
    await pushOverIt(tester);

    status.add(CallStatus.disconnected(DisconnectReason.ended()));
    await tester.pumpAndSettle();

    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();

    expect(find.text('above'), findsNothing);
    expect(find.text('stream'), findsNothing);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('pops straight away when it is the top route', (tester) async {
    await pumpPlayerRoute(tester);

    status.add(CallStatus.disconnected(DisconnectReason.ended()));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });
}
