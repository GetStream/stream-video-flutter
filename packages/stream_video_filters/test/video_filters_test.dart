// ignore_for_file: implementation_imports, invalid_use_of_visible_for_testing_member

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:stream_video_filters/stream_video_filters.dart';
import 'package:stream_video_filters/stream_video_filters_platform_interface.dart';
import 'package:stream_webrtc_flutter/src/native/native_webrtc_capabilities.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeFiltersPlatform platform;
  late List<String> attached;

  setUp(() {
    platform = _FakeFiltersPlatform();
    StreamVideoFiltersPlatform.instance = platform;
    debugWebRtcCapabilitiesOverride = _capabilities(isAndroid: true);

    attached = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('FlutterWebRTC.Method'), (
          call,
        ) async {
          if (call.method == 'setVideoEffects') {
            final args = call.arguments as Map;
            attached.add(
              '${args['trackId']}: ${(args['names'] as List).join(',')}',
            );
          }
          return null;
        });
  });

  tearDown(() {
    debugWebRtcCapabilitiesOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('FlutterWebRTC.Method'),
          null,
        );
  });

  final filters = <String, (NativeVideoFilter Function(), String)>{
    'BackgroundBlurFilter': (
      () => BackgroundBlurFilter(BlurIntensity.heavy),
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

        await filter.apply(_stream('cam-1'));
        await filter.apply(_stream('cam-2'));

        expect(platform.registrations, [registration]);
        expect(attached, [
          'cam-1: ${filter.effectName}',
          'cam-2: ${filter.effectName}',
        ]);
      });

      test('stop detaches it from the track', () async {
        final filter = create();
        final stream = _stream('cam-1');

        final result = await filter.apply(stream);
        await result.stop!();

        expect(result.output, same(stream));
        expect(attached.last, 'cam-1: ');
      });

      test('registers again after unregisterAllFilters', () async {
        final filter = create();

        await filter.apply(_stream('cam-1'));
        await StreamVideoFilters().unregisterAllFilters();
        await filter.apply(_stream('cam-1'));

        expect(platform.registrations, [registration, registration]);
      });
    });
  }

  test('CustomVideoFilter registers through its callback once', () async {
    var registered = 0;
    final filter = CustomVideoFilter(
      'grayscale',
      onRegister: () async => registered++,
    );

    await filter.apply(_stream('cam-1'));
    await filter.apply(_stream('cam-2'));

    expect(registered, 1);
    expect(attached, [
      'cam-1: grayscale',
      'cam-2: grayscale',
    ]);
  });

  test('a stream without a video track is left alone', () async {
    final stream = _FakeStream(const []);

    final result = await BackgroundBlurFilter().apply(stream);

    expect(result.output, same(stream));
    expect(platform.registrations, isEmpty);
    expect(attached, isEmpty);
  });

  test('applying fails where video effects are not supported', () async {
    debugWebRtcCapabilitiesOverride = _capabilities(isWindows: true);

    await expectLater(
      BackgroundBlurFilter().apply(_stream('cam-1')),
      throwsUnsupportedError,
    );
    expect(attached, isEmpty);
  });

  group('isSupported', () {
    test('asks the device where video effects are supported', () async {
      platform.supported = false;

      expect(await StreamVideoFilters().isSupported(), isFalse);
    });

    test('is false where video effects are not supported', () async {
      debugWebRtcCapabilitiesOverride = _capabilities(isWindows: true);

      expect(await StreamVideoFilters().isSupported(), isFalse);
      expect(platform.supportChecks, 0);
    });

    test('is true where both agree', () async {
      expect(await StreamVideoFilters().isSupported(), isTrue);
    });
  });

  test('filters with the same effect are equal', () {
    expect(
      BackgroundBlurFilter(BlurIntensity.light),
      BackgroundBlurFilter(BlurIntensity.light),
    );
    expect(
      BackgroundBlurFilter(BlurIntensity.light),
      isNot(BackgroundBlurFilter(BlurIntensity.heavy)),
    );
    expect(VirtualBackgroundFilter('a'), VirtualBackgroundFilter('a'));
    expect(FullFrameBlurFilter(), FullFrameBlurFilter());
    expect(
      CustomVideoFilter('a', onRegister: () async {}),
      CustomVideoFilter('a', onRegister: () async {}),
    );
  });
}

WebRtcCapabilities _capabilities({
  bool isAndroid = false,
  bool isWindows = false,
}) {
  return nativeWebRtcCapabilitiesFor(
    isAndroid: isAndroid,
    isIOS: false,
    isMacOS: false,
    isWindows: isWindows,
    isLinux: false,
  );
}

MediaStream _stream(String trackId) => _FakeStream([_FakeTrack(trackId)]);

class _FakeFiltersPlatform extends StreamVideoFiltersPlatform
    with MockPlatformInterfaceMixin {
  final registrations = <String>[];
  bool supported = true;
  int supportChecks = 0;

  @override
  Future<bool?> isBackgroundEffectSupported() async {
    supportChecks++;
    return supported;
  }

  @override
  Future<void> registerBlurEffectProcessors() async {
    registrations.add('blur');
  }

  @override
  Future<void> registerImageEffectProcessors({
    required String backgroundImageUrl,
  }) async {
    registrations.add('image $backgroundImageUrl');
  }

  @override
  Future<void> registerFullFrameBlurEffectProcessor() async {
    registrations.add('full frame blur');
  }

  @override
  Future<void> unregisterAllFilters() async {}
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
