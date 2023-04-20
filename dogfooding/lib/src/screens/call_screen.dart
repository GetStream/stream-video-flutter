import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../utils/users_provider.dart';
import 'chat_screen.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
    required this.call,
    required this.chatChannel,
    this.callConnectOptions = const CallConnectOptions(),
  });

  final Call call;
  final CallConnectOptions callConnectOptions;
  final Channel chatChannel;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  void showChatDialog(BuildContext context) {
    showBottomSheet<dynamic>(
      context: context,
      builder: (_) {
        return const FractionallySizedBox(
          heightFactor: 0.8,
          child: ChatScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamUsersConfiguration(
      usersProvider: MockUsersProvider(),
      child: StreamChannel(
        channel: widget.chatChannel,
        child: Scaffold(
          body: StreamCallContainer(
            call: widget.call,
            callConnectOptions: widget.callConnectOptions,
            callContentBuilder:
                (BuildContext context, Call call, CallState callState) {
              return StreamCallContent(
                call: call,
                callState: callState,
                callControlsBuilder: (
                  BuildContext context,
                  Call call,
                  CallState callState,
                ) {
                  final localParticipant = callState.localParticipant!;
                  return StreamCallControls(
                    options: [
                      CallControlOption(
                        icon: const Icon(Icons.chat_outlined),
                        onPressed: () {
                          showChatDialog(context);
                        },
                      ),
                      ToggleSpeakerphoneOption(call: call),
                      ToggleMicrophoneOption(
                        call: call,
                        localParticipant: localParticipant,
                      ),
                      ToggleCameraOption(
                        call: call,
                        localParticipant: localParticipant,
                      ),
                      LeaveCallOption(
                        call: call,
                        onLeaveCallTap: () {
                          call.end();
                          call.disconnect();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
