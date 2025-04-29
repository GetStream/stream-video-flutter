import 'dart:async';

import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../stream_video.dart';
import '../call/stats/tracer.dart';
import 'peer_connection.dart';

class TracedStreamPeerConnection extends StreamPeerConnection {
  TracedStreamPeerConnection({
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
        tracer.trace('onRenegotiationNeeded', null);
        originalNegotiationNeeded?.call();
      }
      ..onIceConnectionState = (state) {
        tracer.trace('onIceConnectionStateChange', state.name);
        originalIceConnectionState?.call(state);
      }
      ..onIceCandidate = (candidate) {
        tracer.trace('onIceCandidate', candidate.toMap());
        originalIceCandidate?.call(candidate);
      }
      ..onTrack = (event) {
        final streams = event.streams.map((stream) => 'stream:${stream.id}');
        tracer.trace(
            'onTrack', '${event.track.kind}:${event.track.id} $streams');
        originalOnTrack?.call(event);
      }
      ..onIceGatheringState = (state) {
        tracer.trace('onIceGatheringStateChange', state.name);
        originalIceGatheringState?.call(state);
      }
      ..onSignalingState = (state) {
        tracer.trace('onSignalingStateChange', state.name);
        originalSignalingState?.call(state);
      }
      ..onConnectionState = (state) {
        tracer.trace('onConnectionStateChange', state.name);

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

  Future<void> traceStats(
    List<Map<String, dynamic>> newStats,
  ) async {
    final statsDiff = _deltaCompression(newStats, _previousStats);
    tracer.trace('getstats', statsDiff);
    _previousStats = newStats;
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

  Map<String, dynamic> _deltaCompression(
    List<Map<String, dynamic>> newStats,
    List<Map<String, dynamic>>? oldStats,
  ) {
    final newStatsLookup = _convertToMap(newStats);
    final oldStatsLookup = _convertToMap(oldStats);

    // if (oldStats != null) {
    //   for (final report in oldStats) {
    //     if (report.containsKey('id')) {
    //       oldStatsLookup[report['id']] = report;
    //     }
    //   }
    // }

    var latestTimestamp = double.negativeInfinity;

    for (final Map<String, dynamic> report in newStatsLookup.values) {
      final id = report.remove('id');
      if (id == null || !oldStatsLookup.containsKey(id)) continue;

      final oldReport = oldStatsLookup[id] as Map<String, dynamic>;

      for (final entry in Map<String, dynamic>.from(report).entries) {
        if (oldReport[entry.key] == entry.value) {
          report.remove(entry.key);
        }
      }

      final ts = report['timestamp'];
      if (ts is num && ts > latestTimestamp) {
        latestTimestamp = ts.toDouble();
      }
    }

    // Zero out the latest timestamp in the matching report(s)
    for (final Map<String, dynamic> report in newStatsLookup.values) {
      if (report['timestamp'] == latestTimestamp) {
        report['timestamp'] = 0;
      }
    }

    // Add top-level timestamp as a separate report (if needed)
    newStatsLookup.addAll(
      {
        'timestamp': latestTimestamp == double.negativeInfinity
            ? DateTime.now().millisecondsSinceEpoch
            : latestTimestamp,
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
      tracer.trace('createOfferSuccess', result.getDataOrNull()?.toMap());
    } else {
      tracer.trace('createOfferError', result.getErrorOrNull()?.toString());
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
      tracer.trace('createAnswerSuccess', result.getDataOrNull()?.toMap());
    } else {
      tracer.trace('createAnswerError', result.getErrorOrNull()?.toString());
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
      tracer.trace('setRemoteDescriptionSuccess', null);
    } else {
      tracer.trace(
        'setRemoteDescriptionError',
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
      tracer.trace('setLocalDescriptionSuccess', null);
    } else {
      tracer.trace(
        'setLocalDescriptionError',
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
      tracer.trace('addIceCandidateSuccess', null);
    } else {
      tracer.trace(
        'addIceCandidateError',
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
