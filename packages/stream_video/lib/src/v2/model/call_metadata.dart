import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call_cid.dart';

@immutable
class CallMetadata with EquatableMixin {
  const CallMetadata({
    required this.details,
    required this.info,
    required this.users,
  });
  final CallDetails details;
  final CallInfo info;
  final Map<String, CallUser> users;

  @override
  List<Object> get props => [details, info, users];

  @override
  String toString() {
    return 'CallMetadata{details: $details, info: $info, users: $users}';
  }
}

@immutable
class CallDetails with EquatableMixin {
  const CallDetails({
    required this.memberUserIds,
    required this.members,
    required this.isBroadcastingEnabled,
    required this.isRecordingEnabled,
  });

  final List<String> memberUserIds;
  final Map<String, CallMember> members;
  final bool isBroadcastingEnabled;
  final bool isRecordingEnabled;

  @override
  List<Object> get props => [
        memberUserIds,
        members,
        isBroadcastingEnabled,
        isRecordingEnabled,
      ];

  @override
  String toString() {
    return 'CallDetails{memberUserIds: $memberUserIds, members: $members, '
        'isBroadcastingEnabled: $isBroadcastingEnabled, '
        'isRecordingEnabled: $isRecordingEnabled}';
  }
}

@immutable
class CallInfo with EquatableMixin {
  const CallInfo({
    required this.cid,
    required this.createdByUserId,
    this.createdAt,
    this.updatedAt,
  });

  final StreamCallCid cid;
  final String createdByUserId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object> get props => [
        cid,
        createdByUserId,
        createdAt ?? 0,
        updatedAt ?? 0,
      ];

  @override
  String toString() {
    return 'CallInfo{cid: $cid, '
        'createdByUserId: $createdByUserId, createdAt: $createdAt, '
        'updatedAt: $updatedAt}';
  }
}

@immutable
class CallMember with EquatableMixin {
  const CallMember({
    required this.callCid,
    required this.userId,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  final String callCid;
  final String userId;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object> get props => [
        callCid,
        userId,
        role,
        createdAt ?? 0,
        updatedAt ?? 0,
      ];

  @override
  String toString() {
    return 'CallMember{callCid: $callCid, userId: $userId, role: $role,'
        ' createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class CallUser with EquatableMixin {
  const CallUser({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.teams,
    this.createdAt,
    this.updatedAt,
    this.customJson,
  });

  final String id;
  final String name;
  final String role;
  final String imageUrl;
  final List<String> teams;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? customJson;

  @override
  List<Object> get props => [
        id,
        name,
        role,
        imageUrl,
        teams,
        createdAt ?? 0,
        updatedAt ?? 0,
        customJson ?? '',
      ];

  @override
  String toString() {
    return 'CallUser{id: $id, name: $name, role: $role, imageUrl: $imageUrl, '
        'teams: $teams, createdAt: $createdAt, updatedAt: $updatedAt, '
        'customJson: $customJson}';
  }
}