import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:meta/meta.dart';
import '../sfu/data/models/sfu_track_type.dart';

import 'media/media_constraints.dart';
import 'model/rtc_tracks_info.dart';
import 'model/rtc_video_dimension.dart';

@immutable
abstract class RtcTrack {
  const RtcTrack({
    required this.trackId,
    required this.trackType,
    required this.stream,
    required this.track,
    this.receiver,
    this.transceiver,
    this.muted = false,
  });

  final String trackId;
  final SfuTrackType trackType;
  final rtc.MediaStream stream;
  final rtc.MediaStreamTrack track;
  final rtc.RTCRtpReceiver? receiver;
  final rtc.RTCRtpTransceiver? transceiver;
  final bool muted;

  String get trackSid => '$trackId:$trackType';

  bool get isVideoTrack {
    return trackType == SfuTrackType.video ||
        trackType == SfuTrackType.screenShare;
  }

  RtcTrack copyWith();
}

class RtcRemoteTrack extends RtcTrack {
  const RtcRemoteTrack({
    required super.trackId,
    required super.trackType,
    required super.stream,
    required super.track,
    super.receiver,
    super.transceiver,
    super.muted,
  });

  @override
  RtcRemoteTrack copyWith({
    String? trackId,
    SfuTrackType? trackType,
    rtc.MediaStream? stream,
    rtc.MediaStreamTrack? track,
    rtc.RTCRtpReceiver? receiver,
    rtc.RTCRtpTransceiver? transceiver,
    bool? muted,
  }) {
    return RtcRemoteTrack(
      trackId: trackId ?? this.trackId,
      trackType: trackType ?? this.trackType,
      stream: stream ?? this.stream,
      track: track ?? this.track,
      receiver: receiver ?? this.receiver,
      transceiver: transceiver ?? this.transceiver,
      muted: muted ?? this.muted,
    );
  }

  @override
  String toString() {
    return 'RtcRemoteTrack{trackId: $trackId, trackType: $trackType, '
        'muted: $muted, stream.id: ${stream.id}';
  }
}

class RtcLocalTrack<T extends MediaConstraints> extends RtcTrack {
  const RtcLocalTrack({
    required super.trackId,
    required super.trackType,
    required super.stream,
    required super.track,
    required this.mediaConstraints,
    this.videoDimension,
    super.receiver,
    super.transceiver,
    super.muted,
  });

  /// The media constraints used to create this track.
  ///
  /// This is used to recreate the track if needed.
  /// For example, if the user changes the camera.
  final T mediaConstraints;

  /// The video dimension of the track in case it is a video track.
  final RtcVideoDimension? videoDimension;

  @override
  RtcLocalTrack<T> copyWith({
    String? trackId,
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
      trackId: trackId ?? this.trackId,
      trackType: trackType ?? this.trackType,
      stream: stream ?? this.stream,
      track: track ?? this.track,
      mediaConstraints: mediaConstraints ?? this.mediaConstraints,
      videoDimension: videoDimension ?? this.videoDimension,
      receiver: receiver ?? this.receiver,
      transceiver: transceiver ?? this.transceiver,
      muted: muted ?? this.muted,
    );
  }

  @override
  String toString() {
    return 'RtcLocalTrack{trackId: $trackId, trackType: $trackType, '
        'muted: $muted, stream.id: ${stream.id}';
  }
}
