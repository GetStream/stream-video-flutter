import 'package:state_notifier/state_notifier.dart';

import '../../../action/participant_action.dart';
import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_track_state.dart';
import '../../../sfu/data/models/sfu_track_type.dart';
import '../../../webrtc/media/constraints/camera_position.dart';
import '../../../webrtc/model/rtc_video_dimension.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateParticipantMixin on StateNotifier<CallState> {
  void setParticipantPinned(
    SetParticipantPinned action,
  ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.sessionId == action.sessionId) {
          return participant.copyWith(isPinned: action.pinned);
        }

        return participant;
      }).toList(),
    );
  }

  void participantUpdateViewportVisibility(
    UpdateViewportVisibility action,
  ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.sessionId == action.sessionId) {
          return participant.copyWith(
            viewportVisibility: action.visibility,
          );
        }

        return participant;
      }).toList(),
    );
  }

  void participantUpdateViewportVisibilities(
    UpdateViewportVisibilities action,
  ) {
    for (final action in action.actions) {
      participantUpdateViewportVisibility(action);
    }
  }

  void participantUpdateSubscriptions(
    UpdateSubscriptions action,
  ) {
    final sessionId = state.sessionId;
    _logger.d(
        () => '[participantUpdateSubscriptions] #$sessionId; action: $action');
    for (final action in action.actions) {
      if (action is UpdateSubscription) {
        participantUpdateSubscription(action);
      } else if (action is RemoveSubscription) {
        participantRemoveSubscription(action);
      }
    }
  }

  void participantUpdateSubscription(
    UpdateSubscription action,
  ) {
    _logger.d(() =>
        '[participantUpdateSubscription] #${state.sessionId}; action: $action');
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final trackState = participant.publishedTracks[action.trackType];
        if (participant.userId == action.userId &&
            participant.sessionId == action.sessionId &&
            trackState is RemoteTrackState) {
          _logger
              .v(() => '[participantUpdateSubscription] pFound: $participant');

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
        _logger.v(() => '[participantUpdateSubscription] pSame: $participant');
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
                  // TODO: Should be null, but copyWith doesn't allow it.
                  videoDimension: const RtcVideoDimension.zero(),
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
}
