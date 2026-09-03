import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_remote_track.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

class _MockTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockMediaStream extends Mock implements rtc.MediaStream {}

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

void main() {
  group('RtcRemoteTrack copyWith', () {
    test('preserves the transceiver', () {
      final transceiver = _MockTransceiver();
      final track = RtcRemoteTrack(
        trackIdPrefix: 'prefix',
        trackType: SfuTrackType.audio,
        mediaStream: _MockMediaStream(),
        mediaTrack: _MockMediaStreamTrack(),
        transceiver: transceiver,
      );

      // `RtcManager.unpublishTrack` resolves the sender through this field, so
      // a copy that drops it silently changes teardown behaviour. Copies are
      // made whenever an audio output device is applied on web.
      final copy = track.copyWith(audioSinkId: 'device-1');

      expect(copy.transceiver, same(transceiver));
      expect(copy.audioSinkId, 'device-1');
    });
  });
}
