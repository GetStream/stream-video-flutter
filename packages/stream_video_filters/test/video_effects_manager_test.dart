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
    when(
      () => call.partialState<bool?>(any()),
    ).thenAnswer((_) => videoEnabled.stream);
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

      expect(log, ['registerBlur', 'setVideoEffects:[]']);

      platform.blurRegistration!.complete();
      await register;
      await unregister;

      expect(log.last, 'unregisterAll');
      expect(StreamVideoEffectsManager.isBlurRegistered, isFalse);
    });
  });
}
