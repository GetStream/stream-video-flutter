import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart'
    show AppleAudioCategoryOption, AppleAudioMode;

void main() {
  group('AudioConfigurationPolicy.androidCallServiceKind', () {
    test('the viewer policy runs in the livestream viewer service', () {
      expect(
        const AudioConfigurationPolicy.viewer().androidCallServiceKind,
        AndroidCallServiceKind.livestreamViewer,
      );
    });

    test('policies that send audio run in the call service', () {
      expect(
        const AudioConfigurationPolicy.broadcaster().androidCallServiceKind,
        AndroidCallServiceKind.call,
      );
      expect(
        const AudioConfigurationPolicy.hiFi().androidCallServiceKind,
        AndroidCallServiceKind.call,
      );
    });

    test('a custom policy without an Android configuration follows its base '
        'policy', () {
      expect(
        const AudioConfigurationPolicy.custom().androidCallServiceKind,
        AndroidCallServiceKind.call,
      );
      expect(
        const AudioConfigurationPolicy.custom(
          basePolicy: AudioConfigurationPolicy.viewer(),
        ).androidCallServiceKind,
        AndroidCallServiceKind.livestreamViewer,
      );
    });

    test(
      'a custom Android configuration runs in the call service whatever the '
      'base policy',
      () {
        expect(
          AudioConfigurationPolicy.custom(
            basePolicy: const AudioConfigurationPolicy.viewer(),
            androidConfiguration: const AudioConfigurationPolicy.broadcaster()
                .getAndroidConfiguration(),
          ).androidCallServiceKind,
          AndroidCallServiceKind.call,
        );
      },
    );

    test('a custom policy can name its service kind outright', () {
      expect(
        const AudioConfigurationPolicy.custom(
          basePolicy: AudioConfigurationPolicy.viewer(),
          androidCallServiceKind: AndroidCallServiceKind.call,
        ).androidCallServiceKind,
        AndroidCallServiceKind.call,
      );
    });
  });

  group('AudioConfigurationPolicy.defaultsToSpeaker', () {
    test('the viewer policy defaults to the loudspeaker', () {
      expect(const AudioConfigurationPolicy.viewer().defaultsToSpeaker, isTrue);
    });

    test('the broadcaster and HiFi policies follow the call settings', () {
      expect(
        const AudioConfigurationPolicy.broadcaster().defaultsToSpeaker,
        isFalse,
      );
      expect(const AudioConfigurationPolicy.hiFi().defaultsToSpeaker, isFalse);
    });

    test('a custom policy follows its base policy', () {
      expect(
        const AudioConfigurationPolicy.custom().defaultsToSpeaker,
        isFalse,
      );
      expect(
        const AudioConfigurationPolicy.custom(
          basePolicy: AudioConfigurationPolicy.viewer(),
        ).defaultsToSpeaker,
        isTrue,
      );
    });
  });

  group('AudioConfigurationPolicy.getAppleConfiguration', () {
    test('the configuration a call starts with asks iOS for the loudspeaker '
        'only under the viewer policy', () {
      for (final policy in const [
        AudioConfigurationPolicy.broadcaster(),
        AudioConfigurationPolicy.viewer(),
        AudioConfigurationPolicy.hiFi(),
      ]) {
        expect(
          policy
              .getAppleConfiguration(defaultToSpeaker: policy.defaultsToSpeaker)
              .appleAudioCategoryOptions,
          policy.defaultsToSpeaker
              ? contains(AppleAudioCategoryOption.defaultToSpeaker)
              : isNot(contains(AppleAudioCategoryOption.defaultToSpeaker)),
          reason: '${policy.runtimeType}',
        );
      }
    });

    test('the viewer policy does not use the voice chat mode', () {
      expect(
        const AudioConfigurationPolicy.viewer()
            .getAppleConfiguration(defaultToSpeaker: true)
            .appleAudioMode,
        AppleAudioMode.default_,
      );
    });
  });
}
