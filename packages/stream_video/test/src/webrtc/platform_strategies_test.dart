import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/webrtc/audio/audio_input_switcher.dart';
import 'package:stream_video/src/webrtc/media/device_id_constraint.dart';
import 'package:stream_video/src/webrtc/media/screen_share_constraints.dart';
import 'package:stream_video/src/webrtc/media/screen_share_source.dart';

import '../../fixtures/webrtc_capabilities.dart';

void main() {
  /// The implementation each factory picks on [platform].
  ({Type input, Type deviceId, Type screenShare}) picksOn(
    PlatformType platform,
  ) {
    overrideWebRtcCapabilities(platform: platform);
    return (
      input: AudioInputSwitcher.forPlatform().runtimeType,
      deviceId: DeviceIdConstraint.forPlatform().runtimeType,
      screenShare: ScreenShareSource.forPlatform().runtimeType,
    );
  }

  final expected = {
    PlatformType.android: (
      input: InPlaceAudioInputSwitcher,
      deviceId: OptionalDeviceIdConstraint,
      screenShare: SystemScreenShareSource,
    ),
    PlatformType.ios: (
      input: InPlaceAudioInputSwitcher,
      deviceId: OptionalDeviceIdConstraint,
      screenShare: BroadcastExtensionScreenShareSource,
    ),
    PlatformType.macOS: (
      input: InPlaceAudioInputSwitcher,
      deviceId: OptionalDeviceIdConstraint,
      screenShare: SelectedScreenShareSource,
    ),
    PlatformType.windows: (
      input: InPlaceAudioInputSwitcher,
      deviceId: OptionalDeviceIdConstraint,
      screenShare: SelectedScreenShareSource,
    ),
    PlatformType.linux: (
      input: InPlaceAudioInputSwitcher,
      deviceId: OptionalDeviceIdConstraint,
      screenShare: SelectedScreenShareSource,
    ),
    PlatformType.web: (
      input: RecaptureAudioInputSwitcher,
      deviceId: ExactDeviceIdConstraint,
      screenShare: SystemScreenShareSource,
    ),
  };

  group('forPlatform', () {
    for (final MapEntry(key: platform, value: picks) in expected.entries) {
      test('picks the ${platform.name} implementations', () {
        expect(picksOn(platform), picks);
      });
    }
  });

  group('DeviceIdConstraint', () {
    const optional = [
      {'echoCancellation': true},
    ];

    test('optional adds the device as a source id after the optional '
        'constraints', () {
      final constraints = <String, dynamic>{};

      const OptionalDeviceIdConstraint().addTo(
        constraints,
        deviceId: 'mic-2',
        optional: optional,
      );

      expect(constraints, {
        'optional': [
          {'echoCancellation': true},
          {'sourceId': 'mic-2'},
        ],
      });
    });

    test('exact names the device and leaves out the optional constraints', () {
      final constraints = <String, dynamic>{};

      const ExactDeviceIdConstraint().addTo(
        constraints,
        deviceId: 'mic-2',
        optional: optional,
      );

      expect(constraints, {
        'deviceId': {'exact': 'mic-2'},
      });
    });

    test('without a device, both keep only the optional constraints', () {
      for (final form in const <DeviceIdConstraint>[
        OptionalDeviceIdConstraint(),
        ExactDeviceIdConstraint(),
      ]) {
        final constraints = <String, dynamic>{};

        form.addTo(constraints, deviceId: null, optional: optional);

        expect(constraints, {'optional': optional}, reason: '$form');
      }
    });

    test('without a device or optional constraints, both add nothing', () {
      for (final form in const <DeviceIdConstraint>[
        OptionalDeviceIdConstraint(),
        ExactDeviceIdConstraint(),
      ]) {
        final constraints = <String, dynamic>{};

        form.addTo(constraints, deviceId: null);

        expect(constraints, isEmpty, reason: '$form');
      }
    });
  });

  group('ScreenShareSource', () {
    const broadcast = ScreenShareConstraints(useiOSBroadcastExtension: true);
    const picked = ScreenShareConstraints(sourceId: 'screen-2');

    test('only the broadcast extension source runs a share in the '
        'extension, and only when asked', () {
      const extension = BroadcastExtensionScreenShareSource();
      expect(extension.usesBroadcastExtension(broadcast), isTrue);
      expect(extension.usesBroadcastExtension(picked), isFalse);

      for (final source in const <ScreenShareSource>[
        SelectedScreenShareSource(),
        SystemScreenShareSource(),
      ]) {
        expect(
          source.usesBroadcastExtension(broadcast),
          isFalse,
          reason: '$source',
        );
      }
    });

    test('the system source names no source', () {
      final video = <String, dynamic>{};

      const SystemScreenShareSource().addTo(video, picked);

      expect(video, isEmpty);
    });
  });
}
