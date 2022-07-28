// import 'package:livekit_client/livekit_client.dart';
import 'package:stream_video/protobuf/video_coordinator_rpc/coordinator_service.pb.dart';
import 'package:stream_video/protobuf/video_models/models.pb.dart';

class CallParticipant {
  final String id;
  final String role;
  final String name;
  final String profileImageURL;
  final bool isOnline;
  final bool hasVideo;
  final bool hasAudio;

  CallParticipant({
    required this.id,
    required this.role,
    required this.name,
    required this.profileImageURL,
    required this.isOnline,
    required this.hasVideo,
    required this.hasAudio,
  });
}

extension VideoParticipantX on Participant {
  CallParticipant toCallParticipant() => CallParticipant(
        id: user.id,
        role: role,
        name: user.name.isEmpty ? user.id : user.name,
        profileImageURL: user.imageUrl,
        isOnline: online,
        hasVideo: video,
        hasAudio: audio,
      );
}

extension JoinCallResponseX on JoinCallResponse {
  List<CallParticipant> callParticipants() =>
      callState.participants.map((e) => e.toCallParticipant()).toList();
}
