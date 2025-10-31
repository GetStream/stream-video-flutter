import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call/call_type.dart';
import 'models/call_member_state.dart';
import 'models/models.dart';
import 'webrtc/rtc_media_device/rtc_media_device.dart';

/// Represents the call's state.
@immutable
class CallState extends Equatable {
  factory CallState({
    required String currentUserId,
    required StreamCallCid callCid,
    required CallPreferences preferences,
  }) {
    return CallState._(
      preferences: preferences,
      currentUserId: currentUserId,
      callCid: callCid,
      createdByUser: CallUser.empty(),
      isRingingFlow: false,
      sessionId: '',
      status: CallStatus.idle(),
      isRecording: false,
      isBroadcasting: false,
      isTranscribing: false,
      isCaptioning: false,
      isBackstage: false,
      isAudioProcessing: false,
      settings: const CallSettings(),
      egress: const CallEgress(),
      rtmpIngress: '',
      videoInputDevice: null,
      audioInputDevice: null,
      audioOutputDevice: null,
      ownCapabilities: List.unmodifiable(const []),
      callParticipants: List.unmodifiable(const []),
      callMembers: List.unmodifiable(const []),
      capabilitiesByRole: const {},
      createdAt: null,
      updatedAt: null,
      startsAt: null,
      endedAt: null,
      startedAt: null,
      liveStartedAt: null,
      liveEndedAt: null,
      timerEndsAt: null,
      blockedUserIds: const [],
      participantCount: 0,
      anonymousParticipantCount: 0,
      iOSMultitaskingCameraAccessEnabled: false,
      custom: const {},
    );
  }

  const CallState._({
    required this.preferences,
    required this.currentUserId,
    required this.callCid,
    required this.createdByUser,
    required this.isRingingFlow,
    required this.sessionId,
    required this.status,
    required this.isRecording,
    required this.isBroadcasting,
    required this.isTranscribing,
    required this.isCaptioning,
    required this.isBackstage,
    required this.isAudioProcessing,
    required this.settings,
    required this.egress,
    required this.rtmpIngress,
    required this.ownCapabilities,
    required this.callParticipants,
    required this.callMembers,
    required this.capabilitiesByRole,
    required this.videoInputDevice,
    required this.audioInputDevice,
    required this.audioOutputDevice,
    required this.createdAt,
    required this.updatedAt,
    required this.startsAt,
    required this.endedAt,
    required this.startedAt,
    required this.liveStartedAt,
    required this.liveEndedAt,
    required this.timerEndsAt,
    required this.blockedUserIds,
    required this.participantCount,
    required this.anonymousParticipantCount,
    required this.iOSMultitaskingCameraAccessEnabled,
    required this.custom,
  });

  final CallPreferences preferences;
  final String currentUserId;
  final StreamCallCid callCid;
  final CallUser createdByUser;
  final bool isRingingFlow;
  final String sessionId;
  final CallStatus status;
  final CallSettings settings;
  final CallEgress egress;
  final String rtmpIngress;
  final bool isRecording;
  final bool isBroadcasting;
  final bool isTranscribing;
  final bool isCaptioning;
  final bool isBackstage;
  final bool isAudioProcessing;
  final RtcMediaDevice? videoInputDevice;
  final RtcMediaDevice? audioInputDevice;
  final RtcMediaDevice? audioOutputDevice;
  final List<CallPermission> ownCapabilities;
  final List<CallParticipantState> callParticipants;
  final List<CallMemberState> callMembers;
  final Map<String, List<String>> capabilitiesByRole;
  final DateTime? createdAt;
  final DateTime? startsAt;
  final DateTime? endedAt;
  final DateTime? updatedAt;
  final DateTime? startedAt;
  final DateTime? liveStartedAt;
  final DateTime? liveEndedAt;
  final DateTime? timerEndsAt;
  final List<String> blockedUserIds;
  final int participantCount;
  final int anonymousParticipantCount;
  final bool iOSMultitaskingCameraAccessEnabled;
  final Map<String, Object> custom;

  String get callId => callCid.id;

  StreamCallType get callType => callCid.type;

  CallParticipantState? get localParticipant {
    return callParticipants.firstWhereOrNull((element) => element.isLocal);
  }

  List<CallParticipantState> get otherParticipants {
    return callParticipants.where((element) => !element.isLocal).toList();
  }

  List<CallParticipantState> get activeSpeakers {
    return callParticipants.where((element) => element.isSpeaking).toList();
  }

  bool get createdByMe => createdByUserId == currentUserId;

  String get createdByUserId => createdByUser.id;

  List<CallMemberState> get ringingMembers {
    return callMembers
        .where(
          (member) =>
              member.callAcceptedAt == null &&
              member.callRejectedAt == null &&
              member.userId != currentUserId,
        )
        .toList();
  }

