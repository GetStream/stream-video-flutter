import 'package:equatable/equatable.dart';

import 'sfu_connection_quality.dart';
import 'sfu_track_type.dart';

class SfuParticipant with EquatableMixin {
  SfuParticipant({
    required this.userId,
    required this.userName,
    required this.userImage,
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
  final String userName;
  final String userImage;
  final String sessionId;
  final List<SfuTrackType> publishedTracks;
  final DateTime joinedAt;
  final String trackLookupPrefix;
  final SfuConnectionQuality connectionQuality;
  final bool isSpeaking;
  final bool isDominantSpeaker;
  final double audioLevel;

  SfuParticipant copyWith({
    String? userId,
    String? userName,
    String? userImage,
    String? sessionId,
    List<SfuTrackType>? publishedTracks,
    DateTime? joinedAt,
    String? trackLookupPrefix,
    SfuConnectionQuality? connectionQuality,
    bool? isSpeaking,
    bool? isDominantSpeaker,
    double? audioLevel,
  }) =>
      SfuParticipant(
        userId: userId ?? this.userId,
        userName: userId ?? this.userName,
        userImage: userId ?? this.userImage,
        sessionId: sessionId ?? this.sessionId,
        publishedTracks: publishedTracks ?? this.publishedTracks,
        joinedAt: joinedAt ?? this.joinedAt,
        trackLookupPrefix: trackLookupPrefix ?? this.trackLookupPrefix,
        connectionQuality: connectionQuality ?? this.connectionQuality,
        isSpeaking: isSpeaking ?? this.isSpeaking,
        isDominantSpeaker: isDominantSpeaker ?? this.isDominantSpeaker,
        audioLevel: audioLevel ?? this.audioLevel,
      );

  @override
  String toString() {
    return 'SfuParticipant{userId: $userId, sessionId: $sessionId, '
        'trackLookupPrefix: $trackLookupPrefix, '
        'userName: $userName, userImage: $userImage, '
        'publishedTracks: $publishedTracks, joinedAt: $joinedAt, '
        'connectionQuality: $connectionQuality, isSpeaking: $isSpeaking, '
        'isDominantSpeaker: $isDominantSpeaker, audioLevel: $audioLevel}';
  }

  @override
  List<Object?> get props => [
        userId,
        userName,
        userImage,
        sessionId,
        publishedTracks,
        joinedAt,
        trackLookupPrefix,
        connectionQuality,
        isSpeaking,
        isDominantSpeaker,
        audioLevel.hashCode,
      ];
}
