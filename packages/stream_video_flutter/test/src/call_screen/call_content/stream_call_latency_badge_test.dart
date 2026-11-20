import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// StatsReporter is not exported; the badge only reaches it through
// `Call.statsReporter`.
// ignore: implementation_imports
import 'package:stream_video/src/call/stats/stats_reporter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

class _MockStatsReporter extends Mock implements StatsReporter {}

/// What the badge selects out of the call state.
typedef _Session = ({String sessionId, bool connected});

void main() {
  late MockCall call;
  late MockCallState callState;
  late _MockStatsReporter reporter;

  setUp(() {
    call = MockCall();
    callState = MockCallState();
    reporter = _MockStatsReporter();

    when(() => callState.sessionId).thenReturn('session');
    when(() => callState.status).thenReturn(CallStatus.connected());
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    when(() => call.partialState<_Session>(any())).thenAnswer((invocation) {
      final CallStateSelector<_Session> selector =
          invocation.positionalArguments[0];
      return Stream.value(selector(callState));
    });
    when(() => call.statsReporter).thenReturn(reporter);
    when(() => reporter.stream).thenAnswer((_) => const Stream.empty());
  });

  CallMetrics metrics(int? latency) => CallMetrics(
    clientEnvironment: ClientEnvironment.empty(),
    publisher: PeerConnectionStats.empty().copyWith(latency: latency),
  );

  Future<void> pump(WidgetTester tester, {int? latency}) async {
    when(
      () => reporter.currentMetrics,
    ).thenReturn(latency == null ? null : metrics(latency));

    await tester.pumpWidget(
      TestWrapper(
        child: Center(child: StreamCallLatencyBadge(call: call)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Color dotColor(WidgetTester tester) {
    final dot = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(StreamCallLatencyBadge),
        matching: find.byWidgetPredicate(
          (it) =>
              it is DecoratedBox &&
              (it.decoration as BoxDecoration).shape == BoxShape.circle,
        ),
      ),
    );
    return (dot.decoration as BoxDecoration).color!;
  }

  String reading(WidgetTester tester) =>
      tester.widget<Text>(find.byType(Text)).textSpan!.toPlainText();

  StreamColorScheme colors(WidgetTester tester) =>
      tester.element(find.byType(StreamCallLatencyBadge)).streamColorScheme;

  testWidgets('shows -- before the first measurement', (tester) async {
    await pump(tester);

    expect(reading(tester), '-- ms');
    expect(dotColor(tester), colors(tester).textTertiary);
  });

  testWidgets('shows -- before the call has a session', (tester) async {
    when(() => call.statsReporter).thenReturn(null);

    await tester.pumpWidget(
      TestWrapper(
        child: Center(child: StreamCallLatencyBadge(call: call)),
      ),
    );
    await tester.pumpAndSettle();

    expect(reading(tester), '-- ms');
  });

  testWidgets('marks a latency up to 100 ms as great', (tester) async {
    await pump(tester, latency: 100);

    expect(reading(tester), '100 ms');
    expect(dotColor(tester), colors(tester).accentSuccess);
    expect(find.bySemanticsLabel('Latency 100 milliseconds'), findsOneWidget);
  });

  testWidgets('marks a latency below 400 ms as fair', (tester) async {
    await pump(tester, latency: 399);

    expect(dotColor(tester), colors(tester).accentWarning);
  });

  testWidgets('marks a latency from 400 ms as poor', (tester) async {
    await pump(tester, latency: 400);

    expect(dotColor(tester), colors(tester).accentError);
  });

  testWidgets('follows the reporter as it measures', (tester) async {
    final controller = StreamController<CallMetrics?>.broadcast();
    addTearDown(controller.close);
    when(() => reporter.stream).thenAnswer((_) => controller.stream);

    await pump(tester, latency: 15);
    expect(reading(tester), '15 ms');

    controller.add(metrics(250));
    // One pump delivers the event, the next builds from it.
    await tester.pump();
    await tester.pump();

    expect(reading(tester), '250 ms');
  });

  testWidgets('picks up the reporter once the session connects', (
    tester,
  ) async {
    final session = StreamController<_Session>();
    addTearDown(session.close);
    when(
      () => call.partialState<_Session>(any()),
    ).thenAnswer((_) => session.stream);
    when(() => call.statsReporter).thenReturn(null);

    await tester.pumpWidget(
      TestWrapper(
        child: Center(child: StreamCallLatencyBadge(call: call)),
      ),
    );
    session.add((sessionId: 'session', connected: false));
    await tester.pump();
    expect(reading(tester), '-- ms');

    when(() => reporter.currentMetrics).thenReturn(metrics(42));
    when(() => call.statsReporter).thenReturn(reporter);
    session.add((sessionId: 'session', connected: true));
    await tester.pump();
    await tester.pump();

    expect(reading(tester), '42 ms');
  });
}
