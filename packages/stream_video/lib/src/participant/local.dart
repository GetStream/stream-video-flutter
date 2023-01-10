import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../protobuf/video/sfu/models/models.pbserver.dart' as sfu_models;
import '../../protobuf/video/sfu/signal_rpc/signal.pb.dart';
import '../events.dart';
import '../exceptions.dart';
import '../extensions.dart';
import '../logger/logger.dart';
import '../options.dart';
import '../platform_detector/platform_detector.dart';
import '../publication/local.dart';
import '../publication/track_info.dart';
import '../sfu-client/rtc/codecs.dart' as codecs;
import '../track/local/audio.dart';
import '../track/local/video.dart';
import '../track/track.dart';
import 'participant.dart';

/// Represents the current participant in the room. Instance of [LocalParticipant] is automatically
/// created after successfully connecting to a [Call] and will be accessible from [Call.localParticipant].
class LocalParticipant extends Participant<LocalTrackPublication> {
  LocalParticipant({
    required super.call,
    required super.info,
  });

  /// Map of track sid => subscribed track
  final trackSubscriptions = <String, TrackSubscriptionDetails>{};

  /// Publish an [AudioTrack] to the [Room].
  /// For most cases, using [setMicrophoneEnabled] would be simpler and recommended.
  Future<LocalTrackPublication<LocalAudioTrack>> publishAudioTrack(
    LocalAudioTrack track, {
    AudioPublishOptions? publishOptions,
  }) async {
    if (audioTracks.any(
      (e) => e.track?.mediaStreamTrack.id == track.mediaStreamTrack.id,
    )) {
      throw TrackPublishException('track already exists');
    }

    // Use defaultPublishOptions if options is null
    publishOptions ??= call.callOptions.defaultAudioPublishOptions;

    final trackInfo = TrackInfo(
      id: trackLookupPrefix,
      type: track.type,
      dtx: publishOptions.dtx,
    );

    await track.start();

    final pub = LocalTrackPublication<LocalAudioTrack>(
      participant: this,
      info: trackInfo,
      track: track,
      publishOptions: publishOptions,
    );

    addTrackPublication(pub);

    print('Audio tracks: ${audioTracks.length}');

    track.transceiver = await call.publisher?.addAudioTransceiver(
      track: track.mediaStreamTrack,
      encodings: [
        if (publishOptions.audioBitrate > 0)
          rtc.RTCRtpEncoding(maxBitrate: publishOptions.audioBitrate),
      ],
    );

    // did publish
    await track.onPublish();

    [events, call.events].emit(
      LocalTrackPublishedEvent(
        participant: this,
        publication: pub,
      ),
    );

    return pub;
  }

  /// Publish a [LocalVideoTrack] to the [Room].
  /// For most cases, using [setCameraEnabled] would be simpler and recommended.
  Future<LocalTrackPublication<LocalVideoTrack>> publishVideoTrack(
    LocalVideoTrack track, {
    VideoPublishOptions? publishOptions,
  }) async {
    if (videoTracks.any(
      (e) => e.track?.mediaStreamTrack.id == track.mediaStreamTrack.id,
    )) {
      throw TrackPublishException('track already exists');
    }

    // Use defaultPublishOptions if options is null
    publishOptions ??= call.callOptions.defaultVideoPublishOptions;

    // use constraints passed to getUserMedia by default
    var dimensions = track.currentOptions.params.dimensions;

    if (CurrentPlatform.isWeb) {
      // getSettings() is only implemented for Web
      try {
        // try to use getSettings for more accurate resolution
        final settings = track.mediaStreamTrack.getSettings();
        if (settings['width'] is int) {
          dimensions = dimensions.copyWith(width: settings['width'] as int);
        }
        if (settings['height'] is int) {
          dimensions = dimensions.copyWith(height: settings['height'] as int);
        }
      } catch (_) {
        logger.warning('Failed to call `mediaStreamTrack.getSettings()`');
      }
    }

    logger.fine(
      'Compute encodings with resolution: $dimensions, options: $publishOptions',
    );

    // Video encodings and simulcasts
    final encodings = codecs.computeVideoEncodings(
      isScreenShare: track.type == sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE,
      dimensions: dimensions,
      options: publishOptions,
    );

    logger.fine('Using encodings: ${encodings?.map((e) => e.toMap())}');

    final layers = codecs.computeVideoLayers(dimensions, encodings);

    logger.fine('Video layers: ${layers.map((e) => e)}');

    final trackInfo = TrackInfo(
      id: trackLookupPrefix,
      type: track.type,
      videoDimension: dimensions,
      videoLayers: layers,
    );

    await track.start();

    final pub = LocalTrackPublication<LocalVideoTrack>(
      participant: this,
      info: trackInfo,
      track: track,
      publishOptions: publishOptions,
    );

    addTrackPublication(pub);

    print('Video tracks: ${videoTracks.length}');

    logger.fine('publishVideoTrack publisher: ${call.publisher}');

    track.transceiver = await call.publisher?.addVideoTransceiver(
      track: track.mediaStreamTrack,
      stream: track.mediaStream,
      encodings: encodings,
    );

    // did publish
    await track.onPublish();

    [events, call.events].emit(
      LocalTrackPublishedEvent(
        participant: this,
        publication: pub,
      ),
    );

    return pub;
  }

