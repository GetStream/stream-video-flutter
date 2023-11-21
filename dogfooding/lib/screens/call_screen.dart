// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:crypto/crypto.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide User;

// 🌎 Project imports:
import 'package:flutter_dogfooding/core/repos/user_chat_repository.dart';
import '../app/user_auth_controller.dart';
import '../di/injector.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
    required this.call,
    this.connectOptions = const CallConnectOptions(),
  });

  final Call call;
  final CallConnectOptions connectOptions;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Channel? _channel;
  late final _streamVideo = locator.get<StreamVideo>();
  late final _userChatRepo = locator.get<UserChatRepository>();

  @override
  void initState() {
    super.initState();
    _connectChatChannel();
  }

  @override
  void dispose() {
    widget.call.leave();
    _userChatRepo.disconnectUser();
    super.dispose();
  }

  Future<void> _connectChatChannel() async {
    final userAuthController = locator.get<UserAuthController>();

    // return if the video user is not yet logged in.
    final currentUser = userAuthController.currentUser;
    if (currentUser == null) return;

    // Connect the video user to the chat client if they are not already
    // connected.
    if (_userChatRepo.currentUser == null) {
      final chatUID = md5.convert(utf8.encode(currentUser.id));
      await _userChatRepo.connectUser(
        User(
          id: chatUID.toString(),
          name: currentUser.name,
          image: currentUser.image,
        ),
      );
    }

    // Create and watch channel for the call.
    _channel = await _userChatRepo.createChannel(widget.call.id);

    // Rebuild the widget to enable the chat button.
    if (mounted) setState(() {});
  }

  void showChat(BuildContext context) {
    showModalBottomSheet<dynamic>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF101418),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (_) {
        final size = MediaQuery.sizeOf(context);
        final viewInsets = MediaQuery.viewInsetsOf(context);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: size.height * 0.6 + viewInsets.bottom,
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: ChatBottomSheet(channel: _channel!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamCallContainer(
        call: widget.call,
        callConnectOptions: widget.connectOptions,
        callContentBuilder: (
          BuildContext context,
          Call call,
          CallState callState,
        ) {
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
                    onPressed: _channel != null //
                        ? () => showChat(context)
                        : null,
                  ),
                  FlipCameraOption(
                    call: call,
                    localParticipant: localParticipant,
                  ),
                  AddReactionOption(
                    call: call,
                    localParticipant: localParticipant,
                  ),
                  ToggleScreenShareOption(
                    call: call,
                    localParticipant: localParticipant,
                    screenShareConstraints: const ScreenShareConstraints(
                        useiOSBroadcastExtension: true),
                  ),
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
                    onLeaveCallTap: () async {
                      final result = await call.leave();
                      if (result is Failure) {
                        debugPrint('Error leaving call: ${result.error}');
                        return;
                      }

                      // End all calls.
                      _streamVideo.pushNotificationManager?.endAllCalls();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ChatBottomSheet extends StatelessWidget {
  const ChatBottomSheet({
    super.key,
    required this.channel,
  });

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: channel,
      child: const Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}
