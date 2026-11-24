import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';

/// A [CallPreferences] that is not a [DefaultCallPreferences].
class _CustomCallPreferences implements CallPreferences {
  @override
  Duration get connectTimeout => const Duration(seconds: 7);
  @override
  AudioInterruptionReaction get audioInterruptionReaction =>
      AudioInterruptionReaction.none;
  @override
  Duration get reconnectTimeout => Duration.zero;
  @override
  Duration get networkAvailabilityTimeout => const Duration(minutes: 1);
  @override
  int get maxIceFailuresWithoutConnect => 2;
  @override
  Duration get reactionAutoDismissTime => const Duration(seconds: 1);
  @override
  Duration get callStatsReportingInterval => const Duration(seconds: 3);
  @override
  bool get dropIfAloneInRingingFlow => false;
  @override
  ClientPublishOptions? get clientPublishOptions => null;
  @override
  int get closedCaptionsVisibilityDurationMs => 1234;
  @override
  int get closedCaptionsVisibleCaptions => 5;
  @override
  VideoModerationConfig get videoModerationConfig =>
      const VideoModerationConfig.disabled();
  @override
  AudioConfigurationPolicy? get audioConfigurationPolicy => null;
  @override
  ParticipantsThrottleIntervalResolver?
  get participantsThrottleIntervalResolver => null;
  @override
  CallEncryptionKeyResolver? get encryptionKeyResolver => null;
}

