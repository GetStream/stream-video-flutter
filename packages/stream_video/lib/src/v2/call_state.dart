import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call_participant_state.dart';
import 'coordinator/models/coordinator_models.dart';
import 'model/call_cid.dart';
import 'model/call_status.dart';

/// TODO - Class that holds any information about the call, including participants
@immutable
class CallStateV2 extends Equatable {
  factory CallStateV2({
    required String currentUserId,
    required StreamCallCid callCid,
  }) {
    return CallStateV2._(
      currentUserId: currentUserId,
      callCid: callCid,
      createdByUserId: '',
      sessionId: '',
      status: CallStatus.idle(),
      callParticipants: List.unmodifiable(const []),
    );
  }

  factory CallStateV2.fromMetadata({
    required String currentUserId,
    required StreamCallCid callCid,
    required bool ringing,
    required CallMetadata metadata,
  }) {
    return CallStateV2._(
      currentUserId: currentUserId,
      callCid: callCid,
      createdByUserId: metadata.info.createdByUserId,
      sessionId: '',
      status: metadata.toCallStatus(currentUserId, ringing),
      callParticipants: List.unmodifiable(
        metadata.toCallParticipants(
          currentUserId,
        ),
      ),
    );
  }

  /// TODO
  const CallStateV2._({
    required this.currentUserId,
    required this.callCid,
    required this.createdByUserId,
    required this.sessionId,
    required this.status,
    required this.callParticipants,
  });

  final String currentUserId;
  final StreamCallCid callCid;
  final String createdByUserId;
  final String sessionId;
  final CallStatus status;
  final List<CallParticipantStateV2> callParticipants;

  CallParticipantStateV2? get localParticipant {
    return callParticipants.where((element) => element.isLocal)?.firstOrNull;
  }

  /// Returns a copy of this [CallStateV2] with the given fields replaced
  /// with the new values.
  CallStateV2 copyWith({
    String? currentUserId,
    StreamCallCid? callCid,
    String? createdByUserId,
    String? sessionId,
    CallStatus? status,
    List<CallParticipantStateV2>? callParticipants,
  }) {
    return CallStateV2._(
      currentUserId: currentUserId ?? this.currentUserId,
      callCid: callCid ?? this.callCid,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      callParticipants: callParticipants ?? this.callParticipants,
    );
  }

  @override
  List<Object?> get props => [
        currentUserId,
        callCid,
        createdByUserId,
        sessionId,
        status,
        callParticipants,
      ];

  @override
  String toString() {
    return 'CallStateV2{currentUserId: $currentUserId, callCid: $callCid, '
        'createdByUserId: $createdByUserId, status: $status, '
        'sessionId: $sessionId, callParticipants: $callParticipants}';
  }
}

extension on CallMetadata {
  CallStatus toCallStatus(String currentUserId, bool ringing) {
    final createdByMe = currentUserId == info.createdByUserId;
    if (createdByMe && ringing) {
      return CallStatus.outgoing();
    } else if (!createdByMe && ringing) {
      return CallStatus.incoming();
    } else {
      return CallStatus.idle();
    }
  }

  List<CallParticipantStateV2> toCallParticipants(String currentUserId) {
    final result = <CallParticipantStateV2>[];
    for (final userId in details.memberUserIds) {
      final member = details.members[userId];
      final isLocal = currentUserId == userId;
      result.add(
        CallParticipantStateV2(
          userId: userId,
          role: member?.role ?? '',
          name: '',
          profileImageURL: '',
          sessionId: '',
          trackIdPrefix: '',
          isLocal: isLocal,
          isOnline: !isLocal,
        ),
      );
    }
    return result;
  }
}
