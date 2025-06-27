import 'dart:async';

import 'package:collection/collection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../protobuf/video/sfu/models/models.pb.dart';
import '../call/stats/tracer.dart';
import '../sfu/data/models/sfu_codec.dart';
import '../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'model/stats/rtc_codec.dart';
import 'model/stats/rtc_inbound_rtp_video_stream.dart';
import 'model/stats/rtc_media_source.dart';
import 'model/stats/rtc_outbound_rtp_video_stream.dart';
import 'model/stats/rtc_stats.dart';
import 'peer_connection.dart';
import 'peer_type.dart';

class TracedStreamPeerConnection extends StreamPeerConnection {
  TracedStreamPeerConnection({
    required super.sfuClient,
    required super.sessionId,
    required super.callCid,
    required super.type,
    required super.pc,
    required super.sdpEditor,
    required this.tracer,
  }) {
    _initTracking();
  }

  final Tracer tracer;
  List<Map<String, dynamic>>? _previousStats;
  List<RtcOutboundRtpVideoStream>? _previousOutboundRtpStats;
  List<RtcInboundRtpVideoStream>? _previousInboundRtpStats;

  List<double> frameTimesHistory = [];
  List<double> fpsHistory = [];

  void _initTracking() {
    final originalIceGatheringState = pc.onIceGatheringState;
    final originalSignalingState = pc.onSignalingState;
    final originalConnectionState = pc.onConnectionState;
    final originalDataChannel = pc.onDataChannel;
    final originalOnTrack = pc.onTrack;
    final originalIceCandidate = pc.onIceCandidate;
    final originalIceConnectionState = pc.onIceConnectionState;
    final originalNegotiationNeeded = pc.onRenegotiationNeeded;
    // final originalClose = pc.onClose;

    pc
      ..onRenegotiationNeeded = () {
        tracer.trace('renegotiationNeeded', null);
        originalNegotiationNeeded?.call();
      }
      ..onIceConnectionState = (state) {
        tracer.trace('iceConnectionStateChange', state.name);
        originalIceConnectionState?.call(state);
      }
      ..onIceCandidate = (candidate) {
        tracer.trace('iceCandidate', candidate.toMap());
        originalIceCandidate?.call(candidate);
      }
      ..onTrack = (event) {
        final streams = event.streams.map((stream) => 'stream:${stream.id}');
        tracer.trace('track', '${event.track.kind}:${event.track.id} $streams');
        originalOnTrack?.call(event);
      }
      ..onIceGatheringState = (state) {
        tracer.trace('iceGatheringStateChange', state.name);
        originalIceGatheringState?.call(state);
      }
      ..onSignalingState = (state) {
        tracer.trace('signalingStateChange', state.name);
        originalSignalingState?.call(state);
      }
      ..onConnectionState = (state) {
        tracer.trace('connectionStateChange', state.name);

        if (state ==
                rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected ||
            state == rtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
          getStats().then(
            (stats) => traceStats(stats.rawStats),
          );
        }

        originalConnectionState?.call(state);
      }
      ..onDataChannel = (channel) {
        tracer.trace('onDataChannel', [channel.id, channel.label]);
        originalDataChannel?.call(channel);
      };
  }

  List<PerformanceStats> getPerformanceStats(
    List<RtcStats> rtcStats,
    SfuTrackType? Function(String) trackIdToTrackType,
  ) {
    final performanceStat = type == StreamPeerType.subscriber
        ? getDecodeStats(
            rtcStats,
            (String id) => trackIdToTrackType(id)?.toDTO(),
          )
        : getEncodeStats(
            rtcStats,
            (String id) => trackIdToTrackType(id)?.toDTO(),
          );

    // Keep only the most recent entries (up to 2) in the history arrays
    if (frameTimesHistory.length > 2) {
      frameTimesHistory = frameTimesHistory.sublist(
        frameTimesHistory.length - 2,
        frameTimesHistory.length,
      );
    }
    if (fpsHistory.length > 2) {
      fpsHistory = fpsHistory.sublist(
        fpsHistory.length - 2,
        fpsHistory.length,
      );
    }

    return performanceStat;
  }

