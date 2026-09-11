// 🎯 Dart imports:
import 'dart:async';
import 'dart:convert';

// � Package imports:
import 'package:collection/collection.dart';
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
import '../utils/feedback_dialog.dart';
import '../widgets/badged_call_option.dart';
import '../widgets/call_duration_title.dart';
import '../widgets/closed_captions_widget.dart';
import '../widgets/e2ee_key_notification.dart';
import '../widgets/settings_menu/settings_menu.dart';
import '../widgets/share_call_card.dart';
import '../widgets/side_panel/call_side_panel.dart';
import '../widgets/side_panel/call_side_panel_layout.dart';
import '../widgets/side_panel/chat_panel_body.dart';
import 'call_participants_list.dart';
import 'call_stats_screen.dart';

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

class _CallScreenState extends State<CallScreen>
    with SingleTickerProviderStateMixin {
  late final _logger = taggedLogger(tag: 'SV:Dogfooding:CallScreen');

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
  ParticipantLayoutMode _currentLayoutMode = ParticipantLayoutMode.auto;
  bool _moreMenuVisible = false;

  /// The panel the user asked for, or null once it starts closing.
  ///
  /// Drives the control bar's selected states, which let go as soon as the
  /// panel starts leaving. Anything asking whether a panel is *on screen*
  /// wants [_mountedPanel] instead.
  CallSidePanel? _openPanel;

  /// The panel whose content is in the tree, or null when nothing is up.
  ///
  /// Outlives [_openPanel] by the length of the exit animation, so it is the
  /// one to read for "is a panel on screen": what the back button dismisses,
  /// and what the app bar makes room for.
  CallSidePanel? _mountedPanel;

  StreamSubscription<CallStatus>? _callStatusSubscription;

  late final _panelController = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  )..addStatusListener(_onPanelStatusChanged);

  late final _panelAnimation = CurvedAnimation(
    parent: _panelController,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  /// Carries the panel's own state across the breakpoint: the docked and the
  /// full-screen layout hang it in different places, and without a global key
  /// crossing the [StreamScreenSize.small] boundary would remount it and lose
  /// the chat's scroll offset.
  final _panelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _connectChatChannel();
    _speakingWhileMutedSubscription = _speakingWhileMuted.stream.listen(
      _onSpeakingWhileMutedChanged,
    );
    _callStatusSubscription = widget.call
        .partialState((state) => state.status)
        .listen(_onCallStatusChanged);
  }

  /// Closes the panel when the call stops being connected.
  ///
  /// The SDK only builds the slot the panel lives in while the call is
  /// connected, so a reconnect takes the panel off screen on its own. Without
  /// this the state would still claim one is up, and on a phone the app bar
  /// would stay collapsed around nothing — taking the only leave button with
  /// it.
  void _onCallStatusChanged(CallStatus status) {
    if (!mounted || _mountedPanel == null) return;
    if (status.isConnected || status.isFastReconnecting || status.isMigrating) {
      return;
    }

    _logger.d(() => 'Closing the $_mountedPanel panel: call is $status');
    setState(() {
      _openPanel = null;
      _mountedPanel = null;
    });
    // Straight to closed rather than reversed: the panel is already gone, so
    // there is nothing left on screen to animate out.
    _panelController.reset();
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
    _callStatusSubscription?.cancel();
    _chatConnectionRecoverySubscription?.cancel();
    _devices.dispose();
    _panelAnimation.dispose();
    _panelController.dispose();
    widget.call.leave();
    _userChatRepo.disconnectUser();
    _videoEffectsManager.dispose();
    super.dispose();
  }

  /// Whether muting should keep the audio track alive instead of releasing
  /// it.
  ///
  /// Speaking-while-muted detection needs the track on iOS and macOS. Null
  /// everywhere else leaves the call's own default, which releases it.
  bool? get _stopTrackOnMute =>
      CurrentPlatform.isIos || CurrentPlatform.isMacOS ? false : null;

  /// Says so on screen when the call refuses to change a device.
  ///
  /// The SDK controls log a refusal and report it here; without a listener the
  /// press is invisible, because a control's state comes from the call's own
  /// participant state and that does not change on failure.
  void _reportDeviceFailure(VideoError error, String description) {
    final message = 'Could not $description';
    _logger.e(() => '$message: $error');
    if (!mounted) return;

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text('$message: ${error.message}'),
        behavior: SnackBarBehavior.floating,
      ),
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
            _logger.e(
              () => 'Failed to re-watch chat channel after reconnect: $e',
            );
          }
        });

    // Rebuild the widget to enable the chat button.
    setState(() {});
  }

  void _onPanelStatusChanged(AnimationStatus status) {
    // _mountedPanel is held until the exit finishes: unmounting the panel any
    // earlier would take the app bar's height back while it is still on
    // screen.
    if (status == AnimationStatus.dismissed) {
      setState(() => _mountedPanel = null);
    }
  }

  /// Opens [panel], or closes it if it is already the open one.
  void _togglePanel(CallSidePanel panel) {
    if (_openPanel == panel) return _closePanel();

    setState(() {
      _openPanel = _mountedPanel = panel;
      // A panel and the more menu never share the screen: both hang off the
      // same control bar.
      _moreMenuVisible = false;
    });
    _panelController.forward();
  }

  /// Closes whichever panel is up, animating it out.
  void _closePanel() {
    if (_mountedPanel == null) return;

    setState(() => _openPanel = null);
    _panelController.reverse();
  }

  void _toggleMoreMenu() {
    if (_moreMenuVisible) return _closeMoreMenu();

    // The mirror of the exclusion in [_togglePanel].
    _closePanel();
    setState(() => _moreMenuVisible = true);
  }

  void _closeMoreMenu() => setState(() => _moreMenuVisible = false);

  /// The panel's chrome and content, or null when nothing is open or closing.
  Widget? _panelContent(Call call, {required bool fullScreen}) {
    final panel = _mountedPanel;
    if (panel == null) return null;

    return CallSidePanelSurface(
      key: _panelKey,
      docked: !fullScreen,
      onClose: _closePanel,
      title: switch (panel) {
        CallSidePanel.participants => PartialCallStateBuilder(
          call: call,
          selector: (state) => state.callParticipants.length,
          builder: (context, count) => Text('Participants ($count)'),
        ),
        CallSidePanel.chat => const Text('Chat'),
        CallSidePanel.stats => const Text('Stats'),
      },
      child: switch (panel) {
        CallSidePanel.participants => CallParticipantsPanelBody(call: call),
        CallSidePanel.chat => switch (_channel) {
          final channel? => ChatPanelBody(channel: channel),
          // Shown while the channel is still connecting. The control that
          // opens this panel is disabled until it arrives, so this is only
          // reached if the connection never lands.
          null => const Center(child: CircularProgressIndicator()),
        },
        CallSidePanel.stats => CallStatsPanelBody(call: call),
      },
    );
  }

  // The controls the two bar layouts have in common. Built per call rather
  // than held as fields: they close over the call the content builder hands
  // in, and a bar rebuilds whenever the window crosses a breakpoint anyway.

  // The menu opens away from wherever the button sits: upwards out of the
  // control bar along the bottom, downwards out of the app bar.
  StreamLayoutButton _layoutToggle({
    StreamMenuDirection menuDirection = StreamMenuDirection.up,
  }) {
    final blocked = context.streamScreenSize.isSmall
        ? const [
            ParticipantLayoutMode.speakerLeft,
            ParticipantLayoutMode.speakerRight,
          ]
        : const <ParticipantLayoutMode>[];

    return StreamLayoutButton(
      layout: _currentLayoutMode,
      layouts: ParticipantLayoutModeX.selectable
          .whereNot(blocked.contains)
          .toList(),
      menuDirection: menuDirection,
      onLayoutModeChanged: (layout) {
        setState(() {
          _currentLayoutMode = layout;
        });
      },
    );
  }

  StreamScreenShareButton _screenShareOption(Call call) =>
      StreamScreenShareButton(
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
  //
  // Still handed this screen's device controller, so a microphone the platform
  // does not report is badged and inert here as it is on the split buttons.
  StreamMicrophoneButton _microphoneToggle(Call call) => StreamMicrophoneButton(
    call: call,
    devices: _devices,
    stopTrackOnMute: _stopTrackOnMute,
    onError: _reportDeviceFailure,
  );

  /// The phone bar's camera. See [_microphoneToggle].
  StreamCameraButton _cameraToggle(Call call) => StreamCameraButton(
    call: call,
    devices: _devices,
    onError: _reportDeviceFailure,
  );

  // Split buttons rather than plain toggles, so the device can be changed
  // mid-call without opening the settings menu.
  //
  // Sharing this screen's one controller with the plain toggles, so the two
  // never disagree about which device is in use.
  StreamMicrophoneSplitButton _microphoneButton(Call call) =>
      StreamMicrophoneSplitButton(
        call: call,
        devices: _devices,
        // The bar sits along the bottom, so its menus come up rather than
        // down.
        menuDirection: StreamMenuDirection.up,
        stopTrackOnMute: _stopTrackOnMute,
        onError: _reportDeviceFailure,
      );

  /// The camera's split button. See [_microphoneButton].
  StreamCameraSplitButton _cameraButton(Call call) => StreamCameraSplitButton(
    call: call,
    devices: _devices,
    menuDirection: StreamMenuDirection.up,
    onError: _reportDeviceFailure,
  );

  // CallFeatureButton rather than StreamParticipantsButton, which has no
  // selected state to show that the panel is up.
  Widget _participantsControl(Call call) => PartialCallStateBuilder(
    call: call,
    selector: (state) => state.callParticipants.length,
    builder: (context, count) => BadgedCallOption(
      badgeCount: count == 0 ? null : count,
      callControlOption: CallFeatureButton(
        icon: Icon(context.streamIcons.usersFill),
        tooltip: 'Participants',
        selected: _openPanel == CallSidePanel.participants,
        onPressed: () => _togglePanel(CallSidePanel.participants),
      ),
    ),
  );

  /// The call's control bar, laid out per screen size.
  CallControlBar _callControls(BuildContext context, Call call) {
    final moreButton = CallFeatureButton(
      icon: Icon(context.streamIcons.moreVerticalFill),
      selected: _moreMenuVisible,
      onPressed: _toggleMoreMenu,
    );

    final panels = [
      _participantsControl(call),
      _ShowChatButton(
        channel: _channel,
        selected: _openPanel == CallSidePanel.chat,
        onPressed: () => _togglePanel(CallSidePanel.chat),
      ),
    ];

    return CallControlBar(
      // A phone splits its controls between the two edges: there
      // is not enough width for a centre row and sides both. Five
      // controls, as the design draws it — screen sharing and the
      // device pickers are reachable from the more menu.
      small: CallControlBarLayout(
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
      // is worth one extra control and a caret at this size.
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
            onPressed: _toggleMoreMenu,
          ),
          _layoutToggle(),
        ],
        center: [
          _microphoneButton(call),
          _cameraButton(call),
          StreamClosedCaptionsButton(call: call),
          StreamAddReactionButton(call: call),
          _screenShareOption(call),
          StreamRecordingButton(call: call),
          StreamLeaveCallButton(call: call),
        ],
        trailing: [
          CallFeatureButton(
            icon: Icon(context.streamIcons.statsFill),
            selected: _openPanel == CallSidePanel.stats,
            onPressed: () => _togglePanel(CallSidePanel.stats),
          ),
          ...panels,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Keyed to what is on screen, not to what was asked for: a panel is
        // still visible while it animates out, and back should dismiss it
        // rather than fall through and leave the call.
        if (_mountedPanel != null) {
          _closePanel();
          return false;
        }

        if (_moreMenuVisible) {
          _closeMoreMenu();
          return false;
        }

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
                // A narrow window has no room beside the grid, so the panel
                // covers it instead of docking next to it.
                final fullScreen = context.streamScreenSize.isSmall;

                return CallSidePanelLayout(
                  animation: _panelAnimation,
                  panel: _panelContent(call, fullScreen: fullScreen),
                  fullScreen: fullScreen,
                  // What the collapsed app bar gave up, handed back to the
                  // grid so it neither moves nor re-tiles while a panel is up.
                  coveredTopExtent: _mountedPanel != null ? kToolbarHeight : 0,
                  child: Stack(
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
                          onTap: _closeMoreMenu,
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
                                onReactionSend: (_) => _closeMoreMenu(),
                                onStatsPressed: () =>
                                    _togglePanel(CallSidePanel.stats),
                                onAudioOutputChange: (_, {closeMenu = true}) {
                                  if (closeMenu) _closeMoreMenu();
                                },
                                onAudioInputChange: (_) => _closeMoreMenu(),
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
                            selector: (state) =>
                                state.otherParticipants.isEmpty,
                            builder: (context, isEmpty) => isEmpty
                                ? ShareCallWelcomeCard(
                                    call: call,
                                    encryptionKey: _encryptionKey,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                    ],
                  ),
                );
              },
              callAppBarWidgetBuilder: (context, call) {
                // A narrow window gives the whole body to the panel, the app
                // bar's row included. A zero-height bar rather than null,
                // because null falls back to the SDK's own.
                if (context.streamScreenSize.isSmall && _mountedPanel != null) {
                  return PreferredSize(
                    preferredSize: Size.zero,
                    // Scaffold sizes this slot from the child rather than the
                    // preferred size, and strips the top inset from the body's
                    // MediaQuery either way — so the status bar's strip has to
                    // be held open here or the panel runs under the notch.
                    child: SizedBox(height: MediaQuery.paddingOf(context).top),
                  );
                }

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
                      if (isCompact)
                        _layoutToggle(
                          menuDirection: StreamMenuDirection.down,
                        ),
                      PartialCallStateBuilder(
                        call: call,
                        selector: (state) => state.localParticipant != null,
                        builder: (context, hasLocalParticipant) =>
                            hasLocalParticipant
                            ? StreamFlipCameraButton(call: call)
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  title: CallDurationTitle(call: call),
                );
              },
              callControlsWidgetBuilder: _callControls,
            );
          },
        ),
      ),
    );
  }
}

class _ShowChatButton extends StatefulWidget {
  const _ShowChatButton({
    required this.channel,
    required this.selected,
    required this.onPressed,
  });

  /// The call's chat channel, or null while it is still connecting — the
  /// button is disabled until it arrives.
  final Channel? channel;

  /// Whether the chat panel is the one currently open.
  final bool selected;

  /// Called to open or close the chat panel.
  final VoidCallback onPressed;

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
      callControlOption: CallFeatureButton(
        icon: Icon(context.streamIcons.messageBubblesFill),
        selected: widget.selected,
        onPressed: widget.channel != null ? widget.onPressed : null,
      ),
      badgeCount: _unreadCount == 0 ? null : _unreadCount,
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
