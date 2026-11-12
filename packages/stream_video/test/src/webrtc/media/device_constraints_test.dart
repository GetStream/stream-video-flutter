import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import '../../../fixtures/webrtc_capabilities.dart';

void main() {
  group('AudioConstraints.toMap', () {
    Map<String, dynamic> audioOf(AudioConstraints constraints) =>
        constraints.toMap()['audio'] as Map<String, dynamic>;

    test('on web, picks the device with an exact deviceId alone', () {
      overrideWebRtcCapabilities(platform: PlatformType.web);

      final audio = audioOf(const AudioConstraints(deviceId: 'mic-1'));

      expect(audio['deviceId'], {'exact': 'mic-1'});
      expect(audio.containsKey('optional'), isFalse);
    });

    test('on web without a device, keeps the optional parameters', () {
      overrideWebRtcCapabilities(platform: PlatformType.web);

      final audio = audioOf(const AudioConstraints());

      expect(audio['optional'], isNotEmpty);
      expect(audio.containsKey('deviceId'), isFalse);
    });

    test('natively, adds the device to the optional parameters', () {
      overrideWebRtcCapabilities(platform: PlatformType.android);

      final audio = audioOf(const AudioConstraints(deviceId: 'mic-1'));

      expect(audio.containsKey('deviceId'), isFalse);
      expect(audio['optional'], anyElement(equals({'sourceId': 'mic-1'})));
    });
  });

  group('CameraConstraints.toMap', () {
    Map<String, dynamic> videoOf(CameraConstraints constraints) =>
        constraints.toMap()['video'] as Map<String, dynamic>;

    test('on web, picks the camera with an exact deviceId', () {
      overrideWebRtcCapabilities(platform: PlatformType.web);

      final video = videoOf(const CameraConstraints(deviceId: 'cam-1'));

      expect(video['deviceId'], {'exact': 'cam-1'});
      expect(video.containsKey('optional'), isFalse);
    });

    test('natively, picks the camera through an optional sourceId', () {
      overrideWebRtcCapabilities(platform: PlatformType.ios);

      final video = videoOf(const CameraConstraints(deviceId: 'cam-1'));

      expect(video['optional'], [
        {'sourceId': 'cam-1'},
      ]);
      expect(video.containsKey('deviceId'), isFalse);
    });
  });
}
