import 'package:collection/collection.dart';

import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../errors/video_error.dart';
import '../../logger/stream_log.dart';
import '../../models/call_cid.dart';
import '../../models/call_credentials.dart';
import '../../models/call_egress.dart';
import '../../models/call_metadata.dart';
import '../../models/call_permission.dart';
import '../../models/call_reaction.dart';
import '../../models/call_session_data.dart';
import '../../models/call_settings.dart';
import '../../models/guest_created_data.dart';
import '../../models/push_device.dart';
import '../../models/push_provider.dart';
import '../../models/queried_calls.dart';
import '../../models/queried_members.dart';
import '../../utils/standard.dart';

extension MemberExt on open.MemberResponse {
  CallMember toCallMember() {
    return CallMember(
      userId: userId,
      role: role ?? '',
      custom: custom,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
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
      deletedAt: deletedAt,
      custom: custom,
    );
  }

  CallMember toCallMember() {
    return CallMember(
      userId: id,
      role: role,
      custom: custom,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}

extension GuessExt on open.CreateGuestResponse {
  GuestCreatedData toGuestCreatedData() {
    return GuestCreatedData(
      accessToken: accessToken,
      duration: duration,
      user: UserResponseData(
        createdAt: user.createdAt,
        id: user.id,
        role: user.role,
        updatedAt: user.updatedAt,
        custom: user.custom,
        deletedAt: user.deletedAt,
        image: user.image,
        name: user.name,
        teams: user.teams,
      ),
    );
  }
}

extension UserListExt on List<open.UserResponse> {
  Map<String, CallUser> toCallUsers() {
    return {for (final user in this) user.id: user.toCallUser()};
  }
}

extension EnvelopeExt on open.CallResponse {
  CallMetadata toCallMetadata({
    open.MemberResponse? membership,
    List<open.MemberResponse>? members,
    List<open.OwnCapability>? ownCapabilities,
  }) {
    return CallMetadata(
      cid: StreamCallCid(cid: cid),
      details: toCallDetails(ownCapabilities),
      settings: settings.toCallSettings(),
      session: session?.toCallSessionData() ?? const CallSessionData(),
      users: {
        createdBy.id: createdBy.toCallUser(),
        ...?members?.toCallUsers(),
        ...?session?.participants.toCallUsers(),
      },
      members: {
        createdBy.id: createdBy.toCallMember(),
        ...?members?.toCallMembers(),
        ...?membership?.let((it) => [it]).toCallMembers(),
      },
    );
  }

  CallDetails toCallDetails(
    List<open.OwnCapability>? ownCapabilities,
  ) {
    return CallDetails(
      createdBy: createdBy.toCallUser(),
      egress: egress.toCallEgress(),
      team: team ?? '',
      ownCapabilities: ownCapabilities?.map(
            (it) => CallPermission.fromAlias(it.value),
          ) ??
          [],
      blockedUserIds: List.unmodifiable(blockedUserIds),
      broadcasting: egress.broadcasting,
      recording: recording,
      backstage: backstage,
      transcribing: transcribing,
      custom: Map.unmodifiable(custom),
      rtmpIngress: ingress.rtmp.address,
      startsAt: startsAt,
      createdAt: createdAt,
      endedAt: endedAt,
      updatedAt: updatedAt,
    );
  }
}

extension EgressExt on open.EgressResponse {
  CallEgress toCallEgress() {
    return CallEgress(
      hlsPlaylistUrl: hls?.playlistUrl,
      rtmps: rtmps.map((it) => it.toCallRtmp()).toList(),
    );
  }
}

extension EgressRtmpExt on open.EgressRTMPResponse {
  CallEgressRtmp toCallRtmp() {
    return CallEgressRtmp(
      name: name,
      streamKey: streamKey,
      url: url,
    );
  }
}

extension CallSettingsExt on open.CallSettingsResponse {
  // TODO open api provides wider settings options
  CallSettings toCallSettings() {
    streamLog.i('CallSettingsExt', () => '[toCallSettings] settings: $this');
    return CallSettings(
      ring: StreamRingSettings(
        autoCancelTimeout: Duration(milliseconds: ring.autoCancelTimeoutMs),
        autoRejectTimeout: Duration(milliseconds: ring.incomingCallTimeoutMs),
      ),
      audio: StreamAudioSettings(
        accessRequestEnabled: audio.accessRequestEnabled,
        opusDtxEnabled: audio.opusDtxEnabled,
        redundantCodingEnabled: audio.redundantCodingEnabled,
      ),
      video: StreamVideoSettings(
        accessRequestEnabled: video.accessRequestEnabled,
        enabled: video.enabled,
      ),
      screenShare: StreamScreenShareSettings(
        accessRequestEnabled: screensharing.accessRequestEnabled,
        enabled: screensharing.enabled,
      ),
      recording: StreamRecordingSettings(
        audioOnly: recording.audioOnly,
        mode: recording.mode.toDomain(),
        quality: recording.quality.toDomain(),
      ),
      broadcasting: StreamBroadcastingSettings(
        enabled: broadcasting.enabled,
        hls: broadcasting.hls.toDomain(),
      ),
      transcription: StreamTranscriptionSettings(
        closedCaptionMode: transcription.closedCaptionMode,
        mode: transcription.mode.toDomain(),
      ),
      backstage: StreamBackstageSettings(
        enabled: backstage.enabled,
      ),
      geofencing: StreamGeofencingSettings(
        names: geofencing.names,
      ),
    );
  }
}

extension on open.TranscriptionSettingsModeEnum {
  TranscriptionSettingsMode toDomain() {
    if (this == open.TranscriptionSettingsModeEnum.autoOn) {
      return TranscriptionSettingsMode.autoOn;
    } else if (this == open.TranscriptionSettingsModeEnum.available) {
      return TranscriptionSettingsMode.available;
    } else {
      return TranscriptionSettingsMode.disabled;
    }
  }
}

extension on open.HLSSettings {
  StreamHlsSettings toDomain() {
    return StreamHlsSettings(
      autoOn: autoOn,
      enabled: enabled,
      qualityTracks: List.unmodifiable(qualityTracks),
    );
  }
}

extension on open.RecordSettingsModeEnum {
  RecordSettingsMode toDomain() {
    if (this == open.RecordSettingsModeEnum.autoOn) {
      return RecordSettingsMode.autoOn;
    } else if (this == open.RecordSettingsModeEnum.available) {
      return RecordSettingsMode.available;
    } else {
      return RecordSettingsMode.disabled;
    }
  }
}

extension on open.RecordSettingsQualityEnum {
  RecordSettingsQuality toDomain() {
    if (this == open.RecordSettingsQualityEnum.n1440p) {
      return RecordSettingsQuality.n1440p;
    } else if (this == open.RecordSettingsQualityEnum.n1080p) {
      return RecordSettingsQuality.n1080p;
    } else if (this == open.RecordSettingsQualityEnum.n720p) {
      return RecordSettingsQuality.n720p;
    } else if (this == open.RecordSettingsQualityEnum.n480p) {
      return RecordSettingsQuality.n480p;
    } else if (this == open.RecordSettingsQualityEnum.n360p) {
      return RecordSettingsQuality.n360p;
    } else {
      return RecordSettingsQuality.audioOnly;
    }
  }
}

extension CredentialsExt on open.Credentials {
  CallCredentials toCallCredentials() {
    return CallCredentials(
      sfuToken: token,
      sfuServer: CallSfuServer(
        url: server.url,
        name: server.edgeName,
        wsEndpoint: server.wsEndpoint,
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
      type: type,
      user: user.toCallUser(),
      emojiCode: emojiCode,
      custom: custom,
    );
  }
}

extension CallStateResponseFieldsExt on open.CallStateResponseFields {
  QueriedCall toQueriedCall() {
    return QueriedCall(
      call: call.toCallMetadata(
        membership: membership,
        members: members,
        ownCapabilities: ownCapabilities,
      ),
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

extension CallSessionResponseExt on open.CallSessionResponse {
  CallSessionData toCallSessionData() {
    return CallSessionData(
      id: id,
      participants: participants.toCallParticipants(),
      participantsCountByRole: participantsCountByRole,
      rejectedBy: rejectedBy,
      acceptedBy: acceptedBy,
      startedAt: startedAt,
      endedAt: endedAt,
      liveStartedAt: liveStartedAt,
      liveEndedAt: liveEndedAt,
    );
  }
}

extension ParticipantExt on open.CallParticipantResponse {
  CallUser toCallUser() {
    return user.toCallUser();
  }

  CallParticipant toCallParticipant() {
    return CallParticipant(
      userSessionId: userSessionId,
      userId: user.id,
      role: role,
      joinedAt: joinedAt,
    );
  }
}

extension ParticipantListExt on List<open.CallParticipantResponse> {
  Map<String, CallParticipant> toCallParticipants() {
    return {
      for (final participant in this)
        participant.userSessionId: participant.toCallParticipant()
    };
  }

  Map<String, CallUser> toCallUsers() {
    return {
      for (final participant in this)
        participant.user.id: participant.toCallUser()
    };
  }
}

extension CreateDeviceRequestPushProviderEnumX
    on open.CreateDeviceRequestPushProviderEnum {
  PushProvider toPushProvider() {
    if (this == open.CreateDeviceRequestPushProviderEnum.firebase) {
      return PushProvider.firebase;
    } else if (this == open.CreateDeviceRequestPushProviderEnum.xiaomi) {
      return PushProvider.xiaomi;
    } else if (this == open.CreateDeviceRequestPushProviderEnum.huawei) {
      return PushProvider.huawei;
    } else if (this == open.CreateDeviceRequestPushProviderEnum.apn) {
      return PushProvider.apn;
    }
    throw VideoError(message: 'Unknown push provider: $this');
  }
}

extension DeviceExt on open.Device {
  PushDevice? toPushDevice() {
    final parsedProvider = PushProvider.fromAlias(pushProvider);
    if (parsedProvider == null) {
      streamLog.e(
        'DeviceExt',
        () => '[toPushDevice] unknown push provider: $pushProvider',
      );
      return null;
    }
    return PushDevice(
      pushToken: id,
      pushProvider: parsedProvider,
      pushProviderName: pushProviderName,
      voip: voip,
      createdAt: createdAt,
      disabled: disabled,
      disabledReason: disabledReason,
    );
  }
}

extension DeviceListExt on List<open.Device> {
  List<PushDevice> toPushDevices() {
    return map((it) => it.toPushDevice()).whereNotNull().toList();
  }
}
