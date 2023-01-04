import 'package:stream_video/stream_video.dart';

class CallParticipantState {
  /// TODO: Documentation
  CallParticipantState({
    required this.id,
    required this.role,
    required this.name,
    this.profileImageURL,
    required this.sessionId,
    required this.idPrefix,
    this.isLocal = false,
    this.connectionQuality = ConnectionQuality.unknown,
    this.isOnline = false,
    this.videoTrack,
    this.screenSharingTrack,
    this.audioLevel = 0,
  });

  final String id;
  final String role;
  final String name;
  final String? profileImageURL;
  final String sessionId;
  final String idPrefix;
  final bool isLocal;
  final ConnectionQuality connectionQuality;
  final bool isOnline;
  VideoTrack? videoTrack;
  VideoTrack? screenSharingTrack;
  double audioLevel;
}
