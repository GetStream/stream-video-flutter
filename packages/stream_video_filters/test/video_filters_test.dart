// ignore_for_file: implementation_imports, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:stream_video_filters/src/video_effect_registry.dart';
import 'package:stream_video_filters/stream_video_filters.dart';
import 'package:stream_video_filters/stream_video_filters_platform_interface.dart';
import 'package:stream_webrtc_flutter/src/native/native_webrtc_capabilities.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeFiltersPlatform platform;
  late List<String> attached;
  var failAttach = false;

  setUp(() {
    platform = _FakeFiltersPlatform();
    StreamVideoFiltersPlatform.instance = platform;
    VideoEffectRegistry.reset();
    debugWebRtcCapabilitiesOverride = _capabilities(isAndroid: true);

    attached = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('FlutterWebRTC.Method'), (
          call,
        ) async {
          if (call.method == 'setVideoEffects') {
            if (failAttach) throw PlatformException(code: 'attach');
            final args = call.arguments as Map;
            attached.add(
              '${args['trackId']}: ${(args['names'] as List).join(',')}',
            );
          }
          return null;
        });
  });

  tearDown(() {
    failAttach = false;
    debugWebRtcCapabilitiesOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('FlutterWebRTC.Method'),
          null,
        );
  });

  final filters = <String, (NativeVideoFilter Function(), String)>{
    'BackgroundBlurFilter': (
      () => BackgroundBlurFilter(intensity: BlurIntensity.heavy),
      'blur',
    ),
    'VirtualBackgroundFilter': (
      () => VirtualBackgroundFilter('assets/bg.jpg'),
      'image assets/bg.jpg',
    ),
    'FullFrameBlurFilter': (FullFrameBlurFilter.new, 'full frame blur'),
  };

  for (final MapEntry(key: name, value: (create, registration))
      in filters.entries) {
    group(name, () {
      test('registers its processor once and attaches it', () async {
        final filter = create();

        await filter.apply(_input('cam-1'));
        await filter.apply(_input('cam-2'));

        expect(platform.registrations, [registration]);
        expect(attached, [
          'cam-1: ${filter.effectName}',
          'cam-2: ${filter.effectName}',
        ]);
      });

      test('stop detaches it from the track', () async {
        final filter = create();
        final input = _input('cam-1');

        final result = await filter.apply(input);
        await result.stop!(_stopDetails);

        expect(result.output, same(input.stream));
        expect(attached.last, 'cam-1: ');
      });

      test('an unregister during its register waits for the attach', () async {
        final filter = create();
        platform.registering = Completer<void>();

        final applying = filter.apply(_input('cam-1'));
        await pumpEventQueue();
        final unregistering = StreamVideoFilters.unregisterAllFilters();
        await pumpEventQueue();
        expect(platform.unregisters, 0);

        platform.registering!.complete();
        platform.registering = null;
        await applying;
        await unregistering;
        await filter.apply(_input('cam-2'));

        expect(platform.unregisters, 1);
        expect(attached.first, 'cam-1: ${filter.effectName}');
        expect(platform.registrations, [registration, registration]);
      });

      test('fails, attaching nothing, when it cannot register', () async {
        final filter = create();
        platform.registerError = PlatformException(code: 'UNSUPPORTED');

        await expectLater(
          filter.apply(_input('cam-1')),
          throwsA(isA<PlatformException>()),
        );
        platform.registerError = null;
        await filter.apply(_input('cam-2'));

        expect(attached, ['cam-2: ${filter.effectName}']);
      });

      test('registers again after unregisterAllFilters', () async {
        final filter = create();

        await filter.apply(_input('cam-1'));
        await StreamVideoFilters.unregisterAllFilters();
        await filter.apply(_input('cam-2'));

        expect(platform.registrations, [registration, registration]);
      });
    });
  }

  test('one blur registration covers every intensity', () async {
    await BackgroundBlurFilter(
      intensity: BlurIntensity.heavy,
    ).apply(_input('cam-1'));
    await BackgroundBlurFilter(
      intensity: BlurIntensity.light,
    ).apply(_input('cam-2'));

    expect(platform.registrations, ['blur']);
  });

  test('equal filters register their processor once', () async {
    await BackgroundBlurFilter().apply(_input('cam-1'));
    await BackgroundBlurFilter().apply(_input('cam-2'));

    expect(platform.registrations, ['blur']);
  });

  test('CustomVideoFilter registers through its callback once', () async {
    final registered = <String>[];
    final filter = CustomVideoFilter(
      'grayscale',
      onRegister: (registration) async =>
          registered.add(registration.effectName),
    );

    await filter.apply(_input('cam-1'));
    await filter.apply(_input('cam-2'));

    expect(registered, ['grayscale']);
    expect(attached, [
      'cam-1: grayscale',
      'cam-2: grayscale',
    ]);
  });

  group('two filters on one track', () {
    test('both run, the later one last', () async {
      final blur = BackgroundBlurFilter();
      final moderation = FullFrameBlurFilter();

      await blur.apply(_input('cam-1'));
      await moderation.apply(_input('cam-1'));

      expect(attached.last, 'cam-1: BackgroundBlurMedium,FullFrameBlur');
    });

    test('stopping one leaves the other attached', () async {
      final blur = BackgroundBlurFilter();
      final moderation = FullFrameBlurFilter();
      await blur.apply(_input('cam-1'));
      final blurred = await moderation.apply(_input('cam-1'));

      await blurred.stop!(_stopDetails);

      expect(attached.last, 'cam-1: BackgroundBlurMedium');
    });

    test('a late stop of a replaced filter keeps the new one', () async {
      final image = VirtualBackgroundFilter('a');
      final old = await image.apply(_input('cam-1'));
      await image.apply(_input('cam-1'));

      await old.stop!(_stopDetails);

      expect(attached.last, 'cam-1: VirtualBackground-a');
    });

    test('stopping the filters applied before sends nothing', () async {
      final blur = BackgroundBlurFilter();
      final moderation = FullFrameBlurFilter();
      final oldBlur = await blur.apply(_input('cam-1'));
      final oldModeration = await moderation.apply(_input('cam-1'));
      await blur.apply(_input('cam-1'));
      await moderation.apply(_input('cam-1'));
      final sent = attached.length;

      await oldModeration.stop!(_stopDetails);
      await oldBlur.stop!(_stopDetails);

      expect(attached, hasLength(sent));
      expect(attached.last, 'cam-1: BackgroundBlurMedium,FullFrameBlur');
    });

    test('changing the first filter keeps the second one last', () async {
      final oldBlur = await BackgroundBlurFilter().apply(_input('cam-1'));
      final oldModeration = await FullFrameBlurFilter().apply(_input('cam-1'));

      await VirtualBackgroundFilter('a').apply(_input('cam-1'));
      await FullFrameBlurFilter().apply(_input('cam-1'));
      await oldModeration.stop!(_stopDetails);
      await oldBlur.stop!(_stopDetails);

      expect(attached.last, 'cam-1: VirtualBackground-a,FullFrameBlur');
    });

    test('a rejected chain keeps the order of the one applied', () async {
      await VirtualBackgroundFilter('a').apply(_input('cam-1'));
      await FullFrameBlurFilter().apply(_input('cam-1'));

      final image = await VirtualBackgroundFilter('a').apply(_input('cam-1'));
      failAttach = true;
      await expectLater(
        FullFrameBlurFilter().apply(_input('cam-1')),
        throwsA(isA<PlatformException>()),
      );
      failAttach = false;
      await image.stop!(_stopDetails);

      expect(attached.last, 'cam-1: VirtualBackground-a,FullFrameBlur');
    });

    test('a filter that cannot be attached is not kept', () async {
      final blur = BackgroundBlurFilter();
      failAttach = true;
      await expectLater(
        blur.apply(_input('cam-1')),
        throwsA(isA<PlatformException>()),
      );
      failAttach = false;

      await FullFrameBlurFilter().apply(_input('cam-1'));

      expect(attached.last, 'cam-1: FullFrameBlur');
    });
  });

  test('a stream without a video track is left alone', () async {
    final input = MediaStreamFilterInput(
      stream: _FakeStream(const []),
      source: MediaStreamFilterSource.camera,
    );

    final result = await BackgroundBlurFilter().apply(input);

    expect(result.output, same(input.stream));
    expect(platform.registrations, isEmpty);
    expect(attached, isEmpty);
  });

  test('applying fails where video effects are not supported', () async {
    debugWebRtcCapabilitiesOverride = _capabilities(isWindows: true);

    await expectLater(
      BackgroundBlurFilter().apply(_input('cam-1')),
      throwsUnsupportedError,
    );
    expect(attached, isEmpty);
  });

  group('isSupported', () {
    test('asks the device where video effects are supported', () async {
      platform.supported = false;

      expect(await StreamVideoFilters.isSupported(), isFalse);
    });

    test('is false where video effects are not supported', () async {
      debugWebRtcCapabilitiesOverride = _capabilities(isWindows: true);

      expect(await StreamVideoFilters.isSupported(), isFalse);
      expect(platform.supportChecks, 0);
    });

    test('is true where both agree', () async {
      expect(await StreamVideoFilters.isSupported(), isTrue);
    });

    test('unregisterAllFilters skips the plugin there', () async {
      debugWebRtcCapabilitiesOverride = _capabilities(isWindows: true);

      await StreamVideoFilters.unregisterAllFilters();

      expect(platform.unregisters, 0);
    });

    test('is false on macOS', () async {
      debugWebRtcCapabilitiesOverride = _capabilities(isMacOS: true);

      expect(await StreamVideoFilters.isSupported(), isFalse);
      expect(platform.supportChecks, 0);
    });
  });

  test('filters with the same effect are equal', () {
    expect(
      BackgroundBlurFilter(intensity: BlurIntensity.light),
      BackgroundBlurFilter(intensity: BlurIntensity.light),
    );
    expect(
      BackgroundBlurFilter(intensity: BlurIntensity.light),
      isNot(BackgroundBlurFilter(intensity: BlurIntensity.heavy)),
    );
    expect(VirtualBackgroundFilter('a'), VirtualBackgroundFilter('a'));
    expect(FullFrameBlurFilter(), FullFrameBlurFilter());
    expect(
      CustomVideoFilter('a', onRegister: (_) async {}),
      CustomVideoFilter('a', onRegister: (_) async {}),
    );
  });
}

