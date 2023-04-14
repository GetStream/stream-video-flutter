// {
//   id: RTCIceCandidate_LwmpU2ZS,
//   type: local-candidate,
//   timestamp: 1679425535359288.0,
//   transportId: RTCTransport_0_1,
//   candidateType: relay,
//   protocol: udp,
//   address: 127.0.0.1,
//   port: 33389,
//   vpn: false,
//   isRemote: false,
//   ip: 127.0.0.1,
//   networkAdapterType: loopback,
//   networkType: unknown,
//   priority: 2122063615,
//   url: turn:sfu-000c954.fdc-ams1.stream-io-video.com:3478?transport=tcp,
//   relayProtocol: tcp,
// }

import 'rtc_writable.dart';

class RtcIceCandidate implements RtcWritable {
  const RtcIceCandidate({
    this.id,
    this.type,
    this.timestamp,
    this.transportId,
    this.candidateType,
    this.protocol,
    this.address,
    this.port,
    this.vpn,
    this.isRemote,
    this.ip,
    this.networkAdapterType,
    this.networkType,
    this.priority,
    this.url,
    this.relayProtocol,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? transportId;
  final String? candidateType;
  final String? protocol;
  final String? address;
  final int? port;
  final bool? vpn;
  final bool? isRemote;
  final String? ip;
  final String? networkAdapterType;
  final String? networkType;
  final int? priority;
  final String? url;
  final String? relayProtocol;

  static RtcIceCandidate? fromJson(dynamic value) {
    if (value is Map) {
      return RtcIceCandidate(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        transportId: value['transportId'],
        candidateType: value['candidateType'],
        protocol: value['protocol'],
        address: value['address'],
        port: value['port'],
        vpn: value['vpn'],
        ip: value['ip'],
        networkAdapterType: value['networkAdapterType'],
        networkType: value['networkType'],
        priority: value['priority'],
        url: value['url'],
        relayProtocol: value['relayProtocol'],
      );
    }
    return null;
  }

  @override
  void writeTo(StringBuffer out) {
    out
      ..write('iceCandidate: ')
      ..write(ip)
      ..write(':')
      ..write(port)
      ..write('\n')
      ..write('protocol: ')
      ..write(protocol)
      ..write('\n')
      ..write('candidateType: ')
      ..write(candidateType)
      ..write('\n');
    if (isRemote != null && isRemote == false) {
      out
        ..write('networkType: ')
        ..write(networkType)
        ..write('\n');
    }
  }
}
