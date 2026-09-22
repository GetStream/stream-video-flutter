import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/webrtc/media/screen_share_constraints.dart';

void main() {
  group('ScreenShareConstraints.toMap', () {
    // The desktop branch is the only one that builds `mandatory`, and the test
    // host is a desktop, so these run where it matters.
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
  }, skip: CurrentPlatform.isDesktop ? null : 'desktop-only constraints');
}
