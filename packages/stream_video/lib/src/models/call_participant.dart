import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/participant_v1/participant.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pb.dart';
import 'package:stream_video/stream_video.dart';

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

extension VideoParticipantX on User {
  CallParticipant toCallParticipant() => CallParticipant(
        id: id,
        role: role,
        name: name.isEmpty ? id : name,
        profileImageURL: imageUrl,
        isOnline: false,
        hasVideo: false,
        hasAudio: false,
      );
}

extension CallParticipantX on CallParticipant {
  User toUserInfo() => User(
        id: id,
        role: role,
        name: name,
        imageUrl: profileImageURL,
      );
}

extension JoinCallResponseX on JoinCallResponse {
  List<CallParticipant> callParticipants() =>
      call.users.values.map((e) => e.toCallParticipant()).toList();
}
