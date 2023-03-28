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
import 'rtc_stats_property.dart';
import 'rtc_video_source.dart';

const _tag = 'SV:StatsMapper';
const _space = ' ';
const _lineFeed = '\n';

extension RtcStatsMapper on List<rtc.StatsReport> {
  RtcPrintableStats toRtcStats() {
    final remoteStat = StringBuffer();
    final localStat = StringBuffer();
    final codecs = <String, RtcCodec>{};
    RtcIceCandidatePair? candidatePair;

    for (final report in this) {
      try {
        final reportType = RtcReportType.fromAlias(report.type);
        if (reportType == RtcReportType.codec) {
          report.extractCodec(codecs);
        } else if (reportType == RtcReportType.candidatePair) {
          final json = report.toJson();
          candidatePair = RtcIceCandidatePair.fromJson(json);
        } else if (reportType == RtcReportType.localCandidate &&
            candidatePair != null) {
          report.extractLocalCandidate(localStat, candidatePair);
        } else if (reportType == RtcReportType.remoteCandidate &&
            candidatePair != null) {
          report.extractRemoteCandidate(remoteStat, candidatePair);
        } else if (reportType == RtcReportType.inboundRtp) {
          report.extractInboundRtp(remoteStat, codecs);
        } else if (reportType == RtcReportType.outboundRtp) {
          report.extractOutboundRtp(localStat, codecs);
        } else if (reportType == RtcReportType.track) {
          report.extractTrack(remoteStat: remoteStat, localStat: localStat);
        } else if (reportType == RtcReportType.mediaSource) {
          report.extractMediaSource(localStat);
        } else if (reportType == RtcReportType.remoteInboundRtp) {
          report.extractRemoteInboundRtp(localStat);
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

extension on rtc.StatsReport {
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
      final rtcBase = RTCOutboundRTPVideoStream.fromJson(json);
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
