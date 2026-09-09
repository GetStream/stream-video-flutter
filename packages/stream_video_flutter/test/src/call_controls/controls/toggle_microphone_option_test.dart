import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  // The icons the widget resolves off `context.streamIcons`; the defaults are
  // what TestWrapper's theme installs.
  const icons = StreamIcons();

  testWidgets('ToggleMicrophoneOption', (tester) async {
    var isAudioEnabled = true;

    final localParticipant = MockCallParticipantState();
    final call = MockCall();

    when(() => localParticipant.isAudioEnabled).thenReturn(isAudioEnabled);
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer(
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

    expect(find.byIcon(icons.voiceFill), findsOneWidget);
    expect(find.byIcon(icons.voiceOffFill), findsNothing);

    await tester.tap(find.byIcon(icons.voiceFill));
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
    expect(find.byIcon(icons.voiceFill), findsNothing);
    expect(find.byIcon(icons.voiceOffFill), findsOneWidget);
  });
}
