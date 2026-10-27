import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../call/call_reject_reason.dart';
import '../errors/stream_video_exception.dart';
import '../sfu/data/models/sfu_error.dart';
import 'leave_initiator.dart';

/// Why a call disconnected, carried by `CallStatusDisconnected`.
@immutable
sealed class DisconnectReason extends Equatable {
  const DisconnectReason();

  const factory DisconnectReason.failure(
    StreamVideoException error,
  ) = DisconnectReasonFailure;

  const factory DisconnectReason.sfuError(
    SfuError error,
  ) = DisconnectReasonSfuError;

  /// This side left the call, as [initiator] says, for the reason in
  /// [message], if one was given.
  const factory DisconnectReason.left({
    LeaveInitiator initiator,
    String? message,
  }) = DisconnectReasonLeft;

  const factory DisconnectReason.rejected({
    required String byUserId,
    CallRejectReason? reason,
    LeaveInitiator? initiator,
  }) = DisconnectReasonRejected;

  const factory DisconnectReason.blocked() = DisconnectReasonBlocked;

  const factory DisconnectReason.cancelled({
    required String byUserId,
  }) = DisconnectReasonCancelled;

  /// The call ended for everyone. [initiator] is set when this side ended
  /// it, through `Call.end`, with [message] as the reason it gave.
  factory DisconnectReason.ended({
    LeaveInitiator? initiator,
    String? message,
  }) {
    return DisconnectReasonEnded(initiator: initiator, message: message);
  }

  /// The system call UI ended the call: CallKit on iOS, Telecom on Android.
  factory DisconnectReason.nativeCallEnded() {
    return DisconnectReasonNativeCallEnded();
  }

  @Deprecated('Use DisconnectReason.nativeCallEnded instead.')
  factory DisconnectReason.callEnded() = DisconnectReason.nativeCallEnded;

  factory DisconnectReason.replaced() {
    return DisconnectReasonReplaced();
  }

  factory DisconnectReason.lastParticipantLeft() {
    return DisconnectReasonLastParticipantLeft();
  }

  factory DisconnectReason.reconnectionFailed() {
    return DisconnectReasonReconnectionFailed();
  }

  @override
  List<Object?> get props => [];
}

final class DisconnectReasonFailure extends DisconnectReason {
  const DisconnectReasonFailure(this.error);

  final StreamVideoException error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() {
    return 'Failure{error: $error}';
  }
}

final class DisconnectReasonSfuError extends DisconnectReason {
  const DisconnectReasonSfuError(this.error);

  final SfuError error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() {
    return 'SfuError{error: $error}';
  }
}

/// This side left the call: through `Call.leave`, or for the SDK or the app
/// on their own.
final class DisconnectReasonLeft extends DisconnectReason {
  const DisconnectReasonLeft({
    this.initiator = LeaveInitiator.unknown,
    this.message,
  });

  /// What made the call leave.
  final LeaveInitiator initiator;

  /// Why the call left, as reported to Stream.
  final String? message;

  @override
  List<Object?> get props => [initiator, message];

  @override
  String toString() {
    return 'Left{initiator: ${initiator.name}, message: $message}';
  }
}

final class DisconnectReasonRejected extends DisconnectReason {
  const DisconnectReasonRejected({
    required this.byUserId,
    this.reason,
    this.initiator,
  });

  final String byUserId;
  final CallRejectReason? reason;

  /// What made this user reject, when the reject's [reason] does not say.
  ///
  /// If null, the initiator is derived from [byUserId] and [reason].
  final LeaveInitiator? initiator;

  @override
  List<Object?> get props => [byUserId, reason, initiator];

  @override
  String toString() {
    return 'Rejected{byUserId: $byUserId, reason: $reason, '
        'initiator: ${initiator?.name}}';
  }
}

final class DisconnectReasonBlocked extends DisconnectReason {
  const DisconnectReasonBlocked();

  @override
  String toString() {
    return 'Blocked';
  }
}

final class DisconnectReasonCancelled extends DisconnectReason {
  const DisconnectReasonCancelled({
    required this.byUserId,
  });

  final String byUserId;

  @override
  List<Object?> get props => [byUserId];

  @override
  String toString() {
    return 'Cancelled{byUserId: $byUserId}';
  }
}

/// The call ended for everyone: on the backend, or through `Call.end`.
final class DisconnectReasonEnded extends DisconnectReason {
  const DisconnectReasonEnded({this.initiator, this.message});

  /// What made this side end the call through `Call.end`, or `null` for a
  /// call ended elsewhere, such as on the backend.
  final LeaveInitiator? initiator;

  /// The reason given to `Call.end`, if any.
  final String? message;

  @override
  List<Object?> get props => [initiator, message];

  @override
  String toString() {
    return 'Ended{initiator: ${initiator?.name}, message: $message}';
  }
}

final class DisconnectReasonReplaced extends DisconnectReason {
  factory DisconnectReasonReplaced() {
    return _instance;
  }

  const DisconnectReasonReplaced._internal();

  static const DisconnectReasonReplaced _instance =
      DisconnectReasonReplaced._internal();

  @override
  String toString() {
    return 'Replaced';
  }
}

final class DisconnectReasonLastParticipantLeft extends DisconnectReason {
  factory DisconnectReasonLastParticipantLeft() {
    return _instance;
  }

  const DisconnectReasonLastParticipantLeft._internal();

  static const DisconnectReasonLastParticipantLeft _instance =
      DisconnectReasonLastParticipantLeft._internal();

  @override
  String toString() {
    return 'LastParticipantLeft';
  }
}

final class DisconnectReasonReconnectionFailed extends DisconnectReason {
  factory DisconnectReasonReconnectionFailed() {
    return _instance;
  }

  const DisconnectReasonReconnectionFailed._internal();

  static const DisconnectReasonReconnectionFailed _instance =
      DisconnectReasonReconnectionFailed._internal();

  @override
  String toString() {
    return 'ReconnectionFailed';
  }
}

/// The system call UI ended the call: CallKit on iOS, Telecom on Android.
final class DisconnectReasonNativeCallEnded extends DisconnectReason {
  factory DisconnectReasonNativeCallEnded() {
    return _instance;
  }

  const DisconnectReasonNativeCallEnded._internal();

  static const DisconnectReasonNativeCallEnded _instance =
      DisconnectReasonNativeCallEnded._internal();

  @override
  String toString() {
    return 'NativeCallEnded';
  }
}

@Deprecated('Use DisconnectReasonNativeCallEnded instead.')
typedef DisconnectReasonCallEnded = DisconnectReasonNativeCallEnded;
