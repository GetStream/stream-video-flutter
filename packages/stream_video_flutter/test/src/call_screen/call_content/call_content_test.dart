// ignore_for_file: avoid_redundant_argument_values, deprecated_member_use_from_same_package
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  group('StreamCallContent', () {
    late MockCall mockCall;
    late MockCallState mockCallState;
    late MockCallParticipantState mockLocalParticipant;
    late MutableStateEmitter<CallState> callStateEmitter;

    setUp(() {
      mockCall = MockCall();
      mockCallState = MockCallState();
      mockLocalParticipant = MockCallParticipantState();
      callStateEmitter = MutableStateEmitter<CallState>(
        mockCallState,
        sync: true,
      );

      when(() => mockCall.state).thenAnswer((_) => callStateEmitter);
      when(
        () => mockCall.partialState<bool>(any()),
      ).thenAnswer((invocation) {
        final CallStateSelector<bool> selector =
            invocation.positionalArguments[0];
        final filtered = selector(mockCallState);
        return Stream.value(filtered);
      });
      when(
        () => mockCall.partialState<CallStatus>(any()),
      ).thenAnswer((_) => Stream.value(CallStatus.connected()));
      when(
        () => mockCall
            .partialState<({bool isScreenShareEnabled, CallStatus status})>(
              any(),
            ),
      ).thenAnswer((invocation) {
        return Stream.value(
          (
            isScreenShareEnabled: false,
            status: CallStatus.connected(),
          ),
        );
      });

      when(
        () => mockCallState.localParticipant,
      ).thenReturn(mockLocalParticipant);
      when(() => mockCallState.status).thenReturn(CallStatus.connected());
      when(() => mockCallState.callParticipants).thenReturn([]);

      when(() => mockLocalParticipant.isScreenShareEnabled).thenReturn(false);
      when(() => mockLocalParticipant.isAudioEnabled).thenReturn(true);
    });

    // A double-tap handler over the body held the pointer arena for
    // kDoubleTapTimeout, so a button inside it — a participant tile's overflow
    // menu above all — did not fire until 300ms after the finger lifted.
    testWidgets('a tap in the body is recognized in the same frame', (
      tester,
    ) async {
      var taps = 0;

      await tester.pumpWidget(
        SizedBox(
          width: 300,
          height: 300,
          child: TestWrapper(
            child: StreamCallContent(
              call: mockCall,
              callAppBarWidgetBuilder: (context, call) => AppBar(),
              callControlsWidgetBuilder: (context, call) => const SizedBox(),
              callParticipantsWidgetBuilder: (context, call) => Center(
                child: ElevatedButton(
                  onPressed: () => taps++,
                  child: const Text('In the body'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('In the body'));
      // No pump for the double-tap timeout: the press has to have landed
      // already.
      await tester.pump();

      expect(taps, 1);
    });

    // The previous session keeps playing the participants' media until a
    // rejoin lands, so the grid stays rather than going blank.
    testWidgets('a rejoin keeps the participants and says it is joining', (
      tester,
    ) async {
      final rejoining = CallStatusReconnecting(
        attempt: 5,
        isFastReconnectAttempt: false,
        phase: CallReconnectPhase.joining,
      );
      when(() => mockCallState.status).thenReturn(rejoining);
      when(
        () => mockCall.partialState<CallStatus>(any()),
      ).thenAnswer((_) => Stream.value(rejoining));
      when(
        () => mockCall
            .partialState<({bool isScreenShareEnabled, CallStatus status})>(
              any(),
            ),
      ).thenAnswer(
        (_) => Stream.value((isScreenShareEnabled: false, status: rejoining)),
      );

      await tester.pumpWidget(
        TestWrapper(
          child: StreamCallContent(
            call: mockCall,
            callAppBarWidgetBuilder: (context, call) => AppBar(),
            callControlsWidgetBuilder: (context, call) => const SizedBox(),
            callParticipantsWidgetBuilder: (context, call) =>
                const Text('Participants'),
          ),
        ),
      );
      // Not settled: the banner's spinner keeps turning.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Participants'), findsOne);
      expect(find.text('Joining… (attempt 5)'), findsOne);
    });

    testWidgets('before the first join the banner says it is connecting', (
      tester,
    ) async {
      final connecting = CallStatus.connecting();
      when(() => mockCallState.status).thenReturn(connecting);
      when(
        () => mockCall.partialState<CallStatus>(any()),
      ).thenAnswer((_) => Stream.value(connecting));
      when(
        () => mockCall
            .partialState<({bool isScreenShareEnabled, CallStatus status})>(
              any(),
            ),
      ).thenAnswer(
        (_) => Stream.value((isScreenShareEnabled: false, status: connecting)),
      );

      await tester.pumpWidget(
        TestWrapper(
          child: StreamCallContent(
            call: mockCall,
            callAppBarWidgetBuilder: (context, call) => AppBar(),
            callControlsWidgetBuilder: (context, call) => const SizedBox(),
            callParticipantsWidgetBuilder: (context, call) =>
                const Text('Participants'),
          ),
        ),
      );
      // Not settled: the banner's spinner keeps turning.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Participants'), findsNothing);
      expect(find.text('Connecting…'), findsOne);
    });

    testWidgets('a custom banner is built with the call status', (
      tester,
    ) async {
      final statuses = <CallStatus>[];

      await tester.pumpWidget(
        TestWrapper(
          child: StreamCallContent(
            call: mockCall,
            callAppBarWidgetBuilder: (context, call) => AppBar(),
            callControlsWidgetBuilder: (context, call) => const SizedBox(),
            callParticipantsWidgetBuilder: (context, call) => const SizedBox(),
            callConnectionBannerBuilder: (context, properties) {
              statuses.add(properties.status);
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pump();

      expect(statuses.last, CallStatus.connected());
      expect(find.byType(StreamCallConnectionBanner), findsNothing);
    });

    // The default bar goes into a `Scaffold.appBar` slot, which reserves
    // `preferredSize.height` — a constant the bar cannot theme. The height a
    // `CallAppBarTheme` sets is measured out for the slot instead.
    testWidgets('the default app bar takes its height from the theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: CallAppBarTheme(
            data: const CallAppBarThemeData(
              style: CallAppBarStyle(height: 120),
            ),
            child: StreamCallContent(
              call: mockCall,
              callControlsWidgetBuilder: (context, call) => const SizedBox(),
              callParticipantsWidgetBuilder: (context, call) =>
                  const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.getSize(find.byType(CallAppBar)).height, 120);
    });

    goldenTest(
      'renders correctly with extendBody true',
      fileName: 'stream_call_content_extend_body_true',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'default',
            child: _CallContentExample(
              mockCall,
              mockCallState,
              extendBody: true,
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'renders correctly with extendBody false',
      fileName: 'stream_call_content_extend_body_false',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'default',
            child: _CallContentExample(
              mockCall,
              mockCallState,
              extendBody: false,
            ),
          ),
        ],
      ),
    );
  });
}

class _CallContentExample extends StatelessWidget {
  const _CallContentExample(
    this.mockCall,
    this.mockCallState, {
    this.extendBody = false,
  });

  final MockCall mockCall;
  final MockCallState mockCallState;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: TestWrapper(
        child: StreamCallContent(
          call: mockCall,
          extendBody: extendBody,
          callAppBarWidgetBuilder: (context, call) => AppBar(
            title: const Text('Custom App Bar'),
          ),
          callParticipantsWidgetBuilder: (context, call) => const ColoredBox(
            color: Colors.green,
            child: Center(
              child: Text('Custom Participants View'),
            ),
          ),
          callControlsWidgetBuilder: (context, call) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
            ],
          ),
        ),
      ),
    );
  }
}
