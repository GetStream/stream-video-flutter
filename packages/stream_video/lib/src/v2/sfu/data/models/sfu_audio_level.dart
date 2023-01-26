import 'package:meta/meta.dart';

@immutable
class SfuAudioLevel {
  const SfuAudioLevel({
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
