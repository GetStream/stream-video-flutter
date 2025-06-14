// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  testWidgets('ToggleMicrophoneOption', (tester) async {
    var isAudioEnabled = true;

    final localParticipant = MockCallParticipantState();
    final call = MockCall();

    when(() => localParticipant.isAudioEnabled).thenReturn(isAudioEnabled);
    when(() => call.setMicrophoneEnabled(enabled: any(named: 'enabled')))
        .thenAnswer(
      (invocation) async {
        isAudioEnabled =
            invocation.namedArguments[const Symbol('enabled')] as bool;
        return const Result.success(none);
      },
    );

    // Microphone is enabled
    await tester.pumpWidget(
      TestWrapper(
        child: ToggleMicrophoneOption(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );

    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
    expect(find.byIcon(Icons.mic_off_rounded), findsNothing);

    await tester.tap(find.byIcon(Icons.mic_rounded));
    await tester.pumpAndSettle();

    verify(() => call.setMicrophoneEnabled(enabled: false)).called(1);

    // Microphone is disabled
    when(() => localParticipant.isAudioEnabled).thenReturn(isAudioEnabled);
    await tester.pumpWidget(
      TestWrapper(
        child: ToggleMicrophoneOption(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );
    expect(find.byIcon(Icons.mic_rounded), findsNothing);
    expect(find.byIcon(Icons.mic_off_rounded), findsOneWidget);
  });
}
