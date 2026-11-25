import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/rtc_manager_fakes.dart';

RtcRemoteTrack _audioTrack() => RtcRemoteTrack(
  trackIdPrefix: 'alice',
  trackType: SfuTrackType.audio,
  mediaStream: FakeMediaStream(),
  mediaTrack: FakeMediaStreamTrack('alice-audio', kind: 'audio'),
);

void main() {
  test('start enables the track', () async {
    final track = _audioTrack();
    track.mediaTrack.enabled = false;

    await track.start();

    expect(track.mediaTrack.enabled, isTrue);
  });

  test('start with enabled false starts the track disabled', () async {
    final track = _audioTrack();

    await track.start(enabled: false);

    expect(track.mediaTrack.enabled, isFalse);
  });
}
