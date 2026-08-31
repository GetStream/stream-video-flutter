import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

typedef FilteredCallState = ({
  bool isAudioEnabled,
  bool canSendAudio,
  CallStatus status,
  String? audioInputDeviceId,
});

void main() {
  group('SpeakingWhileMutedRecognition', () {
    late MockCall call;
    late MockAudioRecognition audioRecognition;
    late StreamController<FilteredCallState> callStateStreamController;

    setUp(() {
      call = MockCall();
      audioRecognition = MockAudioRecognition();
      callStateStreamController = StreamController.broadcast();
      when(() => call.partialState<FilteredCallState>(any())).thenAnswer(
        (_) => callStateStreamController.stream,
      );

      when(
        () => audioRecognition.start(
          onSoundStateChanged: any(named: 'onSoundStateChanged'),
        ),
      ).thenAnswer((_) => Future.value());
      when(
        () => audioRecognition.stop(),
      ).thenAnswer((_) => Future<void>.value());
      when(
        () => audioRecognition.dispose(),
      ).thenAnswer((_) => Future<void>.value());
    });

    tearDown(() {
      callStateStreamController.close();
    });

    test('Test muting', () async {
      final sut = SpeakingWhileMutedRecognition(
        call: call,
        audioRecognition: audioRecognition,
      );
      await Future<void>.delayed(Duration.zero);

      verifyNever(
        () => audioRecognition.start(
          onSoundStateChanged: any(named: 'onSoundStateChanged'),
        ),
      );

      callStateStreamController.add(createCallState(isAudioEnabled: false));

      await Future<void>.delayed(Duration.zero);

      verify(
        () => audioRecognition.start(
          onSoundStateChanged: any(named: 'onSoundStateChanged'),
        ),
      ).called(1);

      await sut.dispose();
    });

    test('Test muting while recognition is active', () async {
      final sut = SpeakingWhileMutedRecognition(
        call: call,
        audioRecognition: audioRecognition,
      );
      await sut.start();

      await Future<void>.delayed(Duration.zero);

      verify(
        () => audioRecognition.start(
          onSoundStateChanged: any(named: 'onSoundStateChanged'),
        ),
      ).called(1);

      callStateStreamController.add(createCallState(isAudioEnabled: false));

      await Future<void>.delayed(Duration.zero);
      // still active, so no new start
      verifyNever(
        () => audioRecognition.start(
          onSoundStateChanged: any(named: 'onSoundStateChanged'),
        ),
      );

      await sut.dispose();
    });

    test('Test unmuting when recognition is active', () async {
      final sut = SpeakingWhileMutedRecognition(
        call: call,
        audioRecognition: audioRecognition,
      );

      await sut.start();

      await Future<void>.delayed(Duration.zero);

      callStateStreamController.add(createCallState(isAudioEnabled: true));

      await Future<void>.delayed(Duration.zero);

      verify(
        () => audioRecognition.stop(),
      ).called(1);

      await sut.dispose();
    });

    test('Test unmuting when recognition is not active', () async {
      final sut = SpeakingWhileMutedRecognition(
        call: call,
        audioRecognition: audioRecognition,
      );

      await Future<void>.delayed(Duration.zero);

      callStateStreamController.add(createCallState(isAudioEnabled: true));

      await Future<void>.delayed(Duration.zero);

      verifyNever(
        () => audioRecognition.stop(),
      );

      await sut.dispose();
    });

    test(
      'Test audio input device change while active restarts detection',
      () async {
        final sut = SpeakingWhileMutedRecognition(
          call: call,
          audioRecognition: audioRecognition,
        );

        callStateStreamController.add(
          createCallState(isAudioEnabled: false, audioInputDeviceId: 'mic-a'),
        );
        await Future<void>.delayed(Duration.zero);

        verify(
          () => audioRecognition.start(
            onSoundStateChanged: any(named: 'onSoundStateChanged'),
          ),
        ).called(1);

        // Switching the microphone while muted restarts detection so it
        // follows the newly selected device.
        callStateStreamController.add(
          createCallState(isAudioEnabled: false, audioInputDeviceId: 'mic-b'),
        );
        await Future<void>.delayed(Duration.zero);

        verify(() => audioRecognition.stop()).called(1);
        verify(
          () => audioRecognition.start(
            onSoundStateChanged: any(named: 'onSoundStateChanged'),
          ),
        ).called(1);

        // Same device again — no restart.
        callStateStreamController.add(
          createCallState(
            isAudioEnabled: false,
            canSendAudio: true,
            audioInputDeviceId: 'mic-b',
          ),
        );
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => audioRecognition.stop());
        verifyNever(
          () => audioRecognition.start(
            onSoundStateChanged: any(named: 'onSoundStateChanged'),
          ),
        );

        await sut.dispose();
      },
    );

    test(
      'Test unmuting while a device-change restart is in flight '
      'leaves detection stopped',
      () async {
        final blockedStop = Completer<void>();
        var stopCalls = 0;
        when(() => audioRecognition.stop()).thenAnswer((_) {
          stopCalls++;
          // The restart's teardown hangs, so the unmute below lands while the
          // previous capture is still being torn down.
          return stopCalls == 1 ? blockedStop.future : Future<void>.value();
        });

        final sut = SpeakingWhileMutedRecognition(
          call: call,
          audioRecognition: audioRecognition,
        );

        callStateStreamController.add(
          createCallState(isAudioEnabled: false, audioInputDeviceId: 'mic-a'),
        );
        await Future<void>.delayed(Duration.zero);

        verify(
          () => audioRecognition.start(
            onSoundStateChanged: any(named: 'onSoundStateChanged'),
          ),
        ).called(1);

        // Switching microphone starts a restart, which blocks in stop().
        callStateStreamController.add(
          createCallState(isAudioEnabled: false, audioInputDeviceId: 'mic-b'),
        );
        await Future<void>.delayed(Duration.zero);

        // The user unmutes before that teardown completes.
        callStateStreamController.add(
          createCallState(isAudioEnabled: true, audioInputDeviceId: 'mic-b'),
        );
        await Future<void>.delayed(Duration.zero);

        // Let the teardown finish and the restart resume.
        blockedStop.complete();
        await Future<void>.delayed(Duration.zero);

        // Detection must not come back up: the user is unmuted, so restarting
        // would flag ordinary speech as "speaking while muted" and, on web,
        // hold a second getUserMedia capture open for the rest of the call.
        verifyNever(
          () => audioRecognition.start(
            onSoundStateChanged: any(named: 'onSoundStateChanged'),
          ),
        );

        await sut.dispose();
      },
    );

    test('Test disconnecting from call', () async {
      final sut = SpeakingWhileMutedRecognition(
        call: call,
        audioRecognition: audioRecognition,
      );

      callStateStreamController.add(
        createCallState(isAudioEnabled: false),
      );

      await Future<void>.delayed(Duration.zero);

      callStateStreamController.add(
        createCallState(
          isAudioEnabled: false,
          status: CallStatus.disconnected(DisconnectReason.ended()),
        ),
      );

      await Future<void>.delayed(Duration.zero);

      verify(
        () => audioRecognition.stop(),
      ).called(1);

      await sut.dispose();
    });

    test(
      'Test a transition queued before dispose does not touch state after it',
      () async {
        // Web: [start] sits on getUserMedia while the permission prompt is up.
        final blockedStart = Completer<void>();
        when(
          () => audioRecognition.start(
            onSoundStateChanged: any(named: 'onSoundStateChanged'),
          ),
        ).thenAnswer((_) => blockedStart.future);

        final sut = SpeakingWhileMutedRecognition(
          call: call,
          audioRecognition: audioRecognition,
        );

        Object? streamError;
        final subscription = sut.stream.listen(
          (_) {},
          onError: (Object e) => streamError = e,
        );

        // Mute: detection starts and blocks on the prompt.
        callStateStreamController.add(createCallState(isAudioEnabled: false));
        await Future<void>.delayed(Duration.zero);

        // Unmute: the stop queues behind the blocked start.
        callStateStreamController.add(createCallState(isAudioEnabled: true));
        await Future<void>.delayed(Duration.zero);

        // The user leaves while the prompt is still up.
        await sut.dispose();

        // The prompt is answered afterwards, releasing the queued stop.
        blockedStart.complete();
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(streamError, isNull);
        // The queued stop must still tear the recogniser down; before the
        // guard it threw on the state write and never got this far.
        verify(() => audioRecognition.stop()).called(1);

        await subscription.cancel();
      },
    );
  });
}

FilteredCallState createCallState({
  bool? isAudioEnabled,
  bool? canSendAudio,
  CallStatus? status,
  String? audioInputDeviceId,
}) {
  return (
    isAudioEnabled: isAudioEnabled ?? true,
    canSendAudio: canSendAudio ?? true,
    status: status ?? CallStatus.joined(),
    audioInputDeviceId: audioInputDeviceId,
  );
}
