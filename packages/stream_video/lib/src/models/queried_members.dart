import 'package:equatable/equatable.dart';

import 'call_metadata.dart';

class QueriedMembers with EquatableMixin {
  factory QueriedMembers({
    required Map<String, CallMember> members,
    required Map<String, CallUser> users,
    String? next,
    String? prev,
  }) {
    return QueriedMembers._(
      members: Map.unmodifiable(members),
      users: Map.unmodifiable(users),
      next: next,
      prev: prev,
    );
  }

  const QueriedMembers._({
    required this.members,
    required this.users,
    this.next,
    this.prev,
  });

  final Map<String, CallMember> members;
  final Map<String, CallUser> users;
  final String? next;
  final String? prev;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [members, users, next, prev];
}