  @override
  Future<void> unpublishTrack(String trackSid, {bool notify = true}) async {
    logger.finer('Unpublish track sid: $trackSid, notify: $notify');
    final pub = trackPublications.remove(trackSid);
    if (pub == null) {
      logger.warning('Publication not found $trackSid');
      return;
    }

    final track = pub.track;
    if (track != null) {
      if (call.callOptions.stopLocalTrackOnUnpublish) {
        await track.stop();
      }

      final sender = track.transceiver?.sender;
      if (sender != null) {
        try {
          await call.publisher?.removeTrack(sender);
        } catch (_) {
          logger.warning('[$runtimeType] rtc.removeTrack() did throw $_');
        }
      }

      // did unpublish
      await track.onUnpublish();
    }

    if (notify) {
      [events, call.events].emit(
        LocalTrackUnpublishedEvent(
          participant: this,
          publication: pub,
        ),
      );
    }

    await pub.dispose();
  }

  @override
  List<LocalTrackPublication<LocalVideoTrack>> get videoTracks =>
      trackPublications.values
          .whereType<LocalTrackPublication<LocalVideoTrack>>()
          .toList();

  @override
  List<LocalTrackPublication<LocalAudioTrack>> get audioTracks =>
      trackPublications.values
          .whereType<LocalTrackPublication<LocalAudioTrack>>()
          .toList();

  @override
  LocalTrackPublication<LocalAudioTrack>? get audioTrack {
    return audioTracks.firstWhereOrNull(
      (it) => it.type == sfu_models.TrackType.TRACK_TYPE_AUDIO,
    );
  }

  @override
  LocalTrackPublication<LocalVideoTrack>? get videoTrack {
    return videoTracks.firstWhereOrNull(
      (it) => it.type == sfu_models.TrackType.TRACK_TYPE_VIDEO,
    );
  }

  @override
  LocalTrackPublication<LocalVideoTrack>? get screenShareTrack {
    return videoTracks.firstWhereOrNull(
      (it) => it.type == sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE,
    );
  }

  @override
  LocalTrackPublication<LocalAudioTrack>? get screenShareAudioTrack {
    return audioTracks.firstWhereOrNull(
      (it) => it.type == sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO,
    );
  }

  /// Shortcut for publishing a [TrackSource.camera].
  Future<LocalTrackPublication?> setCameraEnabled({bool enabled = true}) {
    return setTrackTypeEnabled(
      trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
      enabled: enabled,
    );
  }

  /// Shortcut for publishing a [TrackSource.microphone].
  Future<LocalTrackPublication?> setMicrophoneEnabled({bool enabled = true}) {
    return setTrackTypeEnabled(
      trackType: sfu_models.TrackType.TRACK_TYPE_AUDIO,
      enabled: enabled,
    );
  }

  /// Shortcut for muting/unmuting a [TrackSource.microphone].
  Future<LocalTrackPublication?> toggleMicrophone() {
    return setTrackTypeEnabled(
      trackType: sfu_models.TrackType.TRACK_TYPE_AUDIO,
      enabled: !isAudioEnabled,
    );
  }

  /// Shortcut for publishing a [TrackSource.screenShareVideo].
  Future<LocalTrackPublication?> setScreenShareEnabled({
    bool enabled = true,
    bool? captureScreenAudio,
  }) {
    return setTrackTypeEnabled(
      trackType: sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE,
      enabled: enabled,
      captureScreenAudio: captureScreenAudio,
    );
  }

  /// A convenience method to publish a track for a specific [TrackSource].
  /// This is the recommended method to publish tracks.
  Future<LocalTrackPublication?> setTrackTypeEnabled({
    required sfu_models.TrackType trackType,
    required bool enabled,
    bool? captureScreenAudio,
  }) async {
    logger.fine('setSourceEnabled(source: $trackType, enabled: $enabled)');
    final publication = getTrackPublicationByType(trackType);
    if (publication != null) {
      if (enabled) {
        await publication.unmute();
      } else {
        // ScreenShare cannot be muted, Un-publish instead
        if (trackType == sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE) {
          await unpublishTrack(publication.sid);

          // Also un-publish the audio track if it was published
          final screenShareAudioTrack = this.screenShareAudioTrack;
          if (screenShareAudioTrack != null) {
            await unpublishTrack(screenShareAudioTrack.sid);
          }
        } else {
          await publication.mute();
        }
      }
      return publication;
    } else if (enabled) {
      if (trackType == sfu_models.TrackType.TRACK_TYPE_VIDEO) {
        final track = await LocalVideoTrack.createCameraTrack(
          call.callOptions.defaultCameraCaptureOptions,
        );
        return publishVideoTrack(track);
      } else if (trackType == sfu_models.TrackType.TRACK_TYPE_AUDIO) {
        final track = await LocalAudioTrack.create(
          call.callOptions.defaultAudioCaptureOptions,
        );
        return publishAudioTrack(track);
      } else if (trackType == sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE) {
        final options = call.callOptions.defaultScreenShareCaptureOptions;

        /// When capturing chrome table audio, we can't capture audio/video
        /// track separately, it has to be returned once in getDisplayMedia,
        /// so we publish it twice here, but only return videoTrack to user.
        if (captureScreenAudio != null) {
          final tracks = await LocalVideoTrack.createScreenShareTracksWithAudio(
            options.copyWith(captureScreenAudio: captureScreenAudio),
          );
          LocalTrackPublication<LocalVideoTrack>? publication;
          for (final track in tracks) {
            if (track is LocalVideoTrack) {
              publication = await publishVideoTrack(track);
            } else if (track is LocalAudioTrack) {
              await publishAudioTrack(track);
            }
          }

          /// just return the video track publication
          return publication;
        }
        final track = await LocalVideoTrack.createScreenShareTrack(options);
        return publishVideoTrack(track);
      }
    }
    return null;
  }
}
