import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/sdp/incoming_audio_sources.dart';

typedef _Section = ({
  String kind,
  String mid,
  String? direction,
  String? msid,
  List<int> ssrcs,
});

/// One m-section of an SFU subscriber offer.
_Section _section(
  String kind,
  String mid, {
  String? direction = 'sendonly',
  String? msid,
  List<int> ssrcs = const [],
}) => (kind: kind, mid: mid, direction: direction, msid: msid, ssrcs: ssrcs);

String _offer(List<_Section> sections) {
  return [
    'v=0\r\n',
    'o=- 1 2 IN IP4 127.0.0.1\r\n',
    's=-\r\n',
    't=0 0\r\n',
    for (final section in sections) ...[
      if (section.kind == 'audio')
        'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n'
      else
        'm=video 9 UDP/TLS/RTP/SAVPF 96\r\n',
      'c=IN IP4 0.0.0.0\r\n',
      'a=mid:${section.mid}\r\n',
      if (section.direction case final direction?) 'a=$direction\r\n',
      if (section.msid case final msid?) 'a=msid:$msid\r\n',
      // As the SFU writes them: one line per attribute of each SSRC.
      for (final ssrc in section.ssrcs) ...[
        'a=ssrc:$ssrc cname:${section.msid ?? 'cname'}\r\n',
        if (section.msid case final msid?) 'a=ssrc:$ssrc msid:$msid\r\n',
      ],
    ],
    'm=application 9 UDP/DTLS/SCTP webrtc-datachannel\r\n',
    'c=IN IP4 0.0.0.0\r\n',
    'a=mid:data\r\n',
  ].join();
}

void main() {
  group('incomingAudioSources', () {
    test(
      'lists the audio sections the SFU sends on, keyed by mid and msid',
      () {
        final sdp = _offer([
          _section('audio', '0', msid: 'alice:TRACK_TYPE_AUDIO a1'),
          _section('video', '1', msid: 'alice:TRACK_TYPE_VIDEO v1'),
          _section(
            'audio',
            '2',
            direction: 'sendrecv',
            msid: 'bob:TRACK_TYPE_AUDIO a2',
          ),
        ]);

        expect(incomingAudioSources(sdp), {
          '0|alice:TRACK_TYPE_AUDIO a1|',
          '2|bob:TRACK_TYPE_AUDIO a2|',
        });
      },
    );

    test('treats a section without a direction as sendrecv', () {
      final sdp = _offer([_section('audio', '0', direction: null)]);

      expect(incomingAudioSources(sdp), {'0||'});
    });

    test('keys a section by its SSRCs too, each named once', () {
      final sdp = _offer([
        _section(
          'audio',
          '0',
          msid: 'alice:TRACK_TYPE_AUDIO a1',
          ssrcs: [2000, 1000],
        ),
      ]);

      expect(incomingAudioSources(sdp), {
        '0|alice:TRACK_TYPE_AUDIO a1|1000,2000',
      });
    });

    test('skips inactive and recvonly audio sections', () {
      final sdp = _offer([
        _section('audio', '0', direction: 'inactive', msid: 'gone a1'),
        _section('audio', '1', direction: 'recvonly'),
      ]);

      expect(incomingAudioSources(sdp), isEmpty);
    });

    test('reads text that is not SDP as no sources', () {
      expect(incomingAudioSources('not sdp'), isEmpty);
      expect(incomingAudioSources(''), isEmpty);
    });
  });

  group('offerAddsIncomingAudio', () {
    final alice = _section('audio', '0', msid: 'alice:TRACK_TYPE_AUDIO a1');
    final aliceVideo = _section(
      'video',
      '1',
      msid: 'alice:TRACK_TYPE_VIDEO v1',
    );

    test('is true when a new audio section is appended', () {
      final previous = _offer([alice, aliceVideo]);
      final next = _offer([
        alice,
        aliceVideo,
        _section('audio', '2', msid: 'bob:TRACK_TYPE_AUDIO a2'),
      ]);

      expect(offerAddsIncomingAudio(previous: previous, next: next), isTrue);
    });

    test(
      'is true when an inactive audio section is reused for a new track',
      () {
        final previous = _offer([
          alice,
          _section('audio', '2', direction: 'inactive', msid: 'gone a2'),
        ]);
        final next = _offer([
          alice,
          _section('audio', '2', msid: 'bob:TRACK_TYPE_AUDIO a3'),
        ]);

        expect(offerAddsIncomingAudio(previous: previous, next: next), isTrue);
      },
    );

    // The SFU moving another participant onto an m-line it is already sending
    // on, without retiring it first.
    test('is true when a sending audio section changes track', () {
      final previous = _offer([
        _section(
          'audio',
          '0',
          msid: 'alice:TRACK_TYPE_AUDIO a1',
          ssrcs: [1000],
        ),
      ]);
      final next = _offer([
        _section('audio', '0', msid: 'bob:TRACK_TYPE_AUDIO a2', ssrcs: [2000]),
      ]);

      expect(offerAddsIncomingAudio(previous: previous, next: next), isTrue);
    });

    test('is true when a section without an msid changes SSRC', () {
      final previous = _offer([
        _section('audio', '0', ssrcs: [1000]),
      ]);
      final next = _offer([
        _section('audio', '0', ssrcs: [2000]),
      ]);

      expect(offerAddsIncomingAudio(previous: previous, next: next), isTrue);
    });

    test('is false when a section keeps its track and SSRCs', () {
      final section = _section(
        'audio',
        '0',
        msid: 'alice:TRACK_TYPE_AUDIO a1',
        ssrcs: [1000],
      );
      final previous = _offer([section]);
      final next = _offer([
        section,
        _section('video', '1', msid: 'bob:TRACK_TYPE_VIDEO v2', ssrcs: [3000]),
      ]);

      expect(offerAddsIncomingAudio(previous: previous, next: next), isFalse);
    });

    test('is false when only video was added', () {
      final previous = _offer([alice]);
      final next = _offer([
        alice,
        _section('video', '1', msid: 'bob:TRACK_TYPE_VIDEO v2'),
      ]);

      expect(offerAddsIncomingAudio(previous: previous, next: next), isFalse);
    });

    test('is false when an audio section was removed or went inactive', () {
      final previous = _offer([
        alice,
        _section('audio', '2', msid: 'bob:TRACK_TYPE_AUDIO a2'),
      ]);
      final next = _offer([
        alice,
        _section(
          'audio',
          '2',
          direction: 'inactive',
          msid: 'bob:TRACK_TYPE_AUDIO a2',
        ),
      ]);

      expect(offerAddsIncomingAudio(previous: previous, next: next), isFalse);
    });

    test('is false for an identical offer', () {
      final sdp = _offer([alice, aliceVideo]);

      expect(offerAddsIncomingAudio(previous: sdp, next: sdp), isFalse);
    });
  });
}
