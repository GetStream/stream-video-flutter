import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  _FakeMediaStreamTrack(this.id, this.kind);

  @override
  final String? id;

  @override
  final String? kind;
}

class _FakeSender extends Fake implements rtc.RTCRtpSender {
  _FakeSender(this.track);

  @override
  final rtc.MediaStreamTrack? track;
}

class _FakeTransceiver extends Fake implements rtc.RTCRtpTransceiver {
  _FakeTransceiver({
    required this.mid,
    String? trackId,
    String kind = 'video',
    bool hasTrack = true,
  }) : sender = _FakeSender(
         hasTrack ? _FakeMediaStreamTrack(trackId, kind) : null,
       );

  @override
  final String mid;

  @override
  final rtc.RTCRtpSender sender;
}

/// A transceiver whose `mid` throws, like the web implementation does for a
/// transceiver that has never been negotiated.
class _ThrowingMidTransceiver extends Fake implements rtc.RTCRtpTransceiver {
  _ThrowingMidTransceiver({required String trackId})
    : sender = _FakeSender(_FakeMediaStreamTrack(trackId, 'video'));

  @override
  String get mid => throw TypeError();

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
        transceiver: _FakeTransceiver(mid: '', trackId: videoTrackId),
        liveTransceivers: [
          _FakeTransceiver(mid: '7', trackId: videoTrackId),
          _FakeTransceiver(mid: '0', trackId: audioTrackId, kind: 'audio'),
        ],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, '7');
    });

    test('falls back to the SDP when the live mid is not assigned yet', () {
      final mid = resolveTrackMid(
        transceiver: _FakeTransceiver(mid: '', trackId: videoTrackId),
        liveTransceivers: [_FakeTransceiver(mid: '', trackId: videoTrackId)],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, '3');
    });

    test('falls back to the SDP when the track has no live transceiver', () {
      final mid = resolveTrackMid(
        transceiver: _FakeTransceiver(
          mid: '',
          trackId: audioTrackId,
          kind: 'audio',
        ),
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
        transceiver: _FakeTransceiver(mid: '', trackId: videoTrackId),
        liveTransceivers: const [],
        sdp: sdp,
      );

      expect(mid, '3');
    });

    test('returns null when no m-section carries the track msid', () {
      final mid = resolveTrackMid(
        transceiver: _FakeTransceiver(mid: '', trackId: videoTrackId),
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
        // The track is video, but only the audio m-section carries its msid.
        transceiver: _FakeTransceiver(mid: '', trackId: videoTrackId),
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
        transceiver: _FakeTransceiver(mid: ''),
        liveTransceivers: [_FakeTransceiver(mid: '3', trackId: videoTrackId)],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, isNull);
    });

    test('returns null when the sender has no track', () {
      final mid = resolveTrackMid(
        transceiver: _FakeTransceiver(mid: '', hasTrack: false),
        liveTransceivers: [_FakeTransceiver(mid: '3', trackId: videoTrackId)],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, isNull);
    });

    test('falls back to the mid on the given transceiver as a last resort', () {
      // Both live sources are unavailable — a rejoin reading the previous
      // session's publisher, which is already closed.
      final mid = resolveTrackMid(
        transceiver: _FakeTransceiver(mid: '4', trackId: videoTrackId),
        liveTransceivers: const [],
        sdp: null,
      );

      expect(mid, '4');
    });

    test('prefers the live mid over the one on the given transceiver', () {
      final mid = resolveTrackMid(
        // Stale snapshot: this transceiver was cached before the m-line moved.
        transceiver: _FakeTransceiver(mid: '1', trackId: videoTrackId),
        liveTransceivers: [_FakeTransceiver(mid: '7', trackId: videoTrackId)],
        sdp: null,
      );

      expect(mid, '7');
    });

    test('prefers the SDP over the mid on the given transceiver', () {
      final mid = resolveTrackMid(
        transceiver: _FakeTransceiver(mid: '1', trackId: videoTrackId),
        liveTransceivers: const [],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, '3');
    });

    test('returns null when reading the mid throws', () {
      // On web `mid` reads through to the JS transceiver and null-asserts, so
      // it throws for one that has never been negotiated.
      final mid = resolveTrackMid(
        transceiver: _ThrowingMidTransceiver(trackId: videoTrackId),
        liveTransceivers: const [],
        sdp: null,
      );

      expect(mid, isNull);
    });

    test('falls through to the SDP when the live mid throws', () {
      // Same web behaviour, but hit through the live lookup: a matching
      // transceiver that has never been negotiated must not abort the whole
      // announce, it must let the SDP answer instead.
      final mid = resolveTrackMid(
        transceiver: _ThrowingMidTransceiver(trackId: videoTrackId),
        liveTransceivers: [_ThrowingMidTransceiver(trackId: videoTrackId)],
        sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: videoTrackId),
      );

      expect(mid, '3');
    });

    test('returns null when the live mid throws and nothing else '
        'resolves', () {
      final mid = resolveTrackMid(
        transceiver: _ThrowingMidTransceiver(trackId: videoTrackId),
        liveTransceivers: [_ThrowingMidTransceiver(trackId: videoTrackId)],
        sdp: null,
      );

      expect(mid, isNull);
    });

    test('returns null when there is no SDP and no live mid', () {
      final mid = resolveTrackMid(
        transceiver: _FakeTransceiver(mid: '', trackId: videoTrackId),
        liveTransceivers: [_FakeTransceiver(mid: '', trackId: videoTrackId)],
        sdp: null,
      );

      expect(mid, isNull);
    });

    test('returns null instead of throwing on malformed SDP', () {
      final mid = resolveTrackMid(
        transceiver: _FakeTransceiver(mid: '', trackId: videoTrackId),
        liveTransceivers: const [],
        sdp: 'not an sdp at all',
      );

      expect(mid, isNull);
    });

    group('after the sender track was replaced', () {
      // `RtcLocalTrack.recreate` (unmute-with-restart, camera facing/parameter
      // change) attaches a fresh clone to the sender without updating the
      // transceiver cache, so the cached track id goes stale. Resolution must
      // follow the sender's current track, otherwise every lookup misses and
      // the track is dropped from the announce.
      const staleTrackId = 'stale-clone-id';
      const currentTrackId = 'current-clone-id';

      test('matches the live transceiver by the current track id', () {
        final mid = resolveTrackMid(
          transceiver: _FakeTransceiver(mid: '', trackId: currentTrackId),
          liveTransceivers: [
            _FakeTransceiver(mid: '7', trackId: currentTrackId),
          ],
          sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: staleTrackId),
        );

        expect(mid, '7');
      });

      test('matches the SDP msid by the current track id', () {
        final mid = resolveTrackMid(
          transceiver: _FakeTransceiver(mid: '', trackId: currentTrackId),
          liveTransceivers: [
            _FakeTransceiver(mid: '', trackId: currentTrackId),
          ],
          // A freshly created offer names the clone that is attached now.
          sdp: _sdp(audioTrackId: audioTrackId, videoTrackId: currentTrackId),
        );

        expect(mid, '3');
      });
    });
  });
}
