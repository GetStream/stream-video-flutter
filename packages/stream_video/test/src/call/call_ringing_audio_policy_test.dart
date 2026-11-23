import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';

void main() {
  // A ringing call starts listening to WebRTC's event channel.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(registerMockFallbackValues);

  group('when the client sets a ringing policy', () {
    final options = StreamVideoOptions(
      audioConfigurationPolicy: const AudioConfigurationPolicy.viewer(),
      ringingAudioConfigurationPolicy: const AudioConfigurationPolicy.hiFi(),
    );

    test('it is the resolved ringing policy', () {
      expect(
        options.resolvedRingingAudioConfigurationPolicy,
        isA<HiFiAudioPolicy>(),
      );
    });

    test('a ringing call uses it', () {
      final call = _callWith(options, ringing: true);

      expect(call.audioConfigurationPolicy, isA<HiFiAudioPolicy>());
    });

    test('a call that does not ring uses the client policy', () {
      final call = _callWith(options, ringing: false);

      expect(call.audioConfigurationPolicy, isA<ViewerAudioPolicy>());
    });

    test("a ringing call's own policy wins over it", () {
      final call = _callWith(
        options,
        ringing: true,
        preferences: DefaultCallPreferences(
          audioConfigurationPolicy:
              const AudioConfigurationPolicy.broadcaster(),
        ),
      );

      expect(call.audioConfigurationPolicy, isA<BroadcasterAudioPolicy>());
    });

    test('a ringing call builds its pre-join factory with it', () async {
      // Web has no per-call native factory, so no platform channel is needed.
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;
      addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);
      final call = _callWith(options, ringing: true);

      await call.ensureNativeFactory();

      expect(call.pcFactoryAudioConfigurationPolicy, isA<HiFiAudioPolicy>());
    });
  });

  group('when the client sets no ringing policy', () {
    final options = StreamVideoOptions(
      audioConfigurationPolicy: const AudioConfigurationPolicy.viewer(),
    );

    test('the client policy is the resolved ringing policy', () {
      expect(
        options.resolvedRingingAudioConfigurationPolicy,
        isA<ViewerAudioPolicy>(),
      );
    });

    test('a ringing call uses the client policy', () {
      final call = _callWith(options, ringing: true);

      expect(call.audioConfigurationPolicy, isA<ViewerAudioPolicy>());
    });
  });
}

/// A call whose client has [options], ringing when [ringing].
Call _callWith(
  StreamVideoOptions options, {
  required bool ringing,
  CallPreferences? preferences,
}) {
  final host = setupMockCallHost();
  when(() => host.options).thenReturn(options);
  return createTestCall(
    streamVideo: host,
    stateManager: CallStateNotifier(
      createTestCallState(
        preferences: preferences,
      ).copyWith(isRingingFlow: ringing),
    ),
  );
}
