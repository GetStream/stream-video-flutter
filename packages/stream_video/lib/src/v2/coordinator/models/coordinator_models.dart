import '../../model/call_cid.dart';

class CallMetadataOld {
  const CallMetadataOld({
    required this.createdByMe,
    required this.ringing,
    required this.details,
    required this.info,
  });
  final bool ringing;
  final bool createdByMe;
  final CallDetails details;
  final CallInfo info;

  @override
  String toString() {
    return 'CallMetadataOld{ringing: $ringing, createdByMe: $createdByMe,'
        ' details: $details, info: $info}';
  }
}

class CallMetadata {
  const CallMetadata({
    required this.details,
    required this.info,
  });
  final CallDetails details;
  final CallInfo info;

  @override
  String toString() {
    return 'CallMetadata{details: $details, info: $info}';
  }
}

class CallSfuServer {
  const CallSfuServer({
    required this.name,
    required this.url,
  });
  final String name;
  final String url;

  @override
  String toString() {
    return 'CallEdgeServer{name: $name, url: $url}';
  }
}

class CallIceServer {
  const CallIceServer({
    required this.username,
    required this.password,
    required this.urls,
  });
  final String username;
  final String password;
  final List<String> urls;

  @override
  String toString() {
    return 'CallIceServer{username: $username, '
        'password: $password, urls: $urls}';
  }
}

class CallCredentials {
  const CallCredentials({
    required this.sfuServer,
    required this.sfuToken,
    required this.iceServers,
  });
  final CallSfuServer sfuServer;
  final String sfuToken;
  final List<CallIceServer> iceServers;

  @override
  String toString() {
    return 'CallCredentials{sfuToken: $sfuToken, '
        'edgeServer: $sfuServer, iceServers: $iceServers}';
  }
}

class CallInfo {
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
  String toString() {
    return 'CallInfo{cid: $cid, '
        'createdByUserId: $createdByUserId, createdAt: $createdAt, '
        'updatedAt: $updatedAt}';
  }
}

class CallDetails {
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
  String toString() {
    return 'CallDetails{memberUserIds: $memberUserIds, members: $members, '
        'isBroadcastingEnabled: $isBroadcastingEnabled, '
        'isRecordingEnabled: $isRecordingEnabled}';
  }
}

class CallMember {
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
  String toString() {
    return 'CallMember{callCid: $callCid, userId: $userId, role: $role,'
        ' createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class CallUser {
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
  String toString() {
    return 'CallUser{id: $id, name: $name, role: $role, imageUrl: $imageUrl, '
        'teams: $teams, createdAt: $createdAt, updatedAt: $updatedAt, '
        'customJson: $customJson}';
  }
}
