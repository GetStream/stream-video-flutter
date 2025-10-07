import 'package:equatable/equatable.dart';

import 'sfu_track_type.dart';

class SfuInboundVideoState with EquatableMixin {
  const SfuInboundVideoState({
    required this.userId,
    required this.sessionId,
    required this.trackType,
    required this.paused,
  });

  final String userId;
  final String sessionId;
  final SfuTrackType trackType;
  final bool paused;

  @override
  List<Object?> get props => [userId, sessionId, trackType, paused];

  @override
  String toString() {
    return 'SfuInboundVideoState{userId: $userId, sessionId: $sessionId, trackType: $trackType, paused: $paused}';
  }
}