void main() {
  setUpAll(registerMockFallbackValues);

  group('Call.prefersStereoPlayout', () {
    test('is false for the default policy and voice profile', () {
      final call = createTestCall();

      expect(call.prefersStereoPlayout, isFalse);
    });

    test('is true when the call policy bypasses voice processing', () {
      for (final policy in const <AudioConfigurationPolicy>[
        AudioConfigurationPolicy.hiFi(),
        AudioConfigurationPolicy.viewer(),
      ]) {
        final call = createTestCallWithState(
          initialState: createTestCallState(
            preferences: DefaultCallPreferences(
              audioConfigurationPolicy: policy,
            ),
          ),
        );

        expect(call.prefersStereoPlayout, isTrue, reason: '$policy');
      }
    });

    test('is true for the music profile under the default policy', () {
      final call = createTestCallWithState(
        initialState: createTestCallState().copyWith(
          audioBitrateProfile: SfuAudioBitrateProfile.musicHighQuality,
        ),
      );

      expect(call.prefersStereoPlayout, isTrue);
    });

    test('follows a policy set through updateCallPreferences', () {
      final call = createTestCall();

      call.updateCallPreferences(
        DefaultCallPreferences(
          audioConfigurationPolicy: const AudioConfigurationPolicy.hiFi(),
        ),
      );
      expect(call.prefersStereoPlayout, isTrue);

      call.updateCallPreferences(DefaultCallPreferences());
      expect(call.prefersStereoPlayout, isFalse);
    });
  });

  group('Call.setAudioConfigurationPolicy', () {
    test('sets the policy and keeps the other preferences', () {
      final call = createTestCall();
      call.updateCallPreferences(
        DefaultCallPreferences(closedCaptionsVisibleCaptions: 7),
      );

      final result = call.setAudioConfigurationPolicy(
        const AudioConfigurationPolicy.hiFi(),
      );

      expect(result.isSuccess, isTrue);
      final preferences = call.state.value.preferences;
      expect(preferences.audioConfigurationPolicy, isA<HiFiAudioPolicy>());
      expect(preferences.closedCaptionsVisibleCaptions, 7);
      expect(call.prefersStereoPlayout, isTrue);
    });

    test('null falls back to the client default', () {
      final call = createTestCall();
      call.setAudioConfigurationPolicy(const AudioConfigurationPolicy.hiFi());

      call.setAudioConfigurationPolicy(null);

      expect(call.state.value.preferences.audioConfigurationPolicy, isNull);
      expect(call.prefersStereoPlayout, isFalse);
    });

    test('does not stack wrappers when called repeatedly', () {
      final call = createTestCall();
      final base = DefaultCallPreferences(closedCaptionsVisibleCaptions: 3);
      call.updateCallPreferences(base);

      call
        ..setAudioConfigurationPolicy(const AudioConfigurationPolicy.hiFi())
        ..setAudioConfigurationPolicy(const AudioConfigurationPolicy.viewer())
        ..setAudioConfigurationPolicy(null);

      expect(call.state.value.preferences, same(base));
    });

    test('keeps the values of a custom CallPreferences', () {
      final call = createTestCall();
      final base = _CustomCallPreferences();
      call.updateCallPreferences(base);

      call.setAudioConfigurationPolicy(const AudioConfigurationPolicy.hiFi());

      final preferences = call.state.value.preferences;
      expect(preferences.audioConfigurationPolicy, isA<HiFiAudioPolicy>());
      expect(preferences.connectTimeout, const Duration(seconds: 7));
      expect(preferences.dropIfAloneInRingingFlow, isFalse);
      expect(preferences.closedCaptionsVisibilityDurationMs, 1234);
      expect(preferences.closedCaptionsVisibleCaptions, 5);

      call.setAudioConfigurationPolicy(null);
      expect(call.state.value.preferences, same(base));
    });

    test('is rejected while the call is joining or joined', () {
      for (final status in [
        CallStatus.connecting(),
        CallStatus.connected(),
        CallStatus.joining(),
        CallStatus.joined(),
      ]) {
        final call = createTestCallWithState(
          initialState: createTestCallState().copyWith(status: status),
        );

        final result = call.setAudioConfigurationPolicy(
          const AudioConfigurationPolicy.hiFi(),
        );

        expect(result.isFailure, isTrue, reason: '$status');
        expect(
          call.state.value.preferences.audioConfigurationPolicy,
          isNull,
          reason: '$status',
        );
      }
    });

    test('is allowed again after the call disconnected', () {
      final call = createTestCallWithState(
        initialState: createTestCallState().copyWith(
          status: CallStatus.disconnected(DisconnectReason.ended()),
        ),
      );

      final result = call.setAudioConfigurationPolicy(
        const AudioConfigurationPolicy.hiFi(),
      );

      expect(result.isSuccess, isTrue);
    });

    test('rebuilds a pre-join factory with the new policy', () async {
      // Web has no per-call native factory, so no platform channel is needed.
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;
      addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

      final call = createTestCall();
      await call.ensureNativeFactory();
      expect(
        call.pcFactoryAudioConfigurationPolicy,
        isNot(isA<HiFiAudioPolicy>()),
      );

      call.setAudioConfigurationPolicy(const AudioConfigurationPolicy.hiFi());
      expect(call.pcFactoryAudioConfigurationPolicy, isNull);

      await call.ensureNativeFactory();
      expect(call.pcFactoryAudioConfigurationPolicy, isA<HiFiAudioPolicy>());
    });

    test('keeps a pre-join factory for an equal policy', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;
      addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

      final call = createTestCall();
      call.setAudioConfigurationPolicy(const AudioConfigurationPolicy.hiFi());
      await call.ensureNativeFactory();
      final before = call.pcFactoryAudioConfigurationPolicy;

      // A new, non-const instance of the same policy.
      // ignore: prefer_const_constructors
      call.setAudioConfigurationPolicy(HiFiAudioPolicy());

      expect(call.pcFactoryAudioConfigurationPolicy, same(before));
    });

    test('updateCallPreferences leaves a pre-join factory alone', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;
      addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

      final call = createTestCall();
      await call.ensureNativeFactory();
      final before = call.pcFactoryAudioConfigurationPolicy;

      call.updateCallPreferences(
        DefaultCallPreferences(
          audioConfigurationPolicy: const AudioConfigurationPolicy.hiFi(),
        ),
      );

      expect(call.pcFactoryAudioConfigurationPolicy, same(before));
    });
  });

  group('AudioConfigurationPolicy equality', () {
    test('built-in policies are equal to any instance of their type', () {
      // ignore: prefer_const_constructors
      expect(HiFiAudioPolicy(), const AudioConfigurationPolicy.hiFi());
      // ignore: prefer_const_constructors
      expect(ViewerAudioPolicy(), const AudioConfigurationPolicy.viewer());
      expect(
        // ignore: prefer_const_constructors
        BroadcasterAudioPolicy(),
        const AudioConfigurationPolicy.broadcaster(),
      );
      expect(
        const AudioConfigurationPolicy.hiFi(),
        isNot(const AudioConfigurationPolicy.viewer()),
      );
      expect(
        // ignore: prefer_const_constructors
        HiFiAudioPolicy().hashCode,
        const AudioConfigurationPolicy.hiFi().hashCode,
      );
    });

    test('custom policies compare by their fields', () {
      // ignore: prefer_const_constructors
      final a = CustomAudioPolicy(
        // ignore: prefer_const_constructors
        basePolicy: HiFiAudioPolicy(),
        bypassVoiceProcessing: true,
      );
      // ignore: prefer_const_constructors
      final b = CustomAudioPolicy(
        basePolicy: const HiFiAudioPolicy(),
        bypassVoiceProcessing: true,
      );
      // ignore: prefer_const_constructors
      final c = CustomAudioPolicy(basePolicy: const HiFiAudioPolicy());

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
    });

    test('withAudioConfigurationPolicy returns the original for an equal '
        'policy', () {
      final base = DefaultCallPreferences(
        audioConfigurationPolicy: const AudioConfigurationPolicy.hiFi(),
      );

      // ignore: prefer_const_constructors
      expect(base.withAudioConfigurationPolicy(HiFiAudioPolicy()), same(base));
    });
  });
}
