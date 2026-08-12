import '../models/call_metadata.dart';
import 'call_reject_reason.dart';

enum CallRingingState {
  ended,
  rejected,
  accepted,
  ringing,
}

extension CallRingingStateX on CallRingingState {
  bool get isRinging => this == CallRingingState.ringing;

  /// The reason to settle the local call state with once the ringing flow is
  /// over.
  CallRejectReason? toReason() => switch (this) {
    CallRingingState.ringing => null,
    CallRingingState.ended => CallRejectReason.callEnded(),
    CallRingingState.accepted ||
    CallRingingState.rejected => CallRejectReason.userRespondedElsewhere(),
  };
}

extension CallMetadataRingingStateX on CallMetadata {
  /// Resolves whether this call is still worth ringing for [currentUserId],
  /// based on the latest state fetched from the coordinator.
  ///
  /// Anything other than [CallRingingState.ringing] means the incoming call UI
  /// should not be shown, or should be dismissed if it already is.
  CallRingingState ringingStateFor(String currentUserId) {
    if (details.endedAt != null || session.endedAt != null) {
      return CallRingingState.ended;
    }

    if (session.acceptedBy.containsKey(currentUserId)) {
      return CallRingingState.accepted;
    }

    if (session.rejectedBy.containsKey(currentUserId) ||
        session.missedBy.containsKey(currentUserId)) {
      return CallRingingState.rejected;
    }

    final creatorId = details.createdBy.id;

    // The caller cancelled the ring and nobody else picked up in the meantime.
    if (session.rejectedBy.containsKey(creatorId) &&
        !session.acceptedBy.keys.any((userId) => userId != creatorId)) {
      return CallRingingState.rejected;
    }

    // Everyone else already rejected the call.
    final otherMembers = members.keys
        .where((userId) => userId != currentUserId)
        .toSet();
    if (otherMembers.isNotEmpty &&
        otherMembers.every(session.rejectedBy.containsKey)) {
      return CallRingingState.rejected;
    }

    return CallRingingState.ringing;
  }
}
