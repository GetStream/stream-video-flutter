import '../webrtc/model/stats/rtc_printable_stats.dart';
import '../webrtc/model/stats/rtc_raw_stats.dart';
import '../webrtc/peer_type.dart';

class CallStats {
  CallStats({
    required this.peerType,
    required this.printable,
    required this.raw,
  });

  final StreamPeerType peerType;
  final RtcPrintableStats printable;
  final RtcRawStats raw;

  @override
  String toString() {
    return 'CallStats{peerType: $peerType, printable: $printable, raw: $raw}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStats &&
          runtimeType == other.runtimeType &&
          peerType == other.peerType &&
          printable == other.printable &&
          raw == other.raw;

  @override
  int get hashCode => peerType.hashCode ^ printable.hashCode ^ raw.hashCode;
}
