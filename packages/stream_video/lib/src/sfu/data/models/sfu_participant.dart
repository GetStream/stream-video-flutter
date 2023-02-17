import 'package:stream_video/src/sfu/data/models/sfu_connection_quality.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';

class SfuParticipant {
  SfuParticipant({
    required this.userId,
    required this.sessionId,
    required this.publishedTracks,
    required this.joinedAt,
    required this.trackLookupPrefix,
    required this.connectionQuality,
    required this.isSpeaking,
    required this.isDominantSpeaker,
    required this.audioLevel,
  });

  final String userId;
  final String sessionId;
  final List<SfuTrackType> publishedTracks;
  final DateTime joinedAt;
  final String trackLookupPrefix;
  final SfuConnectionQuality connectionQuality;
  final bool isSpeaking;
  final bool isDominantSpeaker;
  final double audioLevel;

  @override
  String toString() {
    return 'SfuParticipant{userId: $userId, sessionId: $sessionId, '
        'publishedTracks: $publishedTracks, joinedAt: $joinedAt, '
        'trackLookupPrefix: $trackLookupPrefix, '
        'connectionQuality: $connectionQuality, isSpeaking: $isSpeaking, '
        'isDominantSpeaker: $isDominantSpeaker, audioLevel: $audioLevel}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuParticipant &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          sessionId == other.sessionId &&
          publishedTracks == other.publishedTracks &&
          joinedAt == other.joinedAt &&
          trackLookupPrefix == other.trackLookupPrefix &&
          connectionQuality == other.connectionQuality &&
          isSpeaking == other.isSpeaking &&
          isDominantSpeaker == other.isDominantSpeaker &&
          audioLevel == other.audioLevel;

  @override
  int get hashCode =>
      userId.hashCode ^
      sessionId.hashCode ^
      publishedTracks.hashCode ^
      joinedAt.hashCode ^
      trackLookupPrefix.hashCode ^
      connectionQuality.hashCode ^
      isSpeaking.hashCode ^
      isDominantSpeaker.hashCode ^
      audioLevel.hashCode;
}
