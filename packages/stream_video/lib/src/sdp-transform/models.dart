import 'package:equatable/equatable.dart';

class Sdp with EquatableMixin {
  Sdp({
    required this.version,
    required this.origin,
    required this.name,
    required this.timing,
    required this.connection,
    required this.iceUfrag,
    required this.icePwd,
    required this.fingerprint,
    required this.media,
  });

  final int version;
  final Origin origin;
  final String name;
  final Timing timing;
  final Connection connection;
  final String iceUfrag;
  final String icePwd;
  final Fingerprint fingerprint;
  final List<Media> media;
  
  @override
  List<Object?> get props => [
        version,
        origin,
        name,
        timing,
        connection,
        iceUfrag,
        icePwd,
        fingerprint,
        media,
      ];
}

class Connection with EquatableMixin {
  Connection({
    required this.version,
    required this.ip,
  });

  final int version;
  final String ip;

  @override
  List<Object?> get props => [version, ip];
}

class Fingerprint with EquatableMixin {
  Fingerprint({
    required this.type,
    required this.hash,
  });

  final String type;
  final String hash;

  @override
  List<Object?> get props => [type, hash];
}

class Media with EquatableMixin {
  Media({
    required this.rtp,
    this.fmtp,
    required this.type,
    required this.port,
    required this.protocol,
    required this.payloads,
    required this.direction,
    required this.candidates,
  });

  final List<Rtp> rtp;
  final List<Fmtp>? fmtp;
  final String type;
  final int port;
  final String protocol;
  final String payloads;
  final String direction;
  final List<Candidate> candidates;

  @override
  List<Object?> get props =>
      [rtp, fmtp, type, port, protocol, payloads, direction, candidates];
  @override
  String toString() =>
      'rtp: ${rtp.map((e) => e.toString())}, fmtp: ${fmtp?.map((e) => e.toString())}, type: $type, port: $port, protocol: $protocol, payloads: $payloads, direction: $direction, candidates: ${candidates.map((e) => e.toString())}';
}

class Candidate with EquatableMixin {
  Candidate({
    required this.foundation,
    required this.component,
    required this.transport,
    required this.priority,
    required this.ip,
    required this.port,
    required this.type,
  });

  final int foundation;
  final int component;
  final String transport;
  final int priority;
  final String ip;
  final int port;
  final String type;

  @override
  List<Object?> get props =>
      [foundation, component, transport, priority, ip, port, type];
  @override
  String toString() =>
      'foundation: $foundation, component: $component, transport: $transport, priority: $priority, ip: $ip, port: $port, type: $type';
}

class Fmtp with EquatableMixin {
  Fmtp({
    required this.payload,
    required this.config,
  });

  final int payload;
  final String config;

  @override
  List<Object?> get props => [payload, config];

  @override
  String toString() => 'payload: $payload, config: $config';
}

class Rtp with EquatableMixin {
  Rtp({
    required this.payload,
    required this.codec,
    required this.rate,
  });

  final int payload;
  final String codec;
  final int rate;

  @override
  List<Object?> get props => [payload, codec, rate];
  @override
  String toString() => 'payload: $payload, codec: $codec, rate: $rate';
}

class Origin with EquatableMixin {
  Origin({
    required this.username,
    required this.sessionId,
    required this.sessionVersion,
    required this.netType,
    required this.ipVer,
    required this.address,
  });

  final String username;
  final int sessionId;
  final int sessionVersion;
  final String netType;
  final int ipVer;
  final String address;

  @override
  List<Object?> get props =>
      [sessionId, sessionVersion, netType, ipVer, address];
}

class Timing with EquatableMixin {
  Timing({
    required this.start,
    required this.stop,
  });

  final int start;
  final int stop;

  @override
  List<Object?> get props => [start, stop];
}
