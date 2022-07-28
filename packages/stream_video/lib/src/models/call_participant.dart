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


// extension VideoParticipantX on 