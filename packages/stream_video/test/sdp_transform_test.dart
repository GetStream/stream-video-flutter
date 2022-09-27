import 'dart:convert';

import 'package:stream_video/src/sdp-transform/models.dart';
import 'package:test/test.dart';

//given a list split the list into sublists at at given indexes
List<List<T>> splitAt<T>(List<T> list, List<int> indexes) {
  var result = <List<T>>[];
  var start = 0;
  for (var index in indexes) {
    result.add(list.sublist(start, index));
    start = index;
  }
  result.add(list.sublist(start));
  return result;
}

List<int> mediaIndexes(List<String> lines) {
  final mediaIndexes = <int>[];
  lines.asMap().forEach((i, el) {
    if (el.startsWith("m")) {
      mediaIndexes.add(i);
    }
  });
  return mediaIndexes;
}

void main() {
  test('splitAt', () {
    final list = [
      "v",
      "o",
      "s",
      "t",
      "c",
      "a",
      "a",
      "a",
      "m",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "m",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a"
    ];
    expect([
      ['v', 'o', 's', 't', 'c', 'a', 'a', 'a'],
      ['m', 'a', 'a', 'a', 'a', 'a', 'a'],
      ['m', 'a', 'a', 'a', 'a', 'a', 'a']
    ], splitAt(list, [8, 15]));
  });

  test('mediaIndexes', () {
    final list = [
      "v",
      "o",
      "s",
      "t",
      "c",
      "a",
      "a",
      "a",
      "m=audio 54400 RTP/SAVPF 0 96",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "m=video 55400 RTP/SAVPF 97 98",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a"
    ];

    expect(mediaIndexes(list), [8, 15]);
  });
  test('Pass it an unprocessed SDP string. give you a ParsedSdp', () {
    const sdpStr = """v=0\r\n\
o=- 20518 0 IN IP4 203.0.113.1\r\n\
s= \r\n\
t=0 0\r\n\
c=IN IP4 203.0.113.1\r\n\
a=ice-ufrag:F7gI\r\n\
a=ice-pwd:x9cml/YzichV2+XlhiMu8g\r\n\
a=fingerprint:sha-1 42:89:c5:c6:55:9d:6e:c8:e8:83:55:2a:39:f9:b6:eb:e9:a3:a9:e7\r\n\
m=audio 54400 RTP/SAVPF 0 96\r\n\
a=rtpmap:0 PCMU/8000\r\n\
a=rtpmap:96 opus/48000\r\n\
a=ptime:20\r\n\
a=sendrecv\r\n\
a=candidate:0 1 UDP 2113667327 203.0.113.1 54400 typ host\r\n\
a=candidate:1 2 UDP 2113667326 203.0.113.1 54401 typ host\r\n\
m=video 55400 RTP/SAVPF 97 98\r\n\
a=rtpmap:97 H264/90000\r\n\
a=fmtp:97 profile-level-id=4d0028;packetization-mode=1\r\n\
a=rtpmap:98 VP8/90000\r\n\
a=sendrecv\r\n\
a=candidate:0 1 UDP 2113667327 203.0.113.1 55400 typ host\r\n\
a=candidate:1 2 UDP 2113667326 203.0.113.1 55401 typ host\r\n\
""";
    final ls = LineSplitter();
    final lines = ls.convert(sdpStr);
    // final media = lines.asMap().forEach((i, l) {
    //   //  final l = lines[42];
    //   var type = l[0];
    //   var content = l.substring(2);
    //   if (l == "m") {}
    // });
    // expect(actual, matcher)
    // final l = lines[42];
    // var type = l[0];
    // var content = l.substring(2);
    // //parse media
    // expect(type, 'a');
    // expect(content, "candidate:1 2 UDP 2113667326 203.0.113.1 55401 typ host");
    lines.removeWhere((value) => value == "");
    final indexes = mediaIndexes(lines);
    expect(indexes, [8, 15]);
    final medias = splitAt(lines, mediaIndexes(lines));
    // print(medias);
    final first_media = medias[1];
    final candidates = <Candidate>[];
    final fmtps = <Fmtp>[];
    final rtps = <Rtp>[];

    first_media.forEach((mediaLine) {
      // print(mediaLine);
      var type = mediaLine[0];
      var content = mediaLine.substring(2);

      if (mediaLine.contains("candidate")) {
        final candidate = parseCandidate(content);
        candidates.add(candidate);
      }
      if (mediaLine.contains("fmtp")) {
        final fmtp = parseFmtp(content);
        fmtps.add(fmtp);
      }

      if (mediaLine.contains("rtp")) {
        final rtp = parseRtp(content);
        rtps.add(rtp);
      }
    });

    expect(candidates, <Candidate>[
      Candidate(
          foundation: 0,
          component: 1,
          transport: "UDP",
          priority: 2113667327,
          ip: "203.0.113.1",
          port: 54400,
          type: "host"),
      Candidate(
          foundation: 1,
          component: 2,
          transport: "UDP",
          priority: 2113667326,
          ip: "203.0.113.1",
          port: 54401,
          type: "host")
    ]);

    expect(fmtps, <Fmtp>[]);
    expect(rtps, <Rtp>[
      Rtp(payload: 0, codec: "H264", rate: 8000),
      Rtp(payload: 96, codec: "H264", rate: 48000)
    ]);
  });

  test('Parse Origin', () {
    final expected_origin = Origin(
        username: '-',
        sessionId: 20518,
        sessionVersion: 0,
        netType: 'IN',
        ipVer: 4,
        address: '203.0.113.1');
    String str = "- 20518 0 IN IP4 203.0.113.1";
    Origin origin = parseOrigin(str);

    expect(origin, expected_origin);
  });

  test('Parse Timing', () {
    final expected_timing = Timing(start: 0, stop: 0);
    String str = "0 0";
    Timing timing = parseTiming(str);

    expect(timing, expected_timing);
  });

  test('ParseCandidate', () {
    final expected_candidate = Candidate(
        foundation: 1,
        component: 2,
        transport: 'UDP',
        priority: 2113667326,
        ip: '203.0.113.1',
        port: 55401,
        type: 'host');
    String str = "candidate:1 2 UDP 2113667326 203.0.113.1 55401 typ host";
    Candidate candidate = parseCandidate(str);

    expect(candidate, expected_candidate);
  });

  test('ParseConnection', () {
    final expected_connection = Connection(version: 4, ip: '203.0.113.1');
    String str = "IN IP4 203.0.113.1";
    Connection connection = parseConnection(str);

    expect(connection, expected_connection);
  });

  test('ParseFingerPrint', () {
    final expected_fingerprint = Fingerprint(
        type: 'sha-1',
        hash: '42:89:c5:c6:55:9d:6e:c8:e8:83:55:2a:39:f9:b6:eb:e9:a3:a9:e7');
    String str =
        "fingerprint:sha-1 42:89:c5:c6:55:9d:6e:c8:e8:83:55:2a:39:f9:b6:eb:e9:a3:a9:e7";
    Fingerprint fingerprint = parseFingerprint(str);

    expect(fingerprint, expected_fingerprint);
  });

  test('Parse fmtp', () {
    final expected_fmtps = [
      Fmtp(payload: 97, config: 'profile-level-id=4d0028;packetization-mode=1')
    ];
    String str = "fmtp:97 profile-level-id=4d0028;packetization-mode=1";
    Fmtp fmtp = parseFmtp(str);
    final expected_fmtp = expected_fmtps[0];
    expect(fmtp, expected_fmtp);
  });

  test('Parse RTP', () {
    final expected_rtps = <Rtp>[
      Rtp(payload: 97, codec: 'H264', rate: 90000),
      Rtp(payload: 98, codec: 'VP8', rate: 90000)
    ];
    String str = "rtpmap:97 H264/90000";
    Rtp rtp = parseRtp(str);
    final expected_rtp = expected_rtps[0];
    expect(rtp, expected_rtp);
  });
}

