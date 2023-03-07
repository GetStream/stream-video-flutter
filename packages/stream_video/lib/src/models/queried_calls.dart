import 'package:equatable/equatable.dart';

import 'call_metadata.dart';

class QueriedCalls with EquatableMixin {
  QueriedCalls({
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
    required this.blockedUsers,
    required this.members,
    this.membership,
  });

  final CallMetadata call;
  final List<CallUser> blockedUsers;
  final List<CallMember> members;
  final CallMember? membership;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [call, blockedUsers, members, membership];
}
