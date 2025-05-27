import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';

void main() {
  testWidgets('ToggleMicrophoneOption', (tester) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();

    when(() => localParticipant.isAudioEnabled).thenReturn(true);
    when(() => call.setMicrophoneEnabled(enabled: any(named: 'enabled')))
        .thenAnswer(
      (_) async => const Result.success(none),
    );

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
  });
}

// ignore: avoid_implementing_value_types
class MockCallParticipantState extends Mock implements CallParticipantState {}

class MockCall extends Mock implements Call {}
