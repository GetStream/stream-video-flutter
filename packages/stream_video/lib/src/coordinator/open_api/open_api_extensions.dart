import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../models/call_cid.dart';
import '../../models/call_credentials.dart';
import '../../models/call_metadata.dart';

extension MemberExt on open.MemberResponse {
  CallMember toCallMember(String callCid) {
    return CallMember(
      callCid: callCid,
      userId: userId,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension MemberListExt on List<open.MemberResponse> {
  Map<String, CallMember> toCallMembers(String callCid) {
    return {
      for (var member in this) member.userId: member.toCallMember(callCid)
    };
  }

  Map<String, CallUser> toCallUsers() {
    return {for (var member in this) member.userId: member.user.toCallUser()};
  }
}

extension UserExt on open.UserResponse {
  CallUser toCallUser() {
    return CallUser(
      id: id,
      teams: teams,
      role: role,
      name: name ?? '',
      imageUrl: image ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
      customJson: custom,
    );
  }
}

extension UserListExt on List<open.UserResponse> {
  List<CallUser> toCallUsers() {
    return map((it) => it.toCallUser()).toList();
  }
}

extension EnvelopeExt on open.CallResponse {
  CallMetadata toCallMetadata() {
    return CallMetadata(
      details: CallDetails(
        memberUserIds: [createdBy.id],
        members: const {},
        isBroadcastingEnabled: settings.broadcasting.enabled,
        isRecordingEnabled: settings.recording.mode.isNotEmpty,
      ),
      info: CallInfo(
        cid: StreamCallCid(cid: cid),
        createdByUserId: createdBy.id,
        createdAt: createdAt,
        updatedAt: updatedAt,
      ),
      users: {createdBy.id: createdBy.toCallUser()},
    );
  }
}

extension CredentialsExt on open.Credentials {
  CallCredentials toCallCredentials() {
    return CallCredentials(
      sfuToken: token,
      sfuServer: CallSfuServer(
        url: server.url,
        name: server.edgeName,
      ),
      iceServers: iceServers
          .map(
            (it) => CallIceServer(
              username: it.username,
              password: it.password,
              urls: it.urls,
            ),
          )
          .toList(),
    );
  }
}
