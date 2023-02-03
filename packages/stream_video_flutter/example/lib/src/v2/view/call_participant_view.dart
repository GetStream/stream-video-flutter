import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallParticipantView extends StatelessWidget {
  const CallParticipantView({
    super.key,
    required this.call,
    required this.participant,
  });

  final CallV2 call;
  final CallParticipantStateV2? participant;

  @override
  Widget build(BuildContext context) {
    final participant = this.participant;
    print('(D/SV:ParticipantView) [build] participant: $participant');

    if (participant == null) {
      return Container(
        alignment: Alignment.center,
        child: const Text('Mock Participant'),
      );
    }

    return VideoTrackRenderer(
      call: call,
      participant: participant,
      placeholderBuilder: (context) {
        return Center(
          child: StreamUserAvatar(
            avatarTheme: const StreamAvatarTheme(
              constraints: BoxConstraints.tightFor(
                width: 120,
                height: 120,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(60),
              ),
            ),
            user: UserInfo(
              id: participant.userId,
              role: participant.role,
              name: participant.userId,
              imageUrl: participant.profileImageURL,
            ),
          ),
        );
      },
    );
  }
}
