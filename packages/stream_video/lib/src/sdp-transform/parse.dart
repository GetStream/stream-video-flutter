import 'package:stream_video/src/sdp-transform/models.dart';
//Given a string of SDP, return a ParsedSdp object

ParsedSdp parseSdp(String sdpStr) {
  throw UnimplementedError();
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

Media parseMedia(
  String str, {
  required List<Rtp> rtps,
  List<Fmtp>? fmtps,
  required List<Candidate> candidates,
  required String direction,
}) {
  RegExp exp = RegExp(
      r"(?<type>\w*) (?<port>\d*) (?<protocol>[\w/]*)(?: (?<payloads>.*))?");
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