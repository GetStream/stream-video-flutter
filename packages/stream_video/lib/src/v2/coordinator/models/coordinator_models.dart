class CallMetadata {
  const CallMetadata({
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
    return 'CallMetadata{ringing: $ringing, createdByMe: $createdByMe,'
        ' details: $details, info: $info}';
  }
}

class CallInfo {
  const CallInfo({
    required this.cid,
    required this.id,
    required this.type,
    required this.createdByUserId,
    this.createdAt,
    this.updatedAt,
  });

  final String cid;
  final String id;
  final String type;
  final String createdByUserId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CallInfo{cid: $cid, id: $id, type: $type, '
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
  });

  final String id;
  final String name;
  final String role;
  final String imageUrl;
  final List<String> teams;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CallUser{id: $id, name: $name, role: $role, imageUrl: $imageUrl, '
        'teams: $teams, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