  List<PerformanceStats> getEncodeStats(
    List<RtcStats> rtcStats,
    TrackType? Function(String) trackIdToTrackType,
  ) {
    final encodeStats = <PerformanceStats>[];

    final outboundVideoRtpStats =
        rtcStats.whereType<RtcOutboundRtpVideoStream>().toList();

    for (final rtpStat in outboundVideoRtpStats) {
      final codecId = rtpStat.codecId;
      final framesSent = rtpStat.framesSent ?? 0;
      final totalEncodeTime = rtpStat.totalEncodeTime ?? 0;
      final framesPerSecond = rtpStat.framesPerSecond ?? 0;
      final frameHeight = rtpStat.frameHeight ?? 0;
      final frameWidth = rtpStat.frameWidth ?? 0;
      final targetBitrate = rtpStat.targetBitrate ?? 0;
      final mediaSourceId = rtpStat.mediaSourceId;

      if (_previousOutboundRtpStats == null ||
          _previousOutboundRtpStats!.none((stat) => stat.id == rtpStat.id)) {
        continue;
      }

      final prevStat = _previousOutboundRtpStats!
          .firstWhere((stat) => stat.id == rtpStat.id);

      final deltaTotalEncodeTime =
          totalEncodeTime - (prevStat.totalEncodeTime ?? 0);
      final deltaFramesSent = framesSent - (prevStat.framesSent ?? 0);
      final framesEncodeTime = (deltaFramesSent > 0
              ? (deltaTotalEncodeTime / deltaFramesSent) * 1000
              : 0)
          .toDouble();

      frameTimesHistory.add(framesEncodeTime);
      fpsHistory.add(framesPerSecond);

      var trackType = TrackType.TRACK_TYPE_VIDEO;
      if (mediaSourceId != null) {
        final mediaStats =
            rtcStats.whereType<RtcMediaSource>().firstWhereOrNull(
                  (stat) => stat.id == mediaSourceId,
                );

        if (mediaStats != null && mediaStats.trackIdentifier != null) {
          trackType = trackIdToTrackType.call(mediaStats.trackIdentifier!) ??
              TrackType.TRACK_TYPE_VIDEO;
        }
      }

      final avgFrameTimeMs = average(frameTimesHistory);
      final avgFps = average(fpsHistory);

      final codec = rtcStats
          .whereType<RtcCodec>()
          .firstWhereOrNull((stat) => stat.id == codecId);

      encodeStats.add(
        PerformanceStats(
          trackType: trackType,
          codec: _getCodecFromStats(codec)?.toDTO(),
          avgFrameTimeMs: avgFrameTimeMs,
          avgFps: avgFps,
          targetBitrate: targetBitrate.round(),
          videoDimension: VideoDimension(
            width: frameWidth,
            height: frameHeight,
          ),
        ),
      );
    }

    _previousOutboundRtpStats = outboundVideoRtpStats;
    return encodeStats;
  }

  List<PerformanceStats> getDecodeStats(
    List<RtcStats> rtcStats,
    TrackType? Function(String) trackIdToTrackType,
  ) {
    var maxArea = 0;
    RtcInboundRtpVideoStream? maxAreaStat;

    final inboundVideoRtpStats =
        rtcStats.whereType<RtcInboundRtpVideoStream>().toList();

    for (final rtpStat in inboundVideoRtpStats) {
      final kind = rtpStat.kind;
      final frameWidth = rtpStat.frameWidth ?? 0;
      final frameHeight = rtpStat.frameHeight ?? 0;
      final area = frameWidth * frameHeight;

      if (kind == 'video' && area > maxArea) {
        maxArea = area;
        maxAreaStat = rtpStat;
      }
    }

    final prevStat = _previousInboundRtpStats
        ?.firstWhereOrNull((stat) => stat.id == maxAreaStat?.id);

    if (maxAreaStat == null ||
        _previousInboundRtpStats == null ||
        prevStat == null) {
      _previousInboundRtpStats = inboundVideoRtpStats;
      return [];
    }

    final framesDecoded = maxAreaStat.framesDecoded ?? 0;
    final framesPerSecond = maxAreaStat.framesPerSecond ?? 0;
    final totalDecodeTime = maxAreaStat.totalDecodeTime ?? 0;
    final trackIdentifier = maxAreaStat.trackId;

    final deltaTotalDecodeTime =
        totalDecodeTime - (prevStat.totalDecodeTime ?? 0);
    final deltaFramesDecoded = framesDecoded - (prevStat.framesDecoded ?? 0);

    final framesDecodeTime = (deltaFramesDecoded > 0
            ? (deltaTotalDecodeTime / deltaFramesDecoded) * 1000
            : 0)
        .toDouble();

    frameTimesHistory.add(framesDecodeTime);
    fpsHistory.add(framesPerSecond);

    var trackType = TrackType.TRACK_TYPE_VIDEO;
    if (trackIdentifier != null) {
      trackType = trackIdToTrackType.call(trackIdentifier) ??
          TrackType.TRACK_TYPE_VIDEO;
    }

    final avgFrameTimeMs = average(frameTimesHistory);
    final avgFps = average(fpsHistory);

    final codec = rtcStats
        .whereType<RtcCodec>()
        .firstWhereOrNull((stat) => stat.id == maxAreaStat?.codecId);

    _previousInboundRtpStats = inboundVideoRtpStats;

    return [
      PerformanceStats(
        trackType: trackType,
        codec: _getCodecFromStats(codec)?.toDTO(),
        avgFrameTimeMs: avgFrameTimeMs,
        avgFps: avgFps,
        videoDimension: VideoDimension(
          width: maxAreaStat.frameWidth ?? 0,
          height: maxAreaStat.frameHeight ?? 0,
        ),
      ),
    ];
  }

