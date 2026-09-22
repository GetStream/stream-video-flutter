import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

/// What the badge selects out of the call state, which is what its
/// `partialState` call has to be stubbed for.
typedef _Status = ({bool encrypted, bool recording, bool presenting});

void main() {
  late MockCall call;
  late MockCallState callState;

  setUp(() {
    call = MockCall();
    callState = MockCallState();

    when(() => callState.isE2eeEnabled).thenReturn(false);
    when(() => callState.isRecording).thenReturn(false);
    when(() => callState.callParticipants).thenReturn(const []);
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    when(() => call.partialState<_Status>(any())).thenAnswer((invocation) {
      final CallStateSelector<_Status> selector =
          invocation.positionalArguments[0];
      return Stream.value(selector(callState));
    });
    when(() => call.callDurationStream).thenAnswer((_) => const Stream.empty());
  });

  /// Stubs a participant who is or is not presenting.
  ///
  /// Built and handed over separately rather than inline in a `thenReturn`:
  /// [MockCallParticipantState] stubs itself as it is constructed, and mocktail
  /// refuses a `when` opened inside another one.
  MockCallParticipantState participant({required bool presenting}) {
    final it = MockCallParticipantState();
    // The getter rather than the tracks behind it: the mock implements the
    // interface, so it derives nothing from `publishedTracks`.
    when(() => it.isScreenShareEnabled).thenReturn(presenting);
    return it;
  }

  void givenParticipants(List<MockCallParticipantState> participants) {
    when(() => callState.callParticipants).thenReturn(participants);
  }

  Future<void> pump(
    WidgetTester tester, {
    Duration elapsed = Duration.zero,
    StreamCallDurationBadge? badge,
  }) async {
    when(
      () => call.callDurationStream,
    ).thenAnswer((_) => Stream.value(elapsed));

    await tester.pumpWidget(
      // Centred rather than handed straight to the wrapper: the badge hugs its
      // content, and the surface would stretch it if anything let it.
      TestWrapper(
        child: Center(child: badge ?? StreamCallDurationBadge(call: call)),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The timestamp's spans, paired with the colour each one renders in.
  List<(String, Color?)> spans(WidgetTester tester) {
    final text = tester.widget<Text>(find.byType(Text));
    final root = text.textSpan! as TextSpan;

    return [
      for (final child in root.children!.cast<TextSpan>())
        (child.text!, child.style?.color),
    ];
  }

  group('the spoken duration', () {
    String spokenOf(WidgetTester tester) =>
        tester.widget<Text>(find.byType(Text)).semanticsLabel!;

    // Screen readers read the digits out one by one, so the badge announces
    // the elapsed time in words instead.
    testWidgets('announces the units rather than the digits', (tester) async {
      await pump(tester, elapsed: const Duration(minutes: 5, seconds: 3));

      expect(spokenOf(tester), 'Call duration 5 minutes 3 seconds');
    });

    testWidgets('says one of a unit in the singular', (tester) async {
      await pump(tester, elapsed: const Duration(minutes: 1, seconds: 1));

      expect(spokenOf(tester), 'Call duration 1 minute 1 second');
    });

    // `inMinutes` is 60 on the hour, so a guard on the total rather than on
    // the remainder announces a minutes part that reads zero.
    testWidgets('leaves out a unit that reads zero', (tester) async {
      await pump(tester, elapsed: const Duration(hours: 1));

      expect(spokenOf(tester), 'Call duration 1 hour 0 seconds');
    });

    testWidgets('announces a negative elapsed time as zero', (tester) async {
      await pump(tester, elapsed: const Duration(seconds: -8));

      expect(spokenOf(tester), 'Call duration 0 seconds');
    });
  });

  group('the timestamp', () {
    /// The part of the timestamp drawn in the darker colour.
    String elapsedOf(WidgetTester tester) =>
        spans(tester).where((it) => it.$2 != null).map((it) => it.$1).join();

    String wholeOf(WidgetTester tester) =>
        spans(tester).map((it) => it.$1).join();

    // The seconds are the exception to emphasising a unit whole: they run
    // through 01 to 09 once a minute, and carrying their leading zero would
    // have the badge flicker every minute.
    testWidgets('darkens only the 8 in 00:08', (tester) async {
      await pump(tester, elapsed: const Duration(seconds: 8));

      expect(wholeOf(tester), '00:08');
      expect(elapsedOf(tester), '8');
    });

    // A unit the clock has reached is emphasised whole, so the minutes carry
    // their leading zero and the colon after them.
    testWidgets('darkens 04:28 throughout', (tester) async {
      await pump(tester, elapsed: const Duration(minutes: 4, seconds: 28));

      expect(wholeOf(tester), '04:28');
      expect(elapsedOf(tester), '04:28');
    });

    testWidgets('darkens 01:00 throughout', (tester) async {
      await pump(tester, elapsed: const Duration(minutes: 1));

      expect(wholeOf(tester), '01:00');
      expect(elapsedOf(tester), '01:00');
    });

    testWidgets('darkens nothing in 00:00', (tester) async {
      await pump(tester);

      expect(wholeOf(tester), '00:00');
      expect(elapsedOf(tester), isEmpty);
    });

    // A device clock behind the server's `startedAt` makes the elapsed time
    // negative, which `padLeft` renders as `00:-8` rather than padding it.
    testWidgets('reads a negative elapsed time as 00:00', (tester) async {
      await pump(tester, elapsed: const Duration(seconds: -8));

      expect(wholeOf(tester), '00:00');
      expect(elapsedOf(tester), isEmpty);
    });

    testWidgets('rolls into hours rather than counting minutes up', (
      tester,
    ) async {
      await pump(
        tester,
        elapsed: const Duration(hours: 1, minutes: 3, seconds: 5),
      );

      expect(wholeOf(tester), '1:03:05');
      expect(elapsedOf(tester), '1:03:05');
    });

    // The reason for tabular figures: without them the pill twitches every
    // second as a 1 gives way to a 9.
    testWidgets('sets the digits in one width', (tester) async {
      await pump(tester);

      final style = tester.widget<Text>(find.byType(Text)).style!;

      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(style.height, 1);
    });
  });

  group('the indicators', () {
    Finder indicator(IconData icon) => find.byIcon(icon);

    const icons = StreamIcons();

    testWidgets('show nothing for a call with nothing to report', (
      tester,
    ) async {
      await pump(tester);

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('mark an encrypted call', (tester) async {
      when(() => callState.isE2eeEnabled).thenReturn(true);

      await pump(tester);

      expect(indicator(icons.verifiedFill), findsOneWidget);
    });

    testWidgets('mark a recorded call', (tester) async {
      when(() => callState.isRecording).thenReturn(true);

      await pump(tester);

      expect(indicator(icons.recordingFill), findsOneWidget);
    });

    testWidgets('mark a call somebody is presenting to', (tester) async {
      givenParticipants([
        participant(presenting: false),
        participant(presenting: true),
      ]);

      await pump(tester);

      expect(find.byType(Icon), findsOneWidget);
    });

    // The order is fixed rather than following the order they were switched
    // on, so the row stays stable as states come and go.
    testWidgets('order encryption, then recording, then screen share', (
      tester,
    ) async {
      when(() => callState.isE2eeEnabled).thenReturn(true);
      when(() => callState.isRecording).thenReturn(true);
      givenParticipants([participant(presenting: true)]);

      await pump(tester);

      final drawn = tester
          .widgetList<Icon>(find.byType(Icon))
          .map((it) => it.icon)
          .toList();

      expect(drawn.take(2), [icons.verifiedFill, icons.recordingFill]);
      expect(drawn, hasLength(3));
    });

    testWidgets('a show flag leaves one out', (tester) async {
      when(() => callState.isE2eeEnabled).thenReturn(true);
      when(() => callState.isRecording).thenReturn(true);

      await pump(
        tester,
        badge: StreamCallDurationBadge(call: call, showRecording: false),
      );

      expect(indicator(icons.verifiedFill), findsOneWidget);
      expect(indicator(icons.recordingFill), findsNothing);
    });
  });

  group('geometry', () {
    // The pill hugs its content, so it grows as indicators appear — but its
    // height does not, because the timestamp's box is shorter than an icon.
    testWidgets('is 32 tall with indicators and without', (tester) async {
      await pump(tester);

      expect(tester.getSize(find.byType(StreamCallDurationBadge)).height, 32);

      when(() => callState.isE2eeEnabled).thenReturn(true);
      await pump(tester);

      expect(tester.getSize(find.byType(StreamCallDurationBadge)).height, 32);
    });

    testWidgets('charges no gap for indicators it is not showing', (
      tester,
    ) async {
      await pump(tester);
      final bare = tester.getSize(find.byType(StreamCallDurationBadge)).width;

      when(() => callState.isE2eeEnabled).thenReturn(true);
      await pump(tester);
      final withIcon = tester
          .getSize(find.byType(StreamCallDurationBadge))
          .width;

      // The icon and the gap in front of the time, and nothing else.
      expect(withIcon - bare, 28);
    });

    // The default carries the properties that hold the pill still, so a style
    // naming only a size has to keep them.
    testWidgets('a style merges onto the default text style', (tester) async {
      await pump(
        tester,
        badge: StreamCallDurationBadge(
          call: call,
          style: const StreamCallDurationBadgeStyle(
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
      );

      final style = tester.widget<Text>(find.byType(Text)).style!;

      expect(style.fontSize, 18);
      expect(style.fontFeatures, contains(const FontFeature.tabularFigures()));
      expect(style.height, 1);
    });

    testWidgets('a style overrides the indicator colours', (tester) async {
      when(() => callState.isE2eeEnabled).thenReturn(true);

      await pump(
        tester,
        badge: StreamCallDurationBadge(
          call: call,
          style: const StreamCallDurationBadgeStyle(
            encryptedColor: Color(0xFFABCDEF),
          ),
        ),
      );

      expect(
        tester.widget<Icon>(find.byType(Icon)).color,
        const Color(0xFFABCDEF),
      );
    });
  });
}
