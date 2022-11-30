import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import 'package:stream_video/src/core/logger/logger.dart';
import 'package:stream_video/src/core/platform_detector/platform_detector.dart';
import 'package:stream_video/src/track/options.dart';
import 'package:stream_video/src/track/track.dart';

abstract class LocalTrack extends Track {
  LocalTrack({
    required super.name,
    required super.kind,
    required super.source,
    required super.mediaStream,
    required super.mediaStreamTrack,
  });

  /// Options used for this track
  abstract LocalTrackOptions currentOptions;

  bool get isPublished => _published;
  bool _published = false;

  /// Mutes/Unmutes this [LocalTrack].
  Future<bool> mute({bool muted = true}) async {
    final didMute = await super.mute(muted: muted);
    if (didMute) {
      if (muted) {
        await disable();
        if (!CurrentPlatform.isWindows) {
          await stop();
        }
      } else {
        if (!CurrentPlatform.isWindows) {
          await start();
        }
        await enable();
      }
    }
    return didMute;
  }

  /// Restarts the track with new options. This is useful when switching between
  /// front and back cameras.
  @override
  Future<bool> start({
    bool restart = false,
    LocalTrackOptions? options,
  }) async {
    if (!restart) return super.start();

    if (sender == null) throw 'could not restart track';

    final trackOptions = options ?? currentOptions;

    // stop if not already stopped...
    await stop();

    final newStream = await LocalTrack.createStream(trackOptions);
    final newTrack = newStream.getTracks().first;

    // replace track on sender
    try {
      await sender?.replaceTrack(newTrack);
    } catch (error) {
      logger.severe('RTCRtpSender.replaceTrack() did throw $error');
    }

    // set new stream & track to this object
    mediaStream = newStream;
    mediaStreamTrack = newTrack;

    // mark as started
    return super.start();
  }

  @override
  Future<bool> stop() async {
    final didStop = await super.stop();
    if (didStop) {
      logger.fine('Stopping mediaStreamTrack...');
      try {
        await mediaStreamTrack.stop();
      } catch (error) {
        logger.severe('MediaStreamTrack.stop() did throw $error');
      }
      try {
        await mediaStream.dispose();
      } catch (error) {
        logger.severe('MediaStreamTrack.dispose() did throw $error');
      }
    }
    return didStop;
  }

  /// Creates a [rtc.MediaStream] from [LocalTrackOptions].
  static Future<rtc.MediaStream> createStream(
    LocalTrackOptions options,
  ) async {
    final constraints = <String, dynamic>{
      'audio': options.when(
        onAudio: (options) => options.toMediaConstraintsMap(),
        onVideo: (options) {
          if (options is ScreenShareCaptureOptions) {
            return options.captureScreenAudio;
          }
          return false;
        },
      ),
      'video': options.when(
        onAudio: (_) => false,
        onVideo: (options) => options.toMediaConstraintsMap(),
      ),
    };

    final rtc.MediaStream stream;
    if (options is ScreenShareCaptureOptions) {
      stream = await rtc.navigator.mediaDevices.getDisplayMedia(constraints);
    } else {
      // options is CameraVideoTrackOptions
      stream = await rtc.navigator.mediaDevices.getUserMedia(constraints);
    }

    // Check if the stream looks good
    if ((options is VideoCaptureOptions && stream.getVideoTracks().isEmpty) ||
        (options is AudioCaptureOptions && stream.getAudioTracks().isEmpty)) {
      throw 'Failed to create stream, at least 1 video or audio track should exist';
    }
    return stream;
  }
}