  /// Returns a copy of this [CallState] with the given fields replaced
  /// with the new values.
  CallState copyWith({
    CallPreferences? preferences,
    String? currentUserId,
    StreamCallCid? callCid,
    CallUser? createdByUser,
    bool? isRingingFlow,
    String? sessionId,
    CallStatus? status,
    bool? isRecording,
    bool? isBroadcasting,
    bool? isTranscribing,
    bool? isCaptioning,
    bool? isBackstage,
    bool? isAudioProcessing,
    CallSettings? settings,
    CallEgress? egress,
    String? rtmpIngress,
    RtcMediaDevice? videoInputDevice,
    RtcMediaDevice? audioInputDevice,
    RtcMediaDevice? audioOutputDevice,
    List<CallPermission>? ownCapabilities,
    List<CallParticipantState>? callParticipants,
    List<CallMemberState>? callMembers,
    Map<String, List<String>>? capabilitiesByRole,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startsAt,
    DateTime? endedAt,
    DateTime? startedAt,
    DateTime? liveStartedAt,
    DateTime? liveEndedAt,
    DateTime? timerEndsAt,
    List<String>? blockedUserIds,
    int? participantCount,
    int? anonymousParticipantCount,
    bool? iOSMultitaskingCameraAccessEnabled,
    Map<String, Object>? custom,
  }) {
    return CallState._(
      preferences: preferences ?? this.preferences,
      currentUserId: currentUserId ?? this.currentUserId,
      callCid: callCid ?? this.callCid,
      createdByUser: createdByUser ?? this.createdByUser,
      isRingingFlow: isRingingFlow ?? this.isRingingFlow,
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      isRecording: isRecording ?? this.isRecording,
      isBroadcasting: isBroadcasting ?? this.isBroadcasting,
      isTranscribing: isTranscribing ?? this.isTranscribing,
      isCaptioning: isCaptioning ?? this.isCaptioning,
      isBackstage: isBackstage ?? this.isBackstage,
      isAudioProcessing: isAudioProcessing ?? this.isAudioProcessing,
      settings: settings ?? this.settings,
      egress: egress ?? this.egress,
      rtmpIngress: rtmpIngress ?? this.rtmpIngress,
      videoInputDevice: videoInputDevice ?? this.videoInputDevice,
      audioInputDevice: audioInputDevice ?? this.audioInputDevice,
      audioOutputDevice: audioOutputDevice ?? this.audioOutputDevice,
      ownCapabilities: ownCapabilities ?? this.ownCapabilities,
      callParticipants: callParticipants ?? this.callParticipants,
      callMembers: callMembers ?? this.callMembers,
      capabilitiesByRole: capabilitiesByRole ?? this.capabilitiesByRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startsAt: startsAt ?? this.startsAt,
      endedAt: endedAt ?? this.endedAt,
      startedAt: startedAt ?? this.startedAt ?? this.liveStartedAt,
      liveStartedAt: liveStartedAt ?? this.liveStartedAt,
      liveEndedAt: liveEndedAt ?? this.liveEndedAt,
      timerEndsAt: timerEndsAt ?? this.timerEndsAt,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      participantCount: participantCount ?? this.participantCount,
      anonymousParticipantCount:
          anonymousParticipantCount ?? this.anonymousParticipantCount,
      iOSMultitaskingCameraAccessEnabled:
          iOSMultitaskingCameraAccessEnabled ??
          this.iOSMultitaskingCameraAccessEnabled,
      custom: custom ?? this.custom,
    );
  }

  CallState copyFromMetadata(
    CallMetadata metadata, {
    Map<String, List<String>>? capabilitiesByRole,
    bool updateMembers = true,
  }) {
    final capabilities = metadata.details.ownCapabilities.toList();

    return copyWith(
      isBackstage: metadata.details.backstage,
      isRecording: metadata.details.recording,
      isTranscribing: metadata.details.transcribing,
      isCaptioning: metadata.details.captioning,
      isBroadcasting: metadata.details.broadcasting,
      blockedUserIds: metadata.details.blockedUserIds.toList(),
      createdAt: metadata.details.createdAt,
      updatedAt: metadata.details.updatedAt,
      startsAt: metadata.details.startsAt,
      endedAt: metadata.details.endedAt,
      startedAt: metadata.session.startedAt ?? metadata.session.liveStartedAt,
      createdByUser: metadata.details.createdBy,
      custom: metadata.details.custom,
      egress: metadata.details.egress,
      rtmpIngress: metadata.details.rtmpIngress,
      settings: metadata.settings,
      ownCapabilities: capabilities.isEmpty ? null : capabilities,
      liveStartedAt: metadata.session.liveStartedAt,
      liveEndedAt: metadata.session.liveEndedAt,
      timerEndsAt: metadata.session.timerEndsAt,
      capabilitiesByRole: capabilitiesByRole,
      callMembers: updateMembers ? metadata.toCallMembers() : null,
    );
  }

  @override
  List<Object?> get props => [
    currentUserId,
    callCid,
    createdByUser,
    sessionId,
    status,
    isRecording,
    isTranscribing,
    isCaptioning,
    isBroadcasting,
    isBackstage,
    isAudioProcessing,
    settings,
    egress,
    rtmpIngress,
    videoInputDevice,
    audioInputDevice,
    audioOutputDevice,
    ownCapabilities,
    callParticipants,
    callMembers,
    capabilitiesByRole,
    createdAt,
    updatedAt,
    startsAt,
    endedAt,
    startedAt,
    liveStartedAt,
    liveEndedAt,
    timerEndsAt,
    blockedUserIds,
    participantCount,
    anonymousParticipantCount,
    iOSMultitaskingCameraAccessEnabled,
    custom,
  ];

  @override
  String toString() {
    return 'CallState(status: $status, currentUserId: $currentUserId,'
        ' callCid: $callCid, createdByUser: $createdByUser,'
        ' sessionId: $sessionId, isRecording: $isRecording,'
        ' settings: $settings, egress: $egress, '
        ' videoInputDevice: $videoInputDevice,'
        ' audioInputDevice: $audioInputDevice,'
        ' audioOutputDevice: $audioOutputDevice,'
        ' ownCapabilities: $ownCapabilities,'
        ' callParticipants: $callParticipants)';
  }
}
