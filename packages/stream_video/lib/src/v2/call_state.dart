import 'package:meta/meta.dart';
import 'call_participant_state.dart';

import 'model/call_status.dart';

/// TODO - Class that holds any information about the call, including participants
@immutable
class CallStateV2 {
  factory CallStateV2({
    required String callCid,
    String sessionId = '',
    CallStatus status = CallStatus.idle,
    Map<String, CallParticipantState> callParticipants = const {},
  }) {
    return CallStateV2._(
      callCid: callCid,
      sessionId: sessionId,
      status: status,
      callParticipants: Map.unmodifiable(callParticipants),
    );
  }

  /// TODO
  const CallStateV2._({
    required this.callCid,
    required this.sessionId,
    required this.status,
    required this.callParticipants,
  });

  final String callCid;
  final String sessionId;
  final CallStatus status;
  final Map<String, CallParticipantState> callParticipants;

  /// Returns a copy of this [CallStateV2] with the given fields replaced
  /// with the new values.
  CallStateV2 copyWith({
    String? callCid,
    String? sessionId,
    CallStatus? status,
    Map<String, CallParticipantState>? callParticipants,
  }) {
    return CallStateV2(
      callCid: callCid ?? this.callCid,
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      callParticipants: callParticipants ?? this.callParticipants,
    );
  }

  @override
  String toString() {
    return 'CallStateV2{callCid: $callCid, sessionId: $sessionId, '
        'status: $status, callParticipants: $callParticipants}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStateV2 &&
          runtimeType == other.runtimeType &&
          callCid == other.callCid &&
          sessionId == other.sessionId &&
          status == other.status &&
          callParticipants == other.callParticipants;

  @override
  int get hashCode =>
      callCid.hashCode ^
      sessionId.hashCode ^
      status.hashCode ^
      callParticipants.hashCode;
}

void main() {
  final map1 = Map<String, int>.unmodifiable(const {
    '1': 1,
    '2': 2,
    '3': 3,
  });
  final map2 = {
    ...map1,
    '4': 4,
  }..remove('1');

  print(map2);
}
