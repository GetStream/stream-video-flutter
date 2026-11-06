import 'dart:async';

import 'media_stream.dart';
import 'media_stream_track.dart';
import 'rtc_dtmf_sender.dart';
import 'rtc_rtp_parameters.dart';
import 'rtc_stats_report.dart';

abstract class RTCRtpSender {
  RTCRtpSender();

  Future<bool> setParameters(RTCRtpParameters parameters);

  Future<void> replaceTrack(MediaStreamTrack? track);

  Future<void> setTrack(MediaStreamTrack? track, {bool takeOwnership = true});

  Future<List<StatsReport>> getStats();

  Future<void> setStreams(List<MediaStream> streams);

  RTCRtpParameters get parameters;

  MediaStreamTrack? get track;

  String get senderId;

  bool get ownsTrack;

  RTCDTMFSender get dtmfSender;

  Future<void> dispose();
}
