import 'package:stream_video/src/v2/sfu/data/models/sfu_connection_quality.dart';
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
    this.connectionQuality = SfuConnectionQuality.unspecified,
    this.isOnline = false,
    this.audioLevel = 0,
  });

  final String id;
  final String role;
  final String name;
  final String? profileImageURL;
  final String sessionId;
  final String idPrefix;
  final bool isLocal;
  final SfuConnectionQuality connectionQuality;
  final bool isOnline;
  final double audioLevel;
}

class CallParticipantRTC {
  CallParticipantRTC({
    this.videoTrack,
    this.screenSharingTrack,
  });
  VideoTrack? videoTrack;
  VideoTrack? screenSharingTrack;
}
