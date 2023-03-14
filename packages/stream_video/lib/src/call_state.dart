import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'call_participant_state.dart';
import 'call_permission.dart';
import 'models/call_cid.dart';
import 'models/call_metadata.dart';
import 'models/call_setting.dart';
import 'models/call_status.dart';

/// TODO - Class that holds any information about the call, including participants
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
      sessionId: '',
      status: CallStatus.idle(),
      isRecording: false,
      settings: const CallSettings.disabled(),
      ownCapabilities: List.unmodifiable(const []),
      callParticipants: List.unmodifiable(const []),
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
      createdByUserId: metadata.info.createdByUserId,
      sessionId: '',
      status: metadata.toCallStatus(currentUserId, ringing: ringing),
      isRecording: false,
      settings: metadata.details.settings,
      ownCapabilities: List.unmodifiable(metadata.details.ownCapabilities),
      callParticipants: List.unmodifiable(
        metadata.toCallParticipants(
          currentUserId,
        ),
      ),
    );
  }

  /// TODO
  const CallState._({
    required this.currentUserId,
    required this.callCid,
    required this.createdByUserId,
    required this.sessionId,
    required this.status,
    required this.isRecording,
    required this.settings,
    required this.ownCapabilities,
    required this.callParticipants,
  });

  final String currentUserId;
  final StreamCallCid callCid;
  final String createdByUserId;
  final String sessionId;
  final CallStatus status;
  final bool isRecording;
  final CallSettings settings;
  final List<CallPermission> ownCapabilities;
  final List<CallParticipantState> callParticipants;

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
    String? sessionId,
    CallStatus? status,
    bool? isRecording,
    CallSettings? settings,
    List<CallPermission>? ownCapabilities,
    List<CallParticipantState>? callParticipants,
  }) {
    return CallState._(
      currentUserId: currentUserId ?? this.currentUserId,
      callCid: callCid ?? this.callCid,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      sessionId: sessionId ?? this.sessionId,
      status: status ?? this.status,
      isRecording: isRecording ?? this.isRecording,
      settings: settings ?? this.settings,
      ownCapabilities: ownCapabilities ?? this.ownCapabilities,
      callParticipants: callParticipants ?? this.callParticipants,
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
        settings,
        ownCapabilities,
        callParticipants,
      ];

  @override
  String toString() {
    return 'CallState{currentUserId: $currentUserId, callCid: $callCid, '
        'createdByUserId: $createdByUserId, status: $status, '
        'isRecordingInProgress: $isRecording, settings: $settings, '
        'ownCapabilities: $ownCapabilities, '
        'sessionId: $sessionId, callParticipants: $callParticipants}';
  }
}

extension on CallMetadata {
  CallStatus toCallStatus(
    String currentUserId, {
    required bool ringing,
  }) {
    final createdByMe = currentUserId == info.createdByUserId;
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
    for (final userId in details.members.keys) {
      final member = details.members[userId];
      final user = users[userId];
      final isLocal = currentUserId == userId;
      result.add(
        CallParticipantState(
          userId: userId,
          role: member?.role ?? user?.role ?? '',
          name: user?.name ?? '',
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
