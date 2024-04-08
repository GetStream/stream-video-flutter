import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../../logger/stream_log.dart';
import '../../../utils/standard.dart';
import 'rtc_audio_source.dart';
import 'rtc_codec.dart';
import 'rtc_ice_candidate.dart';
import 'rtc_ice_candidate_pair.dart';
import 'rtc_inbound_rtp_audio_stream.dart';
import 'rtc_inbound_rtp_video_stream.dart';
import 'rtc_media_source.dart';
import 'rtc_media_stream_track_local_audio.dart';
import 'rtc_media_stream_track_local_video.dart';
import 'rtc_media_stream_track_receiver_audio.dart';
import 'rtc_media_stream_track_remote_video.dart';
import 'rtc_outbound_rtp_audio_stream.dart';
import 'rtc_outbound_rtp_video_stream.dart';
import 'rtc_printable_stats.dart';
import 'rtc_remote_inbound_rtp.dart';
import 'rtc_remote_inbound_rtp_audio_stream.dart';
import 'rtc_remote_inbound_rtp_video_stream.dart';
import 'rtc_report_type.dart';
import 'rtc_stats.dart';
import 'rtc_stats_property.dart';
import 'rtc_video_source.dart';

const _tag = 'SV:StatsMapper';
const _space = ' ';
const _lineFeed = '\n';

extension RtcStatsMapper on List<rtc.StatsReport> {
  List<Map<String, dynamic>> toRawStats() {
    final rawStats = <Map<String, dynamic>>[];

    for (final report in this) {
      rawStats.add({
          'id': report.id,
          'type': report.type,
          'timestamp': report.timestamp,
          ...report.values,
      });
    }

    return rawStats;
  }

  RtcPrintableStats toPrintableRtcStats() {
    final remoteStat = StringBuffer();
    final localStat = StringBuffer();
    final codecs = <String, RtcCodec>{};

    RtcIceCandidatePair? candidatePair;

    for (final report in this) {
      try {
        final reportType = RtcReportType.fromAlias(report.type);
        switch (reportType) {
          case RtcReportType.codec:
            report.extractCodec(codecs);
            break;
          case RtcReportType.candidatePair:
            final json = report.toJson();
            candidatePair = RtcIceCandidatePair.fromJson(json);
            break;
          case RtcReportType.remoteCandidate:
            if (candidatePair != null) {
              report.extractRemoteCandidate(localStat, candidatePair);
            }
            break;
          case RtcReportType.localCandidate:
            if (candidatePair != null) {
              report.extractLocalCandidate(localStat, candidatePair);
            }
            break;
          case RtcReportType.remoteInboundRtp:
            report.extractRemoteInboundRtp(localStat);
            break;
          case RtcReportType.inboundRtp:
            report.extractInboundRtp(remoteStat, codecs);
            break;
          case RtcReportType.outboundRtp:
            report.extractOutboundRtp(localStat, codecs);
            break;
          case RtcReportType.track:
            report.extractTrack(remoteStat: remoteStat, localStat: localStat);
            break;
          case RtcReportType.mediaSource:
            report.extractMediaSource(localStat);
            break;
          default:
            break;
        }
      } catch (e, stk) {
        streamLog.e(_tag, () => '[toRtcStats] failed: $e; $stk');
      }
    }

    return RtcPrintableStats(
      local: localStat.toString(),
      remote: remoteStat.toString(),
    );
  }
}

extension StatsReportX on rtc.StatsReport {
  RtcStats? toRtcStats() {
    final type = RtcReportType.fromAlias(this.type);

    final kindValue = values[RtcKind.propertyName];
    final kind = kindValue != null ? RtcKind.fromAlias(kindValue) : null;

    final sourceValue = values[RtcSource.propertyName];
    final source =
        sourceValue != null ? RtcSource.fromValue(sourceValue) : null;

    final json = toJson();

    switch (type) {
      case RtcReportType.codec:
        return RtcCodec.fromJson(json);
      case RtcReportType.candidatePair:
        return RtcIceCandidatePair.fromJson(json);
      case RtcReportType.remoteCandidate:
        return RtcIceCandidate.fromJson(json);
      case RtcReportType.localCandidate:
        return RtcIceCandidate.fromJson(json);
      case RtcReportType.inboundRtp:
        if (kind == null) return null;

        switch (kind) {
          case RtcKind.audio:
            return RtcInboundRtpAudioStream.fromJson(json);
          case RtcKind.video:
            return RtcInboundRtpVideoStream.fromJson(json);
          case RtcKind.unknown:
            return null;
        }
      case RtcReportType.remoteInboundRtp:
        if (kind == null) return null;

        switch (kind) {
          case RtcKind.audio:
            return RtcRemoteInboundRtpAudioStream.fromJson(json);
          case RtcKind.video:
            return RtcRemoteInboundRtpVideoStream.fromJson(json);
          case RtcKind.unknown:
            return null;
        }
      case RtcReportType.outboundRtp:
        if (kind == null) return null;

        switch (kind) {
          case RtcKind.audio:
            return RtcOutboundRtpAudioStream.fromJson(json);
          case RtcKind.video:
            return RtcOutboundRtpVideoStream.fromJson(json);
          case RtcKind.unknown:
            return null;
        }
      case RtcReportType.track:
        if (kind == null || source == null) return null;

        switch (kind) {
          case RtcKind.audio:
            if (source == RtcSource.remote) {
              return RtcMediaStreamTrackRemoteAudio.fromJson(json);
            } else {
              return RtcMediaStreamTrackLocalAudio.fromJson(json);
            }
          case RtcKind.video:
            if (source == RtcSource.remote) {
              return RtcMediaStreamTrackRemoteVideo.fromJson(json);
            } else {
              return RtcMediaStreamTrackLocalVideo.fromJson(json);
            }
          case RtcKind.unknown:
            return null;
        }
      case RtcReportType.mediaSource:
        if (kind == null) return null;

        switch (kind) {
          case RtcKind.audio:
            return RtcAudioSource.fromJson(json);
          case RtcKind.video:
            return RtcVideoSource.fromJson(json);
          case RtcKind.unknown:
            return null;
        }
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp,
      ...values,
    };
  }

