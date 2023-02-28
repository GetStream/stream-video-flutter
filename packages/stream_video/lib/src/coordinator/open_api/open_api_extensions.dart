import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../call_permission.dart';
import '../../models/call_cid.dart';
import '../../models/call_credentials.dart';
import '../../models/call_metadata.dart';
import '../../models/call_setting.dart';

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

  CallMember toCallMember(String callCid) {
    return CallMember(
      callCid: callCid,
      userId: id,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
        members: {createdBy.id: createdBy.toCallMember(cid)},
        isBroadcastingEnabled: settings.broadcasting.enabled,
        isRecordingEnabled: settings.recording.mode.isNotEmpty,
        ownCapabilities: ownCapabilities.map(CallPermission.fromAlias),
        settings: settings.toCallSettings(),
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

extension CallSettingsExt on open.CallSettingsResponse {
  CallSettings toCallSettings() {
    return CallSettings(
      audio: AudioSetting(
        accessRequestEnabled: audio.accessRequestEnabled,
      ),
      video: VideoSetting(
        accessRequestEnabled: video.accessRequestEnabled,
      ),
      screenShare: ScreenShareSetting(
        accessRequestEnabled: screensharing.accessRequestEnabled,
      ),
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
