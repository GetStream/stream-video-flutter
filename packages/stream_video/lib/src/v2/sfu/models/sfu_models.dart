class SfuConnectionQualityInfo {
  SfuConnectionQualityInfo({
    required this.userId,
    required this.sessionId,
    required this.connectionQuality,
  });

  final String userId;
  final String sessionId;
  final SfuConnectionQuality connectionQuality;

  @override
  String toString() {
    return 'SfuConnectionQualityInfo{userId: $userId, sessionId: $sessionId, '
        'connectionQuality: $connectionQuality}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuConnectionQualityInfo &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          sessionId == other.sessionId &&
          connectionQuality == other.connectionQuality;

  @override
  int get hashCode =>
      userId.hashCode ^ sessionId.hashCode ^ connectionQuality.hashCode;
}

enum SfuConnectionQuality { unspecified, poor, good, excellent }

class SfuAudioLevel {
  SfuAudioLevel({
    required this.userId,
    required this.sessionId,
    required this.level,
    required this.isSpeaking,
  });

  final String userId;
  final String sessionId;
  final double level;
  final bool isSpeaking;

  @override
  String toString() {
    return 'SfuAudioLevel{userId: $userId, sessionId: $sessionId, '
        'level: $level, isSpeaking: $isSpeaking}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuAudioLevel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          sessionId == other.sessionId &&
          level == other.level &&
          isSpeaking == other.isSpeaking;

  @override
  int get hashCode =>
      userId.hashCode ^
      sessionId.hashCode ^
      level.hashCode ^
      isSpeaking.hashCode;
}
