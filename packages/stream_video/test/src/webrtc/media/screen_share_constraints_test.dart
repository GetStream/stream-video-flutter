import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/webrtc/media/screen_share_constraints.dart';

import '../../../fixtures/webrtc_capabilities.dart';

void main() {
  group('ScreenShareConstraints.toMap where the source is picked by id', () {
    setUp(() => overrideWebRtcCapabilities(platform: PlatformType.linux));

    test('leaves out the frame rate cap when there is none to ask for', () {
      const subject = ScreenShareConstraints(sourceId: '1');

      final video = subject.toMap()['video'] as Map<String, dynamic>;

      expect(
        video.containsKey('mandatory'),
        isFalse,
        reason: 'a null cap would reach the platform as a null frameRate',
      );
    });

    test('asks for the frame rate cap it was given', () {
      const subject = ScreenShareConstraints(sourceId: '1', maxFrameRate: 15);

      final video = subject.toMap()['video'] as Map<String, dynamic>;

      expect(video['mandatory'], {'frameRate': 15.0});
    });

    test('treats a cap of zero as no cap', () {
      const subject = ScreenShareConstraints(sourceId: '1', maxFrameRate: 0);

      final video = subject.toMap()['video'] as Map<String, dynamic>;

      expect(video.containsKey('mandatory'), isFalse);
    });

    test('carries the source id the picker chose', () {
      const subject = ScreenShareConstraints(sourceId: 'screen-2');

      final video = subject.toMap()['video'] as Map<String, dynamic>;

      expect(video['deviceId'], {'exact': 'screen-2'});
    });
  });

  group('ScreenShareConstraints.toMap elsewhere', () {
    test('leaves out the source id and the frame rate cap', () {
      overrideWebRtcCapabilities(platform: PlatformType.android);
      const subject = ScreenShareConstraints(sourceId: '1', maxFrameRate: 15);

      final video = subject.toMap()['video'] as Map<String, dynamic>;

      expect(video.containsKey('deviceId'), isFalse);
      expect(video.containsKey('mandatory'), isFalse);
    });

    test('asks iOS for the broadcast extension', () {
      overrideWebRtcCapabilities(platform: PlatformType.ios);
      const subject = ScreenShareConstraints(useiOSBroadcastExtension: true);

      final video = subject.toMap()['video'] as Map<String, dynamic>;

      expect(video['deviceId'], 'broadcast');
    });

    test('does not ask for the broadcast extension where there is none', () {
      overrideWebRtcCapabilities(platform: PlatformType.android);
      const subject = ScreenShareConstraints(useiOSBroadcastExtension: true);

      final video = subject.toMap()['video'] as Map<String, dynamic>;

      expect(video.containsKey('deviceId'), isFalse);
    });
  });
}
