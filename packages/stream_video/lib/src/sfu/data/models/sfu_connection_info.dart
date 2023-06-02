import 'package:meta/meta.dart';

import 'sfu_connection_quality.dart';

@immutable
class SfuConnectionQualityInfo {
  const SfuConnectionQualityInfo({
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


