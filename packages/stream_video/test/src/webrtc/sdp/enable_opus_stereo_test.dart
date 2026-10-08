import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/sdp/editor/sdp_editor_impl.dart';
import 'package:stream_video/src/webrtc/sdp/policy/sdp_policy.dart';
import 'package:stream_video/src/webrtc/sdp/sdp.dart';

String _sdp(List<String> lines) => lines.join('\r\n');

List<String> _fmtpLines(String sdp) =>
    sdp.split('\n').where((it) => it.startsWith('a=fmtp:')).toList();

void main() {
  final editor = SdpEditorImpl(const SdpPolicy());

  group('EnableOpusStereoRule', () {
    test('adds stereo=1 to opus in a local answer without sprop-stereo', () {
      final answer = _sdp([
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

      final edited = editor.edit(Sdp.localAnswer(answer))!;

      expect(_fmtpLines(edited), [
        'a=fmtp:111 minptime=10;useinbandfec=1;stereo=1',
        'a=fmtp:63 111/111',
        'a=fmtp:111 minptime=10;useinbandfec=1;stereo=1',
      ]);
    });

    test('keeps an existing stereo=1 unchanged', () {
      final answer = _sdp([
        'v=0',
        'm=audio 9 UDP/TLS/RTP/SAVPF 111',
        'a=mid:0',
        'a=rtpmap:111 opus/48000/2',
        'a=fmtp:111 minptime=10;stereo=1;useinbandfec=1',
      ]);

      final edited = editor.edit(Sdp.localAnswer(answer))!;

      expect(_fmtpLines(edited), [
        'a=fmtp:111 minptime=10;stereo=1;useinbandfec=1',
      ]);
    });

    test('leaves video sections untouched', () {
      final answer = _sdp([
        'v=0',
        'm=video 9 UDP/TLS/RTP/SAVPF 96',
        'a=mid:0',
        'a=rtpmap:96 VP8/90000',
        'a=fmtp:96 x-google-start-bitrate=1000',
      ]);

      final edited = editor.edit(Sdp.localAnswer(answer))!;

      expect(_fmtpLines(edited), ['a=fmtp:96 x-google-start-bitrate=1000']);
    });

    test('does not edit local offers', () {
      final offer = _sdp([
        'v=0',
        'm=audio 9 UDP/TLS/RTP/SAVPF 111',
        'a=mid:0',
        'a=rtpmap:111 opus/48000/2',
        'a=fmtp:111 minptime=10;useinbandfec=1',
      ]);

      final edited = editor.edit(Sdp.localOffer(offer))!;

      expect(_fmtpLines(edited), ['a=fmtp:111 minptime=10;useinbandfec=1']);
    });
  });
}
