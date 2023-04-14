import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../logger/stream_log.dart';
import '../../models/call_cid.dart';
import '../../models/call_credentials.dart';
import '../../models/call_metadata.dart';
import '../../models/call_permission.dart';
import '../../models/call_reaction.dart';
import '../../models/call_setting.dart';
import '../../models/queried_calls.dart';
import '../../models/queried_members.dart';

extension MemberExt on open.MemberResponse {
  CallMember toCallMember() {
    return CallMember(
      userId: userId,
      role: role ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension MemberListExt on List<open.MemberResponse> {
  Map<String, CallMember> toCallMembers() {
    return {for (final member in this) member.userId: member.toCallMember()};
  }

  Map<String, CallUser> toCallUsers() {
    return {for (final member in this) member.userId: member.user.toCallUser()};
  }
}

extension UserExt on open.UserResponse {
  CallUser toCallUser() {
    return CallUser(
      id: id,
      teams: teams,
      role: role,
      name: name ?? '',
      image: image ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
      custom: custom,
    );
  }

  CallMember toCallMember() {
    return CallMember(
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
  CallMetadata toCallMetadata([List<open.MemberResponse>? members]) {
    return CallMetadata(
      details: CallDetails(
        members: {
          createdBy.id: createdBy.toCallMember(),
          ...?members?.toCallMembers(),
        },
        isBroadcastingEnabled: broadcasting,
        isRecordingEnabled: recording,
        ownCapabilities: ownCapabilities.map(
          (it) => CallPermission.fromAlias(it.value),
        ),
        settings: settings.toCallSettings(),
      ),
      info: CallInfo(
        cid: StreamCallCid(cid: cid),
        createdBy: createdBy.toCallUser(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      ),
      users: {
        createdBy.id: createdBy.toCallUser(),
        ...?members?.toCallUsers(),
      },
    );
  }
}

extension CallSettingsExt on open.CallSettingsResponse {
  // TODO open api provides wider settings options
  CallSettings toCallSettings() {
    streamLog.i("CallSettingsExt", () => '[toCallSettings] settings: $this');
    return CallSettings(
      audio: AudioSetting(
        accessRequestEnabled: audio.accessRequestEnabled,
        opusDtxEnabled: audio.opusDtxEnabled,
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

extension ReactionExt on open.ReactionResponse {
  CallReaction toCallReaction() {
    return CallReaction(
      reactionType: type,
      user: user.toCallUser(),
      emojiCode: emojiCode,
      custom: custom,
    );
  }
}

extension CallStateResponseFieldsExt on open.CallStateResponseFields {
  QueriedCall toQueriedCall() {
    return QueriedCall(
      call: call.toCallMetadata(members),
      blockedUsers: blockedUsers.map((it) => it.toCallUser()).toList(),
      members: members.map((it) => it.toCallMember()).toList(),
      membership: membership?.toCallMember(),
    );
  }
}

extension QueryCallsResponseExt on open.QueryCallsResponse {
  QueriedCalls toQueriedCalls() {
    return QueriedCalls(
      calls: calls.map((it) => it.toQueriedCall()).toList(),
      next: next,
      prev: prev,
    );
  }
}

extension QueryMembersResponseExt on open.QueryMembersResponse {
  QueriedMembers toQueriedMembers(StreamCallCid callCid) {
    return QueriedMembers(
      members: members.toCallMembers(),
      users: members.toCallUsers(),
      next: next,
      prev: prev,
    );
  }
}
