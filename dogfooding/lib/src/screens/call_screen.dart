import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../utils/users_provider.dart';
import 'chat_screen.dart';

class CallScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StreamUsersConfiguration(
      usersProvider: MockUsersProvider(),
      child: StreamChannel(
        channel: chatChannel,
        child: Scaffold(
          body: StreamCallContainer(
            call: call,
            callConnectOptions: callConnectOptions,
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
                        onPressed: () async {
                          await showBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return const FractionallySizedBox(
                                heightFactor: 0.8,
                                child: ChatScreen(),
                              );
                            },
                          );
                        },
                      ),
                      ToggleSpeakerphoneOption(call: call),
                      ToggleMicrophoneOption(
                          call: call, localParticipant: localParticipant),
                      ToggleCameraOption(
                          call: call, localParticipant: localParticipant),
                      LeaveCallOption(
                          call: call,
                          onLeaveCallTap: () {
                            call.end();
                            call.disconnect();
                          }),
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
