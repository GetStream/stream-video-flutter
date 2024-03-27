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
      videoInputDevice: null,
      audioInputDevice: null,
      audioOutputDevice: null,
      ownCapabilities: List.unmodifiable(const []),
      callParticipants: List.unmodifiable(const []),
      createdAt: null,
      startsAt: null,
      endedAt: null,
      liveStartedAt: null,
      liveEndedAt: null,
      publisherStats: null,
      subscriberStats: null,
      localStats: null,
      latencyHistory: const [],
    );
  }

  factory CallState.fromMetadata({
    required String currentUserId,
    required StreamCallCid callCid,
    required bool ringing,
    required CallMetadata metadata,
  }) {
    return CallState._(
      currentUserId: currentUserId,
      callCid: callCid,
      createdByUserId: metadata.details.createdBy.id,
      isRingingFlow: ringing,
      sessionId: '',
      status: metadata.toCallStatus(currentUserId, ringing: ringing),
      isRecording: metadata.details.recording,
      isBroadcasting: metadata.details.broadcasting,
      isTranscribing: metadata.details.transcribing,
      isBackstage: metadata.details.backstage,
      settings: metadata.settings,
      egress: metadata.details.egress,
      videoInputDevice: null,
      audioInputDevice: null,
      audioOutputDevice: null,
      ownCapabilities: List.unmodifiable(metadata.details.ownCapabilities),
      callParticipants: List.unmodifiable(
        metadata.toCallParticipants(
          currentUserId,
        ),
      ),
      createdAt: null,
      startsAt: null,
      endedAt: null,
      liveStartedAt: null,
      liveEndedAt: null,
      publisherStats: null,
      subscriberStats: null,
      localStats: null,
      latencyHistory: const [],
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
    required this.ownCapabilities,
    required this.callParticipants,
    required this.videoInputDevice,
    required this.audioInputDevice,
    required this.audioOutputDevice,
    required this.createdAt,
    required this.startsAt,
    required this.endedAt,
    required this.liveStartedAt,
    required this.liveEndedAt,
    required this.publisherStats,
    required this.subscriberStats,
    required this.localStats,
    required this.latencyHistory,
  });

  final String currentUserId;
  final StreamCallCid callCid;
  final String createdByUserId;
  final bool isRingingFlow;
  final String sessionId;
  final CallStatus status;
  final CallSettings settings;
  final CallEgress egress;
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
  final DateTime? liveStartedAt;
  final DateTime? liveEndedAt;
  final PeerConnectionStats? publisherStats;
  final PeerConnectionStats? subscriberStats;
  final LocalStats? localStats;
  final List<int> latencyHistory;

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
    RtcMediaDevice? videoInputDevice,
    RtcMediaDevice? audioInputDevice,
    RtcMediaDevice? audioOutputDevice,
    List<CallPermission>? ownCapabilities,
    List<CallParticipantState>? callParticipants,
    DateTime? createdAt,
    DateTime? startsAt,
    DateTime? endedAt,
    DateTime? liveStartedAt,
    DateTime? liveEndedAt,
    PeerConnectionStats? publisherStats,
    PeerConnectionStats? subscriberStats,
    LocalStats? localStats,
    List<int>? latencyHistory,
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
      videoInputDevice: videoInputDevice ?? this.videoInputDevice,
      audioInputDevice: audioInputDevice ?? this.audioInputDevice,
      audioOutputDevice: audioOutputDevice ?? this.audioOutputDevice,
      ownCapabilities: ownCapabilities ?? this.ownCapabilities,
      callParticipants: callParticipants ?? this.callParticipants,
      createdAt: createdAt ?? this.createdAt,
      startsAt: startsAt ?? this.startsAt,
      endedAt: endedAt ?? this.endedAt,
      liveStartedAt: liveStartedAt ?? this.liveStartedAt,
      liveEndedAt: liveEndedAt ?? this.liveEndedAt,
      publisherStats: publisherStats ?? this.publisherStats,
      subscriberStats: subscriberStats ?? this.subscriberStats,
      localStats: localStats ?? this.localStats,
      latencyHistory: latencyHistory ?? this.latencyHistory,
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
        videoInputDevice,
        audioInputDevice,
        audioOutputDevice,
        ownCapabilities,
        callParticipants,
        createdAt,
        startsAt,
        endedAt,
        liveStartedAt,
        liveEndedAt,
        publisherStats,
        subscriberStats,
        localStats,
        latencyHistory,
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

extension on CallMetadata {
  CallStatus toCallStatus(
    String currentUserId, {
    required bool ringing,
  }) {
    final createdByMe = currentUserId == details.createdBy.id;
    if (createdByMe && ringing) {
      return CallStatus.outgoing();
    } else if (!createdByMe && ringing) {
      return CallStatus.incoming();
    } else {
      return CallStatus.idle();
    }
  }

  List<CallParticipantState> toCallParticipants(String currentUserId) {
    final result = <CallParticipantState>[];
    for (final userId in members.keys) {
      final member = members[userId];
      final user = users[userId];
      final isLocal = currentUserId == userId;
      result.add(
        CallParticipantState(
          userId: userId,
          role: member?.role ?? user?.role ?? '',
          name: user?.name ?? '',
          custom: user?.custom ?? {},
          image: user?.image ?? '',
          sessionId: '',
          trackIdPrefix: '',
          isLocal: isLocal,
          isOnline: !isLocal,
        ),
      );
    }
    return result;
  }
}