  void extractCodec(Map<String, RtcCodec> codecs) {
    final json = toJson();
    RtcCodec.fromJson(json)?.also((codec) {
      final codecId = codec.id;
      if (codecId != null) {
        codecs[codecId] = codec;
      }
    });
  }

  void extractLocalCandidate(
    StringBuffer localStat,
    RtcIceCandidatePair candidatePair,
  ) {
    final json = toJson();
    final localCandidate = RtcIceCandidate.fromJson(json);
    if (localCandidate != null &&
        localCandidate.id == candidatePair.localCandidateId) {
      localStat
        ..write(_lineFeed)
        ..write(RtcReportType.localCandidate.alias.toUpperCase())
        ..write(_lineFeed);
      localCandidate.writeTo(localStat);
    }
  }

  void extractRemoteCandidate(
    StringBuffer remoteStat,
    RtcIceCandidatePair candidatePair,
  ) {
    final json = toJson();
    final remoteCandidate = RtcIceCandidate.fromJson(json);
    if (remoteCandidate != null &&
        remoteCandidate.id == candidatePair.remoteCandidateId) {
      remoteStat
        ..write(_lineFeed)
        ..write(RtcReportType.remoteCandidate.alias.toUpperCase())
        ..write(_lineFeed);
      remoteCandidate.writeTo(remoteStat);
    }
  }

  void extractInboundRtp(
    StringBuffer remoteStat,
    Map<String, RtcCodec> codecs,
  ) {
    final json = toJson();
    final String? propValue = values[RtcMediaType.propertyName];
    if (propValue == null) {
      return;
    }
    final mediaType = RtcMediaType.fromAlias(propValue);
    if (mediaType == RtcMediaType.audio) {
      final rtcBase = RtcInboundRtpAudioStream.fromJson(json);
      if (rtcBase != null) {
        remoteStat
          ..write(_lineFeed)
          ..write(RtcReportType.inboundRtp.alias.toUpperCase())
          ..write(_space)
          ..write(mediaType.alias.toUpperCase())
          ..write(_lineFeed);
        rtcBase.writeTo(remoteStat);
        codecs[rtcBase.codecId]?.writeTo(remoteStat);
      }
    } else if (mediaType == RtcMediaType.video) {
      final rtcBase = RtcInboundRtpVideoStream.fromJson(json);
      if (rtcBase != null) {
        remoteStat
          ..write(_lineFeed)
          ..write(RtcReportType.inboundRtp.alias.toUpperCase())
          ..write(_space)
          ..write(mediaType.alias.toUpperCase())
          ..write(_lineFeed);
        rtcBase.writeTo(remoteStat);
        codecs[rtcBase.codecId]?.writeTo(remoteStat);
      }
    }
  }

  void extractOutboundRtp(
    StringBuffer localStat,
    Map<String, RtcCodec> codecs,
  ) {
    final json = toJson();
    final String? propValue = values[RtcMediaType.propertyName];
    if (propValue == null) {
      return;
    }
    final mediaType = RtcMediaType.fromAlias(propValue);
    if (mediaType == RtcMediaType.audio) {
      final rtcBase = RtcOutboundRtpAudioStream.fromJson(json);
      if (rtcBase != null) {
        localStat
          ..write(_lineFeed)
          ..write(rtcBase.type?.toUpperCase())
          ..write(_space)
          ..write(mediaType.alias.toUpperCase())
          ..write(_lineFeed);
        rtcBase.writeTo(localStat);
        codecs[rtcBase.codecId]?.writeTo(localStat);
      }
    } else if (mediaType == RtcMediaType.video) {
      final rtcBase = RtcOutboundRtpVideoStream.fromJson(json);
      if (rtcBase != null) {
        localStat
          ..write(_lineFeed)
          ..write(rtcBase.type?.toUpperCase())
          ..write(_space)
          ..write(mediaType.alias.toUpperCase())
          ..write(_lineFeed);
        rtcBase.writeTo(localStat);
        codecs[rtcBase.codecId]?.writeTo(localStat);
      }
    }
  }

