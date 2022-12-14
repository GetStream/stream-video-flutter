import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pbserver.dart'
    as sfu;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pbserver.dart'
    as signal;
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/extensions.dart';
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/options.dart';
import 'package:stream_video/src/participant/remote.dart';
import 'package:stream_video/src/publication/track_publication.dart';
import 'package:stream_video/src/track/remote/remote.dart';
import 'package:stream_video/src/track/remote/video.dart';
import 'package:stream_video/src/track/track.dart';
import 'package:stream_video/src/types/video_dimensions.dart';

/// Represents a track publication from a RemoteParticipant. Provides methods to
/// control if we should subscribe to the track, and its quality (for video).
class RemoteTrackPublication<T extends RemoteTrack>
    extends TrackPublication<T> {
  /// Creates a new [RemoteTrackPublication].
  RemoteTrackPublication({
    required this.participant,
    required super.info,
    T? track,
  }) {
    logger.fine('RemoteTrackPublication.init track: $track, info: $info');
    updateTrack(track);

    // Start subscription in order to receive the track.
    subscribe();
  }

  /// The [RemoteParticipant] this [RemoteTrackPublication] belongs to.
  @override
  final RemoteParticipant participant;

  /// Current video quality of the published track.
  sfu.VideoQuality get videoQuality => info.videoQuality;

  late final _setVideoDimensionDebounced = debounce(
    setVideoDimension,
    const Duration(milliseconds: 1500),
  );

  void _computeVideoViewDimension({
    required covariant VideoTrack track,
    bool quick = false,
  }) {
    Size maxOfSizes(Size s1, Size s2) => Size(
          math.max(s1.width, s2.width),
          math.max(s1.height, s2.height),
        );

    // filter visible build contexts
    final viewSizes = track.viewKey
        .map((e) => e.currentContext)
        .whereType<BuildContext>() // filter nulls
        .map((e) => e.findRenderObject() as RenderBox?)
        .whereType<RenderBox>() // filter nulls
        .map((e) => e.size);

    logger.finer(
      '[Visibility] ${track.sid} watching ${viewSizes.length} views...',
    );

    VideoDimension? newVideoDimension;
    if (viewSizes.isNotEmpty) {
      // compute largest size
      final largestSize = viewSizes.reduce(maxOfSizes);

      newVideoDimension = VideoDimension(
        largestSize.width.ceil(),
        largestSize.height.ceil(),
      );
    }

    print('newVideoDimension: $newVideoDimension');
    print('previousVideoDimension: ${videoDimension}');

    // Only update track subscription if the dimensions changed.
    if (videoDimension != newVideoDimension) {
      // logger.fine('[Visibility] Change detected, quick: $quick');
      if (quick) {
        setVideoDimension(newVideoDimension);
      } else {
        // debounce sending to server
        _setVideoDimensionDebounced([newVideoDimension]);
      }
    }
  }

  @override
  Future<bool> updateTrack(
    covariant T? newTrack, {
    PublishOptions? publishOptions, // ignored
  }) async {
    logger.fine('RemoteTrackPublication.updateTrack track: $newTrack');
    final didUpdate = await super.updateTrack(newTrack);

    print('RemoteTrackPublication.updateTrack didUpdate: $didUpdate');
    if (didUpdate) {
      _setVideoDimensionDebounced.cancel();

      final callOptions = participant.call.callOptions;
      if (callOptions.adaptiveStream && newTrack is RemoteVideoTrack) {
        // Start monitoring size
        newTrack.onVideoViewSizeChange = (_) {
          _computeVideoViewDimension(track: newTrack);
        };
      }
    }

    return didUpdate;
  }

  /// Updates the video dimensions of the published track.
  Future<void> setVideoDimension(VideoDimension? dimension) async {
    info = info.copyWith(videoDimension: dimension);
    print(
      'RemoteTrackPublication.setVideoDimension dimension: ${info.videoDimension}',
    );
    _updateSubscription(subscribe: true);
  }

  /// Updates the video quality of the published track.
  Future<void> setVideoQuality(sfu.VideoQuality quality) async {
    // we don't support updating quality yet, so mimic by updating the
    // video dimension based on the passed quality.
    final dimension = quality.toVideoDimension();
    return setVideoDimension(dimension);
  }

  /// Subscribes to the track.
  Future<void> subscribe() async {
    if (super.subscribed) {
      return logger.fine('ignoring subscribe() request...');
    }
    _updateSubscription(subscribe: true);
  }

  /// Unsubscribes from the track.
  Future<void> unsubscribe() async {
    if (!super.subscribed) {
      return logger.fine('ignoring unsubscribe() request...');
    }
    _updateSubscription(subscribe: false);
    if (track != null) {
      // Ideally, we should wait for WebRTC's onRemoveTrack event
      // but it does not work reliably across platforms.
      // So for now we will assume remove track succeeded.
      [participant.events, participant.call.events].emit(TrackUnsubscribedEvent(
        participant: participant,
        track: track!,
        publication: this,
      ));
      // Simply set to null for now
      await updateTrack(null);
    }
  }

  Future<signal.UpdateSubscriptionsResponse> _updateSubscription({
    required bool subscribe,
  }) {
    final details = signal.TrackSubscriptionDetails(
      userId: participant.userId,
      sessionId: participant.sessionId,
      trackType: info.type,
    );

    // Add dimension only for video tracks
    if (info.type == sfu.TrackType.TRACK_TYPE_VIDEO ||
        info.type == sfu.TrackType.TRACK_TYPE_SCREEN_SHARE) {
      details.dimension = sfu.VideoDimension(
        width: info.videoDimension?.width,
        height: info.videoDimension?.height,
      );
    }

    return participant.call.updateTrackSubscription(
      track: details,
      subscribe: subscribe,
    );
  }

  @override
  Future<void> dispose() {
    final track = this.track;
    if (track is RemoteVideoTrack) {
      track
        ..onVideoViewBuild = null
        ..onVideoViewSizeChange = null;
    }

    _setVideoDimensionDebounced.cancel();
    return super.dispose();
  }
}
