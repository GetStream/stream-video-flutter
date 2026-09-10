import 'dart:async';

import 'package:flutter/services.dart';
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
// What Chrome reports alongside the real devices: the one it has picked, under
// the reserved `default` id.
const _defaultMic = RtcMediaDevice(
  id: StreamMediaDevicesController.platformDefaultDeviceId,
  label: 'Default - WH-1000XM3 (Bluetooth)',
  kind: RtcMediaDeviceKind.audioInput,
);
const _defaultSpeaker = RtcMediaDevice(
  id: StreamMediaDevicesController.platformDefaultDeviceId,
  label: 'Default - WH-1000XM3 (Bluetooth)',
  kind: RtcMediaDeviceKind.audioOutput,
);
// What a phone reports instead: routes under their own ids, and no `default`
// entry anywhere in the list.
const _phoneSpeaker = RtcMediaDevice(
  id: 'speaker',
  label: 'Speaker',
  kind: RtcMediaDeviceKind.audioOutput,
);
const _earpiece = RtcMediaDevice(
  id: 'earpiece',
  label: 'Earpiece',
  kind: RtcMediaDeviceKind.audioOutput,
);
const _phoneMic = RtcMediaDevice(
  id: 'microphone-bottom',
  label: 'Bottom Microphone',
  kind: RtcMediaDeviceKind.audioInput,
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

    // Both mean "let the platform pick", and a menu over this controller
    // already draws a row for null, so listing the browser's own entry offered
    // the same choice twice.
    test('drops the browser default, which a row already stands for', () async {
      final controller = build();

      deviceChanges.add(const [
        _defaultMic,
        _builtInMic,
        _defaultSpeaker,
        _speakers,
      ]);
      await pumpEventQueue();

      expect(controller.audioInputs, [_builtInMic]);
      expect(controller.audioOutputs, [_speakers]);
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

      // The list was empty before the push too, so emptiness proves nothing
      // on its own: what matters is that the event was not taken in at all,
      // since notifying a disposed ChangeNotifier throws.
      expect(controller.hasEnumerated, isFalse);
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

      // The reason is what tells "could not be asked" from "asked and found
      // nothing": both arrive here, and only the reason separates them.
      expect(controller.enumerationError?.cause, isA<StateError>());
      expect(
        controller.enumerationError?.reason,
        StreamDeviceFailureReason.unknown,
      );
      expect(controller.hasEnumerated, isTrue);
      expect(controller.audioInputs, isEmpty);
    });

    // `reportsNo` is true either way, so a control that badged itself off it
    // alone could not say whether a retry was worth offering.
    test('separates a failed enumeration from absent hardware', () async {
      when(notifier.enumerateDevices).thenAnswer(
        (_) async => Result.failure(
          PlatformException(code: 'NotAllowedError'),
          StackTrace.empty,
        ),
      );

      final controller = build();
      await pumpEventQueue();

      expect(controller.reportsNo(controller.audioInputs), isTrue);
      expect(controller.enumerationFailed, isTrue);
      expect(
        controller.enumerationError?.reason,
        StreamDeviceFailureReason.permissionDenied,
      );
    });

    test('a platform reporting no device has not failed', () async {
      when(notifier.enumerateDevices).thenAnswer(
        (_) async => Result.failure(
          PlatformException(code: 'NotFoundError'),
          StackTrace.empty,
        ),
      );

      final controller = build();
      await pumpEventQueue();

      expect(controller.reportsNo(controller.audioInputs), isTrue);
      expect(controller.enumerationFailed, isFalse);
    });
  });

  group('StreamMediaDevicesController.forCall', () {
    late MockCall call;
    late MutableStateEmitter<CallState> callState;

    setUpAll(() => registerFallbackValue(_builtInMic));

    /// The call using [audioInput], [audioOutput] and [videoInput].
    void inUse({
      RtcMediaDevice? audioInput,
      RtcMediaDevice? audioOutput,
      RtcMediaDevice? videoInput,
    }) => callState.value = callState.value.copyWith(
      audioInputDevice: audioInput,
      audioOutputDevice: audioOutput,
      videoInputDevice: videoInput,
    );

    setUp(() {
      call = MockCall();
      callState = MutableStateEmitter<CallState>(
        CallState(
          currentUserId: 'current-user',
          callCid: StreamCallCid.from(
            type: StreamCallType.defaultType(),
            id: 'test-call',
          ),
          preferences: DefaultCallPreferences(),
        ),
        sync: true,
      );
      when(() => call.state).thenAnswer((_) => callState);
      when(() => call.setVideoInputDevice(_frontCamera)).thenAnswer(
        (_) async => const Result.success(none),
      );
      when(
        () => call.setAudioInputDevice(any()),
      ).thenAnswer((_) async => const Result.success(none));
      when(
        () => call.setAudioOutputDevice(any()),
      ).thenAnswer((_) async => const Result.success(none));
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

    // A call has no "revert to the system default" setter, so committing null
    // moved the radio button while the call kept the device it had.
    test('refuses the system default where it cannot be applied', () async {
      final applied = <RtcMediaDevice?>[];
      final controller = StreamMediaDevicesController(
        deviceNotifier: notifier,
        supportsSystemDefault: false,
        onAudioInputSelected: applied.add,
      );
      addTearDown(controller.dispose);

      deviceChanges.add(const [_headset, _builtInMic]);
      await pumpEventQueue();

      await controller.selectAudioInput(_headset);
      expect(controller.selectedAudioInput, _headset);

      await expectLater(
        () => controller.selectAudioInput(null),
        throwsAssertionError,
      );

      // The pick stands, and the hook was never told to do the impossible.
      expect(controller.selectedAudioInput, _headset);
      expect(applied, [_headset]);
    });
    // The bug this fixes: with no way to draw "let the platform pick", every
    // row in an in-call menu was unselected until something was picked.
    group("the platform's own choice", () {
      // Nothing here draws a row for null, so the browser's own entry is the
      // only handle on its choice and is left in the list.
      test('is listed, there being no row for it', () async {
        final controller = build();
        deviceChanges.add(const [_defaultMic, _builtInMic]);
        await pumpEventQueue();

        expect(controller.audioInputs, [_defaultMic, _builtInMic]);
      });

      test('is what an unpicked selection resolves to', () async {
        final controller = build();
        deviceChanges.add(const [_defaultMic, _builtInMic, _defaultSpeaker]);
        await pumpEventQueue();

        expect(controller.selectedAudioInput, _defaultMic);
        expect(controller.selectedAudioOutput, _defaultSpeaker);
      });

      test('gives way to a device the user picks', () async {
        final controller = build();
        deviceChanges.add(const [_defaultMic, _builtInMic]);
        await pumpEventQueue();

        await controller.selectAudioInput(_builtInMic);

        expect(controller.selectedAudioInput, _builtInMic);
      });

      // Already in use, so there is nothing to switch to.
      test('applies nothing when its own row is picked', () async {
        final controller = build();
        deviceChanges.add(const [_defaultMic, _builtInMic]);
        await pumpEventQueue();

        await controller.selectAudioInput(_defaultMic);

        verifyNever(() => call.setAudioInputDevice(any()));
      });

      test('is resolved again once a picked device is unplugged', () async {
        final controller = build();
        deviceChanges.add(const [_defaultMic, _headset]);
        await pumpEventQueue();
        await controller.selectAudioInput(_headset);

        deviceChanges.add(const [_defaultMic]);
        await pumpEventQueue();

        // The platform falls back to its own choice, so the menu says so.
        expect(controller.selectedAudioInput, _defaultMic);
      });

      test('stays null where the platform reports no such device', () async {
        final controller = build();
        deviceChanges.add(const [_builtInMic, _headset]);
        await pumpEventQueue();

        expect(controller.selectedAudioInput, isNull);
      });
    });

    // Only a browser reports a `default` device, so on a phone the selection
    // comes from what the call says it is using.
    group('the device the call is using', () {
      test('is where the selection starts', () async {
        inUse(audioInput: _phoneMic, audioOutput: _earpiece);
        final controller = build();
        deviceChanges.add(const [_phoneMic, _phoneSpeaker, _earpiece]);
        await pumpEventQueue();

        expect(controller.selectedAudioInput, _phoneMic);
        expect(controller.selectedAudioOutput, _earpiece);
      });

      // The call is already on it, so switching to it is not this
      // controller's to do.
      test('is taken without being applied', () async {
        final controller = build();
        deviceChanges.add(const [_phoneSpeaker, _earpiece]);
        inUse(audioOutput: _earpiece);
        await pumpEventQueue();

        expect(controller.selectedAudioOutput, _earpiece);
        verifyNever(() => call.setAudioOutputDevice(any()));
      });

      // What iOS's own route picker does: the call records the new route, and
      // a menu has to mark it rather than the device picked before.
      test('moves the selection when the call switches route', () async {
        final controller = build();
        deviceChanges.add(const [_phoneSpeaker, _earpiece]);
        inUse(audioOutput: _earpiece);
        await pumpEventQueue();

        inUse(audioOutput: _phoneSpeaker);
        await pumpEventQueue();

        expect(controller.selectedAudioOutput, _phoneSpeaker);
      });

      test('notifies listeners when it changes', () async {
        final controller = build();
        deviceChanges.add(const [_phoneSpeaker, _earpiece]);
        await pumpEventQueue();

        var notifications = 0;
        controller.addListener(() => notifications++);
        inUse(audioOutput: _earpiece);
        await pumpEventQueue();

        expect(notifications, 1);
      });

      // A call resolves an output before it has an input to match it with, so
      // the kinds it has not named have to be left alone.
      test('leaves a kind it names no device for alone', () async {
        final controller = build();
        deviceChanges.add(const [_phoneMic, _phoneSpeaker, _earpiece]);
        await pumpEventQueue();
        await controller.selectAudioInput(_phoneMic);

        inUse(audioOutput: _earpiece);
        await pumpEventQueue();

        expect(controller.selectedAudioInput, _phoneMic);
        expect(controller.selectedAudioOutput, _earpiece);
      });

      test('gives way to a device the user picks', () async {
        final controller = build();
        deviceChanges.add(const [_phoneSpeaker, _earpiece]);
        inUse(audioOutput: _earpiece);
        await pumpEventQueue();

        await controller.selectAudioOutput(_phoneSpeaker);

        expect(controller.selectedAudioOutput, _phoneSpeaker);
        verify(() => call.setAudioOutputDevice(_phoneSpeaker)).called(1);
      });
    });
  });

  group('StreamMediaDevicesController with overlapping selections', () {
    // The revert used to restore whatever was picked before *its own* effect
    // started, throwing away a newer pick that had already succeeded.
    test('a slow rejection does not undo a newer selection', () async {
      final rejectHeadset = Completer<void>();

      final controller = build(
        onAudioInputSelected: (device) {
          if (device?.id == _headset.id) {
            return rejectHeadset.future.then(
              (_) => throw StateError('device busy'),
            );
          }
          return null;
        },
      );

      deviceChanges.add(const [_headset, _builtInMic]);
      await pumpEventQueue();

      // Pick the headset, then change to the built-in before the headset's
      // effect has come back.
      final first = controller.selectAudioInput(_headset);
      await controller.selectAudioInput(_builtInMic);
      expect(controller.selectedAudioInput, _builtInMic);

      rejectHeadset.complete();
      await first;
      await pumpEventQueue();

      // The built-in mic is what the user last picked and what worked, so it
      // is what the picker keeps.
      expect(controller.selectedAudioInput, _builtInMic);
    });
  });
}
