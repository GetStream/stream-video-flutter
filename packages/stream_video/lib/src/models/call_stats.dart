import '../webrtc/peer_type.dart';

class CallStats {
  CallStats({
    required this.peerType,
    required this.remote,
    required this.local,
  });

  final StreamPeerType peerType;
  final String remote;
  final String local;

  @override
  String toString() {
    return 'CallStats{peerType: $peerType, remote: $remote, local: $local}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStats &&
          runtimeType == other.runtimeType &&
          peerType == other.peerType &&
          remote == other.remote &&
          local == other.local;

  @override
  int get hashCode => peerType.hashCode ^ remote.hashCode ^ local.hashCode;
}
