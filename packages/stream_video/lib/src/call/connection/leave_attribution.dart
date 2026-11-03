import 'package:meta/meta.dart';

import '../../models/disconnect_reason.dart';
import '../../models/leave_initiator.dart';
import '../../telemetry/client_event_types.dart';
import '../call_reject_reason.dart';

/// Everything a leave reports about itself, worked out from one
/// [DisconnectReason] so the SFU and the join telemetry cannot disagree.
@internal
@immutable
class LeaveAttribution {
  const LeaveAttribution({
    required this.initiator,
    required this.code,
    required this.message,
    required this.abortCode,
  });

  /// The attribution of a leave for [reason], by the user [currentUserId].
  factory LeaveAttribution.of(
    DisconnectReason reason, {
    required String currentUserId,
  }) {
    final initiator = _initiator(reason, currentUserId);
    return LeaveAttribution(
      initiator: initiator,
      code: _code(reason),
      message: _message(reason),
      abortCode: switch (reason) {
        DisconnectReasonReconnectionFailed() =>
          ClientEventStandardCode.networkOffline,
        _ when initiator == LeaveInitiator.remoteEvent =>
          ClientEventStandardCode.backendLeave,
        _ => ClientEventStandardCode.clientAborted,
      },
    );
  }

  /// What made the call leave, sent as `leave_initiator`.
  final LeaveInitiator initiator;

  /// A short, stable identifier of why the call left, sent as
  /// `leave_reason`, or the app's own words for a leave it gave them for.
  final String code;

  /// Why the call left, in words: the reason the SFU is told and the
  /// `retry_failure_reason` of the join stages the leave aborts.
  final String message;

  /// The code the join stages still in flight are failed with.
  final ClientEventStandardCode abortCode;

  /// The failure the join stages still in flight are failed with.
  ClientEventFailure get abortFailure => ClientEventFailure(
    abortCode,
    message,
    leaveInitiator: initiator,
    leaveReason: code,
  );

  static LeaveInitiator _initiator(
    DisconnectReason reason,
    String currentUserId,
  ) {
    return switch (reason) {
      DisconnectReasonLeft(:final initiator) => initiator,
      DisconnectReasonEnded(:final initiator) => initiator,
      DisconnectReasonCancelled() ||
      DisconnectReasonBlocked() => LeaveInitiator.remoteEvent,
      DisconnectReasonNativeCallEnded() => LeaveInitiator.callkit,
      final DisconnectReasonRejected rejected =>
        rejected.initiator ??
            (rejected.byUserId == currentUserId
                ? rejectInitiator(rejected.reason)
                : LeaveInitiator.remoteEvent),
      DisconnectReasonReplaced() ||
      DisconnectReasonLastParticipantLeft() => LeaveInitiator.app,
      DisconnectReasonReconnectionFailed() ||
      DisconnectReasonFailure() ||
      DisconnectReasonSfuError() => LeaveInitiator.sdkError,
    };
  }

  /// What made the current user reject for [reason], when the reject does
  /// not say.
  ///
  /// One that mirrors a ring resolved elsewhere came from the backend. Any
  /// other is the user's, unless the SDK sent it for them.
  static LeaveInitiator rejectInitiator(CallRejectReason? reason) {
    if (reason == CallRejectReason.timeout()) return LeaveInitiator.sdkError;
    if (reason == CallRejectReason.callEndedLocally()) {
      return LeaveInitiator.app;
    }
    if (reason == CallRejectReason.callEnded() ||
        reason == CallRejectReason.userRespondedElsewhere() ||
        reason == CallRejectReason.creatorRejected() ||
        reason == CallRejectReason.allOtherParticipantsRejected()) {
      return LeaveInitiator.remoteEvent;
    }
    return LeaveInitiator.user;
  }

  static String _code(DisconnectReason reason) {
    return switch (reason) {
      DisconnectReasonLeft(:final message) => message ?? 'left',
      DisconnectReasonEnded() => 'call.ended',
      DisconnectReasonNativeCallEnded() => 'native.call_ended',
      DisconnectReasonRejected(reason: final rejectReason?) =>
        'call.rejected:${rejectReason.value}',
      DisconnectReasonRejected() => 'call.rejected',
      DisconnectReasonCancelled() => 'ring.cancelled',
      DisconnectReasonBlocked() => 'call.blocked',
      DisconnectReasonReplaced() => 'call.replaced',
      DisconnectReasonLastParticipantLeft() => 'call.last_participant_left',
      DisconnectReasonReconnectionFailed() => 'reconnection_failed',
      DisconnectReasonFailure() => 'error',
      DisconnectReasonSfuError(:final error) => 'sfu_error:${error.code.name}',
    };
  }

  static String _message(DisconnectReason reason) {
    return switch (reason) {
      DisconnectReasonLeft(:final message) =>
        message ?? 'user is leaving the call',
      DisconnectReasonEnded(
        initiator: LeaveInitiator.remoteEvent,
        :final message,
      ) =>
        message ?? 'call ended',
      DisconnectReasonEnded(:final message) =>
        message ?? 'user is ending the call',
      DisconnectReasonNativeCallEnded() => 'call ended externally',
      DisconnectReasonRejected(:final reason) =>
        'rejected: ${reason?.value ?? 'unspecified'}',
      DisconnectReasonCancelled(:final byUserId) => 'cancelled: $byUserId',
      DisconnectReasonBlocked() => 'blocked',
      DisconnectReasonReplaced() => 'replaced by another call',
      DisconnectReasonLastParticipantLeft() => 'last participant left',
      DisconnectReasonReconnectionFailed() => 'reconnection failed',
      // The error's message, not its `toString`, which carries the stack
      // trace.
      DisconnectReasonFailure(:final error) => 'failure: ${error.message}',
      DisconnectReasonSfuError(:final error) =>
        'sfu error: ${error.code.name}: ${error.message}',
    };
  }

  @override
  String toString() =>
      'LeaveAttribution{initiator: ${initiator.wireValue}, code: $code, '
      'abortCode: ${abortCode.wireValue}}';
}
