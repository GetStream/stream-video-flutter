import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../call_permission.dart';
import 'call_cid.dart';
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
  List<Object> get props => [details, info, users];

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
  List<Object> get props => [
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
    this.custom,
  });

  final String id;
  final String name;
  final String role;
  final String imageUrl;
  final List<String> teams;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, Object?>? custom;

  @override
  List<Object> get props => [
        id,
        name,
        role,
        imageUrl,
        teams,
        createdAt ?? 0,
        updatedAt ?? 0,
        custom ?? '',
      ];

  @override
  String toString() {
    return 'CallUser{id: $id, name: $name, role: $role, imageUrl: $imageUrl, '
        'teams: $teams, createdAt: $createdAt, updatedAt: $updatedAt, '
        'custom: $custom}';
  }
}
