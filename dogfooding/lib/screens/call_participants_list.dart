import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../widgets/share_call_card.dart';

class CallParticipantsList extends StatelessWidget {
  const CallParticipantsList({super.key, required this.call});

  final Call call;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;

    return StreamBuilder<CallState>(
      stream: call.state.asStream(),
      builder: (context, snapshot) {
        final callState = snapshot.requireData;
        final participants = callState.callParticipants;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Participants (${callState.callParticipants.length})',
              style: textTheme.title3.apply(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    final participant = participants[index];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          StreamUserAvatarTheme(
                            data: streamVideoTheme.userAvatarTheme,
                            child: StreamUserAvatar(
                              user: UserInfo(
                                id: participant.userId,
                                name: participant.name.ifEmpty(
                                  () => participant.userId,
                                ),
                                image: participant.image,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    participant.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    participant.roles.join(', '),
                                    style: textTheme.footnoteItalic,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (participant.isAudioEnabled)
                            const Icon(Icons.mic_rounded)
                          else
                            const Icon(Icons.mic_off_rounded),
                          const SizedBox(width: 8),
                          if (participant.isVideoEnabled)
                            const Icon(Icons.videocam_rounded)
                          else
                            const Icon(Icons.videocam_off_rounded),
                        ],
                      ),
                    );
                  },
                  // separatorBuilder: (context, index) => const Divider(),
                  itemCount: participants.length,
                ),
              ),
              ShareCallParticipantsCard(callId: call.id),
            ],
          ),
        );
      },
    );
  }
}
