import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../logger/stream_log.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../media/media_constraints.dart';
import '../model/rtc_video_dimension.dart';
import 'rtc_track.dart';

const kLocalTrackIdPrefix = 'local';

typedef RtcLocalAudioTrack = RtcLocalTrack<AudioConstraints>;
typedef RtcLocalCameraTrack = RtcLocalTrack<CameraConstraints>;
typedef RtcLocalScreenShareTrack = RtcLocalTrack<ScreenShareConstraints>;

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

  static Future<RtcLocalAudioTrack?> audio({
    String trackIdPrefix = kLocalTrackIdPrefix,
    AudioConstraints constraints = const AudioConstraints(),
  }) async {
    streamLog.i('SV:RtcLocalTrack', () => 'Creating audio track');

    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final audioTrack = stream.getAudioTracks().firstOrNull;

    if (audioTrack == null) {
      streamLog.w('SV:RtcLocalTrack', () => 'No audio track found');
      return null;
    }

    final track = RtcLocalTrack(
      trackIdPrefix: trackIdPrefix,
      trackType: SfuTrackType.audio,
      mediaStream: stream,
      mediaTrack: audioTrack,
      mediaConstraints: constraints,
    );

    return track;
  }

  static Future<RtcLocalCameraTrack?> camera({
    String trackIdPrefix = kLocalTrackIdPrefix,
    CameraConstraints constraints = const CameraConstraints(),
  }) async {
    streamLog.i('SV:RtcLocalTrack', () => 'Creating camera track');
    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final videoTrack = stream.getVideoTracks().firstOrNull;

    if (videoTrack == null) {
      streamLog.w('SV:RtcLocalTrack', () => 'No camera track found');
      return null;
    }

    final track = RtcLocalTrack(
      trackIdPrefix: trackIdPrefix,
      trackType: SfuTrackType.video,
      mediaStream: stream,
      mediaTrack: videoTrack,
      mediaConstraints: constraints,
    );

    return track;
  }

  static Future<RtcLocalScreenShareTrack?> screenShare({
    String trackIdPrefix = kLocalTrackIdPrefix,
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
  }) async {
    streamLog.i('SV:RtcLocalTrack', () => 'Creating screen share track');

    final stream = await rtc.navigator.mediaDevices.getMedia(constraints);
    final videoTrack = stream.getVideoTracks().firstOrNull;

    if (videoTrack == null) {
      streamLog.w('SV:RtcLocalTrack', () => 'No video track found');
      return null;
    }

    final track = RtcLocalTrack(
      trackIdPrefix: trackIdPrefix,
      trackType: SfuTrackType.video,
      mediaStream: stream,
      mediaTrack: videoTrack,
      mediaConstraints: constraints,
    );

    return track;
  }

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
  Future<void> start() async {
    streamLog.i('SV:RtcLocalTrack', () => 'Starting track: $trackId');
    // Enable the track.
    enable();
  }

  @override
  Future<void> stop() async {
    // Disable the track.
    disable();

    // Stop the track.
    streamLog.i('SV:RtcLocalTrack', () => 'Stopping track: $trackId');
    try {
      await mediaTrack.stop();
    } catch (e) {
      streamLog.w('SV:RtcLocalTrack', () => 'Error stopping mediaTrack: $e');
    }

    try {
      await mediaStream.dispose();
    } catch (e) {
      streamLog.w('SV:RtcLocalTrack', () => 'Error disposing mediaStream: $e');
    }
  }

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