WebRtcCapabilities _capabilities({
  bool isAndroid = false,
  bool isMacOS = false,
  bool isWindows = false,
}) {
  return nativeWebRtcCapabilitiesFor(
    isAndroid: isAndroid,
    isIOS: false,
    isMacOS: isMacOS,
    isWindows: isWindows,
    isLinux: false,
  );
}

MediaStreamFilterInput _input(String trackId) => MediaStreamFilterInput(
  stream: _FakeStream([_FakeTrack(trackId)]),
  source: MediaStreamFilterSource.camera,
);

const _stopDetails = MediaStreamFilterStopDetails(
  reason: MediaStreamFilterStopReason.chainChanged,
);

class _FakeFiltersPlatform extends StreamVideoFiltersPlatform
    with MockPlatformInterfaceMixin {
  final registrations = <String>[];
  bool supported = true;
  int supportChecks = 0;
  int unregisters = 0;

  /// When set, a registration waits for it before completing.
  Completer<void>? registering;

  /// When set, a registration throws it.
  Exception? registerError;

  Future<void> _register(String registration) async {
    final error = registerError;
    if (error != null) throw error;
    registrations.add(registration);
    await registering?.future;
  }

  @override
  Future<bool?> isBackgroundEffectSupported() async {
    supportChecks++;
    return supported;
  }

  @override
  Future<void> registerBlurEffectProcessors() => _register('blur');

  @override
  Future<void> registerImageEffectProcessors({
    required String backgroundImageUrl,
  }) => _register('image $backgroundImageUrl');

  @override
  Future<void> registerFullFrameBlurEffectProcessor() =>
      _register('full frame blur');

  @override
  Future<void> unregisterAllFilters() async {
    unregisters++;
  }
}

class _FakeTrack extends Fake implements MediaStreamTrack {
  _FakeTrack(this.id);

  @override
  final String id;

  @override
  String get kind => 'video';
}

class _FakeStream extends Fake implements MediaStream {
  _FakeStream(this._tracks);

  final List<MediaStreamTrack> _tracks;

  @override
  List<MediaStreamTrack> getVideoTracks() => _tracks;
}
