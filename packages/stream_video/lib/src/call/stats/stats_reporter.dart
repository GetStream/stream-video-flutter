import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:thermal/thermal.dart';

import '../../models/models.dart';
import '../../platform_detector/platform_detector.dart';
import '../../webrtc/model/stats/rtc_codec.dart';
import '../../webrtc/model/stats/rtc_ice_candidate_pair.dart';
import '../../webrtc/model/stats/rtc_inbound_rtp_video_stream.dart';
import '../../webrtc/model/stats/rtc_outbound_rtp_video_stream.dart';
import '../../webrtc/model/stats/rtc_printable_stats.dart';
import '../../webrtc/peer_type.dart';
import '../../webrtc/rtc_manager.dart';

class StatsReporter extends StateNotifier<CallMetrics?> {
  StatsReporter({
    required this.rtcManager,
    required this.clientEnvironment,
    Battery? battery,
    Thermal? thermal,
  }) : super(null) {
    _battery = battery ?? Battery();
    _thermal = thermal ?? Thermal();
  }

  final RtcManager rtcManager;
  final ClientEnvironment clientEnvironment;

  late Battery _battery;
  late Thermal _thermal;

  CallMetrics? get currentMetrics => state;

  Stream<
    ({
      PeerConnectionStatsBundle publisherStatsBundle,
      PeerConnectionStatsBundle subscriberStatsBundle,
    })
  >
  run({
    Duration interval = const Duration(seconds: 10),
  }) {
    return Stream.periodic(interval, (tick) => (collectStats(), tick)).asyncMap(
      (data) async {
        final stats = await data.$1;
        if (!mounted) return stats;

        unawaited(_processStats(stats, data.$2));
        return stats;
      },
    );
  }

  Future<
    ({
      PeerConnectionStatsBundle publisherStatsBundle,
      PeerConnectionStatsBundle subscriberStatsBundle,
    })
  >
  collectStats() async {
    final publisherStatsBundle = await rtcManager.publisher?.getStats();
    final subscriberStatsBundle = await rtcManager.subscriber.getStats();

    final publisherStats = PeerConnectionStatsBundle(
      peerType: StreamPeerType.publisher,
      stats: publisherStatsBundle?.rtcStats ?? [],
      printable:
          publisherStatsBundle?.printable ??
          const RtcPrintableStats(local: '', remote: ''),
      raw: publisherStatsBundle?.rawStats ?? [],
    );

    final subscriberStats = PeerConnectionStatsBundle(
      peerType: StreamPeerType.subscriber,
      stats: subscriberStatsBundle.rtcStats,
      printable: subscriberStatsBundle.printable,
      raw: subscriberStatsBundle.rawStats,
    );

    return (
      publisherStatsBundle: publisherStats,
      subscriberStatsBundle: subscriberStats,
    );
  }

