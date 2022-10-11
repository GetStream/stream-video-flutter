import 'package:stream_video/src/sdp-transform/parse.dart';
import 'package:test/test.dart';
import 'package:collection/collection.dart';
main() {
  test('test', () {
    final sdpStr = """v=0
o=- 6210481536300878120 2 IN IP4 127.0.0.1
s=-
t=0 0
a=group:BUNDLE 0 1 2
a=extmap-allow-mixed
a=msid-semantic: WMS
m=audio 9 UDP/TLS/RTP/SAVPF 111 63 103 104 9 102 0 8 106 105 13 110 112 113 126
c=IN IP4 0.0.0.0
a=rtcp:9 IN IP4 0.0.0.0
a=ice-ufrag:HoqB
a=ice-pwd:z5PKd9AV/x8c1XpLXNEAZF5I
a=ice-options:trickle renomination
a=fingerprint:sha-256 42:79:CC:7F:13:53:81:54:84:AB:9D:A3:E1:02:36:B8:EC:23:1B:1A:2F:04:B2:D3:D5:5D:A8:0F:78:42:56:17
a=setup:actpass
a=mid:0
a=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level
a=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time
a=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01
a=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid
a=sendonly
a=msid:- 142f93b4-bfb7-4423-9f87-e46064244016
a=rtcp-mux
a=rtpmap:111 opus/48000/2
a=rtcp-fb:111 transport-cc
a=fmtp:111 minptime=10;useinbandfec=1
a=rtpmap:63 red/48000/2
a=fmtp:63 111/111
a=rtpmap:103 ISAC/16000
a=rtpmap:104 ISAC/32000
a=rtpmap:9 G722/8000
a=rtpmap:102 ILBC/8000
a=rtpmap:0 PCMU/8000
a=rtpmap:8 PCMA/8000
a=rtpmap:106 CN/32000
a=rtpmap:105 CN/16000
a=rtpmap:13 CN/8000
a=rtpmap:110 telephone-event/48000
a=rtpmap:112 telephone-event/32000
a=rtpmap:113 telephone-event/16000
a=rtpmap:126 telephone-event/8000
a=ssrc:2971538723 cname:lIFjiXOBuM+eWCPv
a=ssrc:2971538723 msid:- 142f93b4-bfb7-4423-9f87-e46064244016
m=audio 9 UDP/TLS/RTP/SAVPF 111 63 103 104 9 102 0 8 106 105 13 110 112 113 126
c=IN IP4 0.0.0.0
a=rtcp:9 IN IP4 0.0.0.0
a=ice-ufrag:HoqB
a=ice-pwd:z5PKd9AV/x8c1XpLXNEAZF5I
a=ice-options:trickle renomination
a=fingerprint:sha-256 42:79:CC:7F:13:53:81:54:84:AB:9D:A3:E1:02:36:B8:EC:23:1B:1A:2F:04:B2:D3:D5:5D:A8:0F:78:42:56:17
a=setup:actpass
a=mid:1
a=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level
a=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time
a=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01
a=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid
a=recvonly
a=rtcp-mux
a=rtpmap:111 opus/48000/2
a=rtcp-fb:111 transport-cc
a=fmtp:111 minptime=10;useinbandfec=1
a=rtpmap:63 red/48000/2
a=fmtp:63 111/111
a=rtpmap:103 ISAC/16000
a=rtpmap:104 ISAC/32000
a=rtpmap:9 G722/8000
a=rtpmap:102 ILBC/8000
a=rtpmap:0 PCMU/8000
a=rtpmap:8 PCMA/8000
a=rtpmap:106 CN/32000
a=rtpmap:105 CN/16000
a=rtpmap:13 CN/8000
a=rtpmap:110 telephone-event/48000
a=rtpmap:112 telephone-event/32000
a=rtpmap:113 telephone-event/16000
a=rtpmap:126 telephone-event/8000
m=video 9 UDP/TLS/RTP/SAVPF 96 97 98 99 35 36 100 101 125 124 127 37
c=IN IP4 0.0.0.0
a=rtcp:9 IN IP4 0.0.0.0
a=ice-ufrag:HoqB
a=ice-pwd:z5PKd9AV/x8c1XpLXNEAZF5I
a=ice-options:trickle renomination
a=fingerprint:sha-256 42:79:CC:7F:13:53:81:54:84:AB:9D:A3:E1:02:36:B8:EC:23:1B:1A:2F:04:B2:D3:D5:5D:A8:0F:78:42:56:17
a=setup:actpass
a=mid:2
a=extmap:14 urn:ietf:params:rtp-hdrext:toffset
a=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time
a=extmap:13 urn:3gpp:video-orientation
a=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01
a=extmap:5 http://www.webrtc.org/experiments/rtp-hdrext/playout-delay
a=extmap:6 http://www.webrtc.org/experiments/rtp-hdrext/video-content-type
a=extmap:7 http://www.webrtc.org/experiments/rtp-hdrext/video-timing
a=extmap:8 http://www.webrtc.org/experiments/rtp-hdrext/color-space
a=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid
a=extmap:10 urn:ietf:params:rtp-hdrext:sdes:rtp-stream-id
a=extmap:11 urn:ietf:params:rtp-hdrext:sdes:repaired-rtp-stream-id
a=recvonly
a=rtcp-mux
a=rtcp-rsize
a=rtpmap:96 VP8/90000
a=rtcp-fb:96 goog-remb
a=rtcp-fb:96 transport-cc
a=rtcp-fb:96 ccm fir
a=rtcp-fb:96 nack
a=rtcp-fb:96 nack pli
a=rtpmap:97 rtx/90000
a=fmtp:97 apt=96
a=rtpmap:98 VP9/90000
a=rtcp-fb:98 goog-remb
a=rtcp-fb:98 transport-cc
a=rtcp-fb:98 ccm fir
a=rtcp-fb:98 nack
a=rtcp-fb:98 nack pli
a=rtpmap:99 rtx/90000
a=fmtp:99 apt=98
a=rtpmap:35 AV1/90000
a=rtcp-fb:35 goog-remb
a=rtcp-fb:35 transport-cc
a=rtcp-fb:35 ccm fir
a=rtcp-fb:35 nack
a=rtcp-fb:35 nack pli
a=rtpmap:36 rtx/90000
a=fmtp:36 apt=35
a=rtpmap:100 H264/90000
a=rtcp-fb:100 goog-remb
a=rtcp-fb:100 transport-cc
a=rtcp-fb:100 ccm fir
a=rtcp-fb:100 nack
a=rtcp-fb:100 nack pli
a=fmtp:100 level-asymmetry-allowed=1;packetization-mode=1;profile-level-id=42e01f
a=rtpmap:101 rtx/90000
a=fmtp:101 apt=100
a=rtpmap:125 red/90000
a=rtpmap:124 rtx/90000
a=fmtp:124 apt=125
a=rtpmap:127 ulpfec/90000
a=rtpmap:37 flexfec-03/90000
a=rtcp-fb:37 goog-remb
a=rtcp-fb:37 transport-cc
a=fmtp:37 repair-window=10000000
""";
    final parsedSdp = parseSdp(sdpStr);
    // final supportedCodecs = <Map<String, dynamic>>[];
    // parsedSdp.media.forEach((media) {
    //   media.rtp.forEach((rtp) {
    //     final fmtpLine =
    //         media.fmtp?.firstWhere((f) => f.payload == rtp.payload,orElse: null);
    //     supportedCodecs.add({
    //       "hwAccelerated": true,
    //       "clockRate": rtp.rate ?? 0,
    //       "fmtpLine": fmtpLine?.config ?? '',
    //       // mime: '$kind/${rtp.codec}',
    //     });
    //   });
    // });
    // expect(sdp, parsedSdp);
  });
}
