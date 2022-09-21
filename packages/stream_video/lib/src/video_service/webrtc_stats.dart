import 'dart:async';
import 'dart:convert';

import 'package:livekit_client/livekit_client.dart';
import 'package:rxdart/subjects.dart';
import 'package:stream_video/stream_video.dart';
import 'package:uuid/uuid.dart';
import 'package:webrtc_interface/src/rtc_peerconnection.dart';
import 'package:webrtc_interface/src/rtc_stats_report.dart';

import '../../protobuf/google/protobuf/struct.pb.dart';

// class Constants {
//   static String mediaType = 'mediaType';

//   static String kind = 'kind';

//   static String codecId = 'codecId';

//   static String clockRate = 'clockRate';

//   static String mimeType = 'mimeType';

//   static String payloadType = 'payloadType';
// }

// enum TimelineTag { getUserMedia, peer, connection, track, datachannel, stats }

// class ParseStatsOptions {
//   final bool? remote;
//   ParseStatsOptions({this.remote});
// }

// enum ReportType {
//   outboundRtp('outbound-rtp'),
//   inboundRtp('inbound-rtp');

//   final String name;
//   const ReportType(this.name);
// }

// class TrackReport {
//   final String id;
//   final ReportType type;
//   final Object? track;
//   final Object report;

//   final CodecInfo? codecInfo;
//   final Map<dynamic, dynamic> values;

//   final double timestamp;
//   TrackReport({
//     required this.id,
//     this.track,
//     required this.type,
//     required this.report,
//     this.codecInfo,
//     required this.values,
//     required this.timestamp,
//   });

//   int _bitrate = 0;
//   int get bitrate => _bitrate;
//   set bitrate(int bitrate) => _bitrate = bitrate;

//   int _packetRate = 0;
//   int get packetRate => _packetRate;
//   set packetRate(int packetRate) => _packetRate = packetRate;
// }

// enum MediaType {
//   audio('audio'),
//   video('video'),
//   connexion('connexion'),
//   remote('remote');

//   final String name;
//   const MediaType(this.name);
// }

// extension StringX on String {
//   MediaType toMediaType() {
//     return {
//       MediaType.audio.name: MediaType.audio,
//       MediaType.video.name: MediaType.video,
//       MediaType.connexion.name: MediaType.connexion,
//       MediaType.remote.name: MediaType.remote
//     }[this]!;
//   }

//   ReportType toReportType() {
//     return {
//       ReportType.outboundRtp.name: ReportType.outboundRtp,
//     }[this]!;
//   }
// }

// enum BoundType { inbound, outbound }

// typedef StatsObject = Map<MediaType, Map<BoundType, List<TrackReport>>>;

// class CodecInfo {
//   final int clockRate;
//   final int mimeType;
//   final int payloadType;
//   CodecInfo({
//     required this.clockRate,
//     required this.mimeType,
//     required this.payloadType,
//   });
// }

// class StatsEvent {
//   final String event;
//   final TimelineTag tag;
//   final DateTime? timestamp;
//   final Object data;
//   final String peerId;
//   final String connectionId;
//   final int timeTaken;
//   // final RTCStatsReport? rawStats;
//   final Object? statsObject;
//   final Object? filteredStats;
//   StatsEvent({
//     required this.event,
//     required this.tag,
//     this.timestamp,
//     required this.data,
//     required this.peerId,
//     required this.connectionId,
//     required this.timeTaken,
//     // this.rawStats,
//     this.statsObject,
//     this.filteredStats,
//   });
// }

// class WebRTCStatsOptions {
//   final int getStatsInterval;
//   final bool rawStats;
//   final bool statsObject;
//   final bool filteredStats;
//   final bool wrapGetUserMedia;
//   final bool debug;
//   final bool remote;
//   WebRTCStatsOptions({
//     required this.getStatsInterval,
//     required this.rawStats,
//     required this.statsObject,
//     required this.filteredStats,
//     required this.wrapGetUserMedia,
//     required this.debug,
//     required this.remote,
//   });
//   // logLevel: 'none' | 'error' | 'warn' | 'info' | 'debug';
// }

// class MonitoredPeer {
//   final RTCPeerConnection pc;
//   final String connectionId;
//   //  final MediaStream stream:  | null
//   final StatsObject? stats;
//   final bool remote;

//   MonitoredPeer({
//     required this.pc,
//     required this.connectionId,
//     this.stats,
//     required this.remote,
//   });
// }

// typedef MonitoredPeersObject = Map<String, MonitoredPeerCollection>;
// typedef MonitoredPeerCollection = Map<String, MonitoredPeer>;

