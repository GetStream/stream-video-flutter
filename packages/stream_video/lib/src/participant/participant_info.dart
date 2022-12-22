import 'package:stream_video/protobuf/video/sfu/models/models.pbserver.dart'
    as sfu;

class ParticipantInfo {
  const ParticipantInfo({
    required this.userId,
    required this.sessionId,
    required this.publishedTracks,
    required this.joinedAt,
    required this.trackLookupPrefix,
  });

  factory ParticipantInfo.fromSfu(sfu.Participant participant) {
    return ParticipantInfo(
      userId: participant.userId,
      sessionId: participant.sessionId,
      publishedTracks: participant.publishedTracks,
      joinedAt: participant.joinedAt.toDateTime(),
      trackLookupPrefix: participant.trackLookupPrefix,
    );
  }

  final String userId;
  final String sessionId;
  final Iterable<sfu.TrackType> publishedTracks;
  final DateTime? joinedAt;
  final String trackLookupPrefix;

  bool hasPublishedAudioTrack() {
    return publishedTracks.contains(sfu.TrackType.TRACK_TYPE_AUDIO);
  }

  bool hasPublishedVideoTrack() {
    return publishedTracks.contains(sfu.TrackType.TRACK_TYPE_VIDEO);
  }

  bool hasPublishedScreenShareTrack() {
    return publishedTracks.contains(sfu.TrackType.TRACK_TYPE_SCREEN_SHARE);
  }

  /// Returns a copy of this object with the given fields replaced with the new
  /// values.
  ParticipantInfo copyWith({
    String? userId,
    String? sessionId,
    Iterable<sfu.TrackType>? publishedTracks,
    DateTime? joinedAt,
    String? trackLookupPrefix,
  }) {
    return ParticipantInfo(
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      publishedTracks: publishedTracks ?? this.publishedTracks,
      joinedAt: joinedAt ?? this.joinedAt,
      trackLookupPrefix: trackLookupPrefix ?? this.trackLookupPrefix,
    );
  }
}
