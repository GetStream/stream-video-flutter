// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:crypto/crypto.dart';
import 'package:flutter_dogfooding/router/routes.dart';
import 'package:flutter_dogfooding/widgets/badged_call_option.dart';
import 'package:flutter_dogfooding/widgets/call_duration_title.dart';
import 'package:flutter_dogfooding/widgets/share_call_card.dart';
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
  late final _userChatRepo = locator.get<UserChatRepository>();

  Channel? _channel;
  ParticipantLayoutMode _currentLayoutMode = ParticipantLayoutMode.grid;

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

  void showParticipants(BuildContext context) {
    ParticipantsRoute($extra: widget.call).push(context);
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
          return Stack(
            children: [
              StreamCallContent(
                call: call,
                callState: callState,
                layoutMode: _currentLayoutMode,
                callAppBarBuilder: (context, call, callState) {
                  return CallAppBar(
                    call: call,
                    leadingWidth: 120,
                    leading: Row(
                      children: [
                        ToggleLayoutOption(
                          onLayoutModeChanged: (layout) {
                            setState(() {
                              _currentLayoutMode = layout;
                            });
                          },
                        ),
                        if (call.state.valueOrNull?.localParticipant != null)
                          FlipCameraOption(
                            call: call,
                            localParticipant:
                                call.state.value.localParticipant!,
                          ),
                      ],
                    ),
                    title: CallDurationTitle(call: call),
                  );
                },
                callControlsBuilder: (
                  BuildContext context,
                  Call call,
                  CallState callState,
                ) {
                  final localParticipant = callState.localParticipant!;
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 8,
                    ),
                    color: Colors.black,
                    child: SafeArea(
                      child: Row(children: [
                        ToggleScreenShareOption(
                          call: call,
                          localParticipant: localParticipant,
                          screenShareConstraints: const ScreenShareConstraints(
                            useiOSBroadcastExtension: true,
                          ),
                          enabledScreenShareBackgroundColor:
                              const Color(0xFF005FFF),
                          disabledScreenShareIcon: Icons.screen_share,
                        ),
                        ToggleMicrophoneOption(
                          call: call,
                          localParticipant: localParticipant,
                          disabledMicrophoneBackgroundColor:
                              const Color(0xFFDC433B),
                        ),
                        ToggleCameraOption(
                          call: call,
                          localParticipant: localParticipant,
                          disabledCameraBackgroundColor:
                              const Color(0xFFDC433B),
                        ),
                        const Spacer(),
                        BadgedCallOption(
                          callControlOption: CallControlOption(
                            icon: const Icon(Icons.people),
                            onPressed: _channel != null //
                                ? () => showParticipants(context)
                                : null,
                          ),
                          badgeCount: callState.callParticipants.length,
                        ),
                        BadgedCallOption(
                          callControlOption: CallControlOption(
                            icon: const Icon(Icons.question_answer),
                            onPressed: _channel != null //
                                ? () => showChat(context)
                                : null,
                          ),
                          badgeCount: _channel?.state?.unreadCount ?? 0,
                        )
                      ]),
                    ),
                  );
                },
              ),
              if (call.state.valueOrNull?.otherParticipants.isEmpty ?? false)
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: ShareCallCard(callId: call.id),
                )
            ],
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
