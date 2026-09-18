import 'dart:collection';

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
class CallParticipantState extends Equatable
    implements Comparable<CallParticipantState> {
  CallParticipantState({
    required this.userId,
    required this.roles,
    required this.name,
    @Deprecated('Use customData instead') required this.custom,
    this.customData = const {},
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
  }) : audioLevels = _sealLevels(audioLevels ?? [audioLevel]);

  /// Internal constructor to be used with copyWith methods
  CallParticipantState._({
    required this.userId,
    required this.roles,
    required this.name,
    @Deprecated('Use customData instead') required this.custom,
    required this.customData,
    required this.image,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.publishedTracks,
    required this.pausedTracks,
    required this.isLocal,
    required this.connectionQuality,
    required this.isOnline,
    required this.audioLevel,
    required List<double> audioLevels,
    required this.isSpeaking,
    required this.isDominantSpeaker,
    required this.pin,
    required this.reaction,
    required this.viewportVisibility,
    required this.screenShareViewportVisibility,
    required this.participantSource,
  }) : audioLevels = _sealLevels(audioLevels);

  final String userId;
  final List<String> roles;
  final String name;
  @Deprecated('Use customData instead')
  final Map<String, Object?> custom;
  final Map<String, Object?> customData;
  final String? image;
  final String sessionId;
  final String trackIdPrefix;
  final Map<SfuTrackType, TrackState> publishedTracks;
  final bool isLocal;
  final SfuConnectionQuality connectionQuality;
  final SfuParticipantSource? participantSource;
  final bool isOnline;

  /// The most recent audio level retained for the user.
  ///
  /// Updates stop while a participant is silent, so this holds at the reading
  /// that took them below the speaking threshold rather than tracking every
  /// quiet sample after it. Use [isSpeaking] to tell the two apart.
  final double audioLevel;

  /// The last 10 values [audioLevel] took, oldest first.
  ///
  /// Unmodifiable — a participant's identity is how the SDK detects change, so
  /// mutating this in place would leave the UI stale rather than update it.
  /// Build a new list instead.
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

  /// Identity is used all over the SDK to tell whether a participant changed,
  /// which only holds while nothing mutates a collection in place. Handing out
  /// an unmodifiable view makes that an error rather than a silently stale UI.
  static List<double> _sealLevels(List<double> levels) {
    // Always copied, never just wrapped: a view writes through to whatever list
    // it was built over, including one an unmodifiable view already hides.
    return UnmodifiableListView(List<double>.of(levels));
  }

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
    Map<String, Object?>? customData,
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
      customData: customData ?? this.customData,
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
    final levels = [...audioLevels, audioLevel];
    if (levels.length > 10) {
      levels.removeRange(0, levels.length - 10);
    }

    return copyWith(
      audioLevel: audioLevel,
      audioLevels: levels,
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
      customData: customData,
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
      customData: customData,
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
    customData,
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
