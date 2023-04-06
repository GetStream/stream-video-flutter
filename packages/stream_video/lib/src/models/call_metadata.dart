import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call_cid.dart';
import 'call_permission.dart';
import 'call_setting.dart';

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
  List<Object?> get props => [details, info, users];

  @override
  String toString() {
    return 'CallMetadata{details: $details, info: $info, users: $users}';
  }
}

@immutable
class CallDetails with EquatableMixin {
  const CallDetails({
    required this.members,
    required this.ownCapabilities,
    required this.settings,
    required this.isBroadcastingEnabled,
    required this.isRecordingEnabled,
  });

  final Map<String, CallMember> members;
  final Iterable<CallPermission> ownCapabilities;
  final CallSettings settings;
  final bool isBroadcastingEnabled;
  final bool isRecordingEnabled;

  @override
  List<Object?> get props => [
        members,
        ownCapabilities,
        settings,
        isBroadcastingEnabled,
        isRecordingEnabled,
      ];

  @override
  String toString() {
    return 'CallDetails{members: $members, '
        'capabilities: $ownCapabilities, settings: $settings, '
        'isBroadcastingEnabled: $isBroadcastingEnabled, '
        'isRecordingEnabled: $isRecordingEnabled}';
  }
}

@immutable
class CallInfo with EquatableMixin {
  const CallInfo({
    required this.cid,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  final StreamCallCid cid;
  final CallUser createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get createdByUserId => createdBy.id;

  @override
  List<Object?> get props => [
        cid,
        createdBy,
        createdAt,
        updatedAt,
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
    required this.userId,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  final String userId;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        userId,
        role,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'CallMember{userId: $userId, role: $role,'
        ' createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class CallUser with EquatableMixin {
  const CallUser({
    required this.id,
    required this.name,
    required this.role,
    required this.image,
    required this.teams,
    this.createdAt,
    this.updatedAt,
    this.custom,
  });

  final String id;
  final String name;
  final String role;
  final String image;
  final List<String> teams;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, Object>? custom;

  @override
  List<Object?> get props => [
        id,
        name,
        role,
        image,
        teams,
        createdAt,
        updatedAt,
        custom,
      ];

  @override
  String toString() {
    return 'CallUser{id: $id, name: $name, role: $role, image: $image, '
        'teams: $teams, createdAt: $createdAt, updatedAt: $updatedAt, '
        'custom: $custom}';
  }
}
