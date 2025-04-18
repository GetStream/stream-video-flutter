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
    this.callRejectedAt,
    this.callAcceptedAt,
  });

  factory CallMemberState.fromCallMember(CallMember member, CallUser? user) {
    return CallMemberState(
      userId: member.userId,
      roles: member.roles,
      name: user?.name ?? member.userId,
      custom: member.custom,
      image: user?.image,
    );
  }

  final String userId;
  final List<String> roles;
  final String name;
  final Map<String, Object?> custom;
  final String? image;

  final DateTime? callRejectedAt;
  final DateTime? callAcceptedAt;

  @override
  List<Object?> get props => [
        userId,
        roles,
        name,
        custom,
        image,
        callRejectedAt,
        callAcceptedAt,
      ];

  UserInfo toUserInfo() => UserInfo(
        id: userId,
        role: roles.firstOrNull ?? '',
        name: name,
        image: image,
      );

  CallMemberState copyWith({
    String? userId,
    List<String>? roles,
    String? name,
    Map<String, Object?>? custom,
    String? image,
    DateTime? callRejectedAt,
    DateTime? callAcceptedAt,
  }) {
    return CallMemberState(
      userId: userId ?? this.userId,
      roles: roles ?? this.roles,
      name: name ?? this.name,
      custom: custom ?? this.custom,
      image: image ?? this.image,
      callRejectedAt: callRejectedAt ?? this.callRejectedAt,
      callAcceptedAt: callAcceptedAt ?? this.callAcceptedAt,
    );
  }
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
