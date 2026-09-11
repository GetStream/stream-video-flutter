import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/internal/_background_mute_policy.dart';

void main() {
  group('shouldMuteCameraInBackground', () {
    bool shouldMute({
      bool isVideoEnabled = true,
      bool muteVideoWhenInBackground = false,
      bool multitaskingCameraAccessEnabled = false,
      PlatformType platform = PlatformType.ios,
    }) {
      return shouldMuteCameraInBackground(
        isVideoEnabled: isVideoEnabled,
        muteVideoWhenInBackground: muteVideoWhenInBackground,
        multitaskingCameraAccessEnabled: multitaskingCameraAccessEnabled,
        platform: platform,
      );
    }

    test('does not mute a camera that is already off', () {
      expect(shouldMute(isVideoEnabled: false), isFalse);
    });

    test('mutes on iOS without multitasking camera access', () {
      expect(shouldMute(), isTrue);
    });

    test('does not mute on iOS with multitasking camera access', () {
      expect(shouldMute(multitaskingCameraAccessEnabled: true), isFalse);
    });

    test('does not mute on other platforms', () {
      for (final platform in [
        PlatformType.android,
        PlatformType.web,
        PlatformType.macOS,
        PlatformType.windows,
        PlatformType.linux,
      ]) {
        expect(
          shouldMute(platform: platform),
          isFalse,
          reason: 'should not mute on $platform',
        );
      }
    });

    test('mutes on any platform when the option is set', () {
      expect(
        shouldMute(
          muteVideoWhenInBackground: true,
          platform: PlatformType.android,
        ),
        isTrue,
      );
      expect(
        shouldMute(
          muteVideoWhenInBackground: true,
          multitaskingCameraAccessEnabled: true,
        ),
        isTrue,
      );
    });

    test('the option does not mute a camera that is off', () {
      expect(
        shouldMute(isVideoEnabled: false, muteVideoWhenInBackground: true),
        isFalse,
      );
    });
  });
}
