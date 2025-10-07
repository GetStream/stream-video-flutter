import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../sfu/data/models/sfu_connection_quality.dart';
import '../sfu/data/models/sfu_participant_source.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../sorting/call_participant_sorting_presets.dart';
import '../utils/string.dart';
import 'call_participant_pin.dart';
import 'call_reaction.dart';
import 'call_track_state.dart';
import 'user_info.dart';
import 'viewport_visibility.dart';

@immutable
class CallParticipantState
    with EquatableMixin
    implements Comparable<CallParticipantState> {
  CallParticipantState({
    required this.userId,
    required this.roles,
    required this.name,
    required this.custom,
    this.image,
    required this.sessionId,
    required this.trackIdPrefix,
    this.publishedTracks = const {},
    this.pausedTracks = const {},
    this.isLocal = false,
    this.connectionQuality = SfuConnectionQuality.unspecified,
    this.isOnline = false,
    this.audioLevel = 0,
    List<double>? audioLevels,
    this.isSpeaking = false,
    this.isDominantSpeaker = false,
    this.pin,
    this.reaction,
    this.viewportVisibility = ViewportVisibility.unknown,
    this.screenShareViewportVisibility = ViewportVisibility.unknown,
    this.participantSource,
  }) : audioLevels = audioLevels ?? [audioLevel];

  /// Internal constructor to be used with copyWith methods
  CallParticipantState._({
    required this.userId,
    required this.roles,
    required this.name,
    required this.custom,
    required this.image,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.publishedTracks,
    required this.pausedTracks,
    required this.isLocal,
    required this.connectionQuality,
    required this.isOnline,
    required this.audioLevel,
    required this.audioLevels,
    required this.isSpeaking,
    required this.isDominantSpeaker,
    required this.pin,
    required this.reaction,
    required this.viewportVisibility,
    required this.screenShareViewportVisibility,
    required this.participantSource,
  });

  final String userId;
  final List<String> roles;
  final String name;
  final Map<String, Object?> custom;
  final String? image;
  final String sessionId;
  final String trackIdPrefix;
  final Map<SfuTrackType, TrackState> publishedTracks;
  final bool isLocal;
  final SfuConnectionQuality connectionQuality;
  final SfuParticipantSource? participantSource;
  final bool isOnline;

  /// The latest audio level for the user.
  final double audioLevel;

  /// List of the last 10 audio levels.
  final List<double> audioLevels;

  /// A list of tracks that are currently paused by our servers.
  /// Typically, a server-side pause happens when the local participant doesn't
  /// have enough bandwidth to receive all tracks. In this case, the server
  /// will pause some tracks to optimize the bandwidth usage.
  /// Once the bandwidth is restored, the server will resume the paused tracks.
  /// This is useful to avoid any unwanted video and audio artifacts.
  final Set<SfuTrackType> pausedTracks;

  final bool isSpeaking;
  final bool isDominantSpeaker;
  final CallParticipantPin? pin;
  final CallReaction? reaction;
  final ViewportVisibility viewportVisibility;
  final ViewportVisibility screenShareViewportVisibility;

  bool get isPinned => pin != null;
  String get uniqueParticipantKey => '$userId-$sessionId';

  /// Returns a copy of this [CallParticipantState] with the given fields
  /// replaced with the new values.
  ///
  /// If you want to update the audioLevel, consider using [copyWithUpdatedAudioLevels].
  CallParticipantState copyWith({
    String? userId,
    List<String>? roles,
    String? name,
    Map<String, Object?>? custom,
    String? image,
    String? sessionId,
    String? trackIdPrefix,
    Map<SfuTrackType, TrackState>? publishedTracks,
    Set<SfuTrackType>? pausedTracks,
    bool? isLocal,
    SfuConnectionQuality? connectionQuality,
    bool? isOnline,
    double? audioLevel,
    List<double>? audioLevels,
    bool? isSpeaking,
    bool? isDominantSpeaker,
    CallParticipantPin? pin,
    CallReaction? reaction,
    ViewportVisibility? viewportVisibility,
    ViewportVisibility? screenShareViewportVisibility,
    SfuParticipantSource? participantSource,
  }) {
    return CallParticipantState._(
      userId: userId ?? this.userId,
      roles: roles ?? this.roles,
      name: name ?? this.name,
      custom: custom ?? this.custom,
      image: image ?? this.image,
      sessionId: sessionId ?? this.sessionId,
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      publishedTracks: publishedTracks ?? this.publishedTracks,
      pausedTracks: pausedTracks ?? this.pausedTracks,
      isLocal: isLocal ?? this.isLocal,
      connectionQuality: connectionQuality ?? this.connectionQuality,
      isOnline: isOnline ?? this.isOnline,
      audioLevel: audioLevel ?? this.audioLevel,
      audioLevels: audioLevels ?? this.audioLevels,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isDominantSpeaker: isDominantSpeaker ?? this.isDominantSpeaker,
      pin: pin ?? this.pin,
      reaction: reaction ?? this.reaction,
      viewportVisibility: viewportVisibility ?? this.viewportVisibility,
      screenShareViewportVisibility:
          screenShareViewportVisibility ?? this.screenShareViewportVisibility,
      participantSource: participantSource ?? this.participantSource,
    );
  }

  /// Copies the current state and adds the latest [audioLevel] to the last 10 [audioLevels].
  CallParticipantState copyWithUpdatedAudioLevels({
    required double audioLevel,
    bool? isSpeaking,
  }) {
    final levels = audioLevels;
    levels.add(audioLevel);
    while (levels.length > 10) {
      levels.removeAt(0);
    }

    return copyWith(
      audioLevel: audioLevel,
      audioLevels: audioLevels,
      isSpeaking: isSpeaking,
    );
  }

  CallParticipantState copyWithPin({
    required CallParticipantPin? participantPin,
  }) {
    return CallParticipantState._(
      userId: userId,
      roles: roles,
      name: name,
      custom: custom,
      image: image,
      sessionId: sessionId,
      trackIdPrefix: trackIdPrefix,
      publishedTracks: publishedTracks,
      pausedTracks: pausedTracks,
      isLocal: isLocal,
      connectionQuality: connectionQuality,
      isOnline: isOnline,
      audioLevel: audioLevel,
      audioLevels: audioLevels,
      isSpeaking: isSpeaking,
      isDominantSpeaker: isDominantSpeaker,
      pin: participantPin,
      reaction: reaction,
      viewportVisibility: viewportVisibility,
      screenShareViewportVisibility: screenShareViewportVisibility,
      participantSource: participantSource,
    );
  }

  /// Returns a copy of this [CallParticipantState] with the [reaction] updated.
  ///
  /// This can be used any time you want to update the reaction, but mainly helps
  /// to set it to `null`.
  CallParticipantState copyWithReaction({
    required CallReaction? reaction,
  }) {
    return CallParticipantState._(
      userId: userId,
      roles: roles,
      name: name,
      custom: custom,
      image: image,
      sessionId: sessionId,
      trackIdPrefix: trackIdPrefix,
      publishedTracks: publishedTracks,
      pausedTracks: pausedTracks,
      isLocal: isLocal,
      connectionQuality: connectionQuality,
      isOnline: isOnline,
      audioLevel: audioLevel,
      audioLevels: audioLevels,
      isSpeaking: isSpeaking,
      isDominantSpeaker: isDominantSpeaker,
      pin: pin,
      reaction: reaction,
      viewportVisibility: viewportVisibility,
      screenShareViewportVisibility: screenShareViewportVisibility,
      participantSource: participantSource,
    );
  }

  /// Compares two participants.
  ///
  /// The comparison is based on the [CallParticipantSortingPresets.regular].
  ///
  /// Returns a negative integer, zero, or a positive integer as this object is
  /// less than, equal to, or greater than [other].
  ///
  /// See also:
  ///
  /// * [CallParticipantSortingPresets.regular]
  /// * [CallParticipantSortingPresets.speaker]
  /// * [CallParticipantSortingPresets.livestreamOrAudioRoom]
  @override
  int compareTo(CallParticipantState other) {
    return CallParticipantSortingPresets.regular(this, other);
  }

  @override
  String toString() {
    return 'CallParticipantState{userId: $userId, role: $roles, name: $name, '
        'sessionId: $sessionId, '
        'trackId: $trackIdPrefix, image: $image, '
        'publishedTracks: $publishedTracks, '
        'pausedTracks: $pausedTracks, '
        'isLocal: $isLocal, '
        'connectionQuality: $connectionQuality, isOnline: $isOnline, '
        'audioLevel: $audioLevel, audioLevels: $audioLevels, isSpeaking: $isSpeaking, '
        'isDominantSpeaker: $isDominantSpeaker, isPinned: $isPinned, '
        'reaction: $reaction, viewportVisibility: $viewportVisibility, '
        'screenShareViewportVisibility: $screenShareViewportVisibility, '
        'participantSource: $participantSource}';
  }

  @override
  List<Object?> get props => [
    userId,
    roles,
    name,
    custom,
    image,
    sessionId,
    trackIdPrefix,
    publishedTracks,
    pausedTracks,
    isLocal,
    connectionQuality,
    isOnline,
    audioLevel,
    audioLevels,
    isSpeaking,
    isDominantSpeaker,
    pin,
    reaction,
    viewportVisibility,
    screenShareViewportVisibility,
    participantSource,
  ];

  TrackState? get videoTrack {
    return publishedTracks[SfuTrackType.video];
  }

  TrackState? get audioTrack {
    return publishedTracks[SfuTrackType.audio];
  }

  TrackState? get screenShareTrack {
    return publishedTracks[SfuTrackType.screenShare];
  }

  bool get isAudioEnabled {
    return !(audioTrack?.muted ?? true);
  }

  bool get isVideoEnabled {
    return !(videoTrack?.muted ?? true);
  }

  bool get isScreenShareEnabled {
    return !(screenShareTrack?.muted ?? true);
  }

  bool isTrackPaused(SfuTrackType trackType) {
    return pausedTracks.contains(trackType);
  }

  UserInfo toUserInfo() => UserInfo(
    id: userId,
    role: roles.firstOrNull ?? '',
    name: name.ifEmpty(() => userId),
    image: image,
  );
}
