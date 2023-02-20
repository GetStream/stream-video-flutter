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
    required this.mediaStream,
    required this.mediaTrack,
    this.videoDimension,
    this.receiver,
    this.transceiver,
  });

  final String trackIdPrefix;
  final SfuTrackType trackType;
  final rtc.MediaStream mediaStream;
  final rtc.MediaStreamTrack mediaTrack;
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
    required super.mediaStream,
    required super.mediaTrack,
    super.videoDimension,
    super.receiver,
    super.transceiver,
  });

  @override
  RtcRemoteTrack copyWith({
    String? trackIdPrefix,
    SfuTrackType? trackType,
    rtc.MediaStream? mediaStream,
    rtc.MediaStreamTrack? mediaTrack,
    RtcVideoDimension? videoDimension,
    rtc.RTCRtpReceiver? receiver,
    rtc.RTCRtpTransceiver? transceiver,
  }) {
    return RtcRemoteTrack(
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      trackType: trackType ?? this.trackType,
      mediaStream: mediaStream ?? this.mediaStream,
      mediaTrack: mediaTrack ?? this.mediaTrack,
      videoDimension: videoDimension ?? this.videoDimension,
      receiver: receiver ?? this.receiver,
      transceiver: transceiver ?? this.transceiver,
    );
  }

  @override
  String toString() {
    return 'RtcRemoteTrack{trackIdPrefix: $trackIdPrefix, '
        'trackType: $trackType, stream.id: ${mediaStream.id}';
  }
}

class RtcLocalTrack<T extends MediaConstraints> extends RtcTrack {
  const RtcLocalTrack({
    required super.trackIdPrefix,
    required super.trackType,
    required super.mediaStream,
    required super.mediaTrack,
    required this.mediaConstraints,
    this.stopTrackOnMute = true,
    super.videoDimension,
    super.receiver,
    super.transceiver,
  });

  /// The media constraints used to create this track.
  ///
  /// This is used to recreate the track if needed.
  /// For example, if the user changes the camera.
  final T mediaConstraints;

  /// Whether to stop the track when the user mutes it.
  ///
  /// This is used to avoid the track indicator light remaining on.
  final bool stopTrackOnMute;

  @override
  RtcLocalTrack<T> copyWith({
    String? trackIdPrefix,
    SfuTrackType? trackType,
    rtc.MediaStream? mediaStream,
    rtc.MediaStreamTrack? mediaTrack,
    T? mediaConstraints,
    bool? stopTrackOnMute,
    RtcVideoDimension? videoDimension,
    rtc.RTCRtpReceiver? receiver,
    rtc.RTCRtpTransceiver? transceiver,
  }) {
    return RtcLocalTrack(
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      trackType: trackType ?? this.trackType,
      mediaStream: mediaStream ?? this.mediaStream,
      mediaTrack: mediaTrack ?? this.mediaTrack,
      mediaConstraints: mediaConstraints ?? this.mediaConstraints,
      stopTrackOnMute: stopTrackOnMute ?? this.stopTrackOnMute,
      videoDimension: videoDimension ?? this.videoDimension,
      receiver: receiver ?? this.receiver,
      transceiver: transceiver ?? this.transceiver,
    );
  }

  @override
  String toString() {
    return 'RtcLocalTrack{trackIdPrefix: $trackIdPrefix, '
        'trackType: $trackType, stream.id: ${mediaStream.id}';
  }
}
