import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../sfu/data/models/sfu_connection_quality.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../sorting/call_participant_sorting_presets.dart';
import '../utils/string.dart';
import 'call_reaction.dart';
import 'call_track_state.dart';
import 'user_info.dart';
import 'viewport_visibility.dart';

@immutable
class CallParticipantState
    with EquatableMixin
    implements Comparable<CallParticipantState> {
  const CallParticipantState({
    required this.userId,
    required this.roles,
    required this.name,
    required this.custom,
    this.image,
    required this.sessionId,
    required this.trackIdPrefix,
    this.publishedTracks = const {},
    this.isLocal = false,
    this.connectionQuality = SfuConnectionQuality.unspecified,
    this.isOnline = false,
    this.audioLevel = 0,
    this.isSpeaking = false,
    this.isDominantSpeaker = false,
    this.isPinned = false,
    this.reaction,
    this.viewportVisibility = ViewportVisibility.unknown,
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
  final bool isOnline;
  final double audioLevel;
  final bool isSpeaking;
  final bool isDominantSpeaker;
  final bool isPinned;
  final CallReaction? reaction;
  final ViewportVisibility viewportVisibility;

  /// Returns a copy of this [CallParticipantState] with the given fields
  /// replaced with the new values.
  CallParticipantState copyWith({
    String? userId,
    List<String>? roles,
    String? name,
    Map<String, Object?>? custom,
    String? image,
    String? sessionId,
    String? trackIdPrefix,
    Map<SfuTrackType, TrackState>? publishedTracks,
    bool? isLocal,
    SfuConnectionQuality? connectionQuality,
    bool? isOnline,
    double? audioLevel,
    bool? isSpeaking,
    bool? isDominantSpeaker,
    bool? isPinned,
    CallReaction? reaction,
    ViewportVisibility? viewportVisibility,
  }) {
    return CallParticipantState(
      userId: userId ?? this.userId,
      roles: roles ?? this.roles,
      name: name ?? this.name,
      custom: custom ?? this.custom,
      image: image ?? this.image,
      sessionId: sessionId ?? this.sessionId,
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      publishedTracks: publishedTracks ?? this.publishedTracks,
      isLocal: isLocal ?? this.isLocal,
      connectionQuality: connectionQuality ?? this.connectionQuality,
      isOnline: isOnline ?? this.isOnline,
      audioLevel: audioLevel ?? this.audioLevel,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isDominantSpeaker: isDominantSpeaker ?? this.isDominantSpeaker,
      isPinned: isPinned ?? this.isPinned,
      reaction: reaction ?? this.reaction,
      viewportVisibility: viewportVisibility ?? this.viewportVisibility,
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
        'isLocal: $isLocal, '
        'connectionQuality: $connectionQuality, isOnline: $isOnline, '
        'audioLevel: $audioLevel, isSpeaking: $isSpeaking, '
        'isDominantSpeaker: $isDominantSpeaker, isPinned: $isPinned, '
        'reaction: $reaction, viewportVisibility: $viewportVisibility}';
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
        isLocal,
        connectionQuality,
        isOnline,
        audioLevel,
        isSpeaking,
        isDominantSpeaker,
        isPinned,
        reaction,
        viewportVisibility,
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

  UserInfo toUserInfo() => UserInfo(
        id: userId,
        role: roles.firstOrNull ?? '',
        name: name.ifEmpty(() => userId),
        image: image,
      );
}
