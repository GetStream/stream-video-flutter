import 'dart:async';

import 'package:stream_video/src/track/local/local.dart';
import 'package:stream_video/src/track/options.dart';
import 'package:stream_video/src/track/track.dart';

import 'package:stream_video/src/types/other.dart';

class LocalAudioTrack extends LocalTrack with AudioTrack {
  LocalAudioTrack({
    required super.name,
    required super.source,
    required super.mediaStream,
    required super.mediaStreamTrack,
    required this.currentOptions,
  }) : super(kind: TrackType.audio);

  @override
  covariant AudioCaptureOptions currentOptions;

  /// Creates a new audio track from the default audio input device.
  static Future<LocalAudioTrack> create([
    AudioCaptureOptions? options,
  ]) async {
    options ??= const AudioCaptureOptions();
    final stream = await LocalTrack.createStream(options);

    return LocalAudioTrack(
      name: Track.microphoneName,
      source: TrackSource.microphone,
      mediaStream: stream,
      mediaStreamTrack: stream.getAudioTracks().first,
      currentOptions: options,
    );
  }
}
