import 'package:collection/collection.dart';
import 'package:livekit_client/livekit_client.dart'
    show TrackSource, Participant;
import 'package:stream_video/src/models/aliases.dart';

class RoomParticipant {
  final Participant _participant;

  RoomParticipant(this._participant);

  String get id => _participant.sid;

  String get name => _participant.identity;

  VideoConnectionQuality get connectionQuality =>
      _participant.connectionQuality;

  bool get isSpeaking => _participant.isSpeaking;

  VideoTrackPublication? get firstAudioPublication =>
      _participant.audioTracks.firstOrNull;

  VideoTrackPublication? get videoPublication => _participant.videoTracks
      .where((element) => element.sid == id)
      .firstOrNull;

  StreamVideoTrack? get activeVideoTrack => videoPublication?.track;

  bool get isMuted => _participant.isMuted;

    bool isMicrophoneEnabled() => _participant.isMicrophoneEnabled();

    bool isCameraEnabled() => _participant.isCameraEnabled();
  bool get hasAudio => _participant.hasAudio;

  bool get hasVideo => _participant.hasVideo;

  List<VideoTrackPublication> get videoTracks => _participant.videoTracks;
}
