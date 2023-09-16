import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

typedef Role = String;
typedef UserSessionId = String;

@immutable
class CallSessionData with EquatableMixin {
  const CallSessionData({
    this.id = '',
    this.participants = const {},
    this.participantsCountByRole = const {},
    this.rejectedBy = const {},
    this.acceptedBy = const {},
    this.startedAt,
    this.liveStartedAt,
    this.endedAt,
    this.liveEndedAt,
  });

  final String id;
  final Map<UserSessionId, CallParticipant> participants;
  final Map<Role, int> participantsCountByRole;
  final Map<String, DateTime> rejectedBy;
  final Map<String, DateTime> acceptedBy;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime? liveStartedAt;
  final DateTime? liveEndedAt;

  @override
  List<Object?> get props => [
        id,
        startedAt,
        liveStartedAt,
        liveStartedAt,
        liveEndedAt,
      ];
}

@immutable
class CallParticipant with EquatableMixin {
  const CallParticipant({
    required this.userSessionId,
    required this.userId,
    required this.role,
    this.joinedAt,
  });

  final String userSessionId;
  final String userId;
  final String role;
  final DateTime? joinedAt;

  @override
  List<Object?> get props => [
        userSessionId,
        userId,
        role,
        joinedAt,
      ];

  @override
  String toString() {
    return 'CallParticipant{userSessionId: $userSessionId, role: $role'
        ', userId: $userId, joinedAt: $joinedAt}';
  }
}
