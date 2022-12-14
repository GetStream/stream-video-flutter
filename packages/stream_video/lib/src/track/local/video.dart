import 'package:stream_video/protobuf/video/sfu/models/models.pbserver.dart'
    as sfu;
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/track/local/audio.dart';
import 'package:stream_video/src/track/local/local.dart';
import 'package:stream_video/src/track/options.dart';
import 'package:stream_video/src/track/track.dart';

/// A video track from the local device. Use static methods in this class to create
/// video tracks.
class LocalVideoTrack extends LocalTrack with VideoTrack {
  LocalVideoTrack._({
    required super.type,
    required super.mediaStream,
    required super.mediaStreamTrack,
    required this.currentOptions,
  });

  @override
  covariant VideoCaptureOptions currentOptions;

  /// Creates a LocalVideoTrack from camera input.
  static Future<LocalVideoTrack> createCameraTrack([
    CameraCaptureOptions? options,
  ]) async {
    options ??= const CameraCaptureOptions();

    final stream = await LocalTrack.createStream(options);
    return LocalVideoTrack._(
      type: sfu.TrackType.TRACK_TYPE_VIDEO,
      mediaStream: stream,
      mediaStreamTrack: stream.getVideoTracks().first,
      currentOptions: options,
    );
  }

  /// Creates a LocalVideoTrack from the display.
  ///
  /// Note: Android requires a foreground service to be started prior to
  /// creating a screen track. Refer to the example app for an implementation.
  static Future<LocalVideoTrack> createScreenShareTrack([
    ScreenShareCaptureOptions? options,
  ]) async {
    options ??= const ScreenShareCaptureOptions();

    final stream = await LocalTrack.createStream(options);
    return LocalVideoTrack._(
      type: sfu.TrackType.TRACK_TYPE_SCREEN_SHARE,
      mediaStream: stream,
      mediaStreamTrack: stream.getVideoTracks().first,
      currentOptions: options,
    );
  }

  /// Creates a LocalTracks(audio/video) from the display.
  ///
  /// The current API is mainly used to capture audio when chrome captures tab,
  /// but in the future it can also be used for flutter native to open audio
  /// capture device when capturing screen
  static Future<List<LocalTrack>> createScreenShareTracksWithAudio([
    ScreenShareCaptureOptions? options,
  ]) async {
    options ??= const ScreenShareCaptureOptions(captureScreenAudio: true);

    final stream = await LocalTrack.createStream(options);

    final tracks = <LocalTrack>[
      LocalVideoTrack._(
        type: sfu.TrackType.TRACK_TYPE_SCREEN_SHARE,
        mediaStream: stream,
        mediaStreamTrack: stream.getVideoTracks().first,
        currentOptions: options,
      ),
    ];

    if (stream.getAudioTracks().isNotEmpty) {
      tracks.add(LocalAudioTrack(
        type: sfu.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO,
        mediaStream: stream,
        mediaStreamTrack: stream.getAudioTracks().first,
        currentOptions: const AudioCaptureOptions(),
      ));
    }
    return tracks;
  }
}

/// Convenience extensions on [LocalVideoTrack].
extension LocalVideoTrackX on LocalVideoTrack {
  // Calls restartTrack under the hood
  Future<void> setCameraPosition(CameraPosition position) async {
    final options = currentOptions;
    if (options is! CameraCaptureOptions) {
      logger.warning('Not a camera track');
      return;
    }

    // restart with new options
    await restart(options: options.copyWith(cameraPosition: position));
  }

  Future<void> switchCamera(String deviceId) async {
    final options = currentOptions;
    if (options is! CameraCaptureOptions) {
      logger.warning('Not a camera track');
      return;
    }

    // restart with new options
    await restart(options: options.copyWith(deviceId: deviceId));
  }
}
