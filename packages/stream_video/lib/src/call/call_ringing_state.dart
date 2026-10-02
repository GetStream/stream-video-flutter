import 'package:meta/meta.dart';

import '../../open_api/video/coordinator/api.dart' as open;
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
  ///
  /// Only meaningful for the callee: the caller moves on to the call when the
  /// ring is accepted, rather than settling it.
  CallRejectReason? toReason() => switch (this) {
    CallRingingState.ringing => null,
    CallRingingState.ended => CallRejectReason.callEnded(),
    CallRingingState.accepted ||
    CallRingingState.rejected => CallRejectReason.userRespondedElsewhere(),
  };
}

/// The parts of a call a ringing flow is decided by, whichever way they were
/// fetched: a full [CallMetadata], a coordinator event or a polled ring state.
///
/// The collections are copied, so a snapshot never changes with, or changes,
/// the session it was taken from.
@immutable
class RingingSnapshot {
  RingingSnapshot({
    required this.creatorId,
    required Iterable<String> memberIds,
    Map<String, DateTime> acceptedBy = const {},
    Map<String, DateTime> rejectedBy = const {},
    Map<String, DateTime> missedBy = const {},
    this.ended = false,
  }) : memberIds = Set.unmodifiable(memberIds),
       acceptedBy = Map.unmodifiable(acceptedBy),
       rejectedBy = Map.unmodifiable(rejectedBy),
       missedBy = Map.unmodifiable(missedBy);

  /// The user that started the ring.
  final String creatorId;

  /// Every member of the call, the caller included when it is a member.
  final Set<String> memberIds;

  final Map<String, DateTime> acceptedBy;
  final Map<String, DateTime> rejectedBy;
  final Map<String, DateTime> missedBy;

  /// Whether the call or its session already ended.
  final bool ended;

  /// Resolves whether this call is still worth ringing for [currentUserId].
  ///
  /// For the callee, anything other than [CallRingingState.ringing] means the
  /// incoming call UI should not be shown, or should be dismissed if it already
  /// is. For the caller, [CallRingingState.accepted] means somebody picked up
  /// and [CallRingingState.rejected] that everybody else declined.
  CallRingingState resolveFor(String currentUserId) {
    if (ended) return CallRingingState.ended;

    return currentUserId == creatorId
        ? _resolveForCaller(currentUserId)
        : _resolveForCallee(currentUserId);
  }

  CallRingingState _resolveForCaller(String currentUserId) {
    // Checked before the rejections: in a group ring one acceptance is enough,
    // whoever else declined.
    if (acceptedBy.keys.any((userId) => userId != currentUserId)) {
      return CallRingingState.accepted;
    }

    if (_everyoneElseRejected(currentUserId)) {
      return CallRingingState.rejected;
    }

    // Nobody answering is left to the caller's own ring timeout.
    return CallRingingState.ringing;
  }

  CallRingingState _resolveForCallee(String currentUserId) {
    if (acceptedBy.containsKey(currentUserId)) {
      return CallRingingState.accepted;
    }

    if (rejectedBy.containsKey(currentUserId) ||
        missedBy.containsKey(currentUserId)) {
      return CallRingingState.rejected;
    }

    // The caller cancelled the ring, whoever else already picked up.
    if (rejectedBy.containsKey(creatorId)) {
      return CallRingingState.rejected;
    }

    if (_everyoneElseRejected(currentUserId)) {
      return CallRingingState.rejected;
    }

    return CallRingingState.ringing;
  }

  bool _everyoneElseRejected(String currentUserId) {
    final otherMembers = memberIds.where((userId) => userId != currentUserId);
    return otherMembers.isNotEmpty &&
        otherMembers.every(rejectedBy.containsKey);
  }
}

extension CallMetadataRingingStateX on CallMetadata {
  RingingSnapshot get ringingSnapshot => RingingSnapshot(
    creatorId: details.createdBy.id,
    memberIds: members.keys,
    acceptedBy: session.acceptedBy,
    rejectedBy: session.rejectedBy,
    missedBy: session.missedBy,
    ended: details.endedAt != null || session.endedAt != null,
  );

  /// Resolves whether this call is still worth ringing for [currentUserId],
  /// based on the latest state fetched from the coordinator.
  ///
  /// See [RingingSnapshot.resolveFor].
  CallRingingState ringingStateFor(String currentUserId) {
    return ringingSnapshot.resolveFor(currentUserId);
  }
}

extension GetCallRingStateResponseX on open.GetCallRingStateResponse {
  /// The ring state carries no member list, so the members come from the call
  /// state the response is applied to.
  RingingSnapshot toRingingSnapshot({required Iterable<String> memberIds}) {
    return RingingSnapshot(
      creatorId: createdByUserId,
      memberIds: memberIds,
      acceptedBy: acceptedBy,
      rejectedBy: rejectedBy,
      missedBy: missedBy,
      ended: callEndedAt != null || sessionEndedAt != null,
    );
  }
}
