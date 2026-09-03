// 🎯 Dart imports:
import 'dart:async';
import 'dart:convert';

// � Package imports:
import 'package:crypto/crypto.dart';
// �🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide CurrentPlatform;
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide User;

// 🌎 Project imports:
import '../app/user_auth_controller.dart';
import '../core/repos/app_preferences.dart';
import '../core/repos/user_chat_repository.dart';
import '../di/injector.dart';
import '../router/routes.dart';
import '../utils/feedback_dialog.dart';
import '../widgets/badged_call_option.dart';
import '../widgets/call_duration_title.dart';
import '../widgets/closed_captions_widget.dart';
import '../widgets/e2ee_key_notification.dart';
import '../widgets/settings_menu/settings_menu.dart';
import '../widgets/share_call_card.dart';

const _useCustomDesktopScreenShareOption = false;

class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
    required this.call,
    this.connectOptions,
    this.videoEffectsManager,
    this.encryptionKey,
  });

  final Call call;
  final CallConnectOptions? connectOptions;
  final StreamVideoEffectsManager? videoEffectsManager;

  /// The passphrase [call]'s shared key was derived from.
  final String? encryptionKey;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final _userChatRepo = locator.get<UserChatRepository>();

  late String? _encryptionKey = widget.encryptionKey;
  late final _videoEffectsManager =
      widget.videoEffectsManager ?? StreamVideoEffectsManager(widget.call);

  /// Backs the mic and camera split buttons' carets. One controller, so the
  /// two agree about which device is in use.
  late final _devices = StreamMediaDevicesController.forCall(widget.call);

  late final _speakingWhileMuted = SpeakingWhileMutedRecognition(
    call: widget.call,
  );
  late final StreamSubscription<SpeakingWhileMutedState>
  _speakingWhileMutedSubscription;
  Timer? _speakingWhileMutedDebounce;
  DateTime? _lastSnackbarShownAt;

  static const _snackbarDebounce = Duration(seconds: 1);
  static const _snackbarCooldown = Duration(seconds: 5);

  Channel? _channel;
  StreamSubscription<Event>? _chatConnectionRecoverySubscription;
  ParticipantLayoutMode _currentLayoutMode = ParticipantLayoutMode.grid;
  bool _moreMenuVisible = false;

  @override
  void initState() {
    super.initState();
    _connectChatChannel();
    _speakingWhileMutedSubscription = _speakingWhileMuted.stream.listen(
      _onSpeakingWhileMutedChanged,
    );
  }

  void _onSpeakingWhileMutedChanged(SpeakingWhileMutedState state) {
    if (!state.isSpeakingWhileMuted) {
      _speakingWhileMutedDebounce?.cancel();
      _speakingWhileMutedDebounce = null;
      return;
    }

    if (_speakingWhileMutedDebounce?.isActive ?? false) return;

    _speakingWhileMutedDebounce = Timer(_snackbarDebounce, () {
      if (!mounted) return;

      final now = DateTime.now();
      if (_lastSnackbarShownAt != null &&
          now.difference(_lastSnackbarShownAt!) < _snackbarCooldown) {
        return;
      }

      _lastSnackbarShownAt = now;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('You are muted. Unmute to speak.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  void dispose() {
    _speakingWhileMutedDebounce?.cancel();
    _speakingWhileMutedSubscription.cancel();
    _speakingWhileMuted.dispose();
    _chatConnectionRecoverySubscription?.cancel();
    _devices.dispose();
    widget.call.leave();
    _userChatRepo.disconnectUser();
    _videoEffectsManager.dispose();
    super.dispose();
  }

  /// Says so on screen when the call refuses to change a device.
  ///
  /// The SDK controls log a refusal and report it here; without a listener the
  /// press is invisible, because a control's state comes from the call's own
  /// participant state and that does not change on failure.
  /// Whether muting should keep the audio track alive instead of releasing
  /// it.
  ///
  /// Speaking-while-muted detection needs the track on iOS and macOS. Null
  /// everywhere else leaves the call's own default, which releases it.
  bool? get _stopTrackOnMute =>
      CurrentPlatform.isIos || CurrentPlatform.isMacOS ? false : null;

  void _reportDeviceFailure(String message, Object error) {
    debugPrint('$message: $error');
    if (!mounted) return;

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
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
    _channel = await _userChatRepo.createChannel(
      widget.call.id,
      appPreferences.environment,
    );

    if (!mounted) return;

    // A channel watch is bound to the chat websocket connection id, and
    // StreamChatCore disables the client-level state recovery. After a
    // reconnect (e.g. the network blip that also triggers a video fast
    // reconnect) nothing re-watches the channel, so new messages silently stop
    // reaching the device. Re-watch it ourselves.
    _chatConnectionRecoverySubscription = _userChatRepo.chatClient
        .on(EventType.connectionRecovered)
        .listen((_) async {
          try {
            await _channel?.watch();
          } catch (e) {
            debugPrint('Failed to re-watch chat channel after reconnect: $e');
          }
        });

    // Rebuild the widget to enable the chat button.
    setState(() {});
  }

  void showParticipants(BuildContext context) {
    CallParticipantsRoute($extra: widget.call).push<void>(context);
  }

  void showStats(BuildContext context) {
    CallStatsRoute($extra: widget.call).push<void>(context);
  }

  void toggleMoreMenu(BuildContext context) {
    setState(() {
      _moreMenuVisible = !_moreMenuVisible;
    });
  }

  // The controls the two bar layouts have in common. Built per call rather
  // than held as fields: they close over the call the content builder hands
  // in, and a bar rebuilds whenever the window crosses a breakpoint anyway.

  ToggleLayoutOption _layoutToggle() => ToggleLayoutOption(
    initialLayout: _currentLayoutMode,
    onLayoutModeChanged: (layout) {
      setState(() {
        _currentLayoutMode = layout;
      });
    },
  );

  ToggleScreenShareOption _screenShareOption(Call call) =>
      ToggleScreenShareOption(
        call: call,
        screenShareConstraints: const ScreenShareConstraints(
          useiOSBroadcastExtension: true,
          captureScreenAudio: true,
        ),
        desktopScreenSelectorBuilder:
            // ignore: avoid_redundant_argument_values
            _useCustomDesktopScreenShareOption
            ? _customDesktopScreenShareSelector
            : null,
      );

  // The phone bar's microphone and camera: plain round buttons, no caret. A
  // phone has one microphone and two cameras, and the design gives the narrow
  // bar five controls in total — the device picker lives in the more menu
  // there instead.
  ToggleMicrophoneOption _microphoneToggle(Call call) => ToggleMicrophoneOption(
    call: call,
    stopTrackOnMute: _stopTrackOnMute,
    onError: (error) =>
        _reportDeviceFailure('Could not switch the microphone', error),
  );

  /// The phone bar's camera. See [_microphoneToggle].
  ToggleCameraOption _cameraToggle(Call call) => ToggleCameraOption(
    call: call,
    onError: (error) =>
        _reportDeviceFailure('Could not switch the camera', error),
  );

  // Split buttons rather than plain toggles, so the device can be changed
  // mid-call without opening the settings menu.
  //
  // Sharing this screen's one controller: the settings menu offers the same
  // device choice, and two controllers would disagree about which is in use.
  StreamMicrophoneSplitButton _microphoneButton(Call call) =>
      StreamMicrophoneSplitButton(
        call: call,
        devices: _devices,
        // The bar sits along the bottom, so its menus come up rather than
        // down.
        menuDirection: StreamMenuDirection.up,
        stopTrackOnMute: _stopTrackOnMute,
        onError: (error) =>
            _reportDeviceFailure('Could not switch the microphone', error),
      );

  /// The camera's split button. See [_microphoneButton].
  StreamCameraSplitButton _cameraButton(Call call) => StreamCameraSplitButton(
    call: call,
    devices: _devices,
    menuDirection: StreamMenuDirection.up,
    onError: (error) =>
        _reportDeviceFailure('Could not switch the camera', error),
  );

  // onTap, so the button opens this app's own participants screen rather than
  // the SDK's list.
  StreamParticipantsControl _participantsControl(Call call) =>
      StreamParticipantsControl(
        call: call,
        onTap: _channel != null ? () => showParticipants(context) : null,
      );

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
          callContentWidgetBuilder: (BuildContext context, Call call) {
            return StreamCallContent(
              call: call,
              layoutMode: _currentLayoutMode,
              pictureInPictureConfiguration:
                  const PictureInPictureConfiguration(
                    enablePictureInPicture: true,
                  ),
              callParticipantsWidgetBuilder: (context, call) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: StreamCallParticipants(
                            call: call,
                            layoutMode: _currentLayoutMode,
                          ),
                        ),
                        ClosedCaptionsWidget(call: call),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: E2eeKeyNotification(
                        call: call,
                        onKeyApplied: (key) =>
                            setState(() => _encryptionKey = key),
                      ),
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
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: SettingsMenu(
                              call: call,
                              videoEffectsManager: _videoEffectsManager,
                              onReactionSend: (_) =>
                                  setState(() => _moreMenuVisible = false),
                              onStatsPressed: () => setState(() {
                                showStats(context);
                                _moreMenuVisible = false;
                              }),
                              onAudioOutputChange: (_, {closeMenu = true}) {
                                if (closeMenu) {
                                  setState(() => _moreMenuVisible = false);
                                }
                              },
                              onAudioInputChange: (_) =>
                                  setState(() => _moreMenuVisible = false),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (!_moreMenuVisible)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: PartialCallStateBuilder(
                          call: call,
                          selector: (state) => state.otherParticipants.isEmpty,
                          builder: (context, isEmpty) => isEmpty
                              ? ShareCallWelcomeCard(
                                  call: call,
                                  encryptionKey: _encryptionKey,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                  ],
                );
              },
              callAppBarWidgetBuilder: (context, call) {
                // A wide window carries the layout toggle and leaving in the
                // control bar, which is where the design puts them, so the app
                // bar only holds them below that breakpoint. Otherwise both
                // ends of the screen offer the same two controls, and the call
                // has two ways to hang up a few hundred pixels apart.
                final isCompact = !context.streamScreenSize.isLarge;

                return CallAppBar(
                  call: call,
                  leadingWidth: 120,
                  showLeaveCallAction: isCompact,
                  leading: Row(
                    children: [
                      if (isCompact) _layoutToggle(),
                      PartialCallStateBuilder(
                        call: call,
                        selector: (state) => state.localParticipant != null,
                        builder: (context, hasLocalParticipant) =>
                            hasLocalParticipant
                            ? FlipCameraOption(call: call)
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  title: CallDurationTitle(call: call),
                );
              },
              callControlsWidgetBuilder: (BuildContext context, Call call) {
                final moreButton = CallFeatureButton(
                  icon: Icon(context.streamIcons.moreVerticalFill),
                  selected: _moreMenuVisible,
                  onPressed: () => toggleMoreMenu(context),
                );

                final panels = [
                  _participantsControl(call),
                  _ShowChatButton(channel: _channel),
                ];

                return CallControlBar(
                  // A phone splits its controls between the two edges: there
                  // is not enough width for a centre row and sides both. Five
                  // controls, as the design draws it — screen sharing and the
                  // device pickers are reachable from the more menu.
                  CallControlBarLayout(
                    leading: [
                      moreButton,
                      _microphoneToggle(call),
                      _cameraToggle(call),
                    ],
                    trailing: panels,
                  ),
                  // A tablet keeps the phone's shape but has the width for
                  // screen sharing and a caret on each device, so it gets
                  // them: picking a microphone mid-call without opening a menu
                  // is worth the two extra controls at this size.
                  medium: CallControlBarLayout(
                    leading: [
                      moreButton,
                      _screenShareOption(call),
                      _microphoneButton(call),
                      _cameraButton(call),
                    ],
                    trailing: panels,
                  ),
                  large: CallControlBarLayout(
                    leading: [
                      CallFeatureButton(
                        icon: Icon(context.streamIcons.settingsFill),
                        selected: _moreMenuVisible,
                        onPressed: () => toggleMoreMenu(context),
                      ),
                      _layoutToggle(),
                    ],
                    center: [
                      _microphoneButton(call),
                      _cameraButton(call),
                      ToggleClosedCaptionsOption(call: call),
                      AddReactionOption(call: call),
                      _screenShareOption(call),
                      ToggleRecordingOption(call: call),
                      LeaveCallOption(call: call),
                    ],
                    trailing: [
                      CallFeatureButton(
                        icon: Icon(context.streamIcons.statsFill),
                        onPressed: () => showStats(context),
                      ),
                      ...panels,
                    ],
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

class _ShowChatButton extends StatefulWidget {
  const _ShowChatButton({required this.channel});
  final Channel? channel;

  @override
  State<_ShowChatButton> createState() => __ShowChatButtonState();
}

class __ShowChatButtonState extends State<_ShowChatButton> {
  StreamSubscription<int>? _unreadCountSubscription;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _listenToUnreadCount();
  }

  void _listenToUnreadCount() {
    _unreadCountSubscription = widget.channel?.state?.unreadCountStream.listen(
      (count) => setState(() => _unreadCount = count),
    );
  }

  @override
  void didUpdateWidget(covariant _ShowChatButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.channel?.state != oldWidget.channel?.state) {
      _unreadCountSubscription?.cancel();
      _listenToUnreadCount();
    }
  }

  @override
  void dispose() {
    _unreadCountSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BadgedCallOption(
      callControlOption: CallControlButton(
        icon: Icon(context.streamIcons.messageBubblesFill),
        onPressed: widget.channel != null ? () => showChat(context) : null,
      ),
      badgeCount: _unreadCount == 0 ? null : _unreadCount,
    );
  }

  void showChat(BuildContext context) {
    showModalBottomSheet<dynamic>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final size = MediaQuery.sizeOf(context);
        final viewInsets = MediaQuery.viewInsetsOf(context);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: size.height * 0.6 + viewInsets.bottom,
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: ChatBottomSheet(channel: widget.channel!),
        );
      },
    );
  }
}

class ChatBottomSheet extends StatelessWidget {
  const ChatBottomSheet({super.key, required this.channel});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: channel,
      child: Column(
        children: <Widget>[
          const Expanded(child: StreamMessageListView()),
          StreamMessageComposer(),
        ],
      ),
    );
  }
}

// This is an example of a bottom sheet that only allows the selection of a screen.
// After tapping a screen the bottom sheet is directly closed and the screen is shared.
Future<DesktopCapturerSource?> _customDesktopScreenShareSelector(
  BuildContext context,
) {
  final stateNotifier = ScreenSelectorStateNotifier(
    sourceTypes: [SourceType.Screen],
  );

  return showModalBottomSheet<DesktopCapturerSource?>(
    context: context,
    builder: (BuildContext context) {
      return ValueListenableBuilder(
        valueListenable: stateNotifier,
        builder:
            (BuildContext context, ScreenSelectorState value, Widget? child) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
