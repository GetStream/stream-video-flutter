import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/src/v2/sfu/data/models/sfu_track_type.dart';

abstract class RtcTrack {
  RtcTrack({
    required this.trackId,
    required this.trackType,
    required this.stream,
    required this.track,
    this.receiver,
    this.transceiver,
  });

  final String trackId;
  final SfuTrackType trackType;
  final rtc.MediaStream stream;
  final rtc.MediaStreamTrack track;
  final rtc.RTCRtpReceiver? receiver;
  final rtc.RTCRtpTransceiver? transceiver;
}

class RtcRemoteTrack extends RtcTrack {
  RtcRemoteTrack({
    required super.trackId,
    required super.trackType,
    required super.stream,
    required super.track,
    super.receiver,
    super.transceiver,
  });
}

class RtcLocalTrack extends RtcTrack {
  RtcLocalTrack({
    required super.trackId,
    required super.trackType,
    required super.stream,
    required super.track,
    super.receiver,
    super.transceiver,
  });
}
