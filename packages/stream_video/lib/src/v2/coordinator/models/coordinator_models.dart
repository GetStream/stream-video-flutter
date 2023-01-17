class CallMetadata {
  CallMetadata({
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

class CallInfo {
  CallInfo({
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
  CallDetails({
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
  CallMember({
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
}

class CallUser {
  CallUser({
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
}
