import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'call_participant.dart';

class CallParticipantView extends StatelessWidget {
  const CallParticipantView({
    super.key,
    required this.call,
    required this.participant,
  });

  final CallV2 call;
  final CallParticipantV2? participant;

  @override
  Widget build(BuildContext context) {
    final participant = this.participant;
    if (participant == null) {
      return Container(
        alignment: Alignment.center,
        child: const Text('Mock Participant'),
      );
    }
    final rtcRenderer = participant.renderer;
    final Widget rtcView;
    if (rtcRenderer != null) {
      rtcView = rtc.RTCVideoView(
        rtcRenderer,
        mirror: participant.state.isLocal,
      );
    } else {
      rtcView = Container();
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        rtcView,
        StreamUserAvatar(
          avatarTheme: const StreamAvatarTheme(
            constraints: BoxConstraints.tightFor(
              height: 100,
              width: 100,
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          user: UserInfo(
            id: participant.state.userId,
            role: participant.state.role,
            imageUrl: participant.state.profileImageURL,
            name: participant.state.name,
          ),
        ),
      ],
    );
  }
}
