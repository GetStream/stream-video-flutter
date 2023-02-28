import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../logger/stream_log.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../model/rtc_video_dimension.dart';
import '../rtc_audio_api/rtc_audio_api.dart' as rtc_audio_api;
import 'rtc_track.dart';

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
  Future<void> start() async {
    // Enable the track.
    enable();

    streamLog.i('SV:RtcRemoteTrack', () => 'Starting track: $trackId');

    // Start the audio player if it's an audio track.
    if (isAudioTrack) {
      rtc_audio_api.startAudio(trackId, mediaTrack);
    }
  }

  @override
  Future<void> stop() async {
    // Disable the track.
    disable();

    streamLog.i('SV:RtcRemoteTrack', () => 'Stopping track: $trackId');

    // Stop the audio player if it's an audio track.
    if (isAudioTrack) {
      rtc_audio_api.stopAudio(trackId);
    }
  }

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
