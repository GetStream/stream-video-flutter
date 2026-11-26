// ignore_for_file: implementation_imports, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_noise_cancellation/noise_cancellation_audio_processor.dart';
import 'package:stream_video_noise_cancellation/stream_video_noise_cancellation_method_channel.dart';
import 'package:stream_video_noise_cancellation/stream_video_noise_cancellation_platform_interface.dart';
import 'package:stream_webrtc_flutter/src/native/native_webrtc_capabilities.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import 'mock_noise_cancellation_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NoiseCancellationAudioProcessor', () {
    late FakeNoiseCancellationPlatform platform;

    setUp(() {
      platform = FakeNoiseCancellationPlatform();
      StreamVideoNoiseCancellationPlatform.instance = platform;
    });

    test('init registers processor', () async {
      expect(platform.registerProcessorCallCount, 0);

      final _ = NoiseCancellationAudioProcessor();
      await Future<void>.delayed(Duration.zero);

      expect(platform.registerProcessorCallCount, 1);
    });

    test('turns noise cancellation on and off', () async {
      final processor = NoiseCancellationAudioProcessor();

      await processor.setEnabled(true);
      expect(await processor.isEnabled(), isTrue);

      await processor.setEnabled(false);
      expect(await processor.isEnabled(), isFalse);
    });

    test('reports the advanced audio processing support', () async {
      platform.advancedAudioProcessing = false;

      final supported = await NoiseCancellationAudioProcessor()
          .deviceSupportsAdvancedAudioProcessing();

      expect(supported, isFalse);
    });

    test('where unsupported, reads as off and throws when enabled', () async {
      platform.error = UnsupportedError('unsupported');
      final processor = NoiseCancellationAudioProcessor();

      expect(await processor.isEnabled(), isFalse);
      expect(await processor.deviceSupportsAdvancedAudioProcessing(), isFalse);
      await expectLater(processor.setEnabled(true), throwsUnsupportedError);
    });

    test('where unsupported, turning it off does nothing', () async {
      platform.error = UnsupportedError('unsupported');

      await NoiseCancellationAudioProcessor().setEnabled(false);
    });

    test('a native error is reported, not read as unsupported', () async {
      platform.error = PlatformException(code: 'native');
      final processor = NoiseCancellationAudioProcessor();

      await expectLater(
        processor.isEnabled(),
        throwsA(isA<PlatformException>()),
      );
      await expectLater(
        processor.deviceSupportsAdvancedAudioProcessing(),
        throwsA(isA<PlatformException>()),
      );
      await expectLater(
        processor.setEnabled(true),
        throwsA(isA<PlatformException>()),
      );
    });

    test('turning it on waits for the registration', () async {
      platform.registration = Completer<void>();
      final processor = NoiseCancellationAudioProcessor();

      final enabling = processor.setEnabled(true);
      await Future<void>.delayed(Duration.zero);
      expect(platform.calls, isEmpty);
      platform.registration!.complete();
      await enabling;

      expect(platform.calls, ['registerProcessor', 'setEnabled']);
    });

    test('a failed registration still lets it be used', () async {
      platform.registerError = PlatformException(code: 'native');
      final processor = NoiseCancellationAudioProcessor();

      await processor.setEnabled(true);

      expect(await processor.isEnabled(), isTrue);
    });

    test('a failed registration is tried again by the next call', () async {
      platform.registerError = PlatformException(code: 'native');
      final processor = NoiseCancellationAudioProcessor();
      await Future<void>.delayed(Duration.zero);
      platform.registerError = null;

      await processor.setEnabled(true);
      await processor.isEnabled();

      expect(platform.registerProcessorCallCount, 2);
    });

    test('an unsupported registration is not tried again', () async {
      platform.registerError = UnsupportedError('unsupported');
      final processor = NoiseCancellationAudioProcessor();

      await processor.isEnabled();
      await processor.isEnabled();

      expect(platform.registerProcessorCallCount, 1);
    });

    test('runs natively, with no microphone filter', () {
      expect(NoiseCancellationAudioProcessor().toFilter(), isNull);
    });
  });

  group('MethodChannelStreamVideoNoiseCancellation', () {
    const channel = MethodChannel('stream_video_noise_cancellation');
    late List<String> calls;

    setUp(() {
      calls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call.method);
            return call.method == 'setEnabled' ? null : true;
          });
    });

    tearDown(() {
      debugWebRtcCapabilitiesOverride = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('calls the native side where audio processing is supported', () async {
      debugWebRtcCapabilitiesOverride = _capabilities(isAndroid: true);
      final platform = MethodChannelStreamVideoNoiseCancellation();

      await platform.registerProcessor();
      await platform.setEnabled(true);
      expect(await platform.isEnabled(), isTrue);
      expect(await platform.deviceSupportsAdvancedAudioProcessing(), isTrue);

      expect(calls, [
        'registerProcessor',
        'setEnabled',
        'isEnabled',
        'deviceSupportsAdvancedAudioProcessing',
      ]);
    });

    test('throws on macOS', () async {
      debugWebRtcCapabilitiesOverride = _capabilities(isMacOS: true);

      await expectLater(
        MethodChannelStreamVideoNoiseCancellation().isEnabled(),
        throwsUnsupportedError,
      );
      expect(calls, isEmpty);
    });

    test('throws where audio processing is not supported', () async {
      debugWebRtcCapabilitiesOverride = _capabilities(isWindows: true);
      final platform = MethodChannelStreamVideoNoiseCancellation();

      await expectLater(platform.registerProcessor(), throwsUnsupportedError);
      await expectLater(platform.isEnabled(), throwsUnsupportedError);
      await expectLater(platform.setEnabled(true), throwsUnsupportedError);
      await expectLater(
        platform.deviceSupportsAdvancedAudioProcessing(),
        throwsUnsupportedError,
      );
      expect(calls, isEmpty);
    });
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
