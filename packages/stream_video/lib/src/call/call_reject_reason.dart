import 'package:equatable/equatable.dart';

/// Reason for rejecting a call.
///
/// decline - when the callee intentionally declines the call
/// cancel - when the caller cancels the call
/// busy - when the callee is busy and cannot accept the call
/// timeout - when the call times out
/// callEnded - when the call was ended externally (backend event, creator
///   cancelled, or all other participants rejected) before the user answered
/// callEndedLocally - when the local SDK already ended the call and the
///   ringing flow is being brought back in sync
class CallRejectReason with EquatableMixin {
  const CallRejectReason._(this.value);

  factory CallRejectReason.decline() => const CallRejectReason._('decline');
  factory CallRejectReason.cancel() => const CallRejectReason._('cancel');
  factory CallRejectReason.busy() => const CallRejectReason._('busy');
  factory CallRejectReason.timeout() => const CallRejectReason._('timeout');

  /// The call was ended externally before the user could answer — e.g. a
  /// backend `call.ended` event, the creator cancelled, or every other
  /// participant already rejected.
  factory CallRejectReason.callEnded() =>
      const CallRejectReason._('call-ended');

  /// The local SDK already ended the call and the ringing UI / CallKit is
  /// being brought back in sync.
  factory CallRejectReason.callEndedLocally() =>
      const CallRejectReason._('call-ended-locally');

  /// The same user already accepted, rejected, or missed the ringing call on
  /// another device.
  factory CallRejectReason.userRespondedElsewhere() =>
      const CallRejectReason._('user-responded-elsewhere');

  /// The caller cancelled the ringing flow before any other invitee accepted.
  factory CallRejectReason.creatorRejected() =>
      const CallRejectReason._('ring: creator rejected');

  /// Every invitee other than the current user and the caller has already
  /// rejected the ringing call.
  factory CallRejectReason.allOtherParticipantsRejected() =>
      const CallRejectReason._('ring: everyone rejected');

  factory CallRejectReason.custom(String customType) =>
      CallRejectReason._(customType);

  final String value;

  @override
  String toString() => value;

  @override
  List<Object?> get props => [value];
}
