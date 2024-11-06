import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../stream_video.dart';

/// Represents the call's state.
@immutable
class CallState extends Equatable {
  factory CallState({
    required String currentUserId,
    required StreamCallCid callCid,
  }) {
    return CallState._(
      currentUserId: currentUserId,
      callCid: callCid,
      createdByUserId: '',
      isRingingFlow: false,
      sessionId: '',
      status: CallStatus.idle(),
      isRecording: false,
      isBroadcasting: false,
      isTranscribing: false,
      isBackstage: false,
      settings: const CallSettings(),
      egress: const CallEgress(),
      rtmpIngress: '',
      videoInputDevice: null,
      audioInputDevice: null,
      audioOutputDevice: null,
      ownCapabilities: List.unmodifiable(const []),
      callParticipants: List.unmodifiable(const []),
      createdAt: null,
      updatedAt: null,
      startsAt: null,
      endedAt: null,
      liveStartedAt: null,
      liveEndedAt: null,
      timerEndsAt: null,
      publisherStats: null,
      subscriberStats: null,
      localStats: null,
      latencyHistory: const [],
      blockedUserIds: const [],
      participantCount: 0,
      anonymousParticipantCount: 0,
      custom: const {},
    );
  }

  /// TODO
  const CallState._({
    required this.currentUserId,
    required this.callCid,
    required this.createdByUserId,
    required this.isRingingFlow,
    required this.sessionId,
    required this.status,
    required this.isRecording,
    required this.isBroadcasting,
    required this.isTranscribing,
    required this.isBackstage,
    required this.settings,
    required this.egress,
    required this.rtmpIngress,
    required this.ownCapabilities,
    required this.callParticipants,
    required this.videoInputDevice,
    required this.audioInputDevice,
    required this.audioOutputDevice,
    required this.createdAt,
    required this.updatedAt,
    required this.startsAt,
    required this.endedAt,
    required this.liveStartedAt,
    required this.liveEndedAt,
    required this.timerEndsAt,
    required this.publisherStats,
    required this.subscriberStats,
    required this.localStats,
    required this.latencyHistory,
    required this.blockedUserIds,
    required this.participantCount,
    required this.anonymousParticipantCount,
    required this.custom,
  });

  final String currentUserId;
  final StreamCallCid callCid;
  final String createdByUserId;
  final bool isRingingFlow;
  final String sessionId;
  final CallStatus status;
  final CallSettings settings;
  final CallEgress egress;
  final String rtmpIngress;
  final bool isRecording;
  final bool isBroadcasting;
  final bool isTranscribing;
  final bool isBackstage;
  final RtcMediaDevice? videoInputDevice;
  final RtcMediaDevice? audioInputDevice;
  final RtcMediaDevice? audioOutputDevice;
  final List<CallPermission> ownCapabilities;
  final List<CallParticipantState> callParticipants;
  final DateTime? createdAt;
  final DateTime? startsAt;
  final DateTime? endedAt;
  final DateTime? updatedAt;
  final DateTime? liveStartedAt;
  final DateTime? liveEndedAt;
  final DateTime? timerEndsAt;
  final PeerConnectionStats? publisherStats;
  final PeerConnectionStats? subscriberStats;
  final LocalStats? localStats;
  final List<int> latencyHistory;
  final List<String> blockedUserIds;
  final int participantCount;
  final int anonymousParticipantCount;
  final Map<String, Object> custom;

  String get callId => callCid.id;

  StreamCallType get callType => callCid.type;

  CallParticipantState? get localParticipant {
    return callParticipants.firstWhereOrNull((element) => element.isLocal);
  }

  List<CallParticipantState> get otherParticipants {
    return callParticipants.where((element) => !element.isLocal).toList();
  }

