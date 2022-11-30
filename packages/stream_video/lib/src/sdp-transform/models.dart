import 'package:equatable/equatable.dart';

// class Sdp {
//   const Sdp({
//     required this.origin,
//     required this.name,
//     required this.timing,
//     required this.connection,
//     required this.iceUfrag,
//     required this.icePwd,
//     required this.fingerprint,
//     required this.media,
//   });
//
//   final Origin origin;
//   final String name;
//   final Timing timing;
//   final Connection connection;
//   final String iceUfrag;
//   final String icePwd;
//   final Fingerprint fingerprint;
//   final List<Media> media;
//
//   factory Sdp.fromJson(Map<String, dynamic> json) => Sdp(
//         origin: Origin.fromJson(json['origin']),
//         name: json['name'],
//         timing: Timing.fromJson(json['timing']),
//         connection: Connection.fromJson(json['connection']),
//         iceUfrag: json['iceUfrag'],
//         icePwd: json['icePwd'],
//         fingerprint: Fingerprint.fromJson(json['fingerprint']),
//         media: List<Media>.from(json['media'].map((x) => Media.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         'origin': origin.toJson(),
//         'name': name,
//         'timing': timing.toJson(),
//         'connection': connection.toJson(),
//         'iceUfrag': iceUfrag,
//         'icePwd': icePwd,
//         'fingerprint': fingerprint.toJson(),
//         'media': List<dynamic>.from(media.map((x) => x.toJson())),
//       };
// }
//
// class Connection {
//   const Connection({
//     required this.version,
//     required this.ip,
//   });
//
//   final int version;
//   final String ip;
//
//   factory Connection.fromJson(Map<String, dynamic> json) => Connection(
//         version: json['version'],
//         ip: json['ip'],
//       );
//
//   Map<String, dynamic> toJson() => {
//         'version': version,
//         'ip': ip,
//       };
// }
//
// class Fingerprint {
//   Fingerprint({
//     required this.type,
//     required this.hash,
//   });
//
//   final String type;
//   final String hash;
//
//   factory Fingerprint.fromJson(Map<String, dynamic> json) => Fingerprint(
//         type: json['type'],
//         hash: json['hash'],
//       );
//
//   Map<String, dynamic> toJson() => {
//         'type': type,
//         'hash': hash,
//       };
// }
//
// class Media {
//   Media({
//     required this.rtp,
//     required this.fmtp,
//     required this.type,
//     required this.port,
//     required this.protocol,
//     required this.payloads,
//     required this.ptime,
//     required this.direction,
//     required this.candidates,
//   });
//
//   final List<Rtp> rtp;
//   final List<Fmtp> fmtp;
//   final String type;
//   final int port;
//   final String protocol;
//   final String payloads;
//   final int ptime;
//   final String direction;
//   final List<Candidate> candidates;
//
//   factory Media.fromJson(Map<String, dynamic> json) => Media(
//         rtp: List<Rtp>.from(json['rtp'].map((x) => Rtp.fromJson(x))),
//         fmtp: json['fmtp'] == null
//             ? null
//             : List<dynamic>.from(json['fmtp'].map((x) => x)),
//         type: json['type'] == null ? null : json['type'],
//         port: json['port'] == null ? null : json['port'],
//         protocol: json['protocol'] == null ? null : json['protocol'],
//         payloads: json['payloads'] == null ? null : json['payloads'],
//         ptime: json['ptime'] == null ? null : json['ptime'],
//         direction: json['direction'] == null ? null : json['direction'],
//         candidates: json['candidates'] == null
//             ? null
//             : List<Candidate>.from(
//                 json['candidates'].map((x) => Candidate.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         'rtp': List<dynamic>.from(rtp.map((x) => x.toJson())),
//         'fmtp': fmtp == null ? null : List<dynamic>.from(fmtp.map((x) => x)),
//         'type': type == null ? null : type,
//         'port': port == null ? null : port,
//         'protocol': protocol == null ? null : protocol,
//         'payloads': payloads == null ? null : payloads,
//         'ptime': ptime == null ? null : ptime,
//         'direction': direction == null ? null : direction,
//         'candidates': candidates == null
//             ? null
//             : List<dynamic>.from(candidates.map((x) => x.toJson())),
//       };
// }
//
// class Candidate {
//   Candidate({
//     required this.foundation,
//     required this.component,
//     required this.transport,
//     required this.priority,
//     required this.ip,
//     required this.port,
//     required this.type,
//   });
//
//   final int foundation;
//   final int component;
//   final String transport;
//   final int priority;
//   final String ip;
//   final int port;
//   final String type;
//
//   factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
//         foundation: json['foundation'],
//         component: json['component'],
//         transport: json['transport'],
//         priority: json['priority'],
//         ip: json['ip'],
//         port: json['port'],
//         type: json['type'],
//       );
//
//   Map<String, dynamic> toJson() => {
//         'foundation': foundation,
//         'component': component,
//         'transport': transport,
//         'priority': priority,
//         'ip': ip,
//         'port': port,
//         'type': type,
//       };
// }
//
// class Rtp {
//   Rtp({
//     required this.payload,
//     required this.codec,
//     required this.rate,
//   });
//
//   final int payload;
//   final String codec;
//   final int rate;
//
//   factory Rtp.fromJson(Map<String, dynamic> json) => Rtp(
//         payload: json['payload'],
//         codec: json['codec'],
//         rate: json['rate'],
//       );
//
//   Map<String, dynamic> toJson() => {
//         'payload': payload,
//         'codec': codec,
//         'rate': rate,
//       };
// }
//
// class Origin {
//   Origin({
//     required this.username,
//     required this.sessionId,
//     required this.sessionVersion,
//     required this.netType,
//     required this.ipVer,
//     required this.address,
//   });
//
//   final String username;
//   final int sessionId;
//   final int sessionVersion;
//   final String netType;
//   final int ipVer;
//   final String address;
//
//   factory Origin.fromJson(Map<String, dynamic> json) => Origin(
//         username: json['username'],
//         sessionId: json['sessionId'],
//         sessionVersion: json['sessionVersion'],
//         netType: json['netType'],
//         ipVer: json['ipVer'],
//         address: json['address'],
//       );
//
//   Map<String, dynamic> toJson() => {
//         'username': username,
//         'sessionId': sessionId,
//         'sessionVersion': sessionVersion,
//         'netType': netType,
//         'ipVer': ipVer,
//         'address': address,
//       };
// }
//
// class Timing {
//   Timing({
//     required this.start,
//     required this.stop,
//   });
//
//   final int start;
//   final int stop;
//
//   factory Timing.fromJson(Map<String, dynamic> json) => Timing(
//         start: json['start'],
//         stop: json['stop'],
//       );
//
//   Map<String, dynamic> toJson() => {
//         'start': start,
//         'stop': stop,
//       };
// }

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
    this.rate,
  });

  final int payload;
  final String codec;
  final int? rate;

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
