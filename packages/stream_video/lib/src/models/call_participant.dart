import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart' as sfu;
import 'package:stream_video/src/track/local/local.dart';
import 'package:stream_video/src/track/track.dart';

typedef TrackSize = sfu.VideoDimension;

/// Represents a Participant in the [Call].
class CallParticipant<T extends Track> {
  /// Creates a new [CallParticipant].
  const CallParticipant({
    required this.id,
    required this.role,
    required this.name,
    this.profileImageURL,
    required this.isOnline,
    required this.hasVideo,
    required this.hasAudio,
    this.tracks,
    this.trackSize,
    required this.audioLevel,
    required this.createdAt,
    required this.updatedAt,
    required this.sessionId,
    required this.trackLookupPrefix,
    this.extraData,
  });

  /// Creates a new [CallParticipant] from the sfu [Participant].
  CallParticipant.fromSfu(sfu.Participant participant)
      : id = participant.user.id,
        role = participant.user.role,
        name = participant.user.name,
        profileImageURL = participant.user.imageUrl,
        isOnline = true,
        hasVideo = participant.video,
        hasAudio = participant.audio,
        tracks = null,
        trackSize = null,
        audioLevel = 0,
        createdAt = participant.createdAt.toDateTime(),
        updatedAt = participant.updatedAt.toDateTime(),
        sessionId = participant.sessionId,
        trackLookupPrefix = participant.trackLookupPrefix,
        extraData = participant.custom.fields;

  final String id;
  final String role;
  final String name;
  final String? profileImageURL;
  final bool isOnline;
  final bool hasVideo;
  final bool hasAudio;
  final Iterable<T>? tracks;
  final TrackSize? trackSize;
  final double audioLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String sessionId;
  final String trackLookupPrefix;
  final Map<String, Object?>? extraData;

  bool get isLocal => false;

  /// Returns all the [VideoTrack]s of this [CallParticipant].
  Iterable<VideoTrack>? get videoTracks => tracks?.whereType<VideoTrack>();

  /// Returns all the [AudioTrack]s of this [CallParticipant].
  Iterable<AudioTrack>? get audioTracks => tracks?.whereType<AudioTrack>();

  /// Creates a copy of this [CallParticipant] with the given fields replaced
  /// with the new values.
  CallParticipant copyWith({
    String? id,
    String? role,
    String? name,
    String? profileImageURL,
    bool? isOnline,
    bool? hasVideo,
    bool? hasAudio,
    Iterable<T>? tracks,
    TrackSize? trackSize,
    double? audioLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sessionId,
    String? trackLookupPrefix,
    Map<String, Object?>? extraData,
  }) {
    return CallParticipant(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      profileImageURL: profileImageURL ?? this.profileImageURL,
      isOnline: isOnline ?? this.isOnline,
      hasVideo: hasVideo ?? this.hasVideo,
      hasAudio: hasAudio ?? this.hasAudio,
      tracks: tracks ?? this.tracks,
      trackSize: trackSize ?? this.trackSize,
      audioLevel: audioLevel ?? this.audioLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sessionId: sessionId ?? this.sessionId,
      trackLookupPrefix: trackLookupPrefix ?? this.trackLookupPrefix,
      extraData: extraData ?? this.extraData,
    );
  }
}

/// Represents a local [CallParticipant].
class LocalCallParticipant extends CallParticipant<LocalTrack> {
  /// Creates a new [LocalCallParticipant].
  const LocalCallParticipant({
    required super.id,
    required super.role,
    required super.name,
    super.profileImageURL,
    required super.isOnline,
    required super.hasVideo,
    required super.hasAudio,
    super.tracks,
    super.trackSize,
    required super.audioLevel,
    required super.createdAt,
    required super.updatedAt,
    required super.sessionId,
    required super.trackLookupPrefix,
    this.audioDeviceId,
    this.videoDeviceId,
    super.extraData,
  });

  /// Creates a new [LocalCallParticipant] from the sfu [Participant].
  LocalCallParticipant.fromSfu(sfu.Participant participant)
      : audioDeviceId = null,
        videoDeviceId = null,
        super.fromSfu(participant);

  /// The device ID of the currently selected audio input device of the local
  /// participant (returned by the [MediaDevices API](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia))
  final String? audioDeviceId;

  /// The device ID of the currently selected video input device of the local
  /// participant (returned by the [MediaDevices API](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia))
  final String? videoDeviceId;

  @override
  bool get isLocal => true;

  @override
  LocalCallParticipant copyWith({
    String? id,
    String? role,
    String? name,
    String? profileImageURL,
    bool? isOnline,
    bool? hasVideo,
    bool? hasAudio,
    Iterable<LocalTrack>? tracks,
    TrackSize? trackSize,
    double? audioLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sessionId,
    String? trackLookupPrefix,
    String? audioDeviceId,
    String? videoDeviceId,
    Map<String, Object?>? extraData,
  }) {
    return LocalCallParticipant(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      profileImageURL: profileImageURL ?? this.profileImageURL,
      isOnline: isOnline ?? this.isOnline,
      hasVideo: hasVideo ?? this.hasVideo,
      hasAudio: hasAudio ?? this.hasAudio,
      tracks: tracks ?? this.tracks,
      trackSize: trackSize ?? this.trackSize,
      audioLevel: audioLevel ?? this.audioLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sessionId: sessionId ?? this.sessionId,
      trackLookupPrefix: trackLookupPrefix ?? this.trackLookupPrefix,
      audioDeviceId: audioDeviceId ?? this.audioDeviceId,
      videoDeviceId: videoDeviceId ?? this.videoDeviceId,
      extraData: extraData ?? this.extraData,
    );
  }
}