class WebRTCStats {
  WebRTCStats({required this.room, required this.client});
  // _remote = options?.remote ?? true;
  final StreamVideoClient client;
  final Room room;
  // final WebRTCStatsOptions? options;
  // late final Timer connectionMonitoringTimer;
  late final Timer? statsMonitoringTimer;
  // final MonitoredPeersObject _peersToMonitor = {};
  // final bool _remote;
  // final _controller = BehaviorSubject<StatsEvent>();

  // set stats(StatsEvent event) => _controller.add(event);

  // Stream<StatsEvent> get statsStream => _controller.stream;

  static const Duration monitoringSetInterval = Duration(milliseconds: 15000);
  // static const Duration connectionMonitoringSetInterval = Duration(seconds: 1);

  // int get _numberOfMonitoredPeers => _peersToMonitor.keys.length;

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

  // void _startConnectionStateMonitoring() {
  //   connectionMonitoringTimer =
  //       Timer.periodic(connectionMonitoringSetInterval, (s) {
  //     //controller emit
  //     _checkIfConnectionIsClosed();
  //   });
  // }

  Future<void> _sendStat(
    RTCPeerConnection pc, {
    required String callId,
    required StreamCallType callType,
  }) async {
    client.reportCallStats(
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
    var s = <String, Value>{};
    stats.forEach((v) =>
        s[v.id] = Value(structValue: Struct.fromJson(jsonEncode(v.values))));

    return Struct(fields: s);
  }

  void addConnections({
    required RTCPeerConnection publisherPc,
    required RTCPeerConnection subscriberPc,
    required String callId,
    required StreamCallType callType,
    // required String peerId,
    // String? connectionId,
  }) {
    _startStatsMonitoring(
      publisherPc,
      subscriberPc,
      callId,
      callType,
    );
    // var _connectionId = connectionId;
    // final config = pc.getConfiguration;
    // if (_connectionId == null) {
    //   final uuid = Uuid();
    //   _connectionId = uuid.v4();
    // }
    // _monitorPeer(
    //   peerId: peerId,
    //   connectionId: _connectionId,
    //   pc: pc,
    //   remote: _remote,
    // );
  }

  // Future<List<StatsEvent>> _getStats({String? id}) async {
  //   // print(
  //   //     "${id != null ? 'Getting stats from peer ${id}' : 'Getting stats from all peers'}");
  //   var peersToAnalyse = MonitoredPeersObject();
  //   // if (id != null) {
  //   //   if (_peersToMonitor[id] == null) {
  //   //     throw Exception("Cannot get stats. Peer with id ${id} does not exist");
  //   //   }

  //   //   peersToAnalyse[id] = _peersToMonitor[id]!;
  //   // } else {
  //   // else, get stats for all of them
  //   // peersToAnalyse = this._peersToMonitor;
  //   // }

  //   final result = <StatsEvent>[];
  //   for (final id in peersToAnalyse.keys) {
  //     for (final connectionId in peersToAnalyse[id]!.keys) {
  //       final peerObject = peersToAnalyse[id]![connectionId];
  //       final pc = peerObject!.pc;

  //       try {
  //         final stopwatch = Stopwatch()..start();
  //         final stats = await pc.getStats();
  //         stopwatch.stop();
  //         final parseStatsOptions =
  //             ParseStatsOptions(remote: peerObject.remote);
  //         final parsedStats =
  //             parseStats(stats, peerObject.stats!, parseStatsOptions);
  //         final durationInMs = stopwatch.elapsed.inSeconds;
  //         for (final stat in stats) {
  //           print("STATS ${stat.id}  ${stat.type} ${stat.values}");
  //         }
  //       } catch (e) {
  //         print('exception $e');
  //         rethrow;
  //       }
  //     }
  //   }
  //   // result.add(StatsEvent(event: event, tag: tag, data: data, peerId: peerId, connectionId: connectionId, timeTaken: timeTaken))
  //   return result;
  // }

  // void _monitorPeer({
  //   required String peerId,
  //   required String connectionId,
  //   required RTCPeerConnection pc,
  //   required bool remote,
  // }) {
  //   final monitorPeerObject =
  //       MonitoredPeer(pc: pc, connectionId: connectionId, remote: remote);
  //   // _peersToMonitor[peerId] = {connectionId: monitorPeerObject};

  //   _startStatsMonitoring();
  // }

  // void _checkIfConnectionIsClosed() {
  //   print("TODO: checking if connection is closed");
  // }
}

// StatsObject parseStats(List<StatsReport> stats, StatsObject previousStats,
//     ParseStatsOptions parseStatsOptions) {
//   var statsObject = StatsObject();
//   for (final report in stats) {
//     switch (report.type.toReportType()) {
//       case ReportType.outboundRtp:
//         final String rawMediaType =
//             report.values[Constants.mediaType] ?? report.values[Constants.kind];
//         if (!['audio', 'video'].contains(rawMediaType)) continue;
//         if (report.values[Constants.codecId] != null) {
//           final codec = report.values[Constants.codecId];
//           CodecInfo? codecInfo;
//           if (codec != null) {
//             codecInfo = CodecInfo(
//                 clockRate: codec[Constants.clockRate],
//                 mimeType: codec[Constants.mimeType],
//                 payloadType: codec[Constants.payloadType]);
//           }
//           final trackData =
//               report.values["mediaSourceId"] ?? report.values["trackId"];
//           final mediaType = rawMediaType.toMediaType();
//           statsObject[mediaType]![BoundType.outbound]!.add(TrackReport(
//             id: report.id,
//             type: report.type.toReportType(),
//             timestamp: report.timestamp,
//             report: report,
//             codecInfo: codecInfo,
//             track: trackData,
//             values: report.values,
//           ));
//           // final codec = stats.firstWhere((element) => report.values["codecId"] ) .get(report.codecId);
//         }
//         break;

//       case ReportType.inboundRtp:
//         var rawMediaType = report.values[Constants.mediaType] as String? ??
//             report.values["kind"] as String;
//         // Safari is missing mediaType and kind for 'inbound-rtp'
//         if (!['audio', 'video'].contains(rawMediaType)) {
//           if (report.id.contains('Video'))
//             rawMediaType = 'video';
//           else if (report.id.contains('Audio'))
//             rawMediaType = 'audio';
//           else
//             continue;
//         }
//         final codec = report.values[Constants.codecId];
//         if (report.values[Constants.codecId] != null) {
//           CodecInfo? codecInfo;
//           if (codec != null) {
//             codecInfo = CodecInfo(
//                 clockRate: codec[Constants.clockRate],
//                 mimeType: codec[Constants.mimeType],
//                 payloadType: codec[Constants.payloadType]);
//           }
//           final trackData =
//               report.values["mediaSourceId"] ?? report.values["trackId"];
//           final mediaType = rawMediaType.toMediaType();
//           statsObject[mediaType]![BoundType.inbound]!.add(TrackReport(
//             id: report.id,
//             type: report.type.toReportType(),
//             timestamp: report.timestamp,
//             report: report,
//             codecInfo: codecInfo,
//             track: trackData,
//             values: report.values,
//           ));
//           // final codec = stats.firstWhere((element) => report.values["codecId"] ) .get(report.codecId);
//         }
//         break;
//       default:
//     }
//   }

//   statsObject = addAdditionalData(statsObject, previousStats);
//   return statsObject;
// }

// int? computeRate(
//     TrackReport newReport, TrackReport oldReport, String statName) {
//   final newVal = newReport.values[statName];
//   final oldVal = oldReport.values[statName];
//   if (newVal == null || oldVal == null) {
//     return null;
//   }
//   return (newVal - oldVal) / (newReport.timestamp - oldReport.timestamp) * 1000;
// }

// int computeBitrate(
//     TrackReport newReport, TrackReport oldReport, String statName) {
//   return computeRate(newReport, oldReport, statName)! * 8;
// }

// StatsObject addAdditionalData(
//     StatsObject currentStats, StatsObject? previousStats) {
//   if (previousStats == null) return currentStats;
//   // audio
//   // inbound
//   currentStats[MediaType.audio]![BoundType.inbound]!.map((report) {
//     final prev = previousStats[MediaType.audio]![BoundType.inbound]!
//         .firstWhere((r) => r.id == report.id);
//     report
//       ..bitrate = computeBitrate(report, prev, 'bytesReceived')
//       ..packetRate = computeBitrate(report, prev, 'packetsReceived');
//   });

//   // audio
//   // outbound
//   currentStats[MediaType.audio]![BoundType.outbound]!.map((report) {
//     final prev = previousStats[MediaType.audio]![BoundType.outbound]!
//         .firstWhere((r) => r.id == report.id);
//     report
//       ..bitrate = computeBitrate(report, prev, 'bytesSent')
//       ..packetRate = computeBitrate(report, prev, 'packetsSent');
//   });

//   // video
//   // inbound
//   currentStats[MediaType.video]![BoundType.inbound]!.map((report) {
//     final prev = previousStats[MediaType.video]![BoundType.inbound]!
//         .firstWhere((r) => r.id == report.id);
//     report
//       ..bitrate = computeBitrate(report, prev, 'bytesReceived')
//       ..packetRate = computeBitrate(report, prev, 'packetsReceived');
//   });

//   // video
//   // outbound
//   currentStats[MediaType.video]![BoundType.outbound]!.map((report) {
//     final prev = previousStats[MediaType.video]![BoundType.outbound]!
//         .firstWhere((r) => r.id == report.id);
//     report
//       ..bitrate = computeBitrate(report, prev, 'bytesSent')
//       ..packetRate = computeBitrate(report, prev, 'packetsSent');
//   });
//   return currentStats;
// }
