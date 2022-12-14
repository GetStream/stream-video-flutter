import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/protobuf/video/sfu/models/models.pbserver.dart'
    as sfu;
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/exceptions.dart';
import 'package:stream_video/src/extensions.dart';
import 'package:stream_video/src/participant/participant.dart';
import 'package:stream_video/src/participant/participant_info.dart';
import 'package:stream_video/src/publication/remote.dart';
import 'package:stream_video/src/publication/track_info.dart';
import 'package:stream_video/src/track/remote/audio.dart';
import 'package:stream_video/src/track/remote/remote.dart';
import 'package:stream_video/src/track/remote/video.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/types/video_dimensions.dart';

const _kTrackPublishTimeout = Duration(seconds: 10);

/// Represents other participant in the [Room].
class RemoteParticipant extends Participant<RemoteTrackPublication> {
  RemoteParticipant({
    required super.call,
    required super.info,
  }) {
    updateInfo(info);
  }

  /// A convenience property to get all video tracks.
  @override
  List<RemoteTrackPublication<RemoteVideoTrack>> get videoTracks =>
      trackPublications.values
          .whereType<RemoteTrackPublication<RemoteVideoTrack>>()
          .toList();

  /// A convenience property to get all audio tracks.
  @override
  List<RemoteTrackPublication<RemoteAudioTrack>> get audioTracks =>
      trackPublications.values
          .whereType<RemoteTrackPublication<RemoteAudioTrack>>()
          .toList();

  /// A convenience property to get all subscribed tracks.
  List<RemoteTrackPublication> get subscribedTracks => trackPublications.values
      .where((e) => e.subscribed)
      .cast<RemoteTrackPublication>()
      .toList();

  RemoteTrackPublication? getTrackPublication(String sid) {
    final pub = trackPublications[sid];
    if (pub is RemoteTrackPublication) return pub;
    return null;
  }

  /// for internal use
  /// {@nodoc}
  Future<void> addSubscribedMediaTrack({
    required rtc.MediaStreamTrack mediaTrack,
    required rtc.MediaStream stream,
    required String trackSid,
    rtc.RTCRtpReceiver? receiver,
  }) async {
    logger.fine('addSubscribedMediaTrack()');

    // If publication doesn't exist yet...
    var pub = getTrackPublication(trackSid);
    if (pub == null) {
      logger.fine('addSubscribedMediaTrack() pub is null, will wait...');
      logger.fine('addSubscribedMediaTrack() tracks: $trackPublications');

      // Wait for the metadata to arrive
      final event = await events.waitFor<TrackPublishedEvent>(
        duration: _kTrackPublishTimeout,
        filter: (event) {
          return event.participant == this && //
              event.publication.sid == trackSid;
        },
        onTimeout: () {
          throw TrackSubscriptionExceptionEvent(
            participant: this,
            sid: trackSid,
            reason: TrackSubscribeFailReason.notTrackMetadataFound,
          );
        },
      );
      pub = event.publication;
      logger.fine('addSubscribedMediaTrack() did receive pub');
    }

    // Check if track type is supported, throw if not.
    if (![
      sfu.TrackType.TRACK_TYPE_AUDIO,
      sfu.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO,
      sfu.TrackType.TRACK_TYPE_VIDEO,
      sfu.TrackType.TRACK_TYPE_SCREEN_SHARE,
    ].contains(pub.type)) {
      throw TrackSubscriptionExceptionEvent(
        participant: this,
        sid: trackSid,
        reason: TrackSubscribeFailReason.unsupportedTrackType,
      );
    }

    // create Track
    final RemoteTrack track;
    switch (pub.type) {
      // audio track
      case sfu.TrackType.TRACK_TYPE_AUDIO:
      case sfu.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO:
        track = RemoteAudioTrack(
          type: pub.type,
          mediaStream: stream,
          mediaStreamTrack: mediaTrack,
          receiver: receiver,
        );
        break;

      // video track
      case sfu.TrackType.TRACK_TYPE_VIDEO:
      case sfu.TrackType.TRACK_TYPE_SCREEN_SHARE:
        track = RemoteVideoTrack(
          type: pub.type,
          mediaStream: stream,
          mediaStreamTrack: mediaTrack,
          receiver: receiver,
        );
        break;
      case sfu.TrackType.TRACK_TYPE_UNSPECIFIED:
      default:
        throw UnexpectedStateException('Unknown track type');
    }

    await track.start();
    await pub.updateTrack(track);
    addTrackPublication(pub);

    [events, call.events].emit(TrackSubscribedEvent(
      participant: this,
      track: track,
      publication: pub,
    ));
  }

  @override
  Future<void> updateInfo(ParticipantInfo info) async {
    logger.fine('RemoteParticipant.updateFromInfo(info: $info)');
    super.updateInfo(info);

    // figuring out deltas between tracks
    final newPubs = <RemoteTrackPublication>{};

    final tracks = info.publishedTracks.map((type) {
      return TrackInfo(id: info.trackLookupPrefix, type: type);
    });

    print('Received tracks: ${tracks.length}');

    for (final trackInfo in tracks) {
      final pub = getTrackPublication(trackInfo.sid);
      if (pub != null) {
        pub.info = pub.info.merge(trackInfo);
        continue;
      }

      RemoteTrackPublication? newPub;
      if (trackInfo.type == sfu.TrackType.TRACK_TYPE_VIDEO ||
          trackInfo.type == sfu.TrackType.TRACK_TYPE_SCREEN_SHARE) {
        newPub = RemoteTrackPublication<RemoteVideoTrack>(
          participant: this,
          info: trackInfo.copyWith(
            // Set initial dimensions in case the type is video.
            // It will be updated later automatically once the track is received
            // and rendered on the screen.
            videoDimension: VideoDimensionPresets.h540_169,
          ),
        );
      } else if (trackInfo.type == sfu.TrackType.TRACK_TYPE_AUDIO ||
          trackInfo.type == sfu.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO) {
        newPub = RemoteTrackPublication<RemoteAudioTrack>(
          participant: this,
          info: trackInfo,
        );
      }

      if (newPub != null) {
        newPubs.add(newPub);
        addTrackPublication(newPub);
      }
    }

    // Always emit events for new publications, Call will not forward them
    // unless it's ready
    for (final pub in newPubs) {
      final event = TrackPublishedEvent(
        participant: this,
        publication: pub,
      );

      if (call.connectionState == ConnectionState.connected) {
        [events, call.events].emit(event);
      }
    }

    // remove any published track that is not in the info
    final validSids = tracks.map((it) => it.sid);
    final removeSids = {
      ...trackPublications.keys.where((e) => !validSids.contains(e)),
    };

    await Future.wait([
      for (final sid in removeSids) //
        unpublishTrack(sid),
    ]);
  }

  @override
  Future<void> unpublishTrack(
    String trackSid, {
    bool notify = true,
  }) async {
    logger.finer('removePublishedTrack track sid: $trackSid, notify: $notify');
    final pub = trackPublications[trackSid];
    if (pub == null) {
      logger.warning('Publication not found $trackSid');
      return;
    }

    final track = pub.track;
    // if has track
    if (track != null) {
      await track.stop();
      [events, call.events].emit(TrackUnsubscribedEvent(
        participant: this,
        track: track,
        publication: pub,
      ));
    }

    if (notify) {
      [events, call.events].emit(TrackUnpublishedEvent(
        participant: this,
        publication: pub,
      ));
    }

    await pub.dispose();
  }
}
