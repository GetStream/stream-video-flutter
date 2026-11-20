import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  group('CallPreferences.withAudioConfigurationPolicy', () {
    test('replaces the policy and keeps every other value', () {
      final base = DefaultCallPreferences(
        connectTimeout: const Duration(seconds: 9),
        closedCaptionsVisibleCaptions: 4,
        dropIfAloneInRingingFlow: false,
      );

      final updated = base.withAudioConfigurationPolicy(
        const AudioConfigurationPolicy.hiFi(),
      );

      expect(updated.audioConfigurationPolicy, isA<HiFiAudioPolicy>());
      expect(updated.connectTimeout, const Duration(seconds: 9));
      expect(updated.closedCaptionsVisibleCaptions, 4);
      expect(updated.dropIfAloneInRingingFlow, isFalse);
      expect(base.audioConfigurationPolicy, isNull);
    });

    test('can clear a policy set on the original preferences', () {
      final base = DefaultCallPreferences(
        audioConfigurationPolicy: const AudioConfigurationPolicy.viewer(),
      );

      final updated = base.withAudioConfigurationPolicy(null);

      expect(updated.audioConfigurationPolicy, isNull);
    });

    test('returns the original preferences for their own policy', () {
      final base = DefaultCallPreferences();

      expect(base.withAudioConfigurationPolicy(null), same(base));
      expect(
        base
            .withAudioConfigurationPolicy(const AudioConfigurationPolicy.hiFi())
            .withAudioConfigurationPolicy(null),
        same(base),
      );
    });

    test('does not nest copies', () {
      final base = DefaultCallPreferences(closedCaptionsVisibleCaptions: 6);

      final updated = base
          .withAudioConfigurationPolicy(const AudioConfigurationPolicy.hiFi())
          .withAudioConfigurationPolicy(
            const AudioConfigurationPolicy.viewer(),
          );

      expect(updated.audioConfigurationPolicy, isA<ViewerAudioPolicy>());
      expect(updated.closedCaptionsVisibleCaptions, 6);
      expect(updated.withAudioConfigurationPolicy(null), same(base));
    });
  });
}
