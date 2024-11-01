import 'package:collection/collection.dart';

import '../../../../open_api/video/coordinator/api.dart' as open;
import '../../../stream_video.dart';
import '../../errors/video_error.dart';
import '../../utils/standard.dart';

extension MemberExt on open.MemberResponse {
  CallMember toCallMember() {
    return CallMember(
      userId: userId,
      roles: role != null ? [role!] : [],
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
      roles: [role],
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
      roles: [role],
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
      joinAheadTimeSeconds: joinAheadTimeSeconds,
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
      url: streamUrl,
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
        missedCallTimeout: Duration(milliseconds: ring.missedCallTimeoutMs),
      ),
      audio: StreamAudioSettings(
        accessRequestEnabled: audio.accessRequestEnabled,
        opusDtxEnabled: audio.opusDtxEnabled,
        redundantCodingEnabled: audio.redundantCodingEnabled,
        defaultDevice: audio.defaultDevice.toRequestDomain(),
        micDefaultOn: audio.micDefaultOn,
        speakerDefaultOn: audio.speakerDefaultOn,
        noiseCancellation: audio.noiseCancellation?.toSettingsDomain(),
      ),
      video: StreamVideoSettings(
        accessRequestEnabled: video.accessRequestEnabled,
        enabled: video.enabled,
        cameraDefaultOn: video.cameraDefaultOn,
        cameraFacing: video.cameraFacing.toRequestDomain(),
        targetResolution: video.targetResolution.toSettingsDomain(),
      ),
      screenShare: StreamScreenShareSettings(
        accessRequestEnabled: screensharing.accessRequestEnabled,
        enabled: screensharing.enabled,
        targetResolution: video.targetResolution.toSettingsDomain(),
      ),
      recording: StreamRecordingSettings(
        audioOnly: recording.audioOnly,
        mode: RecordSettingsMode.fromString(recording.mode),
        quality: RecordSettingsQuality.fromString(recording.quality),
      ),
      broadcasting: StreamBroadcastingSettings(
        enabled: broadcasting.enabled,
        hls: broadcasting.hls.toSettingsDomain(),
        rtmp: broadcasting.rtmp.toSettingsDomain(),
      ),
      transcription: StreamTranscriptionSettings(
        closedCaptionMode: transcription.closedCaptionMode,
        mode: transcription.mode.toSettingsDomain(),
        languages: transcription.languages,
      ),
      backstage: StreamBackstageSettings(
        enabled: backstage.enabled,
      ),
      geofencing: StreamGeofencingSettings(
        names: geofencing.names,
      ),
      limits: StreamLimitsSettings(
        maxParticipants: limits.maxParticipants,
        maxDurationSeconds: limits.maxDurationSeconds,
      ),
    );
  }
}

extension on open.AudioSettingsResponseDefaultDeviceEnum {
  AudioSettingsRequestDefaultDeviceEnum toRequestDomain() {
    if (this == open.AudioSettingsResponseDefaultDeviceEnum.speaker) {
      return AudioSettingsRequestDefaultDeviceEnum.speaker;
    } else {
      return AudioSettingsRequestDefaultDeviceEnum.earpiece;
    }
  }
}

extension on open.VideoSettingsResponseCameraFacingEnum {
  VideoSettingsRequestCameraFacingEnum toRequestDomain() {
    if (this == open.VideoSettingsResponseCameraFacingEnum.front) {
      return VideoSettingsRequestCameraFacingEnum.front;
    } else if (this == open.VideoSettingsResponseCameraFacingEnum.back) {
      return VideoSettingsRequestCameraFacingEnum.back;
    } else {
      return VideoSettingsRequestCameraFacingEnum.external_;
    }
  }
}

extension on open.TranscriptionSettingsResponseModeEnum {
  TranscriptionSettingsMode toSettingsDomain() {
    if (this == open.TranscriptionSettingsResponseModeEnum.autoOn) {
      return TranscriptionSettingsMode.autoOn;
    } else if (this == open.TranscriptionSettingsResponseModeEnum.available) {
      return TranscriptionSettingsMode.available;
    } else {
      return TranscriptionSettingsMode.disabled;
    }
  }
}

extension on open.NoiseCancellationSettings {
  StreamNoiceCancellingSettings toSettingsDomain() {
    return StreamNoiceCancellingSettings(
      mode: mode.toSettingsDomain(),
    );
  }
}

extension on open.NoiseCancellationSettingsModeEnum {
  NoiceCancellationSettingsMode toSettingsDomain() {
    if (this == open.NoiseCancellationSettingsModeEnum.autoOn) {
      return NoiceCancellationSettingsMode.autoOn;
    } else if (this == open.NoiseCancellationSettingsModeEnum.available) {
      return NoiceCancellationSettingsMode.available;
    } else {
      return NoiceCancellationSettingsMode.disabled;
    }
  }
}

extension on open.HLSSettingsResponse {
  StreamHlsSettings toSettingsDomain() {
    return StreamHlsSettings(
      autoOn: autoOn,
      enabled: enabled,
      qualityTracks: List.unmodifiable(qualityTracks),
    );
  }
}

extension on open.RTMPSettingsResponse {
  StreamRtmpSettings toSettingsDomain() {
    return StreamRtmpSettings(
      quality: quality,
      enabled: enabled,
    );
  }
}

extension on open.TargetResolution {
  StreamTargetResolution toSettingsDomain() {
    return StreamTargetResolution(
      height: height,
      width: width,
      bitrate: bitrate,
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

extension QueryMembersResponseExt on open.QueryCallMembersResponse {
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
      timerEndsAt: timerEndsAt,
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
        participant.userSessionId: participant.toCallParticipant(),
    };
  }

  Map<String, CallUser> toCallUsers() {
    return {
      for (final participant in this)
        participant.user.id: participant.toCallUser(),
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
