import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'model/call_track_state.dart';
import 'sfu/data/models/sfu_connection_quality.dart';
import 'sfu/data/models/sfu_track_type.dart';

@immutable
class CallParticipantState with EquatableMixin {
  factory CallParticipantState({
    required String userId,
    required String role,
    required String name,
    String? profileImageURL,
    required String sessionId,
    required String trackIdPrefix,
    Map<SfuTrackType, TrackState> publishedTracks = const {},
    bool isLocal = false,
    SfuConnectionQuality connectionQuality = SfuConnectionQuality.unspecified,
    bool isOnline = false,
    double audioLevel = 0,
    bool isSpeaking = false,
    bool isDominantSpeaker = false,
  }) {
    return CallParticipantState._(
      userId: userId,
      role: role,
      name: name,
      profileImageURL: profileImageURL,
      sessionId: sessionId,
      trackIdPrefix: trackIdPrefix,
      publishedTracks: Map.unmodifiable(publishedTracks),
      isLocal: isLocal,
      connectionQuality: connectionQuality,
      isOnline: isOnline,
      audioLevel: audioLevel,
      isSpeaking: isSpeaking,
      isDominantSpeaker: isDominantSpeaker,
    );
  }

  /// TODO: Documentation
  const CallParticipantState._({
    required this.userId,
    required this.role,
    required this.name,
    this.profileImageURL,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.publishedTracks,
    this.isLocal = false,
    this.connectionQuality = SfuConnectionQuality.unspecified,
    this.isOnline = false,
    this.audioLevel = 0,
    this.isSpeaking = false,
    this.isDominantSpeaker = false,
  });

  final String userId;
  final String role;
  final String name;
  final String? profileImageURL;
  final String sessionId;
  final String trackIdPrefix;
  final Map<SfuTrackType, TrackState> publishedTracks;
  final bool isLocal;
  final SfuConnectionQuality connectionQuality;
  final bool isOnline;
  final double audioLevel;
  final bool isSpeaking;
  final bool isDominantSpeaker;

  /// Returns a copy of this [CallParticipantState] with the given fields
  /// replaced with the new values.
  CallParticipantState copyWith({
    String? userId,
    String? role,
    String? name,
    String? profileImageURL,
    String? sessionId,
    String? trackIdPrefix,
    Map<SfuTrackType, TrackState>? publishedTracks,
    bool? isLocal,
    SfuConnectionQuality? connectionQuality,
    bool? isOnline,
    double? audioLevel,
    bool? isSpeaking,
    bool? isDominantSpeaker,
  }) {
    return CallParticipantState(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      name: name ?? this.name,
      profileImageURL: profileImageURL ?? this.profileImageURL,
      sessionId: sessionId ?? this.sessionId,
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      publishedTracks: publishedTracks ?? this.publishedTracks,
      isLocal: isLocal ?? this.isLocal,
      connectionQuality: connectionQuality ?? this.connectionQuality,
      isOnline: isOnline ?? this.isOnline,
      audioLevel: audioLevel ?? this.audioLevel,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isDominantSpeaker: isDominantSpeaker ?? this.isDominantSpeaker,
    );
  }

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

  @override
  String toString() {
    return 'CallParticipantState{userId: $userId, role: $role, name: $name, '
        'profileImageURL: $profileImageURL, sessionId: $sessionId, '
        'trackId: $trackIdPrefix, '
        'publishedTracks: $publishedTracks, '
        'isLocal: $isLocal, '
        'connectionQuality: $connectionQuality, isOnline: $isOnline, '
        'audioLevel: $audioLevel, isSpeaking: $isSpeaking, '
        'isDominantSpeaker: $isDominantSpeaker}';
  }

  @override
  List<Object?> get props => [
        userId,
        role,
        name,
        profileImageURL,
        sessionId,
        trackIdPrefix,
        publishedTracks,
        isLocal,
        connectionQuality,
        isOnline,
        audioLevel,
        isSpeaking,
        isDominantSpeaker
      ];
}
