import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../action/internal/coordinator_action.dart';
import '../action/internal/lifecycle_action.dart';
import '../action/internal/rtc_action.dart';
import '../action/participant_action.dart';
import '../call_state.dart';
import '../coordinator/models/coordinator_events.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_created_data.dart';
import '../models/call_metadata.dart';
import '../models/call_participant_state.dart';
import '../models/call_preferences.dart';
import '../models/call_status.dart';
import '../models/call_track_state.dart';
import '../models/disconnect_reason.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../utils/string.dart';
import '../webrtc/media/constraints/camera_position.dart';

final _logger = taggedLogger(tag: 'SV:CoordReducer');

class CallStateNotifier extends StateNotifier<CallState> {

  CallStateNotifier(super.initialState, this.callPreferences);

  final CallPreferences callPreferences;

  //////////// Coordinator Actions ////////////

  void coordinatorUpdateUsers(
    UpdateUsers action,
  ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map(
        (participant) {
          final user = action.users[participant.userId];
          if (user == null) return participant;
          return participant.copyWith(
            role: user.role,
            name: user.name,
            image: user.image,
          );
        },
      ).toList(),
    );
  }

  void coordinatorUpdateCallAccepted(
    CoordinatorCallAcceptedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusOutgoing) {
      _logger.w(() => '[reduceCallAccepted] rejected (status is not Outgoing)');
      return;
    }
    final participant = state.callParticipants.firstWhereOrNull((participant) {
      return participant.userId == event.acceptedByUserId;
    });
    if (participant == null) {
      _logger.w(() => '[reduceCallAccepted] rejected (accepted by non-Member)');
      return;
    }
    state = state.copyWith(
      status: CallStatus.outgoing(acceptedByCallee: true),
    );
  }

  void coordinatorUpdateCallRejected(
    CoordinatorCallRejectedEvent event,
  ) {
    final status = state.status;
    _logger.d(() => '[reduceCallRejected] state: $state');
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallRejected] rejected (status is not Active): $status',
      );
      return;
    }
    final participantIndex = state.callParticipants.indexWhere((participant) {
      return participant.userId == event.rejectedByUserId;
    });
    if (participantIndex == -1) {
      _logger.w(
        () => '[reduceCallRejected] rejected '
            '(by unknown user): ${event.rejectedByUserId}',
      );
      return;
    }
    final callParticipants = [...state.callParticipants];
    final removed = callParticipants.removeAt(participantIndex);
    if (removed.userId == state.currentUserId ||
        callParticipants.hasSingle(state.currentUserId)) {
      state = state.copyWith(
        status: CallStatus.disconnected(
          DisconnectReason.rejected(
            byUserId: removed.userId,
          ),
        ),
        sessionId: '',
        callParticipants: callParticipants,
      );
    }
    state = state.copyWith(
      callParticipants: callParticipants,
    );
  }

  void coordinatorCallEnded(
    CoordinatorCallEndedEvent event,
  ) {
    _logger.i(() => '[reduceCallCancelled] state: $state');
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(() => '[reduceCallEnded] rejected (status is not Active)');
      return;
    }
    if (state.callCid != event.callCid) {
      _logger.w(() => '[reduceCallEnded] rejected (invalid cid): $event');
      return;
    }
    // final participantIndex = state.callParticipants.indexWhere((participant) {
    //   return participant.userId == event.endedByUserId;
    // });
    // if (participantIndex == -1) {
    //   _logger.w(
    //     () => '[reduceCallEnded] rejected '
    //         '(by unknown user): ${event.endedByUserId}',
    //   );
    //   return state;
    // }
    // final callParticipants = [...state.callParticipants];
    // final removed = callParticipants.removeAt(participantIndex);
    // if (removed.userId == state.currentUserId ||
    //     callParticipants.hasSingle(state.currentUserId)) {
    //   return state.copyWith(
    //     status: CallStatus.disconnected(
    //       DisconnectReason.cancelled(
    //         byUserId: removed.userId,
    //       ),
    //     ),
    //     callParticipants: callParticipants,
    //   );
    // }
    // return state.copyWith(
    //   callParticipants: callParticipants,
    // );

    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
      callParticipants: const [],
    );
  }

  void coordinatorCallPermissionsUpdated(
    CoordinatorCallPermissionsUpdatedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallPermissionsUpdated] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      ownCapabilities: List.unmodifiable(
        event.ownCapabilities,
      ),
    );
  }

  void coordinatorCallRecordingStarted(
    CoordinatorCallRecordingStartedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallRecordingStarted] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isRecording: true,
    );
  }

  void coordinatorCallRecordingStopped(
    CoordinatorCallRecordingStoppedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallRecordingStopped] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isRecording: false,
    );
  }

  void coordinatorCallBroadcastingStarted(
    CoordinatorCallBroadcastingStartedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallBroadcastingStarted] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isBroadcasting: true,
    );
  }

  void coordinatorCallBroadcastingStopped(
    CoordinatorCallBroadcastingStoppedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallBroadcastingStopped] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isBroadcasting: false,
    );
  }

  //////////// Lifecycle Actions ////////////

  void lifecycleUpdateUserId(
    SetUserId action,
  ) {
    _logger.d(() => '[reduceUserId] state: $state');
    state = state.copyWith(
      currentUserId: action.userId,
      status: CallStatus.idle(),
      sessionId: '',
      callParticipants: const [],
    );
  }

  void lifecycleCallAccepted(
    CallAccepted action,
  ) {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[reduceCallAccepted] rejected (invalid status): $status',
      );
      return;
    }
    state = state.copyWith(
      status: CallStatus.incoming(acceptedByMe: true),
    );
  }

  void lifecycleCallRejected(
    CallRejected stage,
  ) {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[reduceCallRejected] rejected (invalid status): $status',
      );
      return;
    }
    _logger.i(() => '[reduceCallRejected] stage: $stage, state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.rejected(
          byUserId: state.currentUserId,
        ),
      ),
    );
  }

  void lifecycleCallEnded(
    CallEnded stage,
  ) {
    _logger.i(() => '[reduceCallEnded] stage: $stage, state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
      sessionId: '',
    );
  }

  void lifecycleCallCreated(
    CallCreated stage,
  ) {
    _logger.d(() => '[reduceCallCreated] state: $state');
    state = state.copyWith(
      status: stage.data.toCallStatus(state: state),
      createdByUserId: stage.data.metadata.details.createdBy.id,
      isRingingFlow: stage.data.ringing,
      settings: stage.data.metadata.settings,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(state),
    );
  }

  void lifecycleCallJoining(
    CallJoining stage,
  ) {
    _logger.d(() => '[reduceCallJoining] state: $state');
    state = state.copyWith(
      status: CallStatus.joining(),
    );
  }

  void lifecycleCallJoined(
    CallJoined stage,
  ) {
    final status = state.status.isJoining ? CallStatus.joined() : state.status;
    _logger.d(() => '[reduceCallJoined] state: $state;\nnewStatus: $status');
    state = state.copyWith(
      status: status,
      createdByUserId: stage.data.metadata.details.createdBy.id,
      settings: stage.data.metadata.settings,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(state),
    );
  }

  void lifecycleCallDisconnected(
    CallDisconnected stage,
  ) {
    _logger.w(() => '[reduceCallDisconnected] state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.cancelled(
          byUserId: state.currentUserId,
        ),
      ),
      sessionId: '',
      callParticipants: const [],
    );
  }

  void lifecycleCallTimeout(
    CallTimeout stage,
  ) {
    _logger.e(() => '[reduceCallTimeout] state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        const DisconnectReason.timeout(),
      ),
      sessionId: '',
    );
  }

  void lifecycleCallConnectingAction(
    CallConnecting stage,
  ) {
    _logger.d(() => '[reduceCallConnectingAction] state: $state');
    final CallStatus status;
    if (stage.attempt > 0) {
      status = CallStatus.reconnecting(stage.attempt);
    } else {
      status = CallStatus.connecting();
    }
    state = state.copyWith(
      status: status,
    );
  }

  void lifecycleCallConnectFailed(
    ConnectFailed stage,
  ) {
    _logger.e(() => '[reduceCallConnectFailed] state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.failure(stage.error),
      ),
    );
  }

  void lifecycleCallSessionStart(
    CallSessionStart action,
  ) {
    _logger.d(() => '[reduceCallSessionStart] state: $state');
    state = state.copyWith(
      sessionId: action.sessionId,
      //status: CallStatus.connecting(),
    );
  }

  void lifecycleCallConnected(
    CallConnected stage,
  ) {
    _logger.d(() => '[reduceCallConnected] state: $state');
    state = state.copyWith(
      status: CallStatus.connected(),
    );
  }

  //////////// Participant Actions ////////////

  void participantUpdateSubscriptions(
    UpdateSubscriptions action,
  ) {
    final sessionId = state.sessionId;
    _logger.d(() => '[reduceSubscriptions] #$sessionId; action: $action');
    for (final child in action.actions) {
      if (child is UpdateSubscription) {
        participantUpdateSubscription(child);
      } else if (child is RemoveSubscription) {
        participantRemoveSubscription(child);
      }
    }
  }

  void participantUpdateSubscription(
    UpdateSubscription action,
  ) {
    _logger.d(() => '[updateSub] #${state.sessionId}; action: $action');
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final trackState = participant.publishedTracks[action.trackType];
        if (participant.userId == action.userId &&
            participant.sessionId == action.sessionId &&
            trackState is RemoteTrackState) {
          _logger.v(() => '[updateSub] pFound: $participant');
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              action.trackType: trackState.copyWith(
                subscribed: true,
                videoDimension: action.videoDimension,
              ),
            },
          );
        }
        _logger.v(() => '[updateSub] pSame: $participant');
        return participant;
      }).toList(),
    );
  }

  void participantRemoveSubscription(
    RemoveSubscription action,
  ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.userId == action.userId &&
            participant.sessionId == action.sessionId) {
          final trackState = participant.publishedTracks[action.trackType];
          if (trackState is RemoteTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                action.trackType: trackState.copyWith(
                  subscribed: false,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  void participantSetAudioOutputDevice(
    SetAudioOutputDevice action,
  ) {
    state = state.copyWith(
      audioOutputDevice: action.device,
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) return participant;

        final trackState = participant.publishedTracks[SfuTrackType.audio];
        if (trackState is! RemoteTrackState) return participant;

        return participant.copyWith(
          publishedTracks: {
            ...participant.publishedTracks,
            SfuTrackType.audio: trackState.copyWith(
              audioSinkDevice: action.device,
            ),
          },
        );
      }).toList(),
    );
  }

  void participantUpdateCameraPosition(
    SetCameraPosition action,
  ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.video];
          if (trackState is LocalTrackState) {
            // Creating a new track state to reset the source device.
            // CopyWith doesn't support null values.
            final newTrackState = TrackState.local(
              muted: trackState.muted,
              cameraPosition: action.cameraPosition,
            );

            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.video: newTrackState,
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  void participantFlipCamera(
    FlipCamera action,
  ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.video];
          if (trackState is LocalTrackState) {
            // Creating a new track state to reset the source device.
            // CopyWith doesn't support null values.
            final newTrackState = TrackState.local(
              muted: trackState.muted,
              cameraPosition: trackState.cameraPosition?.flip(),
            );

            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.video: newTrackState,
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  void participantSetVideoInputDevice(
    SetVideoInputDevice action,
  ) {
    state = state.copyWith(
      videoInputDevice: action.device,
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.video];
          if (trackState is LocalTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.video: trackState.copyWith(
                  sourceDevice: action.device,
                  // reset camera position to default
                  cameraPosition: CameraPosition.front,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  void participantSetAudioInputDevice(
    SetAudioInputDevice action,
  ) {
    state = state.copyWith(
      audioInputDevice: action.device,
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.audio];
          if (trackState is LocalTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.audio: trackState.copyWith(
                  sourceDevice: action.device,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  void participantSetCameraEnabled(
    SetCameraEnabled action,
  ) {
    return _toggleTrackType(SfuTrackType.video, action.enabled);
  }

  void participantSetMicrophoneEnabled(
    SetMicrophoneEnabled action,
  ) {
    return _toggleTrackType(SfuTrackType.audio, action.enabled);
  }

  void participantSetScreenShareEnabled(
    SetScreenShareEnabled action,
  ) {
    return _toggleTrackType(SfuTrackType.screenShare, action.enabled);
  }

  void _toggleTrackType(
    SfuTrackType trackType,
    bool enabled,
  ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final publishedTracks = participant.publishedTracks;
          final trackState = publishedTracks[trackType] ?? TrackState.local();
          if (trackState is LocalTrackState) {
            var cameraPosition = trackState.cameraPosition;
            if (trackType == SfuTrackType.video && cameraPosition == null) {
              cameraPosition = CameraPosition.front;
            }
            return participant.copyWith(
              publishedTracks: {
                ...publishedTracks,
                trackType: trackState.copyWith(
                  muted: !enabled,
                  cameraPosition: cameraPosition,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  //////////// RTC Actions ////////////

  void rtcUpdateSubscriberTrack(
    UpdateSubscriberTrack action,
  ) {
    _logger.d(
      () => '[reduceSubTrackReceived] ${state.sessionId}; action: $action',
    );
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final trackState = participant.publishedTracks[action.trackType];
        if (participant.trackIdPrefix == action.trackIdPrefix &&
            trackState is RemoteTrackState) {
          _logger.v(
            () => '[reduceSubTrackReceived] pFound: $participant',
          );
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              action.trackType: trackState.copyWith(
                subscribed: true,
                received: true,
              )
            },
          );
        } else {
          _logger.v(() => '[reduceSubTrackReceived] pSame: $participant');
          return participant;
        }
      }).toList(),
    );
  }

  //////////// SFU Actions ////////////

  void sfuJoinResponse(
      SfuJoinResponseEvent event,
      ) {
    _logger.d(() => '[reduceJoinResponse] ${state.sessionId}; event: $event');
    final participants = event.callState.participants.map((aParticipant) {
      final isLocal = aParticipant.userId == state.currentUserId;
      final existing = state.callParticipants.firstWhereOrNull(
            (it) => it.userId == aParticipant.userId,
      );
      final existingName = existing?.name ?? '';
      final existingRole = existing?.role ?? '';
      final existingImage = existing?.image ?? '';
      return CallParticipantState(
        userId: aParticipant.userId,
        role: existingRole,
        name: aParticipant.userName.ifEmpty(() => existingName),
        image: aParticipant.userImage.ifEmpty(() => existingImage),
        sessionId: aParticipant.sessionId,
        trackIdPrefix: aParticipant.trackLookupPrefix,
        publishedTracks: {
          for (final track in aParticipant.publishedTracks)
            track: TrackState.base(isLocal: isLocal)
        },
        isLocal: isLocal,
        isOnline: !isLocal,
        isSpeaking: aParticipant.isSpeaking,
        audioLevel: aParticipant.audioLevel,
        isDominantSpeaker: aParticipant.isDominantSpeaker,
      );
    }).toList();

    state = state.copyWith(
      callParticipants: participants,
    );
  }

  void sfuTrackUnpublished(
      SfuTrackUnpublishedEvent event,
      ) {
    _logger.d(
          () => '[reduceTrackUnpublished] ${state.sessionId}; event: $event',
    );
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.userId == event.userId &&
            participant.sessionId == event.sessionId) {
          final trackState = participant.publishedTracks[event.trackType]
              ?.copyWith(muted: true);

          final publishedTracks = {
            ...participant.publishedTracks,
          };
          if (trackState != null) {
            publishedTracks[event.trackType] = trackState;
          }
          return participant.copyWith(
            publishedTracks: publishedTracks,
          );
        } else {
          return participant;
        }
      }).toList(),
    );
  }

  void sfuTrackPublished(
      SfuTrackPublishedEvent event,
      ) {
    _logger.d(() => '[reduceTrackPublished] ${state.sessionId}; event: $event');

    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.userId == event.userId &&
            participant.sessionId == event.sessionId) {
          _logger.v(() => '[reduceTrackPublished] pFound: $participant');

          final trackState = participant.publishedTracks[event.trackType]
              ?.copyWith(muted: false) ??
              TrackState.base(isLocal: participant.isLocal);
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              event.trackType: trackState,
            },
          );
        } else {
          _logger.v(() => '[reduceTrackPublished] pSame: $participant');
          return participant;
        }
      }).toList(),
    );
  }

  void sfuUpdateAudioLevelChanged(
      SfuAudioLevelChangedEvent event,
      ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final levelInfo = event.audioLevels.firstWhereOrNull((level) {
          return level.userId == participant.userId &&
              level.sessionId == participant.sessionId;
        });
        if (levelInfo != null) {
          return participant.copyWith(
            audioLevel: levelInfo.level,
            isSpeaking: levelInfo.isSpeaking,
          );
        } else {
          return participant;
        }
      }).toList(),
    );
  }

  void sfuDominantSpeakerChanged(
      SfuDominantSpeakerChangedEvent event,
      ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        // Mark the new dominant speaker
        if (participant.userId == event.userId &&
            participant.sessionId == event.sessionId) {
          return participant.copyWith(
            isDominantSpeaker: true,
          );
        }
        // Unmark the old dominant speaker
        if (participant.isDominantSpeaker) {
          return participant.copyWith(
            isDominantSpeaker: false,
          );
        }
        return participant;
      }).toList(),
    );
  }

  void sfuConnectionQualityChanged(
      SfuConnectionQualityChangedEvent event,
      ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final update = event.connectionQualityUpdates.firstWhereOrNull((it) {
          return it.userId == participant.userId &&
              it.sessionId == participant.sessionId;
        });
        if (state.sessionId == update?.sessionId) {
          return participant.copyWith(
            connectionQuality: update?.connectionQuality,
          );
        } else {
          return participant;
        }
      }).toList(),
    );
  }

  void sfuParticipantJoined(
      SfuParticipantJoinedEvent event,
      ) {
    _logger.d(
          () => '[reduceParticipantJoined] ${state.sessionId}; event: $event',
    );
    final isLocal = state.currentUserId == event.participant.userId;
    final participant = CallParticipantState(
      userId: event.participant.userId,
      role: '',
      name: event.participant.userName,
      image: event.participant.userImage,
      sessionId: event.participant.sessionId,
      trackIdPrefix: event.participant.trackLookupPrefix,
      isLocal: isLocal,
      isOnline: !isLocal,
    );
    state = state.copyWith(
      callParticipants: [
        ...state.callParticipants,
        participant,
      ],
    );
  }

  void sfuParticipantLeft(
      SfuParticipantLeftEvent event,
      ) {
    final callParticipants = [...state.callParticipants]..removeWhere(
          (participant) =>
      participant.userId == event.participant.userId &&
          participant.sessionId == event.participant.sessionId,
    );

    if (callParticipants.length == 1 &&
        callParticipants.first.userId == state.currentUserId &&
        state.isRingingFlow &&
        callPreferences.dropIfAloneInRingingFlow) {
      state = state.copyWith(
        status: CallStatus.disconnected(
          DisconnectReason.lastParticipantLeft(),
        ),
        callParticipants: callParticipants,
      );
    }
    state = state.copyWith(
      callParticipants: callParticipants,
    );
  }
}

extension on List<CallParticipantState> {
  bool hasSingle(String userId) {
    return length == 1 && firstOrNull?.userId == userId;
  }
}

extension on CallCreatedData {
  CallStatus toCallStatus({
    required CallState state,
  }) {
    final status = state.status;
    final createdByMe = state.currentUserId == metadata.details.createdBy.id;
    if (ringing && !status.isOutgoing && createdByMe) {
      return CallStatus.outgoing();
    } else if (ringing && !status.isIncoming && !createdByMe) {
      return CallStatus.incoming();
    } else {
      return status;
    }
  }
}

extension on CallMetadata {
  List<CallParticipantState> toCallParticipants(CallState state) {
    final result = <CallParticipantState>[];
    for (final userId in members.keys) {
      final member = members[userId];
      final user = users[userId];
      final isLocal = state.currentUserId == userId;
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