  void extractTrack({
    required StringBuffer remoteStat,
    required StringBuffer localStat,
  }) {
    final bool? sourceValue = values[RtcSource.propertyName];
    final String? kindAlias = values[RtcKind.propertyName];
    if (sourceValue == null || kindAlias == null) {
      return;
    }
    final source = RtcSource.fromValue(sourceValue);
    final kind = RtcKind.fromAlias(kindAlias);
    if (source == RtcSource.remote && kind == RtcKind.audio) {
      extractTrackRemoteAudio(remoteStat);
    } else if (source == RtcSource.remote && kind == RtcKind.video) {
      extractTrackRemoteVideo(remoteStat);
    } else if (source == RtcSource.local && kind == RtcKind.audio) {
      extractTrackLocalAudio(localStat);
    } else if (source == RtcSource.local && kind == RtcKind.video) {
      extractTrackLocalVideo(localStat);
    }
  }

  void extractTrackRemoteAudio(StringBuffer remoteStat) {
    final json = toJson();
    final rtcBase = RtcMediaStreamTrackRemoteAudio.fromJson(json);
    if (rtcBase != null) {
      remoteStat
        ..write(_lineFeed)
        ..write(RtcSource.remote.alias.toUpperCase())
        ..write(_space)
        ..write(RtcMediaType.audio.alias.toUpperCase())
        ..write(_space)
        ..write(RtcReportType.track.alias.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(remoteStat);
    }
  }

  void extractTrackRemoteVideo(StringBuffer remoteStat) {
    final json = toJson();
    final rtcBase = RtcMediaStreamTrackRemoteVideo.fromJson(json);
    if (rtcBase != null) {
      remoteStat
        ..write(_lineFeed)
        ..write(RtcSource.remote.alias.toUpperCase())
        ..write(_space)
        ..write(RtcMediaType.video.alias.toUpperCase())
        ..write(_space)
        ..write(RtcReportType.track.alias.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(remoteStat);
    }
  }

  void extractTrackLocalAudio(StringBuffer localStat) {
    final json = toJson();
    final rtcBase = RtcMediaStreamTrackLocalAudio.fromJson(json);
    if (rtcBase != null) {
      localStat
        ..write(_lineFeed)
        ..write(RtcSource.local.alias.toUpperCase())
        ..write(_space)
        ..write(RtcMediaType.audio.alias.toUpperCase())
        ..write(_space)
        ..write(RtcReportType.track.alias.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(localStat);
    }
  }

  void extractTrackLocalVideo(StringBuffer localStat) {
    final json = toJson();
    final rtcBase = RtcMediaStreamTrackLocalVideo.fromJson(json);
    if (rtcBase != null) {
      localStat
        ..write(_lineFeed)
        ..write(RtcSource.local.alias.toUpperCase())
        ..write(_space)
        ..write(RtcMediaType.video.alias.toUpperCase())
        ..write(_space)
        ..write(RtcReportType.track.alias.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(localStat);
    }
  }

  void extractMediaSource(
    StringBuffer localStat,
  ) {
    final json = toJson();
    final String? propValue = values[RtcKind.propertyName];
    if (propValue == null) {
      return;
    }
    final kind = RtcKind.fromAlias(propValue);
    RtcMediaSource? rtcBase;
    if (kind == RtcKind.audio) {
      rtcBase = RtcAudioSource.fromJson(json);
    } else if (kind == RtcKind.video) {
      rtcBase = RtcVideoSource.fromJson(json);
    }
    if (rtcBase != null) {
      localStat
        ..write(_lineFeed)
        ..write(rtcBase.type?.toUpperCase())
        ..write(_space)
        ..write(kind.alias.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(localStat);
    }
  }

  void extractRemoteInboundRtp(
    StringBuffer localStat,
  ) {
    final json = toJson();
    final String? propValue = values[RtcKind.propertyName];
    if (propValue == null) {
      return;
    }
    final kind = RtcKind.fromAlias(propValue);
    RtcRemoteInboundRtp? rtcBase;
    if (kind == RtcKind.audio) {
      rtcBase = RtcRemoteInboundRtpAudioStream.fromJson(json);
    } else if (kind == RtcKind.video) {
      rtcBase = RtcRemoteInboundRtpVideoStream.fromJson(json);
    }
    if (rtcBase != null) {
      localStat
        ..write(_lineFeed)
        ..write(rtcBase.type?.toUpperCase())
        ..write(_space)
        ..write(kind.alias.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(localStat);
    }
  }
}

extension on RtcCodec {
  void writeTo(StringBuffer out) {
    out
      ..write('codec: ')
      ..write(mimeType)
      ..write(_lineFeed);
  }
}
