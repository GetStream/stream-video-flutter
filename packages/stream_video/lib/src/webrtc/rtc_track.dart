import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:meta/meta.dart';

import '../sfu/data/models/sfu_track_type.dart';
import 'media/media_constraints.dart';
import 'model/rtc_video_dimension.dart';

@immutable
abstract class RtcTrack {
  const RtcTrack({
    required this.trackIdPrefix,
    required this.trackType,
    required this.stream,
    required this.track,
    this.videoDimension,
    this.receiver,
    this.transceiver,
  });

  final String trackIdPrefix;
  final SfuTrackType trackType;
  final rtc.MediaStream stream;
  final rtc.MediaStreamTrack track;
  final rtc.RTCRtpReceiver? receiver;
  final rtc.RTCRtpTransceiver? transceiver;

  /// The video dimension of the track in case it is a video track.
  final RtcVideoDimension? videoDimension;

  String get trackId => '$trackIdPrefix:$trackType';

  bool get isVideoTrack {
    return trackType == SfuTrackType.video ||
        trackType == SfuTrackType.screenShare;
  }

  RtcTrack copyWith();
}

class RtcRemoteTrack extends RtcTrack {
  const RtcRemoteTrack({
    required super.trackIdPrefix,
    required super.trackType,
    required super.stream,
    required super.track,
    super.videoDimension,
    super.receiver,
    super.transceiver,
  });

  @override
  RtcRemoteTrack copyWith({
    String? trackIdPrefix,
    SfuTrackType? trackType,
    rtc.MediaStream? stream,
    rtc.MediaStreamTrack? track,
    RtcVideoDimension? videoDimension,
    rtc.RTCRtpReceiver? receiver,
    rtc.RTCRtpTransceiver? transceiver,
    bool? muted,
  }) {
    return RtcRemoteTrack(
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      trackType: trackType ?? this.trackType,
      stream: stream ?? this.stream,
      track: track ?? this.track,
      videoDimension: videoDimension ?? this.videoDimension,
      receiver: receiver ?? this.receiver,
      transceiver: transceiver ?? this.transceiver,
    );
  }

  @override
  String toString() {
    return 'RtcRemoteTrack{trackIdPrefix: $trackIdPrefix, '
        'trackType: $trackType, stream.id: ${stream.id}';
  }
}

class RtcLocalTrack<T extends MediaConstraints> extends RtcTrack {
  const RtcLocalTrack({
    required super.trackIdPrefix,
    required super.trackType,
    required super.stream,
    required super.track,
    required this.mediaConstraints,
    super.videoDimension,
    super.receiver,
    super.transceiver,
  });

  /// The media constraints used to create this track.
  ///
  /// This is used to recreate the track if needed.
  /// For example, if the user changes the camera.
  final T mediaConstraints;

  @override
  RtcLocalTrack<T> copyWith({
    String? trackIdPrefix,
    SfuTrackType? trackType,
    rtc.MediaStream? stream,
    rtc.MediaStreamTrack? track,
    T? mediaConstraints,
    RtcVideoDimension? videoDimension,
    rtc.RTCRtpReceiver? receiver,
    rtc.RTCRtpTransceiver? transceiver,
    bool? muted,
  }) {
    return RtcLocalTrack(
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      trackType: trackType ?? this.trackType,
      stream: stream ?? this.stream,
      track: track ?? this.track,
      mediaConstraints: mediaConstraints ?? this.mediaConstraints,
      videoDimension: videoDimension ?? this.videoDimension,
      receiver: receiver ?? this.receiver,
      transceiver: transceiver ?? this.transceiver,
    );
  }

  @override
  String toString() {
    return 'RtcLocalTrack{trackIdPrefix: $trackIdPrefix, '
        'trackType: $trackType, stream.id: ${stream.id}';
  }
}
