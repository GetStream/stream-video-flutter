import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/call_cid.dart';

class CallMetadata extends Equatable {
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

class CallSfuServer extends Equatable {
  const CallSfuServer({
    required this.name,
    required this.url,
  });
  final String name;
  final String url;

  @override
  List<Object> get props => [name, url];

  @override
  String toString() {
    return 'CallEdgeServer{name: $name, url: $url}';
  }
}

class CallIceServer extends Equatable {
  const CallIceServer({
    required this.username,
    required this.password,
    required this.urls,
  });
  final String username;
  final String password;
  final List<String> urls;

  @override
  List<Object> get props => [username, password, urls];

  @override
  String toString() {
    return 'CallIceServer{username: $username, '
        'password: $password, urls: $urls}';
  }
}

@immutable
class CallCredentials extends Equatable {
  const CallCredentials({
    required this.sfuServer,
    required this.sfuToken,
    required this.iceServers,
  });
  final CallSfuServer sfuServer;
  final String sfuToken;
  final List<CallIceServer> iceServers;

  @override
  List<Object> get props => [sfuServer, sfuToken, iceServers];

  @override
  String toString() {
    return 'CallCredentials{sfuToken.length: ${sfuToken.length}, '
        'edgeServer: $sfuServer, iceServers: $iceServers}';
  }
}

@immutable
class CallInfo extends Equatable {
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
class CallDetails extends Equatable {
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

class CallMember extends Equatable {
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

class CallUser extends Equatable {
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
