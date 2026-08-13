import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../logger/stream_log.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../model/rtc_video_dimension.dart';
import '../rtc_audio_api/rtc_audio_api.dart' as rtc_audio_api;
import 'rtc_track.dart';

const _tag = 'SV:RtcRemoteTrack';

class RtcRemoteTrack extends RtcTrack {
  const RtcRemoteTrack({
    required super.trackIdPrefix,
    required super.trackType,
    required super.mediaStream,
    required super.mediaTrack,
    super.videoDimension,
    this.transceiver,
    this.audioSinkId,
  });

  final rtc.RTCRtpTransceiver? transceiver;

  /// The audio sink device id of the track in case it is an audio track.
  final String? audioSinkId;

  @override
  Future<void> start() async {
    // Enable the track.
    enable();

    streamLog.i(_tag, () => 'Starting track: $trackId');

    // Start the audio player if it's an audio track.
    if (isAudioTrack) {
      rtc_audio_api.startAudio(trackId, mediaTrack);
      if (audioSinkId != null) await setSinkId(audioSinkId!);
    }
  }

  /// Stops the track.
  ///
  /// [disposeWebAudioPlayer] (web-only) controls whether the remote audio
  /// `<audio>` element is disposed — pass `false` if the track may resume on the
  /// same transceiver, to preserve the output device. Use the default (`true`)
  /// for permanent teardown. No effect on native.
  @override
  Future<void> stop({bool disposeWebAudioPlayer = true}) async {
    // Disable the track.
    disable();

    streamLog.i(
      _tag,
      () =>
          'Stopping track: $trackId '
          '(disposeWebAudioPlayer: $disposeWebAudioPlayer)',
    );

    // Stop the audio player if it's an audio track.
    if (isAudioTrack && disposeWebAudioPlayer) {
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
    String? audioSinkId,
  }) {
    return RtcRemoteTrack(
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      trackType: trackType ?? this.trackType,
      mediaStream: mediaStream ?? this.mediaStream,
      mediaTrack: mediaTrack ?? this.mediaTrack,
      videoDimension: videoDimension ?? this.videoDimension,
      audioSinkId: audioSinkId ?? this.audioSinkId,
    );
  }

  @override
  String toString() {
    return 'RtcRemoteTrack{trackIdPrefix: $trackIdPrefix, '
        'trackType: $trackType, stream.id: ${mediaStream.id}';
  }
}

const _audioTag = 'SV:RtcRemoteAudioTrack';

extension RtcRemoteAudioTrackHardwareExt on RtcRemoteTrack {
  Future<RtcRemoteTrack> setSinkId(String id) async {
    if (!isAudioTrack) return this;

    streamLog.i(_audioTag, () => 'Setting sink id for track $trackId to $id');

    await rtc_audio_api.setSinkId(trackId, id);
    return copyWith(audioSinkId: id);
  }
}
