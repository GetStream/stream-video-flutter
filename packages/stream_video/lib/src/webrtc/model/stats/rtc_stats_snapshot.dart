import 'rtc_printable_stats.dart';
import 'rtc_stats.dart';
import 'rtc_stats_mapper.dart';

/// One `getStats()` tick, parsed once and viewed three ways.
///
/// The platform reports are flattened into [rawStats] eagerly — that is the
/// single walk out of `rtc.StatsReport`. The typed [rtcStats] models and the
/// [printable] dump are derived from those maps on first access and cached, so
/// a caller that only sends the raw blob to the SFU never pays for building
/// models or formatting strings it will not read.
class RtcStatsSnapshot {
  RtcStatsSnapshot(this.rawStats);

  /// An empty snapshot, for peer connections that do not exist yet.
  RtcStatsSnapshot.empty() : rawStats = const [];

  /// The reports as plain maps, ready to be serialized.
  final List<Map<String, dynamic>> rawStats;

  /// The reports as typed models. Built on first access.
  late final List<RtcStats> rtcStats = rawStats.toRtcStats();

  /// The human-readable dump used by the diagnostics overlay and debug logs.
  ///
  /// Built on first access: formatting it walks every report and every one of
  /// its properties into a string, which is wasted work on the many ticks
  /// where nothing is listening.
  late final RtcPrintableStats printable = rawStats.toPrintableRtcStats();
}
