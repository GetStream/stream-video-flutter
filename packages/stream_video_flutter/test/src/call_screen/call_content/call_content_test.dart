// ignore_for_file: avoid_redundant_argument_values, deprecated_member_use_from_same_package
import 'dart:async';

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

    testWidgets('the body clears the side insets', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(800, 600),
            padding: EdgeInsets.only(left: 12, right: 84),
          ),
          child: TestWrapper(
            child: StreamCallContent(
              call: mockCall,
              callAppBarWidgetBuilder: (context, call) => AppBar(),
              callControlsWidgetBuilder: (context, call) => const SizedBox(),
              callParticipantsWidgetBuilder: (context, call) =>
                  const SizedBox.expand(key: Key('participants')),
            ),
          ),
        ),
      );
      await tester.pump();

      final rect = tester.getRect(find.byKey(const Key('participants')));
      expect(rect.left, 12);
      expect(rect.right, 800 - 84);
    });

    /// Builds the content on [status], with participants that say so. A
    /// status added to the returned controller reaches it after that.
    Future<StreamController<CallStatus>> pumpContent(
      WidgetTester tester,
      CallStatus status, {
      CallConnectionBannerBuilder? callConnectionBannerBuilder,
    }) async {
      final statuses = StreamController<CallStatus>.broadcast();
      addTearDown(statuses.close);

      when(() => mockCallState.status).thenReturn(status);
      when(() => mockCall.partialState<CallStatus>(any())).thenAnswer(
        (_) async* {
          yield status;
          yield* statuses.stream;
        },
      );
      when(
        () => mockCall
            .partialState<({bool isScreenShareEnabled, CallStatus status})>(
              any(),
            ),
      ).thenAnswer((_) async* {
        yield (isScreenShareEnabled: false, status: status);
        yield* statuses.stream.map(
          (status) => (isScreenShareEnabled: false, status: status),
        );
      });

      await tester.pumpWidget(
        TestWrapper(
          child: StreamCallContent(
            call: mockCall,
            callAppBarWidgetBuilder: (context, call) => AppBar(),
            callControlsWidgetBuilder: (context, call) => const SizedBox(),
            callParticipantsWidgetBuilder: (context, call) =>
                const Text('Participants'),
            callConnectionBannerBuilder: callConnectionBannerBuilder,
          ),
        ),
      );
      // Not settled: the banner's spinner keeps turning.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      return statuses;
    }

    // The previous session keeps playing the participants' media until the
    // call is connected again or has left, so the grid stays rather than
    // going blank.
    final keptStatuses = <String, (CallStatus, String)>{
      'offline': (
        CallStatusReconnecting(
          attempt: 1,
          isFastReconnectAttempt: true,
          phase: CallReconnectPhase.offline,
        ),
        "You're offline. Waiting for the network…",
      ),
      'a fast reconnect': (
        CallStatusReconnecting(
          attempt: 1,
          isFastReconnectAttempt: true,
          phase: CallReconnectPhase.waiting,
        ),
        'Reconnecting…',
      ),
      'a rejoin': (
        CallStatusReconnecting(
          attempt: 5,
          isFastReconnectAttempt: false,
          phase: CallReconnectPhase.joining,
        ),
        'Joining… (attempt 5)',
      ),
      'a migration': (CallStatus.migrating(), 'Moving to another server…'),
      'a failed reconnect': (
        CallStatusReconnectionFailed(),
        "Couldn't reconnect to the call",
      ),
    };

    for (final MapEntry(key: name, value: (status, notice))
        in keptStatuses.entries) {
      testWidgets('$name keeps the participants and says so', (tester) async {
        await pumpContent(tester, status);

        expect(find.text('Participants'), findsOne);
        expect(find.text(notice), findsOne);
      });
    }

    testWidgets('before the first join the banner says it is connecting', (
      tester,
    ) async {
      await pumpContent(tester, CallStatus.connecting());

      expect(find.text('Participants'), findsNothing);
      expect(find.text('Connecting…'), findsOne);
    });

    testWidgets('a custom banner is built with each call status', (
      tester,
    ) async {
      final built = <CallStatus>[];
      final reconnecting = CallStatusReconnecting(
        attempt: 1,
        isFastReconnectAttempt: true,
      );

      final statuses = await pumpContent(
        tester,
        CallStatus.connected(),
        callConnectionBannerBuilder: (context, properties) {
          built.add(properties.status);
          return const SizedBox();
        },
      );
      statuses.add(reconnecting);
      // One frame to deliver the status, one to build for it.
      await tester.pump();
      await tester.pump();

      expect(built.first, CallStatus.connected());
      expect(built.last, reconnecting);
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
