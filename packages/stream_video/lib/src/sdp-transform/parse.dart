import 'dart:convert';

import 'package:stream_video/src/sdp-transform/models.dart';
import 'package:stream_video/src/sdp-transform/utils.dart';

/// Given a raw SDP string, return a parsed Sdp object
Sdp parseSdp(String sdpStr) {
  final ls = LineSplitter();
  final lines = ls.convert(sdpStr);

  lines.removeWhere((value) => value == "");
  final indexes = mediaIndexes(lines);
  final splitted = splitAt(lines, mediaIndexes(lines));
  final header = splitted.removeAt(0);
  Origin? origin;
  Timing? timing;
  Connection? connection;
  Fingerprint? fingerprint;
  int? version;
  String? name;
  String? icePwd;
  String? iceUfrag;
  header.forEach((line) {
    var type = line[0];
    var content = line.substring(2);

    if (type == "o") {
      origin = parseOrigin(content);
    }
    if (type == "t") {
      timing = parseTiming(content);
    }
    if (type == "c") {
      connection = parseConnection(content);
    }

    if (type == "v") {
      version = parseVersion(content);
    }

    if (type == "s") {
      name = parseName(content);
    }

    if (line.contains("fingerprint")) {
      fingerprint = parseFingerprint(content);
    }
    if (line.contains("ice-ufrag")) {
      iceUfrag = parseIceUfrag(content);
    }
    if (line.contains("ice-pwd")) {
      icePwd = parseIcePwd(content);
    }
  });
  final medias = <Media>[];
  splitted.forEach((media) {
    final candidates = <Candidate>[];
    final fmtps = <Fmtp>[];
    final rtps = <Rtp>[];

    var directions = "";
    media.reversed.forEach((mediaLine) {
      var type = mediaLine[0];
      var content = mediaLine.substring(2);

      if (mediaLine.contains("sendrecv") |
          mediaLine.contains("recvonly") |
          mediaLine.contains("sendonly") |
          mediaLine.contains("inactive")) {
        directions = content;
      }

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

      if (type == "m") {
        final media = parseMedia(
          content,
          candidates: candidates,
          fmtps: fmtps.isEmpty ? null : fmtps,
          rtps: rtps,
          direction: directions,
        );
        medias.add(media);
      }
    });
  });
  final result = sdp(
    connection: connection!,
    fingerprint: fingerprint!,
    icePwd: icePwd!,
    iceUfrag: iceUfrag!,
    media: medias,
    name: name!,
    origin: origin!,
    timing: timing!,
    version: version!,
  );
  return result;
}

Sdp sdp({
  required Origin origin,
  required Timing timing,
  required Connection connection,
  required Fingerprint fingerprint,
  required List<Media> media,
  required int version,
  required String iceUfrag,
  required String name,
  required String icePwd,
}) =>
    Sdp(
      version: version,
      origin: origin,
      name: name,
      timing: timing,
      connection: connection,
      iceUfrag: iceUfrag, // 'F7gI',
      icePwd: icePwd, //'x9cml/YzichV2+XlhiMu8g',
      fingerprint: fingerprint,
      media: media,
    );

String parseName(String str) {
  RegExp exp = RegExp(r"(?<name>.*)");
  final match = exp.firstMatch(str);
  final name = match!.namedGroup('name');
  return name!;
}

int parseVersion(String str) {
  RegExp exp = RegExp(r"^(?<version>\d*)");
  final match = exp.firstMatch(str);
  final version = match!.namedGroup('version');
  return int.parse(version!);
}

String parseIcePwd(String str) {
  RegExp exp = RegExp(r"^ice-pwd:(?<icePwd>\S*)");
  final match = exp.firstMatch(str);
  final icePwd = match!.namedGroup('icePwd');
  return icePwd!;
}

String parseIceUfrag(String str) {
  RegExp exp = RegExp(r"^ice-ufrag:(?<iceUfrag>\S*)");
  final match = exp.firstMatch(str);
  final iceUfrag = match!.namedGroup('iceUfrag');
  return iceUfrag!;
}

Origin parseOrigin(String str) {
  RegExp exp = RegExp(
    r"^(?<username>\S*) (?<sessionId>\d*) (?<sessionVersion>\d*) (?<netType>\S*) IP(?<ipVer>\d) (?<address>\S*)",
  );
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

Media parseMedia(
  String str, {
  required List<Rtp> rtps,
  List<Fmtp>? fmtps,
  required List<Candidate> candidates,
  required String direction,
}) {
  RegExp exp = RegExp(
    r"(?<type>\w*) (?<port>\d*) (?<protocol>[\w/]*)(?: (?<payloads>.*))?",
  );
  final match = exp.firstMatch(str);
  final type = match!.namedGroup('type');
  final port = match.namedGroup('port');
  final protocol = match.namedGroup('protocol');
  final payloads = match.namedGroup('payloads');

  return Media(
    rtp: rtps,
    fmtp: fmtps,
    type: type!,
    port: int.parse(port!),
    protocol: protocol!,
    payloads: payloads!,
    direction: direction,
    candidates: candidates,
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
    r"^rtpmap:(?<payload>\d*) (?<codec>[\w\-.]*)(?:\s*\/(?<rate>\d*)(?:\s*\/(\S*))?)?",
  );
  final match = exp.firstMatch(str);
  final payload = match!.namedGroup('payload');
  final codec = match.namedGroup('codec');
  final rate = match.namedGroup('rate');
  return Rtp(
    payload: int.parse(payload!),
    codec: 'H264',
    rate: int.parse(rate!),
  );
}

Candidate parseCandidate(String str) {
  RegExp exp = RegExp(
    r"^candidate:(?<foundation>\S*) (?<component>\d*) (?<transport>\S*) (?<priority>\d*) (?<ip>\S*) (?<port>\d*) typ (?<type>\S*)(?: raddr (?<raddr>\S*) rport (?<rport>\d*))?(?: tcptype (?<tcptype>\S*))?(?: generation (?<generation>\d*))?(?: network-id (?<networkId>\d*))?(?: network-cost (?<networkCost>\d*))?",
  );

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
    type: type!,
  );
  return candidate;
}
