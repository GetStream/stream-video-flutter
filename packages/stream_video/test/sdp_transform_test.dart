import 'package:stream_video/src/sdp-transform/models.dart';
import 'package:test/test.dart';

void main() {
//   test('Pass it an unprocessed SDP string. give you a ParsedSdp', () async {
//     const sdpStr = """v=0\r\n\
// o=- 20518 0 IN IP4 203.0.113.1\r\n\
// s= \r\n\
// t=0 0\r\n\
// c=IN IP4 203.0.113.1\r\n\
// a=ice-ufrag:F7gI\r\n\
// a=ice-pwd:x9cml/YzichV2+XlhiMu8g\r\n\
// a=fingerprint:sha-1 42:89:c5:c6:55:9d:6e:c8:e8:83:55:2a:39:f9:b6:eb:e9:a3:a9:e7\r\n\
// m=audio 54400 RTP/SAVPF 0 96\r\n\
// a=rtpmap:0 PCMU/8000\r\n\
// a=rtpmap:96 opus/48000\r\n\
// a=ptime:20\r\n\
// a=sendrecv\r\n\
// a=candidate:0 1 UDP 2113667327 203.0.113.1 54400 typ host\r\n\
// a=candidate:1 2 UDP 2113667326 203.0.113.1 54401 typ host\r\n\
// m=video 55400 RTP/SAVPF 97 98\r\n\
// a=rtpmap:97 H264/90000\r\n\
// a=fmtp:97 profile-level-id=4d0028;packetization-mode=1\r\n\
// a=rtpmap:98 VP8/90000\r\n\
// a=sendrecv\r\n\
// a=candidate:0 1 UDP 2113667327 203.0.113.1 55400 typ host\r\n\
// a=candidate:1 2 UDP 2113667326 203.0.113.1 55401 typ host\r\n\
// """;
//     final ParsedSdp result = parseSdp(sdpStr);

//     expect(result, expectedParsedSdp);
//   });

  test('ParseCandidate', () async {
    final expected_candidate = Candidate(
        foundation: 1,
        component: 2,
        transport: 'UDP',
        priority: 2113667326,
        ip: '203.0.113.1',
        port: 55401,
        type: 'host');
    RegExp exp = RegExp(
        r"^candidate:(?<foundation>\S*) (?<component>\d*) (?<transport>\S*) (?<priority>\d*) (?<ip>\S*) (?<port>\d*) typ (?<type>\S*)(?: raddr (?<raddr>\S*) rport (?<rport>\d*))?(?: tcptype (?<tcptype>\S*))?(?: generation (?<generation>\d*))?(?: network-id (?<networkId>\d*))?(?: network-cost (?<networkCost>\d*))?");
    String str = "candidate:1 2 UDP 2113667326 203.0.113.1 55401 typ host";
    final match = exp.firstMatch(str);//.toList();
    // final match = matches[0];
    final foundation = match!.namedGroup('foundation');
    final component = match.namedGroup('component');
    final transport = match.namedGroup('transport');
    final priority = match.namedGroup('priority');
    final ip = match.namedGroup('ip');
    final port = match.namedGroup('port');
    final type = match.namedGroup('type');
    final candidate = Candidate(
        foundation: int.parse(foundation!),
        component: int.parse(component!),
        transport: transport!,
        priority: int.parse(priority!),
        ip: ip!,
        port: int.parse(port!),
        type: type!);

    expect(candidate, expected_candidate);
  });
}
