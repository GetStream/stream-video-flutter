import 'package:flutter_webrtc/flutter_webrtc.dart';
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
  final bool showTrack;
  //webrtc track
  final MediaStream? track;

  CallParticipant({
    required this.id,
    required this.role,
    required this.name,
    required this.profileImageURL,
    required this.isOnline,
    required this.hasVideo,
    required this.hasAudio,
    required this.showTrack,
    this.track,
  });

  //generate copy with
  CallParticipant copyWith({
    String? id,
    String? role,
    String? name,
    String? profileImageURL,
    bool? isOnline,
    bool? hasVideo,
    bool? hasAudio,
    bool? showTrack,
    MediaStream? track,
  }) {
    return CallParticipant(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      profileImageURL: profileImageURL ?? this.profileImageURL,
      isOnline: isOnline ?? this.isOnline,
      hasVideo: hasVideo ?? this.hasVideo,
      hasAudio: hasAudio ?? this.hasAudio,
      showTrack: showTrack ?? this.showTrack,
      track: track ?? this.track,
    );
  }
}

// extension VideoParticipantX on Participant {
//   CallParticipant toCallParticipant(bool showTrack) {
//     return CallParticipant(
//       id: user.id,
//       role: role,
//       name: user.name.isEmpty ? user.id : user.name,
//       profileImageURL: user.imageUrl,
//       isOnline: online,
//       hasVideo: video,
//       hasAudio: audio,
//       showTrack: showTrack,
//     );
//   }
// }

extension UserX on User {
  CallParticipant toCallParticipant() => CallParticipant(
        id: id,
        role: role,
        name: name.isEmpty ? id : name,
        profileImageURL: imageUrl,
        isOnline: false,
        hasVideo: false,
        hasAudio: false,
        showTrack: false,
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

extension CallParticipantsX on Map<String, CallParticipant> {
  List<CallParticipant> get onlineParticipants => entries
      .map((entry) => entry.value)
      .where((element) => element.isOnline == true)
      .toList();

  List<CallParticipant> get offlineParticipants => entries
      .map((entry) => entry.value)
      .where((element) => element.isOnline == false)
      .toList();
}
