// ignore_for_file: avoid_implementing_value_types

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_filters/stream_video_filters_platform_interface.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

class MockCall extends Mock implements Call {}

class MockCallState extends Mock implements CallState {}

class MockCallParticipantState extends Mock implements CallParticipantState {}

class MockStateEmitter<T> extends Mock implements StateEmitter<T> {}

class MockRtcTrack extends Mock implements RtcTrack {}

class MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

/// Records every native call, in order, into the shared [log].
class FakeStreamVideoFiltersPlatform extends StreamVideoFiltersPlatform {
  FakeStreamVideoFiltersPlatform(this.log);

  final List<String> log;
  bool supported = true;

  /// When set, `registerBlurEffectProcessors` waits for it before completing.
  Completer<void>? blurRegistration;

  @override
  Future<bool?> isBackgroundEffectSupported() async => supported;

  @override
  Future<void> registerBlurEffectProcessors() async {
    log.add('registerBlur');
    await blurRegistration?.future;
  }

  @override
  Future<void> registerFullFrameBlurEffectProcessor() async {
    log.add('registerFullFrameBlur');
  }

  @override
  Future<void> registerImageEffectProcessors({
    required String backgroundImageUrl,
  }) async {
    log.add('registerImage:$backgroundImageUrl');
  }

  @override
  Future<void> unregisterAllFilters() async {
    log.add('unregisterAll');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const webRtcChannel = MethodChannel('FlutterWebRTC.Method');
  const trackId = 'local-video-track';

  late List<String> log;
  late FakeStreamVideoFiltersPlatform platform;
  late MockCall call;
  late MockCallParticipantState localParticipant;
  late StreamController<bool?> videoEnabled;

  setUpAll(() {
    registerFallbackValue((CallState _) => false);
    registerFallbackValue(SfuTrackType.video);
  });

  setUp(() {
    log = [];
    platform = FakeStreamVideoFiltersPlatform(log);
    StreamVideoFiltersPlatform.instance = platform;

    StreamVideoEffectsManager.isBlurRegistered = false;
    StreamVideoEffectsManager.isFullFrameBlurRegistered = false;
    StreamVideoEffectsManager.isImageRegistered.clear();
    StreamVideoEffectsManager.isCustomEffectRegistered.clear();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(webRtcChannel, (methodCall) async {
          if (methodCall.method == 'setVideoEffects') {
            final args = methodCall.arguments as Map<Object?, Object?>;
            log.add('setVideoEffects:${args['names']}');
          }
          return null;
        });

    final mediaTrack = MockMediaStreamTrack();
    when(() => mediaTrack.id).thenReturn(trackId);
    final track = MockRtcTrack();
    when(() => track.mediaTrack).thenReturn(mediaTrack);

    localParticipant = MockCallParticipantState();
    when(() => localParticipant.trackIdPrefix).thenReturn('prefix');

    final callState = MockCallState();
    when(() => callState.preferences).thenReturn(DefaultCallPreferences());
    when(() => callState.localParticipant).thenReturn(localParticipant);
    final stateEmitter = MockStateEmitter<CallState>();
    when(() => stateEmitter.value).thenReturn(callState);

    videoEnabled = StreamController<bool?>.broadcast();

    call = MockCall();
    when(() => call.state).thenReturn(stateEmitter);
    when(() => call.getTrack(any(), any())).thenReturn(track);
    // Like the real stream, replays the current value (camera on) on subscribe.
    when(() => call.partialState<bool?>(any())).thenAnswer((_) async* {
      yield true;
      yield* videoEnabled.stream;
    });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(webRtcChannel, null);
    await videoEnabled.close();
  });

  group('unregisterAllFilters', () {
    test('detaches the effects before unregistering natively', () async {
      final manager = StreamVideoEffectsManager(call);
      await manager.applyBackgroundBlurFilter(BlurIntensity.medium);
      log.clear();

      await manager.unregisterAllFilters();

      expect(log, ['setVideoEffects:[]', 'unregisterAll']);
      expect(manager.appliedVideoEffects, isEmpty);
    });

    test('still unregisters when the detach fails', () async {
      final manager = StreamVideoEffectsManager(call);
      await manager.applyBackgroundBlurFilter(BlurIntensity.medium);
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(webRtcChannel, (methodCall) async {
            if (methodCall.method == 'setVideoEffects') {
              throw PlatformException(code: 'No factory owns trackId');
            }
            return null;
          });

      await manager.unregisterAllFilters();

      expect(log, ['unregisterAll']);
      expect(StreamVideoEffectsManager.isBlurRegistered, isFalse);
    });

    test('applying a filter afterwards registers it again', () async {
      final manager = StreamVideoEffectsManager(call);
      await manager.applyBackgroundBlurFilter(BlurIntensity.medium);
      await manager.applyBackgroundImageFilter('image.png');
      await manager.unregisterAllFilters();
      log.clear();

      await manager.applyBackgroundBlurFilter(BlurIntensity.light);
      await manager.applyBackgroundImageFilter('image.png');

      expect(log, [
        'registerBlur',
        'setVideoEffects:[BackgroundBlurLight]',
        'registerImage:image.png',
        'setVideoEffects:[VirtualBackground-image.png]',
      ]);
    });

    test('turning the camera back on does not re-apply old effects', () async {
      final manager = StreamVideoEffectsManager(call);
      await manager.applyBackgroundBlurFilter(BlurIntensity.medium);
      await manager.unregisterAllFilters();
      log.clear();

      videoEnabled.add(true);
      await pumpEventQueue();

      expect(log, isEmpty);
    });

    test('does nothing when effects are not supported', () async {
      platform.supported = false;
      final manager = StreamVideoEffectsManager(call);

      await manager.unregisterAllFilters();

      expect(log, isEmpty);
    });

    test('waits for a register that is already in flight', () async {
      final otherManager = StreamVideoEffectsManager(call);
      final manager = StreamVideoEffectsManager(call);
      platform.blurRegistration = Completer<void>();

      final register = otherManager.ensureBlurEffectRegistered();
      await pumpEventQueue();
      final unregister = manager.unregisterAllFilters();
      await pumpEventQueue();

      expect(log, ['registerBlur']);

      platform.blurRegistration!.complete();
      await register;
      await unregister;

      expect(log, ['registerBlur', 'setVideoEffects:[]', 'unregisterAll']);
      expect(StreamVideoEffectsManager.isBlurRegistered, isFalse);
    });

    test('waits for an apply that is already in flight', () async {
      final manager = StreamVideoEffectsManager(call);
      platform.blurRegistration = Completer<void>();

      final apply = manager.applyBackgroundBlurFilter(BlurIntensity.medium);
      await pumpEventQueue();
      final unregister = manager.unregisterAllFilters();
      await pumpEventQueue();

      // The detach must not run between the register and the attach.
      expect(log, ['registerBlur']);

      platform.blurRegistration!.complete();
      await apply;
      await unregister;

      expect(log, [
        'registerBlur',
        'setVideoEffects:[BackgroundBlurMedium]',
        'setVideoEffects:[]',
        'unregisterAll',
      ]);
      expect(manager.appliedVideoEffects, isEmpty);
      expect(StreamVideoEffectsManager.isBlurRegistered, isFalse);

      // The apply's camera-on subscription is gone with it.
      log.clear();
      videoEnabled.add(true);
      await pumpEventQueue();
      expect(log, isEmpty);
    });

    test(
      "another manager's effect registers again when the camera turns on",
      () async {
        final manager = StreamVideoEffectsManager(call);
        final otherManager = StreamVideoEffectsManager(call);
        await manager.applyBackgroundBlurFilter(BlurIntensity.medium);
        await otherManager.unregisterAllFilters();
        log.clear();

        videoEnabled.add(true);
        await pumpEventQueue();

        expect(log, ['registerBlur', 'setVideoEffects:[BackgroundBlurMedium]']);
        expect(StreamVideoEffectsManager.isBlurRegistered, isTrue);
      },
    );
  });

  group('apply', () {
    test('does not re-apply on the replayed camera state', () async {
      final manager = StreamVideoEffectsManager(call);

      await manager.applyBackgroundBlurFilter(BlurIntensity.medium);
      await pumpEventQueue();

      expect(log, ['registerBlur', 'setVideoEffects:[BackgroundBlurMedium]']);
    });

    test('re-applies when the camera is turned back on', () async {
      final manager = StreamVideoEffectsManager(call);
      await manager.applyBackgroundBlurFilter(BlurIntensity.medium);
      await pumpEventQueue();
      log.clear();

      videoEnabled.add(false);
      videoEnabled.add(true);
      await pumpEventQueue();

      expect(log, ['setVideoEffects:[BackgroundBlurMedium]']);
    });

    test('calls run in the order they were made when not awaited', () async {
      final manager = StreamVideoEffectsManager(call);

      final disable = manager.disableAllFilters();
      final apply = manager.applyVideoEffects(['Custom']);
      await Future.wait([disable, apply]);

      expect(log, ['setVideoEffects:[]', 'setVideoEffects:[Custom]']);
      expect(manager.appliedVideoEffects, ['Custom']);
    });

    test('a disable made while a custom effect registers wins', () async {
      final manager = StreamVideoEffectsManager(call);

      final apply = manager.applyCustomEffect(
        'Custom',
        registerEffectProcessorCallback: () async => log.add('registerCustom'),
      );
      final disable = manager.disableAllFilters();
      await Future.wait([apply, disable]);

      expect(log, ['registerCustom', 'setVideoEffects:[]']);
      expect(manager.appliedVideoEffects, isEmpty);
    });

    test('a custom effect callback can call back into a manager', () async {
      final manager = StreamVideoEffectsManager(call);

      await manager
          .applyCustomEffect(
            'Custom',
            registerEffectProcessorCallback: () async {
              await manager.ensureBlurEffectRegistered();
              log.add('registerCustom');
            },
          )
          .timeout(const Duration(seconds: 1));

      expect(log, [
        'registerBlur',
        'registerCustom',
        'setVideoEffects:[Custom]',
      ]);
      expect(manager.appliedVideoEffects, ['Custom']);
    });

    test('an apply in flight when disposing attaches nothing', () async {
      final manager = StreamVideoEffectsManager(call);
      platform.blurRegistration = Completer<void>();

      final apply = manager.applyBackgroundBlurFilter(BlurIntensity.medium);
      await pumpEventQueue();
      await manager.dispose();
      platform.blurRegistration!.complete();
      await apply;

      expect(log, ['registerBlur']);

      videoEnabled.add(false);
      videoEnabled.add(true);
      await pumpEventQueue();
      expect(log, ['registerBlur']);
    });
  });

  group('disableAllFilters', () {
    test('waits for an apply that is already in flight', () async {
      final manager = StreamVideoEffectsManager(call);
      platform.blurRegistration = Completer<void>();

      final apply = manager.applyBackgroundBlurFilter(BlurIntensity.medium);
      await pumpEventQueue();
      final disable = manager.disableAllFilters();
      await pumpEventQueue();

      expect(log, ['registerBlur']);

      platform.blurRegistration!.complete();
      await apply;
      await disable;

      expect(log, [
        'registerBlur',
        'setVideoEffects:[BackgroundBlurMedium]',
        'setVideoEffects:[]',
      ]);
      expect(manager.appliedVideoEffects, isEmpty);
    });
  });
}
