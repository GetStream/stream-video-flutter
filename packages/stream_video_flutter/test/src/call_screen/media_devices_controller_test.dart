import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

const _builtInMic = RtcMediaDevice(
  id: 'mic-1',
  label: 'MacBook Pro Microphone',
  kind: RtcMediaDeviceKind.audioInput,
);
const _headset = RtcMediaDevice(
  id: 'mic-2',
  label: 'Jabra Evolve2 65',
  kind: RtcMediaDeviceKind.audioInput,
);
const _speakers = RtcMediaDevice(
  id: 'out-1',
  label: 'MacBook Pro Speakers',
  kind: RtcMediaDeviceKind.audioOutput,
);
const _frontCamera = RtcMediaDevice(
  id: 'cam-1',
  label: 'FaceTime HD Camera',
  kind: RtcMediaDeviceKind.videoInput,
);

void main() {
  late MockRtcMediaDeviceNotifier notifier;
  late StreamController<List<RtcMediaDevice>> deviceChanges;

  setUp(() {
    deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();
    notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(
      notifier.enumerateDevices,
    ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));
  });

  tearDown(() => deviceChanges.close());

  StreamMediaDevicesController build({
    StreamMediaDeviceSelected? onAudioInputSelected,
    StreamMediaDeviceSelected? onAudioOutputSelected,
    StreamMediaDeviceSelected? onVideoInputSelected,
  }) {
    final controller = StreamMediaDevicesController(
      deviceNotifier: notifier,
      onAudioInputSelected: onAudioInputSelected,
      onAudioOutputSelected: onAudioOutputSelected,
      onVideoInputSelected: onVideoInputSelected,
    );
    addTearDown(controller.dispose);
    return controller;
  }

  group('StreamMediaDevicesController', () {
    test('asks for an enumeration up front', () {
      build();
      verify(notifier.enumerateDevices).called(1);
    });

    test('partitions a device change by kind', () async {
      final controller = build();

      deviceChanges.add([_builtInMic, _headset, _speakers, _frontCamera]);
      await pumpEventQueue();

      expect(controller.audioInputs, [_builtInMic, _headset]);
      expect(controller.audioOutputs, [_speakers]);
      expect(controller.videoInputs, [_frontCamera]);
    });

    test('notifies listeners when the device list changes', () async {
      final controller = build();
      var notifications = 0;
      controller.addListener(() => notifications++);

      deviceChanges.add([_builtInMic]);
      await pumpEventQueue();

      expect(notifications, 1);
    });

    test('starts on the system default for every kind', () {
      final controller = build();

      expect(controller.selectedAudioInput, isNull);
      expect(controller.selectedAudioOutput, isNull);
      expect(controller.selectedVideoInput, isNull);
    });

    test('records a selection and runs its hook', () async {
      RtcMediaDevice? applied;
      final controller = build(onAudioInputSelected: (d) => applied = d);

      await controller.selectAudioInput(_headset);

      expect(controller.selectedAudioInput, _headset);
      expect(applied, _headset);
    });

    test('selecting null goes back to the system default', () async {
      final applied = <RtcMediaDevice?>[];
      final controller = build(onAudioInputSelected: applied.add);

      await controller.selectAudioInput(_headset);
      await controller.selectAudioInput(null);

      expect(controller.selectedAudioInput, isNull);
      expect(applied, [_headset, null]);
    });

    // Reselecting the live device would restart the camera for nothing.
    test('picking the device already in use does nothing', () async {
      var applied = 0;
      final controller = build(onVideoInputSelected: (_) => applied++);

      await controller.selectVideoInput(_frontCamera);
      await controller.selectVideoInput(_frontCamera);

      expect(applied, 1);
    });

    test('keeps the three selections independent', () async {
      final controller = build();

      await controller.selectAudioInput(_headset);
      await controller.selectAudioOutput(_speakers);
      await controller.selectVideoInput(_frontCamera);

      expect(controller.selectedAudioInput, _headset);
      expect(controller.selectedAudioOutput, _speakers);
      expect(controller.selectedVideoInput, _frontCamera);
    });

    test('stops listening once disposed', () async {
      final controller = StreamMediaDevicesController(deviceNotifier: notifier)
        ..dispose();

      deviceChanges.add([_builtInMic]);
      await pumpEventQueue();

      expect(controller.audioInputs, isEmpty);
    });
  });
}
