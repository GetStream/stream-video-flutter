import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../../logger/impl/tagged_logger.dart';
import '../../../logger/stream_log.dart';
import '../../../utils/standard.dart';
import 'rtc_codec.dart';
import 'rtc_ice_candidate.dart';
import 'rtc_ice_candidate_pair.dart';
import 'rtc_inbound_rtp_audio_stream.dart';
import 'rtc_inbound_rtp_video_stream.dart';
import 'rtc_media_stream_track_local_audio.dart';
import 'rtc_media_stream_track_local_video.dart';
import 'rtc_media_stream_track_receiver_audio.dart';
import 'rtc_media_stream_track_remote_video.dart';
import 'rtc_outbound_rtp_audio_stream.dart';
import 'rtc_outbound_rtp_video_stream.dart';
import 'rtc_stats.dart';
import 'rtc_stats_property.dart';
import 'rtc_type.dart';

const _tag = 'SV:StatsMapper';
const _space = ' ';
const _lineFeed = '\n';

extension StatsMapper on List<rtc.StatsReport> {
  RtcStats toRtcStats() {
    final remoteStat = StringBuffer();
    final localStat = StringBuffer();
    final codecs = <String, RTCCodec>{};
    RTCIceCandidatePair? candidatePair;

    for (final report in this) {
      streamLog.v(_tag, () => '[toRtcStats] report: ${report.toJson()}');
      try {
        if (report.type == RTCType.CODEC) {
          report.extractCodec(codecs);
        }
        if (report.type == RTCType.CANDIDATE_PAIR) {
          final json = report.toJson();
          candidatePair = RTCIceCandidatePair.fromJson(json);
        }
        if (report.type == RTCType.LOCAL_CANDIDATE && candidatePair != null) {
          report.extractLocalCandidate(localStat, candidatePair);
        }
        if (report.type == RTCType.REMOTE_CANDIDATE && candidatePair != null) {
          report.extractRemoteCandidate(remoteStat, candidatePair);
        }
        if (report.type == RTCType.INBOUND_RTP) {
          report.extractInboundRtp(remoteStat, codecs);
        }
        if (report.type == RTCType.OUTBOUND_RTP) {
          report.extractOutboundRtp(localStat, codecs);
        }
        if (report.type == RTCType.TRACK) {
          report.extractTrack(remoteStat: remoteStat, localStat: localStat);
        }
      } catch (e, stk) {
        streamLog.e(_tag, () => '[toRtcStats] failed: $e; $stk');
      }
    }

    return RtcStats(
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

  void extractCodec(Map<String, RTCCodec> codecs) {
    final json = toJson();
    RTCCodec.fromJson(json)?.also((codec) {
      final codecId = codec.id;
      if (codecId != null) {
        codecs[codecId] = codec;
      }
    });
  }

  void extractLocalCandidate(
    StringBuffer localStat,
    RTCIceCandidatePair candidatePair,
  ) {
    final json = toJson();
    final localCandidate = RTCIceCandidate.fromJson(json);
    if (localCandidate != null &&
        localCandidate.id == candidatePair.localCandidateId) {
      localStat.write(RTCType.LOCAL_CANDIDATE.toUpperCase());
      localStat.write(_lineFeed);
      localCandidate.writeTo(localStat);
      localStat.write(_lineFeed);
    }
  }

  void extractRemoteCandidate(
    StringBuffer remoteStat,
    RTCIceCandidatePair candidatePair,
  ) {
    final json = toJson();
    final remoteCandidate = RTCIceCandidate.fromJson(json);
    if (remoteCandidate != null &&
        remoteCandidate.id == candidatePair.remoteCandidateId) {
      remoteStat.write(RTCType.REMOTE_CANDIDATE.toUpperCase());
      remoteStat.write(_lineFeed);
      remoteCandidate.writeTo(remoteStat);
      remoteStat.write(_lineFeed);
    }
  }

  void extractInboundRtp(
    StringBuffer remoteStat,
    Map<String, RTCCodec> codecs,
  ) {
    final json = toJson();
    final String? mediaType = values[RTCMediaType.KEY];
    if (mediaType == RTCMediaType.AUDIO) {
      final rtcBase = RTCInboundRTPAudioStream.fromJson(json);
      if (rtcBase != null) {
        remoteStat
          ..write(RTCType.INBOUND_RTP.toUpperCase())
          ..write(_space)
          ..write(RTCMediaType.AUDIO.toUpperCase())
          ..write(_lineFeed);
        rtcBase.writeTo(remoteStat);
        codecs[rtcBase.codecId]?.writeTo(remoteStat);
        remoteStat.write(_lineFeed);
      }
    } else if (mediaType == RTCMediaType.VIDEO) {
      final rtcBase = RTCInboundRTPVideoStream.fromJson(json);
      if (rtcBase != null) {
        remoteStat
          ..write(RTCType.INBOUND_RTP.toUpperCase())
          ..write(_space)
          ..write(RTCMediaType.VIDEO.toUpperCase())
          ..write(_lineFeed);
        rtcBase.writeTo(remoteStat);
        codecs[rtcBase.codecId]?.writeTo(remoteStat);
        remoteStat.write(_lineFeed);
      }
    }
  }

  void extractOutboundRtp(
    StringBuffer localStat,
    Map<String, RTCCodec> codecs,
  ) {
    final json = toJson();
    final String? mediaType = values[RTCMediaType.KEY];
    if (mediaType == RTCMediaType.AUDIO) {
      final rtcBase = RTCOutboundRTPAudioStream.fromJson(json);
      if (rtcBase != null) {
        localStat
          ..write(RTCType.OUTBOUND_RTP.toUpperCase())
          ..write(_space)
          ..write(RTCMediaType.AUDIO.toUpperCase())
          ..write(_lineFeed);
        rtcBase.writeTo(localStat);
        codecs[rtcBase.codecId]?.writeTo(localStat);
        localStat.write(_lineFeed);
      }
    } else if (mediaType == RTCMediaType.VIDEO) {
      final rtcBase = RTCOutboundRTPVideoStream.fromJson(json);
      if (rtcBase != null) {
        localStat
          ..write(RTCType.INBOUND_RTP.toUpperCase())
          ..write(_space)
          ..write(RTCMediaType.VIDEO.toUpperCase())
          ..write(_lineFeed);
        rtcBase.writeTo(localStat);
        codecs[rtcBase.codecId]?.writeTo(localStat);
        localStat.write(_lineFeed);
      }
    }
  }

  void extractTrack({
    required StringBuffer remoteStat,
    required StringBuffer localStat,
  }) {
    final bool? remoteSource = values[RTCSource.KEY_REMOTE];
    final String? kind = values[RTCKind.KEY];
    if (remoteSource == null || kind == null) {
      return;
    }
    if (remoteSource && kind == RTCKind.AUDIO) {
      extractTrackRemoteAudio(remoteStat);
    } else if (remoteSource && kind == RTCKind.VIDEO) {
      extractTrackRemoteVideo(remoteStat);
    } else if (!remoteSource && kind == RTCKind.AUDIO) {
      extractTrackLocalAudio(localStat);
    } else if (!remoteSource && kind == RTCKind.VIDEO) {
      extractTrackLocalVideo(localStat);
    }
  }

  void extractTrackRemoteAudio(StringBuffer remoteStat) {
    final json = toJson();
    final rtcBase = RTCMediaStreamTrackRemoteAudio.fromJson(json);
    if (rtcBase != null) {
      remoteStat
        ..write(RTCSource.REMOTE.toUpperCase())
        ..write(_space)
        ..write(RTCMediaType.AUDIO.toUpperCase())
        ..write(_space)
        ..write(RTCType.TRACK.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(remoteStat);
      remoteStat.write(_lineFeed);
    }
  }

  void extractTrackRemoteVideo(StringBuffer remoteStat) {
    final json = toJson();
    final rtcBase = RTCMediaStreamTrackRemoteVideo.fromJson(json);
    if (rtcBase != null) {
      remoteStat
        ..write(RTCSource.REMOTE.toUpperCase())
        ..write(_space)
        ..write(RTCMediaType.VIDEO.toUpperCase())
        ..write(_space)
        ..write(RTCType.TRACK.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(remoteStat);
      remoteStat.write(_lineFeed);
    }
  }

  void extractTrackLocalAudio(StringBuffer localStat) {
    final json = toJson();
    final rtcBase = RTCMediaStreamTrackLocalAudio.fromJson(json);
    if (rtcBase != null) {
      localStat
        ..write(RTCSource.LOCAL.toUpperCase())
        ..write(_space)
        ..write(RTCMediaType.AUDIO.toUpperCase())
        ..write(_space)
        ..write(RTCType.TRACK.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(localStat);
      localStat.write(_lineFeed);
    }
  }

  void extractTrackLocalVideo(StringBuffer localStat) {
    final json = toJson();
    final rtcBase = RTCMediaStreamTrackLocalVideo.fromJson(json);
    if (rtcBase != null) {
      localStat
        ..write(RTCSource.LOCAL.toUpperCase())
        ..write(_space)
        ..write(RTCMediaType.VIDEO.toUpperCase())
        ..write(_space)
        ..write(RTCType.TRACK.toUpperCase())
        ..write(_lineFeed);
      rtcBase.writeTo(localStat);
      localStat.write(_lineFeed);
    }
  }
}

extension on RTCCodec {
  void writeTo(StringBuffer out) {
    out
      ..write('codec: ')
      ..write(mimeType)
      ..write(_lineFeed);
  }
}
