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
