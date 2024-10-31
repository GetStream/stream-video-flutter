import 'package:state_notifier/state_notifier.dart';

import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_track_state.dart';
import '../../../models/viewport_visibility.dart';
import '../../../sfu/data/models/sfu_track_type.dart';
import '../../../webrtc/media/constraints/camera_position.dart';
import '../../../webrtc/model/rtc_video_dimension.dart';
import '../../../webrtc/rtc_media_device/rtc_media_device.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateParticipantMixin on StateNotifier<CallState> {
  void setParticipantPinned({
    required String sessionId,
    required String userId,
    required bool pinned,
  }) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.sessionId == sessionId &&
            participant.userId == userId) {
          return participant.copyWith(isPinned: pinned);
        }

        return participant;
      }).toList(),
    );
  }

  void participantUpdateViewportVisibility({
    required String sessionId,
    required String userId,
    required ViewportVisibility visibility,
  }) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.sessionId == sessionId &&
            participant.userId == userId) {
          return participant.copyWith(
            viewportVisibility: visibility,
          );
        }

        return participant;
      }).toList(),
    );
  }

  void participantUpdateSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) {
    _logger.d(
      () => '[participantUpdateSubscription] #${state.sessionId};',
    );

    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final trackState = participant.publishedTracks[trackType];

        if (participant.userId == userId &&
            participant.sessionId == sessionId &&
            trackState is RemoteTrackState) {
          _logger
              .v(() => '[participantUpdateSubscription] pFound: $participant');

          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              trackType: trackState.copyWith(
                subscribed: true,
                videoDimension: videoDimension,
              ),
            },
          );
        }

        _logger.v(() => '[participantUpdateSubscription] pSame: $participant');
        return participant;
      }).toList(),
    );
  }

  void participantRemoveSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
  }) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.userId == userId &&
            participant.sessionId == sessionId) {
          final trackState = participant.publishedTracks[trackType];
          if (trackState is RemoteTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                trackType: trackState.copyWith(
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

  void participantSetAudioOutputDevice({
    required RtcMediaDevice device,
  }) {
    state = state.copyWith(
      audioOutputDevice: device,
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) return participant;

        final trackState = participant.publishedTracks[SfuTrackType.audio];
        if (trackState is! RemoteTrackState) return participant;

        return participant.copyWith(
          publishedTracks: {
            ...participant.publishedTracks,
            SfuTrackType.audio: trackState.copyWith(
              audioSinkDevice: device,
            ),
          },
        );
      }).toList(),
    );
  }

  void participantUpdateCameraPosition({
    required CameraPosition cameraPosition,
  }) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.video];
          if (trackState is LocalTrackState) {
            // Creating a new track state to reset the source device.
            // CopyWith doesn't support null values.
            final newTrackState = TrackState.local(
              muted: trackState.muted,
              cameraPosition: cameraPosition,
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

  void participantFlipCamera() {
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

  void participantSetVideoInputDevice({
    required RtcMediaDevice device,
  }) {
    state = state.copyWith(
      videoInputDevice: device,
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.video];
          if (trackState is LocalTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.video: trackState.copyWith(
                  sourceDevice: device,
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

  void participantSetAudioInputDevice({
    required RtcMediaDevice device,
  }) {
    state = state.copyWith(
      audioInputDevice: device,
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.audio];
          if (trackState is LocalTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.audio: trackState.copyWith(
                  sourceDevice: device,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  void participantSetCameraEnabled({
    required bool enabled,
  }) {
    return _toggleTrackType(SfuTrackType.video, enabled);
  }

  void participantSetMicrophoneEnabled({
    required bool enabled,
  }) {
    return _toggleTrackType(SfuTrackType.audio, enabled);
  }

  void participantSetScreenShareEnabled({
    required bool enabled,
  }) {
    return _toggleTrackType(SfuTrackType.screenShare, enabled);
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

  void setParticipantsCount({
    required int totalCount,
    required int anonymousCount,
  }) {
    state = state.copyWith(
      participantCount: totalCount,
      anonymousParticipantCount: anonymousCount,
    );
  }
}
