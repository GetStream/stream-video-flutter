import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call_metadata.dart';
import 'user_info.dart';

@immutable
class CallMemberState with EquatableMixin {
  const CallMemberState({
    required this.userId,
    required this.roles,
    required this.name,
    required this.custom,
    this.image,
  });

  final String userId;
  final List<String> roles;
  final String name;
  final Map<String, Object?> custom;
  final String? image;

  @override
  List<Object?> get props => [userId, roles, name, custom];

  UserInfo toUserInfo() => UserInfo(
        id: userId,
        role: roles.firstOrNull ?? '',
        name: name,
        image: image,
      );
}

extension CallMemberStateMetadataX on CallMetadata {
  List<CallMemberState> toCallMembers() {
    return members.values.map((member) {
      final user = users.values.firstWhereOrNull(
        (user) => user.id == member.userId,
      );
      return CallMemberState(
        userId: member.userId,
        roles: member.roles,
        name: user?.name ?? member.userId,
        custom: member.custom,
        image: user?.image,
      );
    }).toList();
  }
}
