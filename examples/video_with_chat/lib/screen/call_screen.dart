import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:video_with_chat/screen/channel_screen.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({
    Key? key,
    required this.call,
    required this.channel,
  }) : super(key: key);

  final Call call;
  final Channel channel;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  var isChatPaneVisible = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: StreamCallContainer(
            call: widget.call,
            callContentBuilder: (context, call, callState) {
              return StreamCallContent(
                call: call,
                callState: callState,
                onBackPressed: () => _finishCall(context),
                callControlsBuilder: (context, call, callState) {
                  return StreamCallControls(
                    options: customCallControlOptions(
                      call: call,
                      channel: widget.channel,
                      onLeaveCallTap: () => _finishCall(context),
                      onChatTap: () {
                        if (kIsWeb) {
                          toggleChatPane();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return StreamChannel(
                                  channel: widget.channel,
                                  child: const ChatScreen(),
                                );
                              },
                              fullscreenDialog: true,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        isChatPaneVisible
            ? Expanded(
                flex: 1,
                child: StreamChannel(
                  channel: widget.channel,
                  child: ChatScreen(onBackPressed: () => toggleChatPane()),
                ),
              )
            : Container()
      ],
    );
  }

  void toggleChatPane() {
    isChatPaneVisible = !isChatPaneVisible;
    setState(() {});
  }

  Future<void> _finishCall(BuildContext context) async {
    await widget.call.disconnect();
    await widget.channel.stopWatching();

    Navigator.of(context).pop();
  }
}

List<Widget> customCallControlOptions({
  required Call call,
  required Channel channel,
  required VoidCallback onLeaveCallTap,
  required VoidCallback onChatTap,
}) {
  final localParticipant = call.state.value.localParticipant;
  assert(localParticipant != null, 'The local participant is null.');

  final cid = channel.cid;
  assert(cid != null, 'The channel cid is null.');

  return [
    ToggleChat(cid: cid, onChatTap: onChatTap),
    ToggleMicrophoneOption(call: call, localParticipant: localParticipant!),
    ToggleCameraOption(call: call, localParticipant: localParticipant),
    FlipCameraOption(call: call, localParticipant: localParticipant),
    LeaveCallOption(call: call, onLeaveCallTap: onLeaveCallTap),
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
