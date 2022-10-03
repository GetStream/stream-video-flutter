import 'dart:async';
import 'dart:convert';

// import 'package:livekit_client/livekit_client.dart';
import 'package:stream_video/protobuf/google/protobuf/struct.pb.dart';
import 'package:stream_video/stream_video.dart';
import 'package:webrtc_interface/src/rtc_peerconnection.dart';

class WebRTCStats {
  WebRTCStats({required this.client});

  final StreamVideoClient client;
  // final Room room;

  late final Timer? statsMonitoringTimer;

  static const Duration monitoringSetInterval = Duration(milliseconds: 15000);

  void _startStatsMonitoring(
    RTCPeerConnection publisherPc,
    RTCPeerConnection subscriberPc,
    String callId,
    StreamCallType callType,
  ) {
    statsMonitoringTimer = Timer.periodic(monitoringSetInterval, (s) async {
      //controller emit
      await _sendStats([publisherPc, subscriberPc], callId, callType);
    });
  }

  Future<void> _sendStat(
    RTCPeerConnection pc, {
    required String callId,
    required StreamCallType callType,
  }) async {
    await client.reportCallStats(
      callType: callType,
      callId: callId,
      stats: await _getStats(pc),
    );
  }

  Future<void> _sendStats(
    List<RTCPeerConnection> pcs,
    String callId,
    StreamCallType callType,
  ) async {
    await Future.wait(pcs.map((pc) => _sendStat(
          pc,
          callId: callId,
          callType: callType,
        )));
  }

  Future<Struct> _getStats(RTCPeerConnection pc) async {
    final stats = await pc.getStats();
    final s = <String, Value>{};
    stats.forEach((v) =>
        s[v.id] = Value(structValue: Struct.fromJson(jsonEncode(v.values))));

    return Struct(fields: s);
  }

  void addConnections({
    required RTCPeerConnection publisherPc,
    required RTCPeerConnection subscriberPc,
    required String callId,
    required StreamCallType callType,
  }) {
    _startStatsMonitoring(
      publisherPc,
      subscriberPc,
      callId,
      callType,
    );
  }
}
