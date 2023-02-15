import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/call_cid.dart';

@immutable
abstract class CoordinatorModelV2 with EquatableMixin {
  const CoordinatorModelV2();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => const [];
}

class CallMetadata extends CoordinatorModelV2 {
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

class CallSfuServer extends CoordinatorModelV2 {
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

class CallIceServer extends CoordinatorModelV2 {
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
class CallCredentials extends CoordinatorModelV2 {
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
class CallInfo extends CoordinatorModelV2 {
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
class CallDetails extends CoordinatorModelV2 {
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

class CallMember extends CoordinatorModelV2 {
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

class CallUser extends CoordinatorModelV2 {
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

class SfuEdge extends CoordinatorModelV2 {
  const SfuEdge({
    this.name,
    this.latencyUrl,
    this.coordinates,
  });

  final String? name;
  final String? latencyUrl;
  final Coordinates? coordinates;

  @override
  List<Object?> get props => [name, latencyUrl, coordinates];
}

class Coordinates extends CoordinatorModelV2 {
  const Coordinates(this.lat, this.lng);

  final double? lat;
  final double? lng;

  @override
  List<Object?> get props => [lat, lng];
}

class Device extends CoordinatorModelV2 {
  const Device({
    required this.userId,
    required this.pushToken,
    required this.pushProviderName,
    required this.createdAt,
    required this.updatedAt,
  });

  final String userId;
  final String pushToken;
  final String pushProviderName;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        userId,
        pushProviderName,
        pushToken,
        createdAt,
        updatedAt,
      ];
}
