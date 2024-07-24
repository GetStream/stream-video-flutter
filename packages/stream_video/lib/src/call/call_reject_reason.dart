import 'package:equatable/equatable.dart';

/// Reason for rejecting a call.
///
/// busy - when the callee is busy and cannot accept the call
/// decline - when the callee intentionally declines the call
/// cancel - when the caller cancels the call
/// timeout - when the call times out
class CallRejectReason with EquatableMixin {
  const CallRejectReason._(this.value);

  factory CallRejectReason.decline() => const CallRejectReason._('decline');
  factory CallRejectReason.cancel() => const CallRejectReason._('cancel');
  factory CallRejectReason.busy() => const CallRejectReason._('busy');
  factory CallRejectReason.timeout() => const CallRejectReason._('timeout');
  factory CallRejectReason.custom(String customType) =>
      CallRejectReason._(customType);

  final String value;

  @override
  String toString() => value;

  @override
  List<Object?> get props => [value];
}
