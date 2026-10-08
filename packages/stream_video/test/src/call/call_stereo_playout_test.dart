import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';

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
}
