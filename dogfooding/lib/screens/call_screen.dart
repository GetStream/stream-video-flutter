// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:crypto/crypto.dart';
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
import 'package:flutter_dogfooding/router/routes.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:flutter_dogfooding/utils/feedback_dialog.dart';
import 'package:flutter_dogfooding/widgets/badged_call_option.dart';
import 'package:flutter_dogfooding/widgets/call_duration_title.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/settings_menu.dart';
import 'package:flutter_dogfooding/widgets/share_call_card.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide User;

// 🌎 Project imports:
import 'package:flutter_dogfooding/core/repos/user_chat_repository.dart';
import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import '../widgets/closed_captions_widget.dart';

const _useCustomDesktopScreenShareOption = false;

class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
    required this.call,
    this.connectOptions,
  });

  final Call call;
  final CallConnectOptions? connectOptions;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final _userChatRepo = locator.get<UserChatRepository>();

  Channel? _channel;
  ParticipantLayoutMode _currentLayoutMode = ParticipantLayoutMode.grid;
  bool _moreMenuVisible = false;

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
    final appPreferences = locator.get<AppPreferences>();

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
        appPreferences.environment,
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
    CallParticipantsRoute($extra: widget.call).push(context);
  }

  void showStats(BuildContext context) {
    CallStatsRoute($extra: widget.call).push(context);
  }

  void toggleMoreMenu(BuildContext context) {
    setState(() {
      _moreMenuVisible = !_moreMenuVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return !Navigator.of(context).userGestureInProgress;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamCallContainer(
          call: widget.call,
          callConnectOptions: widget.connectOptions,
          onCancelCallTap: () async {
            await widget.call.reject(reason: CallRejectReason.cancel());
          },
          onCallDisconnected: (disconnectedProperties) {
            final reason = disconnectedProperties.reason;

            Navigator.of(context).pop();

            if (reason is DisconnectReasonCancelled ||
                reason is DisconnectReasonEnded ||
                reason is DisconnectReasonLastParticipantLeft) {
              showFeedbackDialog(context, call: widget.call);
            }
          },
          callContentBuilder: (
            BuildContext context,
            Call call,
            CallState callState,
          ) {
            return StreamCallContent(
              call: call,
              callState: callState,
              layoutMode: _currentLayoutMode,
              pictureInPictureConfiguration:
                  const PictureInPictureConfiguration(
                enablePictureInPicture: true,
              ),
              callParticipantsBuilder: (context, call, callState) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: StreamCallParticipants(
                            call: call,
                            participants: callState.callParticipants,
                            layoutMode: _currentLayoutMode,
                          ),
                        ),
                        ClosedCaptionsWidget(call: call),
                      ],
                    ),
                    if (_moreMenuVisible) ...[
                      GestureDetector(
                        onTap: () => setState(() => _moreMenuVisible = false),
                        child: Container(color: Colors.black12),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SettingsMenu(
                          call: call,
                          onReactionSend: (_) =>
                              setState(() => _moreMenuVisible = false),
                          onStatsPressed: () => setState(
                            () {
                              showStats(context);
                              _moreMenuVisible = false;
                            },
                          ),
                          onAudioOutputChange: (_) =>
                              setState(() => _moreMenuVisible = false),
                          onAudioInputChange: (_) =>
                              setState(() => _moreMenuVisible = false),
                        ),
                      ),
                    ],
                    if (!_moreMenuVisible &&
                        (call.state.valueOrNull?.otherParticipants.isEmpty ??
                            false))
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ShareCallCard(callId: call.id),
                      )
                  ],
                );
              },
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
                          localParticipant: call.state.value.localParticipant!,
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
                    bottom: 8,
                  ),
                  color: Colors.black,
                  child: SafeArea(
                    child: Row(children: [
                      CallControlOption(
                          icon: const Icon(Icons.more_vert),
                          backgroundColor: _moreMenuVisible
                              ? AppColorPalette.primary
                              : AppColorPalette.buttonSecondary,
                          onPressed: () {
                            toggleMoreMenu(context);
                          }),
                      ToggleScreenShareOption(
                        call: call,
                        localParticipant: localParticipant,
                        screenShareConstraints: const ScreenShareConstraints(
                          useiOSBroadcastExtension: true,
                        ),
                        enabledScreenShareBackgroundColor:
                            AppColorPalette.primary,
                        disabledScreenShareIcon: Icons.screen_share,
                        desktopScreenSelectorBuilder:
                            _useCustomDesktopScreenShareOption
                                ? _customDesktopScreenShareSelector
                                : null,
                      ),
                      ToggleMicrophoneOption(
                        call: call,
                        localParticipant: localParticipant,
                        disabledMicrophoneBackgroundColor:
                            AppColorPalette.appRed,
                      ),
                      ToggleCameraOption(
                        call: call,
                        localParticipant: localParticipant,
                        disabledCameraBackgroundColor: AppColorPalette.appRed,
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
            );
          },
        ),
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

// This is an example of a bottom sheet that only allows the selection of a screen.
// After tapping a screen the bottom sheet is directly closed and the screen is shared.
Future<DesktopCapturerSource?> _customDesktopScreenShareSelector(
    BuildContext context) {
  final ScreenSelectorStateNotifier stateNotifier =
      ScreenSelectorStateNotifier(sourceTypes: [SourceType.Screen]);

  return showModalBottomSheet<DesktopCapturerSource?>(
    context: context,
    builder: (BuildContext context) {
      return ValueListenableBuilder(
        valueListenable: stateNotifier,
        builder:
            (BuildContext context, ScreenSelectorState value, Widget? child) =>
                Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ThumbnailGrid(
            sources: value.sources.values.toList(),
            selectedSource: value.selectedSource,
            onSelectSource: (source) => Navigator.pop(context, source),
          ),
        ),
      );
    },
  );
}
