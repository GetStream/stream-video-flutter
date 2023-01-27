import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:video_with_chat/screen/channel_screen.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({
    Key? key,
    required this.call,
    required this.channel,
  }) : super(key: key);

  final Call call;
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return StreamActiveCall(
      call: call,
      onBackPressed: () => _finishCall(context),
      onHangUp: () => _finishCall(context),
      callControlsBuilder: (context, call, participants) {
        return StreamCallControlsBar(
          options: customCallControlOptions(
              call: call,
              channel: channel,
              onHangup: () => _finishCall(context),
              onChatTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return StreamChannel(
                        channel: channel,
                        child: const ChatScreen(),
                      );
                    },
                    fullscreenDialog: true,
                  ),
                );
              }),
        );
      },
      onParticipantsTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Material(
                child: StreamCallParticipantsInfoView(call: call),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _finishCall(BuildContext context) async {
    await call.disconnect();
    await channel.stopWatching();

    Navigator.of(context).pop();
  }
}

List<Widget> customCallControlOptions({
  required Call call,
  required Channel channel,
  required VoidCallback onHangup,
  required VoidCallback onChatTap,
}) {
  final participant = call.localParticipant;
  assert(participant != null, 'The local participant is null.');

  final cid = channel.cid;
  assert(cid != null, 'The channel cid is null.');

  return [
    ToggleChat(cid: cid, onChatTap: onChatTap),
    ToggleMic(participant: participant!),
    ToggleCamera(participant: participant),
    SwitchCamera(participant: participant),
    CallHangup(onHangup: onHangup),
  ];
}

class ToggleChat extends StatelessWidget {
  const ToggleChat({
    Key? key,
    required this.cid,
    required this.onChatTap,
  }) : super(key: key);

  final VoidCallback onChatTap;

  /// Channel cid used to retrieve unread count.
  final String? cid;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CallControlOption(
          icon: const Icon(Icons.chat),
          iconColor: Colors.black,
          backgroundColor: Colors.white,
          onPressed: onChatTap,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: StreamUnreadIndicator(cid: cid),
        ),
      ],
    );
  }
}
