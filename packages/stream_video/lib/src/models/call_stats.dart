import 'package:meta/meta.dart';

import '../webrtc/model/stats/rtc_printable_stats.dart';
import '../webrtc/model/stats/rtc_raw_stats.dart';
import '../webrtc/model/stats/rtc_stats.dart';
import '../webrtc/peer_type.dart';

@immutable
class CallStats {
  const CallStats({
    required this.peerType,
    required this.printable,
    required this.raw,
    required this.stats,
  });

  final StreamPeerType peerType;
  final List<RtcStats> stats;
  final RtcPrintableStats printable;
  final Map<String, dynamic> raw;

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
          stats == other.stats &&
          raw == other.raw;

  @override
  int get hashCode =>
      peerType.hashCode ^ printable.hashCode ^ raw.hashCode ^ stats.hashCode;
}
