import 'package:equatable/equatable.dart';

import 'call_metadata.dart';

class QueriedCalls with EquatableMixin {
  factory QueriedCalls({
    required List<QueriedCall> calls,
    String? next,
    String? prev,
  }) {
    return QueriedCalls._(
      calls: calls,
      next: next,
      prev: prev,
    );
  }

  const QueriedCalls._({
    required this.calls,
    this.next,
    this.prev,
  });

  final List<QueriedCall> calls;

  final String? next;

  final String? prev;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [calls, next, prev];
}

class QueriedCall with EquatableMixin {
  QueriedCall({
    required this.call,
    required this.members,
    this.membership,
  });

  final CallMetadata call;
  final List<CallMember> members;
  final CallMember? membership;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [call, members, membership];
}
