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

  // The refusal used to be dropped on the floor: `setMicrophoneEnabled`
  // returns a Result, and the button's state comes from the call's own
  // participant state, which does not change on failure. A viewer without
  // `sendAudio` pressed the button and got no movement, no message, no log.
  testWidgets('ToggleMicrophoneOption reports a refusal', (tester) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();
    Object? reported;

    when(() => localParticipant.isAudioEnabled).thenReturn(true);
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.failure(_refused));

    await tester.pumpWidget(
      TestWrapper(
        child: ToggleMicrophoneOption(
          localParticipant: localParticipant,
          call: call,
          onError: (error) => reported = error,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.voiceFill));
    await tester.pumpAndSettle();

    expect(reported, _refused);
  });

  testWidgets('ToggleCameraOption reports a refusal', (tester) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();
    Object? reported;

    when(() => localParticipant.isVideoEnabled).thenReturn(true);
    when(
      () => call.setCameraEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.failure(_refused));

    await tester.pumpWidget(
      TestWrapper(
        child: ToggleCameraOption(
          localParticipant: localParticipant,
          call: call,
          onError: (error) => reported = error,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.videoFill));
    await tester.pumpAndSettle();

    expect(reported, _refused);
  });

  // A control with no listener still has to survive the refusal rather than
  // throw out of the button's callback.
  testWidgets('ToggleMicrophoneOption survives a refusal unwatched', (
    tester,
  ) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();

    when(() => localParticipant.isAudioEnabled).thenReturn(true);
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.failure(_refused));

    await tester.pumpWidget(
      TestWrapper(
        child: ToggleMicrophoneOption(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.voiceFill));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

const _refused = 'the call refused';
