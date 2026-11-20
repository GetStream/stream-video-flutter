import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/sdp/editor/sdp_editor_impl.dart';
import 'package:stream_video/src/webrtc/sdp/policy/sdp_policy.dart';
import 'package:stream_video/src/webrtc/sdp/sdp.dart';

String _sdp(List<String> lines) => lines.join('\r\n');

List<String> _fmtpLines(String sdp) => sdp
    .split('\n')
    .map((it) => it.trimRight())
    .where((it) => it.startsWith('a=fmtp:'))
    .toList();

/// An offer with two audio sections: mid 0 announces `sprop-stereo=1`,
/// mid 1 does not.
final _offer = _sdp([
  'v=0',
  'm=audio 9 UDP/TLS/RTP/SAVPF 111 63',
  'a=mid:0',
  'a=rtpmap:111 opus/48000/2',
  'a=fmtp:111 minptime=10;useinbandfec=1;sprop-stereo=1',
  'a=rtpmap:63 red/48000/2',
  'a=fmtp:63 111/111',
  'm=audio 9 UDP/TLS/RTP/SAVPF 111',
  'a=mid:1',
  'a=rtpmap:111 opus/48000/2',
  'a=fmtp:111 minptime=10;useinbandfec=1',
]);

final _answer = _sdp([
  'v=0',
  'm=audio 9 UDP/TLS/RTP/SAVPF 111 63',
  'a=mid:0',
  'a=rtpmap:111 opus/48000/2',
  'a=fmtp:111 minptime=10;useinbandfec=1',
  'a=rtpmap:63 red/48000/2',
  'a=fmtp:63 111/111',
  'm=audio 9 UDP/TLS/RTP/SAVPF 111',
  'a=mid:1',
  'a=rtpmap:111 opus/48000/2',
  'a=fmtp:111 minptime=10;useinbandfec=1',
]);

String _singleOpusAnswer({String mid = '0', String payloadType = '111'}) =>
    _sdp([
      'v=0',
      'm=audio 9 UDP/TLS/RTP/SAVPF $payloadType',
      'a=mid:$mid',
      'a=rtpmap:$payloadType opus/48000/2',
      'a=fmtp:$payloadType minptime=10',
    ]);

void main() {
  final editor = SdpEditorImpl(const SdpPolicy());

  String editAnswer(String answer, {String? offer}) =>
      editor.edit(Sdp.localAnswer(answer, offerSdp: offer))!;

  group('MirrorSpropStereoRule', () {
    test('adds stereo=1 only to the mids whose offer has sprop-stereo=1', () {
      final edited = editAnswer(_answer, offer: _offer);

      expect(_fmtpLines(edited), [
        'a=fmtp:111 minptime=10;useinbandfec=1;stereo=1',
        'a=fmtp:63 111/111',
        'a=fmtp:111 minptime=10;useinbandfec=1',
      ]);
    });

    test('matches sections by mid, not by position', () {
      final offer = _sdp([
        'v=0',
        'm=audio 9 UDP/TLS/RTP/SAVPF 111',
        'a=mid:5',
        'a=rtpmap:111 opus/48000/2',
        'a=fmtp:111 minptime=10;sprop-stereo=1',
      ]);
      final answer = _sdp([
        'v=0',
        'm=audio 9 UDP/TLS/RTP/SAVPF 111',
        'a=mid:4',
        'a=rtpmap:111 opus/48000/2',
        'a=fmtp:111 minptime=10',
        'm=audio 9 UDP/TLS/RTP/SAVPF 111',
        'a=mid:5',
        'a=rtpmap:111 opus/48000/2',
        'a=fmtp:111 minptime=10',
      ]);

      expect(_fmtpLines(editAnswer(answer, offer: offer)), [
        'a=fmtp:111 minptime=10',
        'a=fmtp:111 minptime=10;stereo=1',
      ]);
    });

    test('follows the Opus payload type of each side', () {
      final offer = _sdp([
        'v=0',
        'm=audio 9 UDP/TLS/RTP/SAVPF 109',
        'a=mid:0',
        'a=rtpmap:109 opus/48000/2',
        'a=fmtp:109 minptime=10;sprop-stereo=1',
      ]);

      expect(
        _fmtpLines(
          editAnswer(_singleOpusAnswer(payloadType: '96'), offer: offer),
        ),
        ['a=fmtp:96 minptime=10;stereo=1'],
      );
    });

    test('ignores sprop-stereo on a non-Opus codec in the offer', () {
      final offer = _sdp([
        'v=0',
        'm=audio 9 UDP/TLS/RTP/SAVPF 111 9',
        'a=mid:0',
        'a=rtpmap:111 opus/48000/2',
        'a=fmtp:111 minptime=10',
        'a=rtpmap:9 G722/8000',
        'a=fmtp:9 sprop-stereo=1',
      ]);

      expect(
        _fmtpLines(editAnswer(_singleOpusAnswer(), offer: offer)),
        ['a=fmtp:111 minptime=10'],
      );
    });

    test('keeps an existing stereo=1 unchanged', () {
      final answer = _sdp([
        'v=0',
        'm=audio 9 UDP/TLS/RTP/SAVPF 111',
        'a=mid:0',
        'a=rtpmap:111 opus/48000/2',
        'a=fmtp:111 minptime=10;stereo=1;useinbandfec=1',
      ]);

      expect(_fmtpLines(editAnswer(answer, offer: _offer)), [
        'a=fmtp:111 minptime=10;stereo=1;useinbandfec=1',
      ]);
    });

    test('leaves the answer unchanged without an offer', () {
      expect(_fmtpLines(editAnswer(_answer)), _fmtpLines(_answer));
    });

    test('leaves the answer unchanged when no offer section is stereo', () {
      final offer = _offer.replaceAll(';sprop-stereo=1', '');

      expect(
        _fmtpLines(editAnswer(_answer, offer: offer)),
        _fmtpLines(_answer),
      );
    });

    test('leaves video sections untouched', () {
      final offer = _sdp([
        'v=0',
        'm=video 9 UDP/TLS/RTP/SAVPF 96',
        'a=mid:0',
        'a=rtpmap:96 VP8/90000',
        'a=fmtp:96 sprop-stereo=1',
      ]);
      final answer = _sdp([
        'v=0',
        'm=video 9 UDP/TLS/RTP/SAVPF 96',
        'a=mid:0',
        'a=rtpmap:96 VP8/90000',
        'a=fmtp:96 x-google-start-bitrate=1000',
      ]);

      expect(_fmtpLines(editAnswer(answer, offer: offer)), [
        'a=fmtp:96 x-google-start-bitrate=1000',
      ]);
    });

    test('does not edit local offers', () {
      final edited = editor.edit(Sdp.localOffer(_answer))!;

      expect(_fmtpLines(edited), _fmtpLines(_answer));
    });
  });
}
