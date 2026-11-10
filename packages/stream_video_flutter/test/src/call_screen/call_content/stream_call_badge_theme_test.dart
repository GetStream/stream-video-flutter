import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  late MockCall call;
  late MockCallState callState;

  setUp(() {
    call = MockCall();
    callState = MockCallState();

    when(() => callState.participantCount).thenReturn(3);
    when(() => callState.callParticipants).thenReturn(const []);
    when(() => callState.isE2eeEnabled).thenReturn(false);
    when(() => callState.isRecording).thenReturn(false);
    when(() => callState.sessionId).thenReturn('session');
    when(() => callState.status).thenReturn(CallStatus.connected());
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    void stubPartialState<T>() {
      when(() => call.partialState<T>(any())).thenAnswer((invocation) {
        final CallStateSelector<T> selector = invocation.positionalArguments[0];
        return Stream.value(selector(callState));
      });
    }

    // One per badge: the participant count, the duration's indicators, and
    // the session the latency badge follows.
    stubPartialState<int>();
    stubPartialState<({bool encrypted, bool recording, bool presenting})>();
    stubPartialState<({String sessionId, bool connected})>();
    when(() => call.callDurationStream).thenAnswer((_) => const Stream.empty());
    when(() => call.statsReporter).thenReturn(null);
  });

  const shared = StreamCallBadgeStyle(
    backgroundColor: Color(0xFF123456),
    textStyle: TextStyle(color: Color(0xFFABCDEF)),
  );

  Future<void> pump(WidgetTester tester, {Widget? extra}) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamCallBadgeTheme(
          data: const StreamCallBadgeThemeData(style: shared),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamCallParticipantsBadge(call: call),
                StreamCallDurationBadge(call: call),
                StreamCallLatencyBadge(call: call),
                ?extra,
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Color pillColor(WidgetTester tester, Type badge) {
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(badge),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    return (box.decoration as BoxDecoration).color!;
  }

  Color textColor(WidgetTester tester, Type badge) => tester
      .widget<Text>(
        find.descendant(of: find.byType(badge), matching: find.byType(Text)),
      )
      .style!
      .color!;

  testWidgets('one shared theme restyles every badge', (tester) async {
    await pump(tester);

    for (final badge in [
      StreamCallParticipantsBadge,
      StreamCallDurationBadge,
      StreamCallLatencyBadge,
    ]) {
      expect(
        pillColor(tester, badge),
        shared.backgroundColor,
        reason: '$badge',
      );
      expect(
        textColor(tester, badge),
        shared.textStyle!.color,
        reason: '$badge',
      );
    }
  });

  testWidgets("a badge's own style wins over the shared one", (tester) async {
    const own = Color(0xFF00FF00);

    await tester.pumpWidget(
      TestWrapper(
        child: StreamCallBadgeTheme(
          data: const StreamCallBadgeThemeData(style: shared),
          child: Center(
            child: StreamCallParticipantsBadge(
              call: call,
              style: const StreamCallParticipantsBadgeStyle(
                backgroundColor: own,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(pillColor(tester, StreamCallParticipantsBadge), own);
    expect(
      textColor(tester, StreamCallParticipantsBadge),
      shared.textStyle!.color,
    );
  });

  testWidgets('the shared theme is carried by StreamVideoTheme', (
    tester,
  ) async {
    late StreamCallBadgeThemeData resolved;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [
            StreamVideoTheme.light().copyWith(
              callBadgeTheme: const StreamCallBadgeThemeData(style: shared),
            ),
          ],
        ),
        home: Builder(
          builder: (context) {
            resolved = StreamCallBadgeTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(resolved.style, shared);
  });
}
