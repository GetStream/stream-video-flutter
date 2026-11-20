import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';

void main() {
  // A ringing call starts listening to WebRTC's event channel.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(registerMockFallbackValues);

  /// A call whose client has [options], ringing when [ringing].
  Call callWith(
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

  final options = StreamVideoOptions(
    audioConfigurationPolicy: const AudioConfigurationPolicy.viewer(),
    ringingAudioConfigurationPolicy: const AudioConfigurationPolicy.hiFi(),
  );

  group('StreamVideoOptions.resolvedRingingAudioConfigurationPolicy', () {
    test('is the ringing policy when set', () {
      expect(
        options.resolvedRingingAudioConfigurationPolicy,
        isA<HiFiAudioPolicy>(),
      );
    });

    test('falls back to the client policy', () {
      final withoutRinging = StreamVideoOptions(
        audioConfigurationPolicy: const AudioConfigurationPolicy.viewer(),
      );

      expect(
        withoutRinging.resolvedRingingAudioConfigurationPolicy,
        isA<ViewerAudioPolicy>(),
      );
    });
  });

  group('Call.audioConfigurationPolicy', () {
    test('is the ringing policy for a ringing call', () {
      final call = callWith(options, ringing: true);

      expect(call.audioConfigurationPolicy, isA<HiFiAudioPolicy>());
    });

    test('is the client policy for a call that does not ring', () {
      final call = callWith(options, ringing: false);

      expect(call.audioConfigurationPolicy, isA<ViewerAudioPolicy>());
    });

    test('is the client policy for a ringing call without a ringing one', () {
      final call = callWith(
        StreamVideoOptions(
          audioConfigurationPolicy: const AudioConfigurationPolicy.viewer(),
        ),
        ringing: true,
      );

      expect(call.audioConfigurationPolicy, isA<ViewerAudioPolicy>());
    });

    test("is the call's own policy over the ringing one", () {
      final call = callWith(
        options,
        ringing: true,
        preferences: DefaultCallPreferences(
          audioConfigurationPolicy:
              const AudioConfigurationPolicy.broadcaster(),
        ),
      );

      expect(call.audioConfigurationPolicy, isA<BroadcasterAudioPolicy>());
    });

    test('builds the pre-join factory of a ringing call with the ringing '
        'policy', () async {
      // Web has no per-call native factory, so no platform channel is needed.
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;
      addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);
      final call = callWith(options, ringing: true);

      await call.ensureNativeFactory();

      expect(call.pcFactoryAudioConfigurationPolicy, isA<HiFiAudioPolicy>());
      expect(call.audioConfigurationPolicy, isA<HiFiAudioPolicy>());
    });
  });
}
