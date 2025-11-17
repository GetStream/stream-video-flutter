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
    late MockStateEmitter<CallState> mockCallStateEmitter;

    setUp(() {
      mockCall = MockCall();
      mockCallState = MockCallState();
      mockLocalParticipant = MockCallParticipantState();
      mockCallStateEmitter = MockStateEmitter<CallState>();

      when(() => mockCallStateEmitter.value).thenReturn(mockCallState);
      when(() => mockCall.state).thenReturn(mockCallStateEmitter);
      when(
        () => mockCall.partialState<CallParticipantState?>(any()),
      ).thenAnswer((invocation) {
        final CallStateSelector<CallParticipantState?> selector =
            invocation.positionalArguments[0];
        final filtered = selector(mockCallState);
        return Stream.value(filtered);
      });
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