  double average(
    List<double> arr,
  ) {
    if (arr.isEmpty) return 0;
    return arr.reduce((a, b) => a + b) / arr.length;
  }

  SfuCodec? _getCodecFromStats(RtcCodec? codec) {
    if (codec == null) return null;

    return SfuCodec(
      payloadType: codec.payloadType ?? 0,
      name: codec.mimeType?.split('/').last ?? codec.mimeType ?? 'unknown',
      fmtpLine: codec.sdpFmtpLine ?? '',
      clockRate: codec.clockRate ?? 0,
      encodingParameters: '',
    );
  }

  Future<void> traceStats(
    List<Map<String, dynamic>> newRtcStats,
  ) async {
    final statsDiff = _diffCompression(newRtcStats, _previousStats);
    tracer.trace('getstats', statsDiff);
    _previousStats = newRtcStats;
  }

  Map<String, dynamic> _convertToMap(
    List<Map<String, dynamic>>? original,
  ) {
    if (original == null) return {};

    return original
        .map(Map<String, dynamic>.from)
        .toList()
        .asMap()
        .map((_, map) => MapEntry(map['id'], map));
  }

  Map<String, dynamic> _diffCompression(
    List<Map<String, dynamic>> newStats,
    List<Map<String, dynamic>>? oldStats,
  ) {
    final newStatsLookup = _convertToMap(newStats);
    final oldStatsLookup = _convertToMap(oldStats);

    num latestTimestamp = double.negativeInfinity;

    for (final Map<String, dynamic> report in newStatsLookup.values) {
      final id = report.remove('id');

      var ts = report['timestamp'];
      if (ts is num) {
        ts = ts / 1000;
        report['timestamp'] = ts;
        if (ts > latestTimestamp) {
          latestTimestamp = ts;
        }
      }

      if (id == null || !oldStatsLookup.containsKey(id)) continue;

      final oldReport = oldStatsLookup[id] as Map<String, dynamic>;

      for (final entry in Map<String, dynamic>.from(report).entries) {
        if (oldReport[entry.key] == entry.value) {
          report.remove(entry.key);
        }
      }
    }

    for (final Map<String, dynamic> report in newStatsLookup.values) {
      if (report['timestamp'] == latestTimestamp) {
        report['timestamp'] = 0;
      }
    }

    // Add top-level timestamp as a separate report (if needed)
    newStatsLookup.addAll(
      {
        'timestamp':
            latestTimestamp == double.negativeInfinity ? 0 : latestTimestamp,
      },
    );

    return newStatsLookup;
  }

  @override
  Future<Result<rtc.RTCSessionDescription>> createOffer([
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    tracer.trace('createOffer', mediaConstraints);

    final result = await super.createOffer(mediaConstraints);

    if (result.isSuccess) {
      tracer.trace('createOffer.success', result.getDataOrNull()?.toMap());
    } else {
      tracer.trace('createOffer.error', result.getErrorOrNull()?.toString());
    }

    return result;
  }

  @override
  Future<Result<rtc.RTCSessionDescription>> createAnswer([
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    tracer.trace('createAnswer', mediaConstraints);

    final result = await super.createAnswer(mediaConstraints);

    if (result.isSuccess) {
      tracer.trace('createAnswer.success', result.getDataOrNull()?.toMap());
    } else {
      tracer.trace('createAnswer.error', result.getErrorOrNull()?.toString());
    }

    return result;
  }

  @override
  Future<Result<void>> setRemoteDescription(
    rtc.RTCSessionDescription sd,
  ) async {
    tracer.trace('setRemoteDescription', sd.toMap());

    final result = await super.setRemoteDescription(sd);

    if (result.isSuccess) {
      tracer.trace('setRemoteDescription.success', null);
    } else {
      tracer.trace(
        'setRemoteDescription.error',
        result.getErrorOrNull()?.toString(),
      );
    }

    return result;
  }

  @override
  Future<Result<void>> setLocalDescription(
    rtc.RTCSessionDescription description,
  ) async {
    tracer.trace('setLocalDescription', description.toMap());

    final result = await super.setLocalDescription(description);

    if (result.isSuccess) {
      tracer.trace('setLocalDescription.success', null);
    } else {
      tracer.trace(
        'setLocalDescription.error',
        result.getErrorOrNull()?.toString(),
      );
    }

    return result;
  }

  @override
  Future<Result<None>> addIceCandidate(rtc.RTCIceCandidate candidate) async {
    tracer.trace('addIceCandidate', candidate.toMap());

    final result = await super.addIceCandidate(candidate);

    if (result.isSuccess) {
      tracer.trace('addIceCandidate.success', null);
    } else {
      tracer.trace(
        'addIceCandidate.error',
        result.getErrorOrNull()?.toString(),
      );
    }

    return result;
  }

  @override
  Future<void> dispose() {
    tracer.dispose();
    return super.dispose();
  }
}
