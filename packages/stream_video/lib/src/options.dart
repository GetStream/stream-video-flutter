import 'track/local/audio.dart';
import 'track/local/video.dart';
import 'track/options.dart';
import 'track/track.dart';
import 'types/video_encoding.dart';
import 'types/video_parameters.dart';

class TrackOption<T extends Track> {
  const TrackOption({
    this.enabled = false,
    this.track,
  });

  final bool enabled;
  final T? track;
}

/// Options used when connecting to the server.
class ConnectOptions {
  const ConnectOptions({
    this.camera = const TrackOption(),
    this.microphone = const TrackOption(),
    this.screenShare = const TrackOption(),
  });

  final TrackOption<LocalVideoTrack> camera;
  final TrackOption<LocalAudioTrack> microphone;
  final TrackOption<LocalVideoTrack> screenShare;
}

/// Options used to modify the behavior of the [Call].
class CallOptions {
  const CallOptions({
    this.defaultCameraCaptureOptions = const CameraCaptureOptions(),
    this.defaultScreenShareCaptureOptions = const ScreenShareCaptureOptions(),
    this.defaultAudioCaptureOptions = const AudioCaptureOptions(),
    this.defaultVideoPublishOptions = const VideoPublishOptions(),
    this.defaultAudioPublishOptions = const AudioPublishOptions(),
    this.adaptiveStream = true,
    this.dynacast = false,
    this.stopLocalTrackOnUnpublish = true,
  });

  /// Default options used for [LocalVideoTrack.createCameraTrack].
  final CameraCaptureOptions defaultCameraCaptureOptions;

  /// Default options used for [LocalVideoTrack.createScreenShareTrack].
  final ScreenShareCaptureOptions defaultScreenShareCaptureOptions;

  /// Default options used when capturing video for a [LocalAudioTrack].
  final AudioCaptureOptions defaultAudioCaptureOptions;

  /// Default options used when publishing a [LocalVideoTrack].
  final VideoPublishOptions defaultVideoPublishOptions;

  /// Default options used when publishing a [LocalAudioTrack].
  final AudioPublishOptions defaultAudioPublishOptions;

  /// AdaptiveStream lets LiveKit automatically manage quality of subscribed
  /// video tracks to optimize for bandwidth and CPU.
  /// When attached video elements are visible, it'll choose an appropriate
  /// resolution based on the size of largest video element it's attached to.
  ///
  /// When none of the video elements are visible, it'll temporarily pause
  /// the data flow until they are visible again.
  final bool adaptiveStream;

  /// enable Dynacast, off by default. With Dynacast dynamically pauses
  /// video layers that are not being consumed by any subscribers, significantly
  /// reducing publishing CPU and bandwidth usage.
  final bool dynacast;

  /// Set this to false in case you would like to stop the track yourself.
  /// If you set this to false, make sure you call [Track.stop].
  /// Defaults to true.
  final bool stopLocalTrackOnUnpublish;
}

/// Used to group [AudioPublishOptions] and [VideoPublishOptions].
mixin PublishOptions {}

/// Options used when publishing video.
class VideoPublishOptions with PublishOptions {
  const VideoPublishOptions({
    this.videoEncoding,
    this.simulcast = true,
    this.videoSimulcastLayers = const [],
    this.screenShareSimulcastLayers = const [],
  });

  /// If provided, this will be used instead of the SDK's suggested encodings.
  /// Usually you don't need to provide this.
  /// Defaults to null.
  final VideoEncoding? videoEncoding;

  /// Whether to enable simulcast or not.
  /// https://blog.livekit.io/an-introduction-to-webrtc-simulcast-6c5f1f6402eb
  /// Defaults to true.
  final bool simulcast;

  final List<VideoParameters> videoSimulcastLayers;

  final List<VideoParameters> screenShareSimulcastLayers;

  @override
  String toString() =>
      '$runtimeType(videoEncoding: $videoEncoding, simulcast: $simulcast)';
}

/// Options used when publishing audio.
class AudioPublishOptions with PublishOptions {
  const AudioPublishOptions({
    this.dtx = true,
    this.audioBitrate = AudioPreset.music,
  });

  /// Whether to enable DTX (Discontinuous Transmission) or not.
  /// https://en.wikipedia.org/wiki/Discontinuous_transmission
  /// Defaults to true.
  final bool dtx;

  /// max audio bitrate
  final int audioBitrate;

  @override
  String toString() => '$runtimeType(dtx: $dtx)';
}

mixin AudioPreset {
  static const telephone = 12000;
  static const speech = 20000;
  static const music = 32000;
  static const musicStereo = 48000;
  static const musicHighQuality = 64000;
  static const musicHighQualityStereo = 96000;
}
