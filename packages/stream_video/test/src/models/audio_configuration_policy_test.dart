import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

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
}
