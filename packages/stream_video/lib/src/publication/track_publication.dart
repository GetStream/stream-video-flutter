import '../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as signal;
import '../disposable.dart';
import '../events.dart';
import '../extensions.dart';
import '../internal/events.dart';
import '../logger/logger.dart';
import '../options.dart';
import '../participant/participant.dart';
import '../track/track.dart';
import '../types/video_dimensions.dart';
import 'track_info.dart';

/// Represents a track that's published to the server. This class contains
/// metadata associated with tracks.
///
/// Base for [RemoteTrackPublication] and [LocalTrackPublication],
/// can not be instantiated directly.
abstract class TrackPublication<T extends Track> with Disposable {
  TrackPublication({
    required this.info,
  });

  String get id => info.id;
  sfu_models.TrackType get type => info.type;
  String get sid => info.sid;

  /// The [Participant] this publication belongs to.
  abstract final Participant participant;

  /// The current [Track] for this publication (readonly).
  T? get track => _track;
  T? _track;

  /// The options used to publish this track (readonly).
  PublishOptions? get publishOptions => _publishOptions;
  PublishOptions? _publishOptions;

  /// Returns true if the track is muted.
  bool get muted => track?.muted ?? true;

  /// If the [Track] is published with simulcast, only for video. (readonly)
  bool get simulcasted => _simulcasted == true;
  bool? _simulcasted;

  /// The video dimensions of the [Track], reported by publisher.
  /// Only available for [VideoTrack]s. (readonly)
  VideoDimension? get videoDimension => info.videoDimension;

  /// Returns true if the track is subscribed.
  bool get subscribed => track != null;

  /// Info related to the track.
  TrackInfo info;

  /// True when the track is published with name [Track.screenShareName].
  bool get isScreenShare {
    return type == sfu_models.TrackType.TRACK_TYPE_SCREEN_SHARE;
  }

  // Equality operators
  // Object is considered equal when sid is equal
  @override
  int get hashCode => sid.hashCode;

  @override
  bool operator ==(Object other) =>
      other is TrackPublication && sid == other.sid;

  // Update track to new value, dispose previous if exists.
  // Returns true if value has changed.
  // Intended for internal use only.
  Future<bool> updateTrack(
    T? newTrack, {
    PublishOptions? publishOptions,
  }) async {
    if (_track == newTrack) return false;
    // dispose previous track (if exists)
    await _track?.dispose();

    _track = newTrack;
    _publishOptions = publishOptions;

    if (newTrack != null) {
      // listen for Track's muted events
      newTrack.events.on<InternalTrackMuteUpdatedEvent>(
        _onTrackMuteUpdatedEvent,
      );
    }

    return true;
  }

  void _onTrackMuteUpdatedEvent(InternalTrackMuteUpdatedEvent event) {
    // send signal to server (if mute initiated by local user)
    if (event.notifyServer) {
      logger.fine(
        '${this} Sending mute signal... sid:$sid, muted:${event.muted}',
      );
      participant.call.sfuClient.updateMuteStates(
        muteStates: [
          signal.TrackMuteState(
            trackType: event.track.type,
            muted: event.muted,
          ),
        ],
      );
    }

    // emit events
    final newEvent = event.muted
        ? TrackMutedEvent(participant: participant, publication: this)
        : TrackUnmutedEvent(participant: participant, publication: this);
    [participant.events, participant.call.events].emit(newEvent);
  }

  @override
  String toString() => '$runtimeType(sid: $sid, source: $type)';

  @override
  Future<void> dispose() async {
    await _track?.dispose();
    _track = null;
    return super.dispose();
  }
}
