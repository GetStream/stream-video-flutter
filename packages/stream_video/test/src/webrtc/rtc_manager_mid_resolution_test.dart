import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  _FakeMediaStreamTrack(this.id);

  @override
  final String? id;
}

class _FakeSender extends Fake implements rtc.RTCRtpSender {
  _FakeSender(this.track);

  @override
  final rtc.MediaStreamTrack? track;
}

class _FakeTransceiver extends Fake implements rtc.RTCRtpTransceiver {
  _FakeTransceiver({required this.mid, String? trackId})
    : sender = _FakeSender(
        trackId == null ? null : _FakeMediaStreamTrack(trackId),
      );

  @override
  final String mid;

  @override
  final rtc.RTCRtpSender sender;
}

/// SDP with two video m-sections. The first one is the recycled/inactive
/// leftover (mid 1), the track is currently attached to the last one (mid 3).
String _sdp({
  required String audioTrackId,
  required String videoTrackId,
  bool includeMsid = true,
  bool duplicateVideoSection = true,
}) {
  String msid(String trackId) =>
      includeMsid ? 'a=msid:stream-id $trackId\r\n' : '';

  return [
    'v=0\r\n',
    'o=- 1 2 IN IP4 127.0.0.1\r\n',
    's=-\r\n',
    't=0 0\r\n',
    'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
    'c=IN IP4 0.0.0.0\r\n',
    'a=mid:0\r\n',
    'a=sendonly\r\n',
    msid(audioTrackId),
    if (duplicateVideoSection) ...[
      'm=video 9 UDP/TLS/RTP/SAVPF 96\r\n',
      'c=IN IP4 0.0.0.0\r\n',
      'a=mid:1\r\n',
      'a=inactive\r\n',
      msid(videoTrackId),
    ],
    'm=application 9 UDP/DTLS/SCTP webrtc-datachannel\r\n',
    'c=IN IP4 0.0.0.0\r\n',
    'a=mid:2\r\n',
    'm=video 9 UDP/TLS/RTP/SAVPF 96\r\n',
    'c=IN IP4 0.0.0.0\r\n',
    'a=mid:3\r\n',
    'a=sendonly\r\n',
    msid(videoTrackId),
  ].join();
}

void main() {
  const audioTrackId = 'audio-track-id';
  const videoTrackId = 'video-track-id';

  group('resolveTrackMid', () {
    test('prefers the live transceiver mid over the SDP', () {
      final mid = resolveTrackMid(
        trackId: videoTrackId,
        kind: 'video',
        liveTransceivers: [
          _FakeTransceiver(mid: '7', trackId: videoTrackId),
          _FakeTransceiver(mid: '0', trackId: audioTrackId),
        ],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, '7');
    });

    test('falls back to the SDP when the live mid is not assigned yet', () {
      final mid = resolveTrackMid(
        trackId: videoTrackId,
        kind: 'video',
        liveTransceivers: [_FakeTransceiver(mid: '', trackId: videoTrackId)],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, '3');
    });

    test('falls back to the SDP when the track has no live transceiver', () {
      final mid = resolveTrackMid(
        trackId: audioTrackId,
        kind: 'audio',
        liveTransceivers: [_FakeTransceiver(mid: '3', trackId: videoTrackId)],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, '0');
    });

    test('picks the last matching m-section for a recycled m-line', () {
      final sdp = _sdp(
        audioTrackId: audioTrackId,
        videoTrackId: videoTrackId,
      );

      // Both m=video sections carry the msid of the same track; the current one
      // is the later section.
      expect(sdp.split('a=msid:stream-id $videoTrackId').length - 1, 2);

      final mid = resolveTrackMid(
        trackId: videoTrackId,
        kind: 'video',
        liveTransceivers: const [],
        sdp: sdp,
      );

      expect(mid, '3');
    });

    test('returns null when no m-section carries the track msid', () {
      final mid = resolveTrackMid(
        trackId: videoTrackId,
        kind: 'video',
        liveTransceivers: const [],
        sdp: _sdp(
          audioTrackId: audioTrackId,
          videoTrackId: videoTrackId,
          includeMsid: false,
        ),
      );

      expect(mid, isNull);
    });

    test('returns null when the msid matches an m-section of another kind', () {
      final mid = resolveTrackMid(
        trackId: videoTrackId,
        // The track is video, but only the audio m-section carries its msid.
        kind: 'video',
        liveTransceivers: const [],
        sdp: _sdp(
          audioTrackId: videoTrackId,
          videoTrackId: 'some-other-track',
          duplicateVideoSection: false,
        ),
      );

      expect(mid, isNull);
    });

    test('returns null when the track has no id', () {
      final mid = resolveTrackMid(
        trackId: null,
        kind: 'video',
        liveTransceivers: [_FakeTransceiver(mid: '3', trackId: videoTrackId)],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, isNull);
    });

    test('returns null when there is no SDP and no live mid', () {
      final mid = resolveTrackMid(
        trackId: videoTrackId,
        kind: 'video',
        liveTransceivers: [_FakeTransceiver(mid: '', trackId: videoTrackId)],
        sdp: null,
      );

      expect(mid, isNull);
    });

    test('returns null instead of throwing on malformed SDP', () {
      final mid = resolveTrackMid(
        trackId: videoTrackId,
        kind: 'video',
        liveTransceivers: const [],
        sdp: 'not an sdp at all',
      );

      expect(mid, isNull);
    });
  });
}