Origin parseOrigin(String str) {
  RegExp exp = RegExp(
      r"^(?<username>\S*) (?<sessionId>\d*) (?<sessionVersion>\d*) (?<netType>\S*) IP(?<ipVer>\d) (?<address>\S*)");
  final match = exp.firstMatch(str);
  final username = match!.namedGroup('username');
  final sessionId = match.namedGroup('sessionId');
  final sessionVersion = match.namedGroup('sessionVersion');
  final netType = match.namedGroup('netType');
  final ipVer = match.namedGroup('ipVer');
  final address = match.namedGroup('address');
  return Origin(
    username: username!,
    sessionId: int.parse(sessionId!),
    sessionVersion: int.parse(sessionVersion!),
    netType: netType!,
    ipVer: int.parse(ipVer!),
    address: address!,
  );
}

Timing parseTiming(String str) {
  RegExp exp = RegExp(r"^(?<start>\d*) (?<stop>\d*)");
  final match = exp.firstMatch(str);
  final start = match!.namedGroup('start');
  final stop = match.namedGroup('stop');
  return Timing(start: int.parse(start!), stop: int.parse(stop!));
}

Connection parseConnection(String str) {
  RegExp exp = RegExp(r"^IN IP(?<version>\d) (?<ip>\S*)");
  final match = exp.firstMatch(str);
  final version = match!.namedGroup('version');
  final ip = match.namedGroup('ip');
  return Connection(version: int.parse(version!), ip: ip!);
}

Fingerprint parseFingerprint(String str) {
  RegExp exp = RegExp(r"^fingerprint:(?<type>\S*) (?<hash>\S*)");
  final match = exp.firstMatch(str);
  final type = match!.namedGroup('type');
  final hash = match.namedGroup('hash');
  return Fingerprint(type: type!, hash: hash!);
}

Fmtp parseFmtp(String str) {
  RegExp exp = RegExp(r"^fmtp:(?<payload>\d*) (?<config>[\S| ]*)");
  final match = exp.firstMatch(str);
  final payload = match!.namedGroup('payload');
  final config = match.namedGroup('config');
  return Fmtp(payload: int.parse(payload!), config: config!);
}

Rtp parseRtp(String str) {
  RegExp exp = RegExp(
      r"^rtpmap:(?<payload>\d*) (?<codec>[\w\-.]*)(?:\s*\/(?<rate>\d*)(?:\s*\/(\S*))?)?");
  final match = exp.firstMatch(str);
  final payload = match!.namedGroup('payload');
  final codec = match.namedGroup('codec');
  final rate = match.namedGroup('rate');
  return Rtp(
      payload: int.parse(payload!), codec: 'H264', rate: int.parse(rate!));
}

Candidate parseCandidate(String str) {
  RegExp exp = RegExp(
      r"^candidate:(?<foundation>\S*) (?<component>\d*) (?<transport>\S*) (?<priority>\d*) (?<ip>\S*) (?<port>\d*) typ (?<type>\S*)(?: raddr (?<raddr>\S*) rport (?<rport>\d*))?(?: tcptype (?<tcptype>\S*))?(?: generation (?<generation>\d*))?(?: network-id (?<networkId>\d*))?(?: network-cost (?<networkCost>\d*))?");

  final match = exp.firstMatch(str);
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
  return candidate;
}
