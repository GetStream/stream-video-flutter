import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

class _MockDynascaleManager extends Mock implements DynascaleManager {}

const _camera = RtcMediaDevice(
  id: 'cam-1',
  label: 'MacBook Pro Camera',
  kind: RtcMediaDeviceKind.videoInput,
);
const _microphone = RtcMediaDevice(
  id: 'mic-1',
  label: 'MacBook Pro Microphone',
  kind: RtcMediaDeviceKind.audioInput,
);
const _otherMicrophone = RtcMediaDevice(
  id: 'mic-2',
  label: 'Studio Microphone',
  kind: RtcMediaDeviceKind.audioInput,
);
const _speaker = RtcMediaDevice(
  id: 'spk-1',
  label: 'MacBook Pro Speakers',
  kind: RtcMediaDeviceKind.audioOutput,
);

/// The call settings with noise cancellation in [mode].
CallSettings _settings(NoiseCancellationSettingsMode mode) => CallSettings(
  audio: StreamAudioSettings(
    noiseCancellation: StreamNoiceCancellingSettings(mode: mode),
  ),
);

void main() {
  setUpAll(() {
    registerFallbackValue(const RtcVideoDimension(width: 0, height: 0));
  });

  late MockCall call;
  late MockCallState callState;
  late _MockDynascaleManager dynascale;
  late StreamController<IncomingVideoSettings?> incomingVideo;
  late StreamController<List<RtcMediaDevice>> deviceChanges;
  late StreamMediaDevicesController devices;
  late List<RtcMediaDevice?> pickedMicrophones;

  setUp(() {
    call = MockCall();
    callState = MockCallState();
    dynascale = _MockDynascaleManager();
    incomingVideo = StreamController<IncomingVideoSettings?>.broadcast();
    deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();
    pickedMicrophones = [];

    when(() => callState.localParticipant).thenReturn(null);
    when(() => callState.isAudioProcessing).thenReturn(false);
    when(() => call.isAudioProcessorConfigured).thenReturn(true);
    when(
      () => callState.settings,
    ).thenReturn(_settings(NoiseCancellationSettingsMode.available));
    final emitter = MutableStateEmitter<CallState>(callState, sync: true);
    when(() => call.state).thenAnswer((_) => emitter);
    // Runs the real selectors against the stubbed state.
    when(
      () => call.partialState<CallParticipantState?>(any()),
    ).thenAnswer((invocation) {
      final CallStateSelector<CallParticipantState?> selector =
          invocation.positionalArguments.first;
      return Stream.value(selector(callState));
    });
    when(
      () => call.partialState<({bool available, bool on})>(any()),
    ).thenAnswer((invocation) {
      final CallStateSelector<({bool available, bool on})> selector =
          invocation.positionalArguments.first;
      return Stream.value(selector(callState));
    });

    when(() => call.dynascaleManager).thenReturn(dynascale);
    when(() => dynascale.incomingVideoSettings).thenReturn(null);
    when(
      () => dynascale.incomingVideoSettingsStream,
    ).thenAnswer((_) => incomingVideo.stream);
    when(
      () => call.setPreferredIncomingVideoResolution(any()),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => call.setIncomingVideoEnabled(any()),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      call.startAudioProcessing,
    ).thenAnswer((_) async => const Result.success(none));
    when(
      call.stopAudioProcessing,
    ).thenAnswer((_) async => const Result.success(none));

    final notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(
      notifier.enumerateDevices,
    ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));
    devices = StreamMediaDevicesController(
      deviceNotifier: notifier,
      supportsSystemDefault: false,
      onAudioInputSelected: pickedMicrophones.add,
    );
    addTearDown(devices.dispose);
  });

  tearDown(() async {
    await incomingVideo.close();
    await deviceChanges.close();
  });

  Future<void> pump(
    WidgetTester tester, {
    List<RtcMediaDevice> available = const [_camera, _microphone, _speaker],
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    tester.view.physicalSize = const Size(600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TestWrapper(
        platform: TargetPlatform.macOS,
        child: Directionality(
          textDirection: textDirection,
          child: SingleChildScrollView(
            child: StreamDeviceSettings(call: call, devices: devices),
          ),
        ),
      ),
    );
    deviceChanges.add(available);
    await tester.pumpAndSettle();
  }

  group('StreamDeviceSettings', () {
    testWidgets('offers the camera, microphone and speaker in use', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('Select Camera'), findsOneWidget);
      expect(find.text('Select Microphone'), findsOneWidget);
      expect(find.text('Select Speaker'), findsOneWidget);
      expect(find.text('Incoming Video Quality'), findsOneWidget);
    });

    testWidgets('leaves the speaker out where the platform lists none', (
      tester,
    ) async {
      await pump(tester, available: const [_camera, _microphone]);

      expect(find.text('Select Microphone'), findsOneWidget);
      expect(find.text('Select Speaker'), findsNothing);
    });

    testWidgets('picking a microphone hands it to the controller', (
      tester,
    ) async {
      await pump(
        tester,
        available: const [_camera, _microphone, _otherMicrophone, _speaker],
      );

      // The field, by its icon: the heading above it is not part of what
      // opens the menu.
      await tester.tap(find.byIcon(const StreamIcons().voiceFill));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Studio Microphone').last);
      await tester.pumpAndSettle();

      expect(pickedMicrophones.map((it) => it?.id), ['mic-2']);
    });

    group('noise cancellation', () {
      testWidgets('is offered where the call is configured for it', (
        tester,
      ) async {
        await pump(tester);

        expect(find.text('Noise Cancellation'), findsOneWidget);
        expect(
          tester.widget<StreamSwitch>(find.byType(StreamSwitch)).props.value,
          isFalse,
        );
      });

      testWidgets('is left out where the call has it disabled', (
        tester,
      ) async {
        when(
          () => callState.settings,
        ).thenReturn(_settings(NoiseCancellationSettingsMode.disabled));
        await pump(tester);

        expect(find.text('Noise Cancellation'), findsNothing);
        expect(find.byType(StreamSwitch), findsNothing);
      });

      testWidgets('is left out where no audio processor is configured', (
        tester,
      ) async {
        when(() => call.isAudioProcessorConfigured).thenReturn(false);
        await pump(tester);

        expect(find.text('Noise Cancellation'), findsNothing);
      });

      testWidgets('turning the switch on starts audio processing', (
        tester,
      ) async {
        await pump(tester);

        await tester.tap(find.byType(StreamSwitch));
        verify(call.startAudioProcessing).called(1);
        verifyNever(call.stopAudioProcessing);
      });

      testWidgets('turning the switch off stops audio processing', (
        tester,
      ) async {
        when(() => callState.isAudioProcessing).thenReturn(true);
        await pump(tester);

        await tester.tap(find.byType(StreamSwitch));
        verify(call.stopAudioProcessing).called(1);
        verifyNever(call.startAudioProcessing);
      });
    });

    group('incoming video quality', () {
      testWidgets('shows the quality the call is set to', (tester) async {
        when(() => dynascale.incomingVideoSettings).thenReturn(
          IncomingVideoSettings(
            enabled: true,
            preferredResolution: const RtcVideoDimension(
              width: 1280,
              height: 720,
            ),
            participants: const {},
          ),
        );
        await pump(tester);

        expect(find.text('HD 720p'), findsOneWidget);
      });

      testWidgets('follows a change made elsewhere', (tester) async {
        await pump(tester);
        expect(find.text('Auto'), findsOneWidget);

        incomingVideo.add(
          IncomingVideoSettings(
            enabled: false,
            preferredResolution: null,
            participants: const {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Disable video'), findsOneWidget);
      });

      testWidgets('picking a resolution asks the call for it', (tester) async {
        await pump(tester);

        await tester.tap(find.text('Auto'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Full HD 1080p'));
        await tester.pumpAndSettle();

        verify(
          () => call.setPreferredIncomingVideoResolution(
            const RtcVideoDimension(width: 1920, height: 1080),
          ),
        ).called(1);
      });

      testWidgets('disabling video turns incoming video off', (tester) async {
        await pump(tester);

        await tester.tap(find.text('Auto'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Disable video'));
        await tester.pumpAndSettle();

        verify(() => call.setIncomingVideoEnabled(false)).called(1);
      });
    });

    testWidgets('right to left, the device icons are at the right edge', (
      tester,
    ) async {
      await pump(tester, textDirection: TextDirection.rtl);

      final field = find.ancestor(
        of: find.byIcon(const StreamIcons().voiceFill),
        matching: find.byType(StreamSelectInput),
      );
      expect(
        tester.getCenter(find.byIcon(const StreamIcons().voiceFill)).dx,
        greaterThan(tester.getCenter(field).dx),
      );
    });
  });

  group('StreamDeviceSettingsTab', () {
    testWidgets('is labelled "Device" with a gear', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamModalWindow(
            tabs: [StreamDeviceSettingsTab(call: call, devices: devices)],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Device'), findsNWidgets(2));
      expect(find.byIcon(const StreamIcons().settingsFill), findsOneWidget);
      expect(find.byType(StreamDeviceSettings), findsOneWidget);
    });
  });

  group('IncomingVideoQuality', () {
    test('rounds a resolution down to the nearest choice', () {
      IncomingVideoQuality at(int height) => IncomingVideoQuality.of(
        IncomingVideoSettings(
          enabled: null,
          preferredResolution: RtcVideoDimension(
            width: height * 16 ~/ 9,
            height: height,
          ),
          participants: const {},
        ),
      );

      expect(IncomingVideoQuality.of(null), IncomingVideoQuality.auto);
      expect(at(2160), IncomingVideoQuality.p2160);
      expect(at(1440), IncomingVideoQuality.p1080);
      expect(at(720), IncomingVideoQuality.p720);
      expect(at(360), IncomingVideoQuality.p144);
      expect(at(100), IncomingVideoQuality.auto);
    });
  });

  group('goldens', () {
    setUp(() {
      final local = MockCallParticipantState();
      when(() => local.name).thenReturn('Katie Miler');
      when(() => local.image).thenReturn(null);
      when(() => local.isSpeaking).thenReturn(false);
      when(() => local.isAudioEnabled).thenReturn(true);
      when(() => local.isVideoEnabled).thenReturn(true);
      when(
        () => local.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => local.reaction).thenReturn(null);
      when(() => callState.localParticipant).thenReturn(local);
    });

    for (final brightness in Brightness.values) {
      streamGoldenTest(
        'StreamDeviceSettings renders the device fields',
        fileName: 'stream_device_settings',
        brightness: brightness,
        constraints: const BoxConstraints.tightFor(width: 520, height: 720),
        pumpBeforeTest: (tester) async {
          deviceChanges.add(const [_camera, _microphone, _speaker]);
          await tester.pumpAndSettle();
        },
        builder: () => StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              // A real renderer needs a live call. A flat fill stands in for
              // the camera.
              participantTile: (context, props) => DefaultStreamParticipantTile(
                props: props.copyWith(
                  videoRendererBuilder: (_, _, _) =>
                      const ColoredBox(color: Color(0xFF6E7A8A)),
                ),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: StreamDeviceSettings(call: call, devices: devices),
          ),
        ),
      );
    }
  });
}
