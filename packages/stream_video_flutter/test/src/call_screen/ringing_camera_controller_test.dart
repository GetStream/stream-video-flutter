import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const CallConnectOptions()));

  late MockCall call;
  late MockCallState state;
  late CallConnectOptions options;

  setUp(() {
    call = MockCall();
    state = MockCallState();
    options = const CallConnectOptions();
    stubRingingCall(call, state);
    // The mock has no storage of its own, so the setter is captured and the
    // getter reads back what was last written.
    when(() => call.connectOptions).thenAnswer((_) => options);
    when(() => call.connectOptions = any()).thenAnswer((invocation) {
      return options =
          invocation.positionalArguments.first as CallConnectOptions;
    });
  });

  StreamRingingCameraController controllerWith({
    MockRtcLocalCameraTrack? track,
    Future<RtcLocalCameraTrack> Function()? open,
  }) => StreamRingingCameraController(
    call: call,
    openCameraTrack: open ?? () async => track ?? mockCameraTrack(),
  );

  test('the camera is handed to the call as a provided track', () async {
    final track = mockCameraTrack();
    final controller = controllerWith(track: track);

    await controller.setCameraEnabled(enabled: true);

    expect(controller.cameraEnabled, isTrue);
    expect(controller.cameraTrack, track);
    expect(options.camera, isA<TrackProvided>());
    // isEnabled reads false for a provided track, which is why the screen asks
    // the controller rather than the option.
    expect(options.camera.isEnabled, isFalse);

    controller.dispose();
  });

  test(
    'turning the camera off stops the track and clears the option',
    () async {
      final track = mockCameraTrack();
      final controller = controllerWith(track: track);

      await controller.setCameraEnabled(enabled: true);
      await controller.setCameraEnabled(enabled: false);

      expect(controller.cameraEnabled, isFalse);
      expect(options.camera, isA<TrackDisabled>());
      verify(track.stop).called(1);

      controller.dispose();
    },
  );

  test(
    'a camera that will not open is reported, and the call carries on',
    () async {
      final controller = controllerWith(
        open: () async => throw Exception('nope'),
      );

      await controller.setCameraEnabled(enabled: true);

      expect(controller.cameraError, isNotNull);
      expect(controller.cameraEnabled, isFalse);
      expect(options.camera, isA<TrackDisabled>());

      controller.dispose();
    },
  );

  test(
    'a track that lands after the camera was turned off is stopped',
    () async {
      final track = mockCameraTrack();
      final opened = Completer<RtcLocalCameraTrack>();
      final controller = controllerWith(open: () => opened.future);

      final opening = controller.setCameraEnabled(enabled: true);
      await controller.setCameraEnabled(enabled: false);
      opened.complete(track);
      await opening;

      expect(controller.cameraEnabled, isFalse);
      verify(track.stop).called(1);

      controller.dispose();
    },
  );

  test('a cancelled call turns the camera off on the way out', () async {
    final track = mockCameraTrack();
    final controller = controllerWith(track: track);
    await controller.setCameraEnabled(enabled: true);

    when(
      () => state.status,
    ).thenReturn(
      CallStatus.disconnected(
        const DisconnectReason.cancelled(byUserId: 'local'),
      ),
    );
    controller.dispose();

    verify(track.stop).called(1);
  });

  test('a call the callee picked up keeps the camera running', () async {
    final track = mockCameraTrack();
    final controller = controllerWith(track: track);
    await controller.setCameraEnabled(enabled: true);

    // The call owns the track now — it was handed over as TrackOption.provided
    // and stopping it here would cut the video the caller just joined with.
    when(
      () => state.status,
    ).thenReturn(CallStatus.outgoing(acceptedByCallee: true));
    controller.dispose();

    verifyNever(track.stop);
  });

  test('the microphone is recorded, not opened', () {
    final controller = controllerWith();

    controller.setMicrophoneEnabled(enabled: true);
    expect(options.microphone, isA<TrackEnabled>());

    controller.toggleMicrophone();
    expect(options.microphone, isA<TrackDisabled>());

    controller.dispose();
  });
}
