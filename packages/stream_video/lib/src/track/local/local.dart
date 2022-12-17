import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:meta/meta.dart';
import '../../exceptions.dart';
import '../../internal/events.dart';
import '../../logger/logger.dart';
import '../options.dart';
import '../track.dart';

/// Base class for [LocalAudioTrack] and [LocalVideoTrack].
abstract class LocalTrack extends Track {
  LocalTrack({
    required super.type,
    required super.mediaStream,
    required super.mediaStreamTrack,
  });

  /// Options used for this track
  abstract LocalTrackOptions currentOptions;

  /// Whether this track is published to the server.
  bool get isPublished => _published;
  bool _published = false;

  /// Mutes this [LocalTrack]. This will stop the sending of track data
  /// and notify the [RemoteParticipant] with [TrackMutedEvent].
  /// Returns true if muted, false if unchanged.
  Future<bool> mute() async {
    logger.fine('LocalTrack.mute() muted: $muted');
    if (muted) return false; // already muted
    await disable();
    await stop();
    updateMuted(muted: true, notifyServer: true);
    return true;
  }

  /// Un-mutes this [LocalTrack]. This will re-start the sending of track data
  /// and notify the [RemoteParticipant] with [TrackUnmutedEvent].
  /// Returns true if un-muted, false if unchanged.
  Future<bool> unmute() async {
    logger.fine('LocalTrack.unmute() muted: $muted');
    if (!muted) return false; // already un-muted
    await restart();
    await enable();
    updateMuted(muted: false, notifyServer: true);
    return true;
  }

  /// Restarts the track with new options. This is useful when switching between
  /// front and back cameras.
  Future<void> restart({LocalTrackOptions? options}) async {
    if (sender == null) throw TrackCreateException('could not restart track');
    if (options != null && currentOptions.runtimeType != options.runtimeType) {
      throw Exception('options must be a ${currentOptions.runtimeType}');
    }

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
    updateMediaStreamAndTrack(
      stream: newStream,
      track: newTrack,
    );

    // mark as started
    await start();

    // notify so VideoView can re-compute mirror mode if necessary
    events.emit(
      LocalTrackOptionsUpdatedEvent(
        track: this,
        options: currentOptions,
      ),
    );
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

  @mustCallSuper
  Future<bool> onPublish() async {
    if (_published) {
      // already published
      return false;
    }

    logger.fine('$runtimeType.publish()');

    _published = true;
    return true;
  }

  @mustCallSuper
  Future<bool> onUnpublish() async {
    if (!_published) {
      // already unpublished
      return false;
    }

    logger.fine('$runtimeType.unpublish()');

    _published = false;
    return true;
  }
}