  /// Returns a copy of this [CallState] with the given fields replaced
  /// with the new values.
  CallState copyWith({
    String? currentUserId,
    StreamCallCid? callCid,
    String? createdByUserId,
    bool? isRingingFlow,
    String? sessionId,
    CallStatus? status,
    bool? isRecording,
    bool? isBroadcasting,
    bool? isTranscribing,
    bool? isBackstage,
    CallSettings? settings,
    CallEgress? egress,
    String? rtmpIngress,
    RtcMediaDevice? videoInputDevice,
    RtcMediaDevice? audioInputDevice,
    RtcMediaDevice? audioOutputDevice,
    List<CallPermission>? ownCapabilities,
    List<CallParticipantState>? callParticipants,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startsAt,
    DateTime? endedAt,
    DateTime? liveStartedAt,
    DateTime? liveEndedAt,
    DateTime? timerEndsAt,
    PeerConnectionStats? publisherStats,
    PeerConnectionStats? subscriberStats,
    LocalStats? localStats,
    List<int>? latencyHistory,
    List<String>? blockedUserIds,
    int? participantCount,
    int? anonymousParticipantCount,
    Map<String, Object>? custom,
  }) {
    return CallState._(
      currentUserId: currentUserId ?? this.currentUserId,
      callCid: callCid ?? this.callCid,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      isRingingFlow: isRingingFlow ?? this.isRingingFlow,
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      isRecording: isRecording ?? this.isRecording,
      isBroadcasting: isBroadcasting ?? this.isBroadcasting,
      isTranscribing: isTranscribing ?? this.isTranscribing,
      isBackstage: isBackstage ?? this.isBackstage,
      settings: settings ?? this.settings,
      egress: egress ?? this.egress,
      rtmpIngress: rtmpIngress ?? this.rtmpIngress,
      videoInputDevice: videoInputDevice ?? this.videoInputDevice,
      audioInputDevice: audioInputDevice ?? this.audioInputDevice,
      audioOutputDevice: audioOutputDevice ?? this.audioOutputDevice,
      ownCapabilities: ownCapabilities ?? this.ownCapabilities,
      callParticipants: callParticipants ?? this.callParticipants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startsAt: startsAt ?? this.startsAt,
      endedAt: endedAt ?? this.endedAt,
      liveStartedAt: liveStartedAt ?? this.liveStartedAt,
      liveEndedAt: liveEndedAt ?? this.liveEndedAt,
      timerEndsAt: timerEndsAt ?? this.timerEndsAt,
      publisherStats: publisherStats ?? this.publisherStats,
      subscriberStats: subscriberStats ?? this.subscriberStats,
      localStats: localStats ?? this.localStats,
      latencyHistory: latencyHistory ?? this.latencyHistory,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      participantCount: participantCount ?? this.participantCount,
      anonymousParticipantCount:
          anonymousParticipantCount ?? this.anonymousParticipantCount,
      custom: custom ?? this.custom,
    );
  }

  CallState copyFromMetadata(CallMetadata metadata) {
    final capabilities = metadata.details.ownCapabilities.toList();

    return copyWith(
      isBackstage: metadata.details.backstage,
      isRecording: metadata.details.recording,
      isTranscribing: metadata.details.transcribing,
      isBroadcasting: metadata.details.broadcasting,
      blockedUserIds: metadata.details.blockedUserIds.toList(),
      createdAt: metadata.details.createdAt,
      updatedAt: metadata.details.updatedAt,
      startsAt: metadata.details.startsAt,
      endedAt: metadata.details.endedAt,
      createdByUserId: metadata.details.createdBy.id,
      custom: metadata.details.custom,
      egress: metadata.details.egress,
      rtmpIngress: metadata.details.rtmpIngress,
      settings: metadata.settings,
      ownCapabilities: capabilities.isEmpty ? null : capabilities,
      liveStartedAt: metadata.session.liveStartedAt,
      liveEndedAt: metadata.session.liveEndedAt,
      timerEndsAt: metadata.session.timerEndsAt,
    );
  }

  @override
  List<Object?> get props => [
        currentUserId,
        callCid,
        createdByUserId,
        sessionId,
        status,
        isRecording,
        isTranscribing,
        isBroadcasting,
        isBackstage,
        settings,
        egress,
        rtmpIngress,
        videoInputDevice,
        audioInputDevice,
        audioOutputDevice,
        ownCapabilities,
        callParticipants,
        createdAt,
        updatedAt,
        startsAt,
        endedAt,
        liveStartedAt,
        liveEndedAt,
        timerEndsAt,
        publisherStats,
        subscriberStats,
        localStats,
        latencyHistory,
        blockedUserIds,
        participantCount,
        anonymousParticipantCount,
        custom,
      ];

  @override
  String toString() {
    return 'CallState(status: $status, currentUserId: $currentUserId,'
        ' callCid: $callCid, createdByUserId: $createdByUserId,'
        ' sessionId: $sessionId, isRecording: $isRecording,'
        ' settings: $settings, egress: $egress, '
        ' videoInputDevice: $videoInputDevice,'
        ' audioInputDevice: $audioInputDevice,'
        ' audioOutputDevice: $audioOutputDevice,'
        ' ownCapabilities: $ownCapabilities,'
        ' callParticipants: $callParticipants)';
  }
}
