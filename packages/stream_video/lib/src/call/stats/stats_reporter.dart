import 'dart:async';

import 'package:collection/collection.dart';

import '../../models/models.dart';
import '../../webrtc/model/stats/rtc_codec.dart';
import '../../webrtc/model/stats/rtc_ice_candidate_pair.dart';
import '../../webrtc/model/stats/rtc_inbound_rtp_video_stream.dart';
import '../../webrtc/model/stats/rtc_outbound_rtp_video_stream.dart';
import '../../webrtc/model/stats/rtc_printable_stats.dart';
import '../../webrtc/peer_type.dart';
import '../../webrtc/rtc_manager.dart';
import '../state/call_state_notifier.dart';

class StatsReporter {
  StatsReporter({
    required this.rtcManager,
    required this.stateManager,
  });

  final RtcManager rtcManager;
  final CallStateNotifier stateManager;

  Stream<({CallStats publisherStats, CallStats subscriberStats})> run({
    Duration interval = const Duration(seconds: 10),
  }) {
    return Stream.periodic(interval, (_) => collectStats()).asyncMap(
      (event) async {
        final stats = await event;
        _processStats(stats);
        return event;
      },
    );
  }

  Future<({CallStats publisherStats, CallStats subscriberStats})>
      collectStats() async {
    final publisherStatsBundle = await rtcManager.publisher?.getStats();
    final subscriberStatsBundle = await rtcManager.subscriber.getStats();

    final publisherStats = CallStats(
      peerType: StreamPeerType.publisher,
      stats: publisherStatsBundle?.rtcStats ?? [],
      printable: publisherStatsBundle?.printable ??
          const RtcPrintableStats(local: '', remote: ''),
      raw: publisherStatsBundle?.rawStats ?? [],
    );

    final subscriberStats = CallStats(
      peerType: StreamPeerType.subscriber,
      stats: subscriberStatsBundle.rtcStats,
      printable: subscriberStatsBundle.printable,
      raw: subscriberStatsBundle.rawStats,
    );

    return (publisherStats: publisherStats, subscriberStats: subscriberStats);
  }

  void _processStats(
    ({CallStats publisherStats, CallStats subscriberStats}) stats,
  ) {
    final state = stateManager.callState;

    var publisherStats = state.publisherStats ?? PeerConnectionStats.empty();
    var subscriberStats = state.subscriberStats ?? PeerConnectionStats.empty();

    final allStats = stats.publisherStats.stats
        .whereType<RtcOutboundRtpVideoStream>()
        .map(MediaStatsInfo.fromRtcOutboundRtpVideoStream);

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

    final codec = stats.publisherStats.stats
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

    final inboudRtpVideo = stats.subscriberStats.stats
        .whereType<RtcInboundRtpVideoStream>()
        .firstOrNull;

    if (inboudRtpVideo != null) {
      final jitterInMs = ((inboudRtpVideo.jitter ?? 0) * 1000).toInt();
      final resolution = inboudRtpVideo.frameWidth != null &&
              inboudRtpVideo.frameHeight != null &&
              inboudRtpVideo.framesPerSecond != null
          ? '${inboudRtpVideo.frameWidth} x ${inboudRtpVideo.frameHeight} @ ${inboudRtpVideo.framesPerSecond}fps'
          : null;

      final codecStats = stats.subscriberStats.stats
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

    final subscriberCandidatePair = stats.subscriberStats.stats
        .whereType<RtcIceCandidatePair>()
        .firstOrNull;
    if (subscriberCandidatePair != null) {
      final incomingBitrate = subscriberCandidatePair.availableIncomingBitrate;

      subscriberStats = subscriberStats.copyWith(
        bitrateKbps: incomingBitrate != null ? incomingBitrate / 1000 : null,
      );
    }

    final publisherCandidatePair = stats.subscriberStats.stats
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

    var latencyHistory = state.latencyHistory;
    if (publisherStats.latency != null) {
      latencyHistory = [
        ...state.latencyHistory.reversed.take(19).toList().reversed,
        publisherStats.latency!,
      ];
    }

    stateManager.lifecycleCallStats(
      publisherStats: publisherStats,
      subscriberStats: subscriberStats,
      latencyHistory: latencyHistory,
    );
  }
}