  Future<void> _processStats(
    ({
      PeerConnectionStatsBundle publisherStatsBundle,
      PeerConnectionStatsBundle subscriberStatsBundle,
    })
    stats,
    int tick,
  ) async {
    if (!mounted) return;

    var publisherStats = state?.publisher ?? PeerConnectionStats.empty();
    var subscriberStats = state?.subscriber ?? PeerConnectionStats.empty();

    final allStats = stats.publisherStatsBundle.stats
        .whereType<RtcOutboundRtpVideoStream>()
        .map(
          MediaStatsInfo.fromRtcOutboundRtpVideoStream,
        );

    final mediaStats = allStats.firstWhereOrNull(
      (s) => s.width != null && s.height != null && s.fps != null,
    );

    final jitterInMs = ((mediaStats?.jitter ?? 0) * 1000).toInt();
    final resolution = mediaStats != null
        ? '${mediaStats.width} x ${mediaStats.height} @ ${mediaStats.fps}fps'
        : null;

    var activeOutbound = allStats.toList();

    if (publisherStats.outboundMediaStats.isNotEmpty) {
      activeOutbound = activeOutbound
          .where(
            (s) =>
                publisherStats.outboundMediaStats.none((i) => s.id == i.id) ||
                publisherStats.outboundMediaStats
                        .firstWhere((i) => i.id == s.id)
                        .bytesSent !=
                    s.bytesSent,
          )
          .toList();
    }

    final codec = stats.publisherStatsBundle.stats
        .whereType<RtcCodec>()
        .where((c) => c.mimeType?.startsWith('video') ?? false)
        .where((c) => activeOutbound.any((s) => s.videoCodecId == c.id))
        .map((c) => c.mimeType?.replaceFirst('video/', ''))
        .where((c) => c != null)
        .cast<String>()
        .toList();

    publisherStats = publisherStats.copyWith(
      resolution: resolution,
      qualityDropReason: mediaStats?.qualityLimit,
      jitterInMs: jitterInMs,
      videoCodec: codec,
      outboundMediaStats: allStats.toList(),
    );

    final inboudRtpVideo = stats.subscriberStatsBundle.stats
        .whereType<RtcInboundRtpVideoStream>()
        .firstOrNull;

    if (inboudRtpVideo != null) {
      final jitterInMs = ((inboudRtpVideo.jitter ?? 0) * 1000).toInt();
      final resolution =
          inboudRtpVideo.frameWidth != null &&
              inboudRtpVideo.frameHeight != null &&
              inboudRtpVideo.framesPerSecond != null
          ? '${inboudRtpVideo.frameWidth} x ${inboudRtpVideo.frameHeight} @ ${inboudRtpVideo.framesPerSecond}fps'
          : null;

      final codecStats = stats.subscriberStatsBundle.stats
          .whereType<RtcCodec>()
          .where((c) => c.mimeType?.startsWith('video') ?? false)
          .firstOrNull;

      final codec = codecStats?.mimeType?.replaceFirst('video/', '');

      subscriberStats = subscriberStats.copyWith(
        resolution: resolution,
        jitterInMs: jitterInMs,
        videoCodec: codec != null ? [codec] : [],
      );
    }

    final subscriberCandidatePair = stats.subscriberStatsBundle.stats
        .whereType<RtcIceCandidatePair>()
        .firstOrNull;
    if (subscriberCandidatePair != null) {
      final incomingBitrate = subscriberCandidatePair.availableIncomingBitrate;

      subscriberStats = subscriberStats.copyWith(
        bitrateKbps: incomingBitrate != null ? incomingBitrate / 1000 : null,
      );
    }

    final publisherCandidatePair = stats.publisherStatsBundle.stats
        .whereType<RtcIceCandidatePair>()
        .firstOrNull;
    if (publisherCandidatePair != null) {
      final latency = publisherCandidatePair.currentRoundTripTime;
      final outgoingBitrate = publisherCandidatePair.availableOutgoingBitrate;

      publisherStats = publisherStats.copyWith(
        latency: latency != null ? (latency * 1000).toInt() : null,
        bitrateKbps: outgoingBitrate != null ? outgoingBitrate / 1000 : null,
      );
    }

    var latencyHistory = state?.latencyHistory;
    if (publisherStats.latency != null) {
      latencyHistory = [
        ...state?.latencyHistory.reversed.take(19).toList().reversed ?? [],
        publisherStats.latency!,
      ];
    }

    var batteryLevelHistory = state?.batteryLevelHistory;
    var thermalStatusHistory = state?.thermalStatusHistory;
    var batteryLevel = 0;

    // check battery and thermal state every 10th tick (by default every 100s)
    if (tick % 10 == 0) {
      final batteryCheckAvailable =
          CurrentPlatform.isAndroid ||
          CurrentPlatform.isIos ||
          CurrentPlatform.isMacOS ||
          CurrentPlatform.isWindows;

      try {
        if (batteryCheckAvailable) {
          batteryLevel = await _battery.batteryLevel;
          batteryLevelHistory = <int>[
            ...state?.batteryLevelHistory.reversed.take(49).toList().reversed ??
                [],
            batteryLevel,
          ];
        }
      } catch (_) {
        // Ignore battery read failures
      }

      final thermalStatusAvailable =
          CurrentPlatform.isAndroid || CurrentPlatform.isIos;

      try {
        if (thermalStatusAvailable) {
          final thermalStatus = await _thermal.thermalStatus;
          thermalStatusHistory = <int>[
            ...state?.thermalStatusHistory.reversed
                    .take(49)
                    .toList()
                    .reversed ??
                [],
            ThermalStatus.values.indexOf(thermalStatus),
          ];
        }
      } catch (_) {
        // Ignore thermal read failures
      }
    }

    state =
        state?.copyWith(
          publisher: publisherStats,
          subscriber: subscriberStats,
          latencyHistory: latencyHistory ?? [],
          batteryLevelHistory: batteryLevelHistory,
          thermalStatusHistory: thermalStatusHistory,
          clientEnvironment: clientEnvironment,
        ) ??
        CallMetrics(
          publisher: publisherStats,
          subscriber: subscriberStats,
          clientEnvironment: clientEnvironment,
          latencyHistory: latencyHistory ?? [],
          batteryLevelHistory: batteryLevelHistory ?? [],
          thermalStatusHistory: thermalStatusHistory ?? [],
          initialBatteryLevel: batteryLevel,
        );
  }
}
