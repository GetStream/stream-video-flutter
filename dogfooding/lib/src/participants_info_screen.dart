import 'package:dogfooding/src/participants_invite_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/call_participants_info_view.dart';
import 'package:stream_video_flutter/participant_info/model/MuteToggleButtonTitles.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class StreamCallParticipantsInfoScreen extends StatelessWidget {
  const StreamCallParticipantsInfoScreen({super.key, required this.call});

  final Call call;

  static const routeName = '/call/participants';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants (${call.participants.length + 1})'),
      ),
      body: StreamCallParticipantsInfoView(
          call: call,
          inviteButtonTitle: 'Invite',
          muteToggleButtonTitles: MuteToggleButtonTitles(
            muteTitle: 'Mute Me',
            unmuteTitle: 'Unmute Me',
          ),
          onInviteButtonPress: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CallParticipantsInviteScreen(call: call)));
          }),
    );
  }
}
