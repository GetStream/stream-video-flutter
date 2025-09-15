import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

typedef FilteredCallState = ({
  bool isAudioEnabled,
  bool canSendAudio,
  CallStatus status,
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
  });
}

FilteredCallState createCallState({
  bool? isAudioEnabled,
  bool? canSendAudio,
  CallStatus? status,
}) {
  return (
    isAudioEnabled: isAudioEnabled ?? true,
    canSendAudio: canSendAudio ?? true,
    status: status ?? CallStatus.joined(),
  );
}
