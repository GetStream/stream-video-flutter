import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

import 'sfu/data/models/sfu_connection_quality.dart';
import 'sfu/data/models/sfu_track_type.dart';
import 'utils/pair.dart';

@immutable
class CallParticipantStateV2 {
  factory CallParticipantStateV2({
    required String userId,
    required String role,
    required String name,
    String? profileImageURL,
    required String sessionId,
    required String trackId,
    Set<SfuTrackType> publishedTrackTypes = const {},
    bool isLocal = false,
    SfuConnectionQuality connectionQuality = SfuConnectionQuality.unspecified,
    bool isOnline = false,
    double audioLevel = 0,
    bool isSpeaking = false,
  }) {
    return CallParticipantStateV2._(
      userId: userId,
      role: role,
      name: name,
      profileImageURL: profileImageURL,
      sessionId: sessionId,
      trackId: trackId,
      publishedTrackTypes: Set.unmodifiable(publishedTrackTypes),
      isLocal: isLocal,
      connectionQuality: connectionQuality,
      isOnline: isOnline,
      audioLevel: audioLevel,
      isSpeaking: isSpeaking,
    );
  }

  /// TODO: Documentation
  const CallParticipantStateV2._({
    required this.userId,
    required this.role,
    required this.name,
    this.profileImageURL,
    required this.sessionId,
    required this.trackId,
    required this.publishedTrackTypes,
    this.isLocal = false,
    this.connectionQuality = SfuConnectionQuality.unspecified,
    this.isOnline = false,
    this.audioLevel = 0,
    this.isSpeaking = false,
  });

  final String userId;
  final String role;
  final String name;
  final String? profileImageURL;
  final String sessionId;
  final String trackId;
  final Set<SfuTrackType> publishedTrackTypes;
  final bool isLocal;
  final SfuConnectionQuality connectionQuality;
  final bool isOnline;
  final double audioLevel;
  final bool isSpeaking;

  /// Returns a copy of this [CallParticipantStateV2] with the given fields
  /// replaced with the new values.
  CallParticipantStateV2 copyWith({
    String? userId,
    String? role,
    String? name,
    String? profileImageURL,
    String? sessionId,
    String? trackIdPrefix,
    Set<SfuTrackType>? publishedTrackTypes,
    bool? isLocal,
    SfuConnectionQuality? connectionQuality,
    bool? isOnline,
    double? audioLevel,
    bool? isSpeaking,
  }) {
    return CallParticipantStateV2(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      name: name ?? this.name,
      profileImageURL: profileImageURL ?? this.profileImageURL,
      sessionId: sessionId ?? this.sessionId,
      trackId: trackIdPrefix ?? this.trackId,
      publishedTrackTypes: publishedTrackTypes ?? this.publishedTrackTypes,
      isLocal: isLocal ?? this.isLocal,
      connectionQuality: connectionQuality ?? this.connectionQuality,
      isOnline: isOnline ?? this.isOnline,
      audioLevel: audioLevel ?? this.audioLevel,
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }

  @override
  String toString() {
    return 'CallParticipantState{userId: $userId, role: $role, name: $name, '
        'profileImageURL: $profileImageURL, sessionId: $sessionId, '
        'trackId: $trackId, '
        'publishedTrackTypes: $publishedTrackTypes, '
        'isLocal: $isLocal, '
        'connectionQuality: $connectionQuality, isOnline: $isOnline, '
        'audioLevel: $audioLevel, isSpeaking: $isSpeaking}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallParticipantStateV2 &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          role == other.role &&
          name == other.name &&
          profileImageURL == other.profileImageURL &&
          sessionId == other.sessionId &&
          trackId == other.trackId &&
          publishedTrackTypes == other.publishedTrackTypes &&
          isLocal == other.isLocal &&
          connectionQuality == other.connectionQuality &&
          isOnline == other.isOnline &&
          audioLevel == other.audioLevel &&
          isSpeaking == other.isSpeaking;

  @override
  int get hashCode =>
      userId.hashCode ^
      role.hashCode ^
      name.hashCode ^
      profileImageURL.hashCode ^
      sessionId.hashCode ^
      trackId.hashCode ^
      publishedTrackTypes.hashCode ^
      isLocal.hashCode ^
      connectionQuality.hashCode ^
      isOnline.hashCode ^
      audioLevel.hashCode ^
      isSpeaking.hashCode;
}
