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

    // An empty list before the platform has answered means "not asked yet",
    // not "none" — a control that disables itself for want of a device would
    // otherwise flash an error on startup.
    test('says whether the platform has answered yet', () async {
      final controller = build();

      expect(controller.hasEnumerated, isFalse);
      expect(controller.videoInputs, isEmpty);

      deviceChanges.add([]);
      await pumpEventQueue();

      expect(controller.hasEnumerated, isTrue);
      expect(controller.videoInputs, isEmpty);
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

  group('StreamMediaDevicesController reconciles its selection', () {
    test('drops a picked device the platform stops reporting', () async {
      final controller = build();
      deviceChanges.add(const [_headset, _builtInMic]);
      await pumpEventQueue();

      await controller.selectAudioInput(_headset);
      expect(controller.selectedAudioInput, _headset);

      // The headset is unplugged.
      deviceChanges.add(const [_builtInMic]);
      await pumpEventQueue();

      // Back to the system default, which is what the platform will do anyway
      // and what the menu can actually draw a selected row for.
      expect(controller.selectedAudioInput, isNull);
    });

    test('re-reads a device the platform has renamed', () async {
      const unnamed = RtcMediaDevice(
        id: 'mic-1',
        label: '',
        kind: RtcMediaDeviceKind.audioInput,
      );
      const named = RtcMediaDevice(
        id: 'mic-1',
        label: 'Built-in Microphone',
        kind: RtcMediaDeviceKind.audioInput,
      );

      final controller = build();
      deviceChanges.add(const [unnamed]);
      await pumpEventQueue();
      await controller.selectAudioInput(unnamed);

      // Labels only arrive once permission is granted.
      deviceChanges.add(const [named]);
      await pumpEventQueue();

      expect(controller.selectedAudioInput?.label, 'Built-in Microphone');
    });

    test('puts the selection back when applying it is rejected', () async {
      final controller = StreamMediaDevicesController(
        deviceNotifier: notifier,
        onAudioInputSelected: (device) {
          if (device == _headset) throw StateError('device in use');
        },
      );
      addTearDown(controller.dispose);

      deviceChanges.add(const [_headset, _builtInMic]);
      await pumpEventQueue();

      await controller.selectAudioInput(_builtInMic);
      await controller.selectAudioInput(_headset);

      // The picker would otherwise go on naming a device nothing switched to.
      expect(controller.selectedAudioInput, _builtInMic);
    });

    test('records why the devices could not be listed', () async {
      when(notifier.enumerateDevices).thenAnswer(
        (_) async =>
            Result.failure(StateError('no platform'), StackTrace.empty),
      );

      final controller = build();
      await pumpEventQueue();

      // Distinct from "the platform found nothing", so a picker can say which.
      expect(controller.enumerationError, isA<StateError>());
      expect(controller.hasEnumerated, isTrue);
      expect(controller.audioInputs, isEmpty);
    });
  });

  group('StreamMediaDevicesController.forCall', () {
    late MockCall call;

    setUp(() {
      call = MockCall();
      when(() => call.setVideoInputDevice(_frontCamera)).thenAnswer(
        (_) async => const Result.success(none),
      );
    });

    StreamMediaDevicesController build() {
      final controller = StreamMediaDevicesController.forCall(
        call,
        deviceNotifier: notifier,
      );
      addTearDown(controller.dispose);
      return controller;
    }

    test('drives the call when a camera is picked', () async {
      final controller = build();
      deviceChanges.add(const [_frontCamera]);
      await pumpEventQueue();

      await controller.selectVideoInput(_frontCamera);

      verify(() => call.setVideoInputDevice(_frontCamera)).called(1);
      expect(controller.selectedVideoInput, _frontCamera);
    });

    test('offers no system-default row, having no way to apply one', () {
      // Call's device setters take a device, so there is nothing to hand the
      // choice back to; a row for it would move the radio and change nothing.
      expect(build().supportsSystemDefault, isFalse);
    });

    test('keeps the old camera when the call refuses to switch', () async {
      when(() => call.setVideoInputDevice(_frontCamera)).thenAnswer(
        (_) async => Result.failure(StateError('blocked'), StackTrace.empty),
      );

      final controller = build();
      deviceChanges.add(const [_frontCamera]);
      await pumpEventQueue();

      await controller.selectVideoInput(_frontCamera);

      // Otherwise the menu shows a camera the call is not using.
      expect(controller.selectedVideoInput, isNull);
    });
  });
}
