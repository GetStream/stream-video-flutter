import 'model/rtc_video_encoding.dart';
import 'model/rtc_video_parameters.dart';

class TrackPublishOptions {
  const TrackPublishOptions();
}

/// Options used when publishing video.
class VideoTrackPublishOptions extends TrackPublishOptions {
  const VideoTrackPublishOptions({
    this.videoEncoding,
    this.simulcast = true,
    this.videoSimulcastLayers = const [],
    this.screenShareSimulcastLayers = const [],
  });

  /// If provided, this will be used instead of the SDK's suggested encodings.
  /// Usually you don't need to provide this.
  /// Defaults to null.
  final RtcVideoEncoding? videoEncoding;

  /// Whether to enable simulcast or not.
  /// Defaults to true.
  final bool simulcast;

  final List<RtcVideoParameters> videoSimulcastLayers;

  final List<RtcVideoParameters> screenShareSimulcastLayers;

  @override
  String toString() {
    return '$runtimeType(videoEncoding: $videoEncoding, simulcast: $simulcast)';
  }
}

/// Options used when publishing audio.
class AudioTrackPublishOptions extends TrackPublishOptions {
  const AudioTrackPublishOptions({
    this.audioBitrate = AudioPreset.music,
  });

  /// max audio bitrate
  final int audioBitrate;

  @override
  String toString() => '$runtimeType(audioBitrate: $audioBitrate)';
}

mixin AudioPreset {
  static const telephone = 12000;
  static const speech = 20000;
  static const music = 32000;
  static const musicStereo = 48000;
  static const musicHighQuality = 64000;
  static const musicHighQualityStereo = 96000;
}
