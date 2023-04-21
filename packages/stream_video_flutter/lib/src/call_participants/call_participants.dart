import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'layout/participant_layout_mode.dart';
import 'regular_call_participants_content.dart';
import 'screen_share_call_participants_content.dart';

/// Builder function used to build a participant item.
typedef CallParticipantBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// Builder function used to build a screen sharing content.
typedef ScreenShareContentBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// Builder function used to build participant item in screen sharing mode.
typedef ScreenShareParticipantBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallParticipantState participant,
);

/// A function used to sort the participants.
typedef Filter<T> = bool Function(T element);

/// Comparator used to sort the participants.
typedef Sort<T> = Comparator<T>;

/// Widget that renders all the [StreamCallParticipant], based on the number
/// of people in a call.
class StreamCallParticipants extends StatelessWidget {
  /// Creates a new instance of [StreamCallParticipant].
  StreamCallParticipants({
    super.key,
    required this.call,
    required this.participants,
    this.filter = _defaultFilter,
    Sort<CallParticipantState>? sort,
    this.enableLocalVideo,
    this.callParticipantBuilder = _defaultParticipantBuilder,
    this.localVideoParticipantBuilder,
    this.screenShareContentBuilder,
    this.screenShareParticipantBuilder = _defaultParticipantBuilder,
    this.layoutMode = ParticipantLayoutMode.grid,
  }) : sort = sort ?? layoutMode.sorting;

  /// Represents a call.
  final Call call;

  /// The list of participants to display.
  final Iterable<CallParticipantState> participants;

  /// Used for filtering the call participants.
  final Filter<CallParticipantState> filter;

  /// Used for sorting the call participants.
  final Sort<CallParticipantState> sort;

  /// Enable local video view for the local participant.
  final bool? enableLocalVideo;

  /// Builder function used to build a participant grid item.
  final CallParticipantBuilder callParticipantBuilder;

  /// Builder function used to build a local video participant widget.
  final CallParticipantBuilder? localVideoParticipantBuilder;

  /// Builder function used to build a screen sharing item.
  final ScreenShareContentBuilder? screenShareContentBuilder;

  /// Builder function used to build participant item in screen sharing mode.
  final ScreenShareParticipantBuilder screenShareParticipantBuilder;

  /// The layout mode used to display the participants.
  final ParticipantLayoutMode layoutMode;

  // The default participant filter.
  static bool _defaultFilter(CallParticipantState participant) => true;

  // The default participant builder.
  static Widget _defaultParticipantBuilder(
    BuildContext context,
    Call call,
    CallParticipantState participant,
  ) {
    return StreamCallParticipant(
      // We use the sessionId as the key to avoid rebuilding the widget
      // when the participant changes.
      key: ValueKey(participant.sessionId),
      call: call,
      participant: participant,
    );
  }

  final _participants = [
    CallParticipantState(
      name: 'A',
      userId: '1',
      sessionId: '1',
      role: 'admin',
      trackIdPrefix: '1',
      // publishedTracks: {
      //   SfuTrackType.audio: TrackState.remote(),
      //   SfuTrackType.video: TrackState.remote(),
      // },
      connectionQuality: SfuConnectionQuality.excellent,
      isSpeaking: false,
      isDominantSpeaker: false,
      audioLevel: 0,
      viewportVisibility: const ViewportVisibility.visible(size: Size(50, 50)),
      isPinned: false,
      isLocal: false,
    ),

    // Presenter, video, audio
    CallParticipantState(
      name: 'B',
      userId: '2',
      sessionId: '2',
      role: 'admin',
      trackIdPrefix: '2',
      // publishedTracks: {
      //   SfuTrackType.audio: TrackState.remote(),
      //   SfuTrackType.video: TrackState.remote(),
      //   SfuTrackType.screenShare: TrackState.remote(),
      // },
      connectionQuality: SfuConnectionQuality.excellent,
      isSpeaking: false,
      isDominantSpeaker: false,
      audioLevel: 0,
      viewportVisibility: const ViewportVisibility.visible(size: Size(50, 50)),
      isPinned: false,
      isLocal: false,
    ),

    // Muted
    const CallParticipantState(
      name: 'C',
      userId: '3',
      sessionId: '3',
      role: 'admin',
      trackIdPrefix: '3',
      // publishedTracks: const {},
      connectionQuality: SfuConnectionQuality.excellent,
      isSpeaking: false,
      isDominantSpeaker: false,
      audioLevel: 0,
      viewportVisibility: ViewportVisibility.visible(size: Size(50, 50)),
      isPinned: false,
      isLocal: false,
    ),

    // Dominant speaker
    CallParticipantState(
      name: 'D',
      userId: '4',
      sessionId: '4',
      role: 'admin',
      trackIdPrefix: '4',
      // publishedTracks: {SfuTrackType.audio: TrackState.remote()},
      connectionQuality: SfuConnectionQuality.excellent,
      isSpeaking: false,
      isDominantSpeaker: true,
      audioLevel: 0,
      viewportVisibility: const ViewportVisibility.visible(size: Size(50, 50)),
      isPinned: false,
      isLocal: false,
    ),

    // Presenter only
    CallParticipantState(
      name: 'E',
      userId: '5',
      sessionId: '5',
      role: 'admin',
      trackIdPrefix: '5',
      // publishedTracks: {SfuTrackType.screenShare: TrackState.remote()},
      connectionQuality: SfuConnectionQuality.excellent,
      isSpeaking: false,
      isDominantSpeaker: false,
      audioLevel: 0,
      viewportVisibility: const ViewportVisibility.visible(size: Size(50, 50)),
      isPinned: false,
      isLocal: false,
    ),

    // pinned
    CallParticipantState(
      name: 'F',
      userId: '6',
      sessionId: '6',
      role: 'admin',
      trackIdPrefix: '6',
      // publishedTracks: {
      //   SfuTrackType.audio: TrackState.remote(),
      //   SfuTrackType.video: TrackState.remote()
      // },
      connectionQuality: SfuConnectionQuality.excellent,
      isSpeaking: false,
      isDominantSpeaker: false,
      audioLevel: 0,
      viewportVisibility: const ViewportVisibility.visible(size: Size(50, 50)),
      isPinned: true,
      isLocal: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final participants = [...this.participants].where(filter);

    final screenShareParticipant = participants.firstWhereOrNull(
      (it) {
        final screenShareTrack = it.screenShareTrack;
        final isScreenShareEnabled = it.isScreenShareEnabled;

        // If the screen share track is local, we don't have to subscribe to
        // anything and we can directly use the mute state.
        if (screenShareTrack is! RemoteTrackState) return isScreenShareEnabled;

        // If the screen share track is remote and already subscribed and
        // received, we can directly use the mute state.
        if (screenShareTrack.subscribed && screenShareTrack.received) {
          return isScreenShareEnabled;
        }

        // If it's not yet subscribed, we have to show it in order for it to
        // start the subscription process.
        return true;
      },
    );

    if (screenShareParticipant != null) {
      return ScreenShareCallParticipantsContent(
        call: call,
        participants: participants,
        screenSharingParticipant: screenShareParticipant,
        screenShareContentBuilder: screenShareContentBuilder,
        screenShareParticipantBuilder: screenShareParticipantBuilder,
      );
    }

    return RegularCallParticipantsContent(
      call: call,
      participants: participants,
      layoutMode: layoutMode,
      enableLocalVideo: enableLocalVideo,
      callParticipantBuilder: callParticipantBuilder,
      localVideoParticipantBuilder: localVideoParticipantBuilder,
    );
  }
}
