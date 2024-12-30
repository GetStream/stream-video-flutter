import 'package:meta/meta.dart';

import '../webrtc/model/stats/rtc_outbound_rtp_video_stream.dart';
import '../webrtc/model/stats/rtc_printable_stats.dart';
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
  final List<Map<String, dynamic>> raw;

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

@immutable
class PeerConnectionStats {
  const PeerConnectionStats({
    required this.latency,
    required this.resolution,
    required this.qualityDropReason,
    required this.jitterInMs,
    required this.bitrateKbps,
    this.videoCodec = const [],
    this.outboundMediaStats = const [],
  });

  factory PeerConnectionStats.empty() => const PeerConnectionStats(
        latency: null,
        resolution: null,
        qualityDropReason: null,
        jitterInMs: null,
        bitrateKbps: null,
        videoCodec: null,
      );

  final int? latency;
  final String? resolution;
  final String? qualityDropReason;
  final int? jitterInMs;
  final double? bitrateKbps;
  final List<String>? videoCodec;
  final List<MediaStatsInfo> outboundMediaStats;

  @override
  String toString() {
    return 'PeerConnectionStats{latency: $latency, resolution: $resolution, qualityDropReason: $qualityDropReason, jitterInMs: $jitterInMs, bitrateKbps: $bitrateKbps, videoCodec: $videoCodec}';
  }

  PeerConnectionStats copyWith({
    int? latency,
    String? resolution,
    String? qualityDropReason,
    int? jitterInMs,
    double? bitrateKbps,
    List<String>? videoCodec,
    List<MediaStatsInfo>? outboundMediaStats,
  }) {
    return PeerConnectionStats(
      latency: latency ?? this.latency,
      resolution: resolution ?? this.resolution,
      qualityDropReason: qualityDropReason ?? this.qualityDropReason,
      jitterInMs: jitterInMs ?? this.jitterInMs,
      bitrateKbps: bitrateKbps ?? this.bitrateKbps,
      videoCodec: videoCodec ?? this.videoCodec,
      outboundMediaStats: outboundMediaStats ?? this.outboundMediaStats,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeerConnectionStats &&
          runtimeType == other.runtimeType &&
          latency == other.latency &&
          resolution == other.resolution &&
          qualityDropReason == other.qualityDropReason &&
          jitterInMs == other.jitterInMs &&
          bitrateKbps == other.bitrateKbps &&
          outboundMediaStats == other.outboundMediaStats &&
          videoCodec == other.videoCodec;

  @override
  int get hashCode =>
      latency.hashCode ^
      resolution.hashCode ^
      qualityDropReason.hashCode ^
      jitterInMs.hashCode ^
      bitrateKbps.hashCode ^
      outboundMediaStats.hashCode ^
      videoCodec.hashCode;
}

@immutable
class MediaStatsInfo {
  const MediaStatsInfo({
    required this.id,
    required this.bytesSent,
    required this.videoCodecId,
    required this.qualityLimit,
    required this.jitter,
    required this.width,
    required this.height,
    required this.fps,
    required this.deviceLatency,
  });

  factory MediaStatsInfo.fromRtcOutboundRtpVideoStream(
    RtcOutboundRtpVideoStream stream,
  ) =>
      MediaStatsInfo(
        id: stream.id,
        bytesSent: stream.bytesSent,
        videoCodecId: stream.codecId,
        qualityLimit: stream.qualityLimitationReason,
        jitter: stream.jitter,
        width: stream.frameWidth,
        height: stream.frameHeight,
        fps: stream.framesPerSecond,
        deviceLatency: stream.totalPacketSendDelay,
      );

  final String? id;
  final String? qualityLimit;
  final double? jitter;
  final int? width;
  final int? height;
  final double? fps;
  final double? deviceLatency;
  final int? bytesSent;
  final String? videoCodecId;

  @override
  String toString() {
    return 'MediaStatsInfo{qualityLimit: $qualityLimit, jitter: $jitter, width: $width, height: $height, fps: $fps, deviceLatency: $deviceLatency, bytesSent: $bytesSent, videoCodec: $videoCodecId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaStatsInfo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          qualityLimit == other.qualityLimit &&
          jitter == other.jitter &&
          width == other.width &&
          height == other.height &&
          fps == other.fps &&
          deviceLatency == other.deviceLatency &&
          bytesSent == other.bytesSent &&
          videoCodecId == other.videoCodecId;

  @override
  int get hashCode =>
      id.hashCode ^
      bytesSent.hashCode ^
      videoCodecId.hashCode ^
      qualityLimit.hashCode ^
      jitter.hashCode ^
      width.hashCode ^
      height.hashCode ^
      fps.hashCode ^
      deviceLatency.hashCode;
}

@immutable
class LocalStats {
  const LocalStats({
    required this.sfu,
    required this.sdkVersion,
    required this.webRtcVersion,
  });

  factory LocalStats.empty() => const LocalStats(
        sfu: '',
        sdkVersion: '',
        webRtcVersion: '',
      );

  final String sfu;
  final String sdkVersion;
  final String webRtcVersion;

  @override
  String toString() {
    return 'LocalStats{sfu: $sfu, sdkVersion: $sdkVersion, webRtcVersion: $webRtcVersion}';
  }

  LocalStats copyWith({
    String? sfu,
    String? sdkVersion,
    String? webRtcVersion,
  }) {
    return LocalStats(
      sfu: sfu ?? this.sfu,
      sdkVersion: sdkVersion ?? this.sdkVersion,
      webRtcVersion: webRtcVersion ?? this.webRtcVersion,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalStats &&
          runtimeType == other.runtimeType &&
          sfu == other.sfu &&
          sdkVersion == other.sdkVersion &&
          webRtcVersion == other.webRtcVersion;

  @override
  int get hashCode =>
      sfu.hashCode ^ sdkVersion.hashCode ^ webRtcVersion.hashCode;
}
