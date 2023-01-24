import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'participants_invite_screen.dart';

class StreamCallParticipantsInfoScreen extends StatelessWidget {
  const StreamCallParticipantsInfoScreen({
    super.key,
    required this.call,
  });

  final Call call;

  static const routeName = '/call/participants';

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants (${call.participants.length + 1})'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamCallParticipantsInfoView(call: call),
          ),
          Material(
            elevation: 8,
            color: streamChatTheme.colorTheme.appBg,
            child: StreamCallParticipantsInfoOptions(
              call: call,
              inviteButtonTitle: 'Invite',
              muteToggleTitles: const MuteToggleTitles(
                muteTitle: 'Mute Me',
                unmuteTitle: 'Unmute Me',
              ),
              onInviteButtonPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CallParticipantsInviteScreen(
                      call: call,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
