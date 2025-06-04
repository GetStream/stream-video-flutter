// ignore_for_file: avoid_redundant_argument_values

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';

void main() {
  group('StreamCallContent', () {
    late MockCall mockCall;
    late MockCallState mockCallState;
    late MockCallParticipantState mockLocalParticipant;

    setUp(() {
      mockCall = MockCall();
      mockCallState = MockCallState();
      mockLocalParticipant = MockCallParticipantState();

      when(() => mockCallState.localParticipant)
          .thenReturn(mockLocalParticipant);
      when(() => mockCallState.status).thenReturn(CallStatus.connected());
      when(() => mockCallState.callParticipants).thenReturn([]);
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
  const _CallContentExample(this.mockCall, this.mockCallState,
      {this.extendBody = false});

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
          callState: mockCallState,
          extendBody: extendBody,
          callAppBarBuilder: (context, call, callState) => AppBar(
            title: const Text('Custom App Bar'),
          ),
          callParticipantsBuilder: (context, call, callState) =>
              const ColoredBox(
            color: Colors.green,
            child: Center(
              child: Text('Custom Participants View'),
            ),
          ),
          callControlsBuilder: (context, call, callState) => Row(
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

class MockCall extends Mock implements Call {}

class MockCallState extends Mock implements CallState {}

class MockCallParticipantState extends Mock implements CallParticipantState {}
