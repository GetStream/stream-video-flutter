import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pbserver.dart'
    as sfu;
import 'package:stream_video/src/call/call.dart';
import 'package:stream_video/src/disposable.dart';
import 'package:stream_video/src/event_emitter.dart';
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/extensions.dart';
import 'package:stream_video/src/participant/participant_info.dart';
import 'package:stream_video/src/publication/track_publication.dart';
import 'package:stream_video/src/types/other.dart';

const _kDefaultSpeakingThreshold = 0.3;

/// Represents a Participant in the call, notifies changes via delegates as
/// well as ChangeNotifier/providers.
/// A change notification is triggered when
/// - speaking status changed
/// - mute status changed
/// - added/removed subscribed tracks
/// - metadata changed
/// Base for [RemoteParticipant] and [LocalParticipant],
/// can not be instantiated directly.
abstract class Participant<T extends TrackPublication>
    with EventEmittable<ParticipantEvent>, Disposable, EquatableMixin {
  Participant({
    required this.call,
    required ParticipantInfo info,
  }) {
    updateInfo(info);
  }

  /// Reference to [Call]
  final Call call;

  /// User-assigned identity.
  String get userId => info.userId;

  /// Server assigned unique id.
  String get sessionId => info.sessionId;

  // /// Name of the participant (readonly).
  // String get name => participantInfo.name;

  /// Server assigned track lookup prefix.
  String get trackLookupPrefix => info.trackLookupPrefix;

  /// When the participant joined the room
  DateTime get joinedAt => info.joinedAt ?? DateTime.now();

  /// When the participant had last spoken.
  DateTime? lastSpokeAt;

  /// true if this [Participant] has a [sfu.TrackType.TRACK_TYPE_AUDIO] track.
  bool get hasAudio => audioTrack != null;

  /// true if this [Participant] has a [sfu.TrackType.TRACK_TYPE_VIDEO] track.
  bool get hasVideo => videoTrack != null;

  /// true if this [Participant] has a [sfu.TrackType.TRACK_TYPE_SCREEN_SHARE]
  /// track.
  bool get hasScreenShare => screenShareTrack != null;

  /// true if this [Participant] has a [sfu.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO]
  /// track.
  bool get hasScreenShareAudio => screenShareAudioTrack != null;

  /// A convenience property to get all video tracks. This includes both video
  /// and screen share tracks.
  List<T> get videoTracks;

  /// A convenience property to get all audio tracks. This includes both audio
  /// and screen share audio tracks.
  List<T> get audioTracks;

  /// Convenience method to get the audio track publication of this participant.
  T? get audioTrack;

  /// Convenience method to get the video track publication of this participant.
  T? get videoTrack;

  /// Convenience method to get the screen share track publication of this
  /// participant.
  T? get screenShareTrack;

  /// Convenience method to get the screen share audio track publication of this
  /// participant.
  T? get screenShareAudioTrack;

  /// Map of track sessionId => published track
  final trackPublications = <String, T>{};

  /// Info related to this participant.
  ParticipantInfo get info => _info;
  late ParticipantInfo _info;

  void updateInfo(ParticipantInfo info) {
    _info = info;
    [events, call.events].emit(ParticipantInfoUpdatedEvent(
      participant: this,
    ));
  }

  /// Audio level between 0-1, 1 being the loudest.
  double get audioLevel => _audioLevel;
  double _audioLevel = 0;

  set audioLevel(double level) {
    if (_audioLevel != level) {
      _audioLevel = level;

      events.emit(AudioLevelChangedEvent(
        participant: this,
        audioLevel: level,
      ));

      // This is a heuristic that is not 100% accurate.
      // We use a threshold of 0.3 to determine if the participant is speaking.
      // This is because the audio level is not always 0 when the participant
      // is not speaking.
      isSpeaking = level > _kDefaultSpeakingThreshold;
    }
  }

  /// if [Participant] is currently speaking.
  bool get isSpeaking => _isSpeaking;
  bool _isSpeaking = false;

  set isSpeaking(bool speaking) {
    if (_isSpeaking == speaking) return;
    _isSpeaking = speaking;
    if (speaking) {
      lastSpokeAt = DateTime.now();
    }

    events.emit(SpeakingChangedEvent(
      participant: this,
      speaking: speaking,
    ));
  }

  /// Connection quality between the [Participant] and the Server.
  ConnectionQuality get connectionQuality => _connectionQuality;
  ConnectionQuality _connectionQuality = ConnectionQuality.unknown;

  set connectionQuality(ConnectionQuality quality) {
    if (_connectionQuality == quality) return;
    _connectionQuality = quality;

    [events, call.events].emit(ParticipantConnectionQualityUpdatedEvent(
      participant: this,
      connectionQuality: _connectionQuality,
    ));
  }

  /// for internal use
  /// {@nodoc}
  void addTrackPublication(T pub) {
    pub.track?.sid = pub.sid;
    trackPublications[pub.sid] = pub;
  }

  /// Un-publish a [TrackPublication] that's already published by this
  /// [Participant].
  Future<void> unpublishTrack(String trackSid, {bool notify = true});

  /// Convenience method to unpublish all tracks.
  Future<void> unpublishAllTracks({
    bool notify = true,
    bool? stopOnUnpublish,
  }) async {
    final trackSids = trackPublications.keys.toSet();
    await Future.wait([
      for (final sid in trackSids) //
        unpublishTrack(sid, notify: notify),
    ]);
  }

  /// Convenience property to check whether [sfu.TrackType.TRACK_TYPE_VIDEO] is
  /// enabled or not.
  bool get isVideoEnabled => !(videoTrack?.muted ?? true);

  /// Convenience property to check whether [sfu.TrackType.TRACK_TYPE_AUDIO] is
  /// enabled or not.
  bool get isAudioEnabled => !(audioTrack?.muted ?? true);

  /// Convenience property to check whether [sfu.TrackType.TRACK_TYPE_SCREEN_SHARE]
  /// is enabled or not.
  bool get isScreenShareEnabled => !(screenShareTrack?.muted ?? true);

  /// Convenience property to check whether [sfu.TrackType.TRACK_TYPE_SCREEN_SHARE_AUDIO]
  /// is enabled or not.
  bool get isScreenShareAudioEnabled => !(screenShareAudioTrack?.muted ?? true);

  /// Tries to find a [TrackPublication] by its [TrackSource]. Otherwise, will
  /// return a compatible type of [TrackPublication] for the [TrackSource] specified.
  /// returns null when not found.
  T? getTrackPublicationByType(sfu.TrackType type) {
    if (type == sfu.TrackType.TRACK_TYPE_UNSPECIFIED) return null;
    return trackPublications.values.firstWhereOrNull((it) {
      return it.type == type;
    });
  }

  @override
  Future<void> dispose() async {
    if (events.mounted) {
      events.dispose();
    }
    await unpublishAllTracks(notify: false);
    return super.dispose();
  }

  @override
  List<Object?> get props => [sessionId];
}
