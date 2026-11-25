// ignore_for_file: strict_raw_type

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../stream_video_flutter.dart';

typedef LivestreamEndedWidgetBuilder =
    Widget Function(
      BuildContext context,
      Call call,
    );

typedef LivestreamBackstageWidgetBuilder =
    Widget Function(
      BuildContext context,
      Call call,
    );

typedef LivestreamControlsWidgetBuilder =
    Widget Function(
      BuildContext context,
      Call call,
    );

enum LivestreamJoinBehaviour {
  /// Automatically join the livestream backstage or live call when the widget is initialized. Depending on permissions.
  autoJoinAsap,

  /// Automatically join the livestream when it goes live.
  autoJoinWhenLive,

  /// Do not automatically join the livestream.
  manualJoin,
}

/// Creates a widget that allows a user to view a livestream.
///
/// The call duration sits in the app bar. The video is shown in a
/// [StreamLivestreamTile], whose toolbar shows whether the call is live, the
/// viewer count and a fullscreen button, plus a speakerphone toggle when one
/// is asked for. Before the call goes live and after it ends, a status card
/// takes the video's place.
class LivestreamPlayer extends StatefulWidget {
  /// Creates a livestream player
  ///
  /// * [call] is the livestream call intended to be viewed.
  ///
  /// * [showParticipantCount] defines if the call should show participant count.
  ///
  /// * [backButtonBuilder] allows you to build a back/close button for closing the livestream.
  ///
  /// * [videoPlaceholderBuilder] allows you to build a video placeholder for the
  /// video renderer. This is useful when the video is not available or
  /// disconnected. By default, it uses the [StreamUserAvatar] widget
  ///
  /// * [livestreamHostsUnavailableBuilder] allows you to build a custom widget when
  /// a livestream is connected but no host is in it.
  ///
  /// * [livestreamNotConnectedBuilder] allows you to build a custom widget when
  /// the livestream is not connected. Provides connection state information.
  ///
  /// * [videoRendererBuilder] allows you to build a custom video renderer
  ///
  /// * [allowDiagnostics] displays call diagnostics when the widget is double-tapped.
  const LivestreamPlayer({
    super.key,
    required this.call,
    this.joinBehaviour = LivestreamJoinBehaviour.autoJoinAsap,
    this.connectOptions,
    this.showParticipantCount,
    this.includeAnonymousParticipants = true,
    this.showLiveIndicator,
    this.showSpeakerphoneToggle,
    this.showRecordingsWhenEnded = true,
    this.backButtonBuilder,
    this.livestreamEndedWidgetBuilder,
    this.livestreamBackstageWidgetBuilder,
    this.livestreamControlsWidgetBuilder,
    this.videoPlaceholderBuilder,
    this.videoRendererBuilder,
    this.livestreamHostsUnavailableBuilder,
    this.livestreamNotConnectedBuilder,
    this.livestreamFastReconnectingOverlayBuilder,
    this.livestreamHostsParticipantBuilder,
    this.livestreamHostsParticipantsFilter,
    this.allowDiagnostics = false,
    this.onCallDisconnected,
    this.onRecordingTapped,
    this.onFullscreenTapped,
    this.startInFullscreenMode = false,
    this.showMultipleHosts = false,
    this.layoutMode = ParticipantLayoutMode.grid,
    this.screenShareMode = LivestreamScreenShareMode.spotlight,
    this.videoFit = VideoFit.adaptive,
    this.fullscreenVideoFit = VideoFit.adaptive,
    this.pictureInPictureConfiguration = const PictureInPictureConfiguration(),
    this.leaveCallOnDispose = true,
  });

  /// The livestream call to display.
  final Call call;

  /// Defines the behavior for automatically joining the livestream.
  final LivestreamJoinBehaviour joinBehaviour;

  /// Whether the player leaves the call when it is disposed, for example
  /// when its route is popped with the back button.
  ///
  /// It only applies to a call this player joined itself, through
  /// [joinBehaviour]. A call the app joined, or started joining, before the
  /// player was shown, or joined with [LivestreamJoinBehaviour.manualJoin], is
  /// left to the app.
  ///
  /// A left call cannot be joined again, so anything that disposes the player
  /// and builds a new one for the same call ends the livestream, for example
  /// a page without keep-alive or an `AnimatedSwitcher`. Keep the player
  /// mounted, give it a `GlobalKey` when it moves in the tree, or set this to
  /// `false`.
  ///
  /// Set it to `false` when the livestream should keep playing after the
  /// player is gone, such as in an in-app picture-in-picture overlay.
  final bool leaveCallOnDispose;

  /// Options used when joining the livestream.
  /// If null, defaults to disabling camera and microphone.
  final CallConnectOptions? connectOptions;

  /// Whether the toolbar shows the viewer count.
  ///
  /// Falls back to [StreamLivestreamTileStyle.showSpectatorsIndicator], then
  /// true.
  final bool? showParticipantCount;

  /// Whether anonymous viewers are part of the participant count.
  ///
  /// Defaults to true.
  final bool includeAnonymousParticipants;

  /// Whether the toolbar shows whether the call is live.
  ///
  /// Falls back to [StreamLivestreamTileStyle.showLiveIndicator], then true.
  final bool? showLiveIndicator;

  /// Whether the toolbar shows the speakerphone toggle.
  ///
  /// Falls back to [StreamLivestreamTileStyle.showSpeakerphoneToggle], then
  /// false.
  final bool? showSpeakerphoneToggle;

  /// Boolean to display list of recordings when the livestream has ended.
  ///
  /// Defaults to true.
  final bool showRecordingsWhenEnded;

  /// Determines whether the livestream should start in fullscreen mode.
  /// When true, the video is shown with [fullscreenVideoFit].
  /// When false, it is shown with [videoFit].
  /// Defaults to false.
  final bool startInFullscreenMode;

  /// [WidgetBuilder] used to build a back or close button.
  ///
  /// It is shown at the start of the app bar, which fullscreen hides.
  final WidgetBuilder? backButtonBuilder;

  /// The builder used to create a custom widget when the livestream has ended.
  ///
  /// It replaces the whole screen, app bar and back button included.
  final LivestreamEndedWidgetBuilder? livestreamEndedWidgetBuilder;

  /// The builder used to create a custom widget when the livestream is in backstage mode.
  ///
  /// It replaces the whole screen, app bar and back button included.
  final LivestreamBackstageWidgetBuilder? livestreamBackstageWidgetBuilder;

  /// The builder used to create custom controls for the livestream player.
  ///
  /// The controls replace the tile's toolbar and are laid over the video,
  /// in fullscreen too.
  final LivestreamControlsWidgetBuilder? livestreamControlsWidgetBuilder;

  /// Builder function used to build a video placeholder.
  final VideoPlaceholderBuilder? videoPlaceholderBuilder;

  /// Builder function used to build a video renderer.
  final VideoRendererBuilder? videoRendererBuilder;

  /// Builder function used to create a custom widget when a livestream is
  /// connected but no host is in it.
  final LivestreamHostsUnavailableBuilder? livestreamHostsUnavailableBuilder;

  /// Builder function used to create a custom widget when the livestream is not connected.
  /// Provides connection state information (isMigrating, isReconnecting) that can be
  /// used to show appropriate status messages.
  final LivestreamNotConnectedBuilder? livestreamNotConnectedBuilder;

  /// Builder function used to create a custom widget when the livestream is fast reconnecting.
  final LivestreamFastReconnectingOverlayBuilder?
  livestreamFastReconnectingOverlayBuilder;

  /// Builder function used to create a custom widget displaying the hosts video.
  final LivestreamHostsParticipantBuilder? livestreamHostsParticipantBuilder;

  /// Function used to select the hosts from all the call participants.
  ///
  /// If null, the participants with video enabled are the hosts. While none
  /// has video, the participants with the `host` role and the call's creator
  /// are, and their tiles show their avatar.
  /// If [showMultipleHosts] is false, only the first host is shown.
  final LivestreamHostsParticipantsFilter? livestreamHostsParticipantsFilter;

  /// The action to perform when the call is disconnected.
  ///
  /// By default, it leaves the call and pops the current route, except when
  /// the livestream ended: then the player stays and shows the ended view.
  final void Function(CallDisconnectedProperties)? onCallDisconnected;

  /// The action to perform when the recording shown when livestream is ended is tapped.
  final FutureOr<void> Function(String)? onRecordingTapped;

  /// The action to perform when the fullscreen button is tapped.
  ///
  /// It replaces the player's own toggle, so the player stays in the mode it
  /// started in: [fullscreenVideoFit] then only applies with
  /// [startInFullscreenMode].
  final VoidCallback? onFullscreenTapped;

  /// Denotes if the livestream allows multiple hosts.
  /// Used with default [livestreamHostsParticipantBuilder] to display the hosts video.
  ///
  /// If yes, use [layoutMode] to set the participants layout.
  /// If no, only the first streaming participant will be shown.
  ///
  /// Defaults to false.
  final bool showMultipleHosts;

  /// The layout mode used to display the hosts when [showMultipleHosts] is true.
  final ParticipantLayoutMode layoutMode;

  /// The screen share mode used to display the screen share host.
  final LivestreamScreenShareMode screenShareMode;

  /// How the video is fitted while the player is not in fullscreen mode.
  ///
  /// Defaults to [VideoFit.adaptive]: the video fills the tile when it shares
  /// the tile's orientation, and is letterboxed when it does not.
  /// Pass [VideoFit.contain] to always show the whole video.
  final VideoFit videoFit;

  /// How the video is fitted while the player is in fullscreen mode.
  ///
  /// Defaults to [VideoFit.adaptive]: the video fills the player when it
  /// shares the player's orientation, and is letterboxed when it does not, so
  /// a landscape feed on a portrait phone is shown whole.
  /// Pass [VideoFit.cover] to always fill the player, cropping a feed whose
  /// orientation differs.
  final VideoFit fullscreenVideoFit;

  /// Boolean to allow a user to double-tap a call to see diagnostic data.
  ///
  /// Defaults to false.
  final bool allowDiagnostics;

  /// Configuration for picture-in-picture mode.
  final PictureInPictureConfiguration pictureInPictureConfiguration;

  @override
  State<LivestreamPlayer> createState() => _LivestreamPlayerState();
}

class _LivestreamPlayerState extends State<LivestreamPlayer>
    with SingleTickerProviderStateMixin {
  final _logger = taggedLogger(tag: 'SV:LivestreamPlayer');

  StreamSubscription? _joinSubscription;
  StreamSubscription? _leaveSubscription;

  /// Set once the auto-join has fired, so it fires only once per player.
  bool _connectStarted = false;

  /// The call this player joined itself, which it leaves on dispose. Null
  /// when the app joined the call, or nothing was joined.
  Call? _joinedCall;

  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  /// Represents a call.
  Call get call => widget.call;

  /// Controls the visibility of diagnostic data.
  bool _isStatsVisible = false;

  /// Stores if the livestream is in fullscreen mode, which shows the video
  /// with [LivestreamPlayer.fullscreenVideoFit].
  bool _fullscreen = false;

  /// Whether the livestream is over and this player still owes its route a
  /// pop. See [_popSelf].
  var _popPending = false;

  /// Whether this player is closing its route itself, which the fullscreen
  /// back handling must not hold back.
  var _closing = false;

  @override
  void initState() {
    super.initState();

    _fullscreen = widget.startInFullscreenMode;

    if (widget.joinBehaviour != LivestreamJoinBehaviour.manualJoin) {
      _joinWhenPossible();
    }

    _leaveOnDisconnect();
  }

  void _joinWhenPossible() {
    final tickStream = Stream<DateTime>.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now().toUtc(),
    );

    final canJoinEarlyStream = call
        .partialState(
          (state) => (
            startsAt: state.startsAt,
            joinAheadSeconds: state.settings.backstage.joinAheadTimeSeconds,
          ),
        )
        .switchMap((data) {
          final startsAt = data.startsAt;
          final joinAheadSeconds = data.joinAheadSeconds;

          if (startsAt == null || joinAheadSeconds == null) {
            return Stream<bool>.value(false);
          }

          final windowOpensAt = startsAt.subtract(
            Duration(seconds: joinAheadSeconds),
          );
          final now = DateTime.now().toUtc();
          final isWithinWindow = !now.isBefore(windowOpensAt);

          if (isWithinWindow) {
            return Stream<bool>.value(true);
          }

          // Not yet in the window: use the tick stream, filter with .where(),
          // emit false initially, then true when the window opens and complete.
          return tickStream
              .where((nowTick) => !nowTick.isBefore(windowOpensAt))
              .take(1)
              .map((_) => true)
              .startWith(false);
        })
        .distinct();

    final callData = call.partialState(
      (state) => (
        isLive: !state.isBackstage,
        canJoinBackstage: state.ownCapabilities.contains(
          CallPermission.joinBackstage,
        ),
        status: state.status,
      ),
    );

    _joinSubscription =
        Rx.combineLatest2(
          callData,
          canJoinEarlyStream,
          (callData, canJoinEarly) => (
            canJoinAsap:
                callData.isLive || callData.canJoinBackstage || canJoinEarly,
            isLive: callData.isLive,
          ),
        ).listen((data) {
          {
            if (widget.joinBehaviour == LivestreamJoinBehaviour.autoJoinAsap &&
                data.canJoinAsap) {
              _connect();
            } else if (widget.joinBehaviour ==
                    LivestreamJoinBehaviour.autoJoinWhenLive &&
                data.isLive) {
              _connect();
            }
          }
        });

    _compositeSubscription.add(_joinSubscription!);
  }

  void _leaveOnDisconnect() {
    _leaveSubscription = call.partialState((state) => state.status).listen((
      status,
    ) {
      if (status.isDisconnected) {
        _leaveSubscription?.cancel();

        if (widget.onCallDisconnected != null) {
          final disconnectedStatus = status as CallStatusDisconnected;
          final disconnectedProperties = CallDisconnectedProperties(
            reason: disconnectedStatus.reason,
            call: call,
          );

          widget.onCallDisconnected?.call(disconnectedProperties);
        } else if (status case CallStatusDisconnected(
          reason: DisconnectReasonEnded(),
        )) {
          _logger.d(() => '[onDisconnected] livestream ended, staying');
        } else {
          _leave();
        }
      }
    });

    _compositeSubscription.add(_leaveSubscription!);
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();

    final joinedCall = _joinedCall;
    if (widget.leaveCallOnDispose && joinedCall != null) {
      unawaited(_leaveOnDispose(joinedCall));
    }

    super.dispose();
  }

  /// Leaves [call] once the player is gone, so the livestream does not keep
  /// playing behind a closed screen.
  Future<void> _leaveOnDispose(Call call) async {
    if (call.state.value.status.isDisconnected) return;

    _logger.d(() => '[dispose] leaving call: ${call.callCid}');
    try {
      final result = await call.leave(
        reason: const DisconnectReason.left(initiator: LeaveInitiator.app),
      );
      if (result is Failure) {
        _logger.e(() => '[dispose] leave failed: $result');
      }
    } catch (e, stk) {
      _logger.e(() => '[dispose] leave failed: $e\n$stk');
    }
  }

  @override
  void didUpdateWidget(LivestreamPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.call != widget.call) _popPending = false;
  }

  @override
  Widget build(BuildContext context) {
    // The duration badge repaints every second as it ticks; the boundary
    // keeps that from repainting the screen the player is embedded in.
    return RepaintBoundary(child: _buildPlayer(context));
  }

  // A host ending the call disconnects the viewers before `endedAt` is
  // known, so that disconnect counts as ended too.
  static ({bool isBackstage, bool hasEnded}) _playerData(CallState state) => (
    isBackstage: state.isBackstage,
    hasEnded:
        state.endedAt != null ||
        switch (state.status) {
          CallStatusDisconnected(reason: DisconnectReasonEnded()) => true,
          _ => false,
        },
  );

  Widget _buildPlayer(BuildContext context) {
    if (_popPending) {
      // `ModalRoute.of` depends on the route's own status, so this rebuilds
      // once this player's route becomes the top one and the pop it owes can
      // finally happen.
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) unawaited(_popSelf());
        });
      }
    }

    return PartialCallStateBuilder(
      call: call,
      selector: _playerData,
      builder: (context, data) {
        if (data.hasEnded) {
          return widget.livestreamEndedWidgetBuilder?.call(context, call) ??
              _layout(
                context,
                body: LivestreamEndedContent(
                  call: call,
                  showRecordings: widget.showRecordingsWhenEnded,
                  onRecordingTapped: widget.onRecordingTapped,
                ),
              );
        }

        if (data.isBackstage) {
          return widget.livestreamBackstageWidgetBuilder?.call(context, call) ??
              _layout(
                context,
                body: LivestreamBackstageContent(call: widget.call),
              );
        }

        return _layout(
          context,
          body: _liveTile(context),
          fullscreen: _fullscreen,
        );
      },
    );
  }

  /// The live video in the livestream tile, or under the custom controls
  /// when [LivestreamPlayer.livestreamControlsWidgetBuilder] builds them.
  Widget _liveTile(BuildContext context) {
    Widget content = LivestreamContent(
      call: call,
      videoPlaceholderBuilder: widget.videoPlaceholderBuilder,
      videoRendererBuilder: widget.videoRendererBuilder,
      livestreamHostsUnavailableBuilder:
          widget.livestreamHostsUnavailableBuilder,
      livestreamNotConnectedBuilder: widget.livestreamNotConnectedBuilder,
      livestreamFastReconnectingOverlayBuilder:
          widget.livestreamFastReconnectingOverlayBuilder,
      livestreamHostsParticipantBuilder:
          widget.livestreamHostsParticipantBuilder,
      livestreamHostsParticipantsFilter:
          widget.livestreamHostsParticipantsFilter,
      displayDiagnostics: _isStatsVisible,
      videoFit: _fullscreen ? widget.fullscreenVideoFit : widget.videoFit,
      showMultipleHosts: widget.showMultipleHosts,
      layoutMode: widget.layoutMode,
      screenShareMode: widget.screenShareMode,
      pictureInPictureConfiguration: widget.pictureInPictureConfiguration,
    );

    // Wrapped in both modes, so toggling fullscreen keeps the video's
    // elements. Edge to edge, the video's corners are square.
    final tileTheme = StreamParticipantTileTheme.of(context);
    content = StreamParticipantTileTheme(
      data: _fullscreen
          ? tileTheme.copyWith(
              style: (tileTheme.style ?? const StreamParticipantTileStyle())
                  .copyWith(borderRadius: BorderRadius.zero),
            )
          : tileTheme,
      child: content,
    );

    final controls = widget.livestreamControlsWidgetBuilder?.call(
      context,
      call,
    );

    return GestureDetector(
      onDoubleTap: () {
        if (widget.allowDiagnostics) {
          setState(() {
            _isStatsVisible = !_isStatsVisible;
          });
        }
      },
      child: controls != null
          // Custom controls take the toolbar's place over the video.
          ? Stack(
              children: [
                SizedBox.expand(child: content),
                controls,
              ],
            )
          : StreamLivestreamTile(
              call: call,
              style: _fullscreen ? _fullscreenTileStyle(context) : null,
              isFullscreen: _fullscreen,
              showLiveIndicator: widget.showLiveIndicator,
              showSpectatorsIndicator: widget.showParticipantCount,
              includeAnonymousParticipants: widget.includeAnonymousParticipants,
              showSpeakerphoneToggle: widget.showSpeakerphoneToggle,
              onFullscreenTapped: () {
                if (widget.onFullscreenTapped != null) {
                  widget.onFullscreenTapped?.call();
                } else {
                  setState(() {
                    _fullscreen = !_fullscreen;
                  });
                }
              },
              child: content,
            ),
    );
  }

  /// Insets the toolbar by `md` at the start and `md - xs` at the end when
  /// the tile fills the screen, unless the theme sets its own padding. The
  /// fullscreen button's tap target adds the other `xs` at the end.
  StreamLivestreamTileStyle? _fullscreenTileStyle(BuildContext context) {
    final themed = StreamLivestreamTileTheme.of(context).style?.toolbarPadding;
    if (themed != null) return null;

    final spacing = context.streamSpacing;
    return StreamLivestreamTileStyle(
      toolbarPadding: EdgeInsetsDirectional.only(
        start: spacing.md,
        end: spacing.md - spacing.xs,
      ),
    );
  }

  /// The screen around [body]: the back button and the call duration at the
  /// top. In [fullscreen], [body] fills the screen on its own, and back leaves
  /// fullscreen before it leaves the screen.
  ///
  /// Both modes build the same widgets around [body], so toggling fullscreen
  /// keeps the video's elements.
  Widget _layout(
    BuildContext context, {
    required Widget body,
    bool fullscreen = false,
  }) {
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;

    return PopScope(
      // Back leaves fullscreen first when the player toggles it itself.
      canPop: _closing || !fullscreen || widget.onFullscreenTapped != null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _fullscreen = false);
      },
      child: Scaffold(
        backgroundColor: colorScheme.backgroundApp,
        appBar: fullscreen
            ? null
            : CallAppBar(
                call: call,
                showBackButton: false,
                showLeaveCallAction: false,
                leading: widget.backButtonBuilder?.call(context),
                // Repaints once a second, so it doesn't repaint the video
                // with it.
                title: RepaintBoundary(
                  child: StreamCallDurationBadge(call: call),
                ),
              ),
        // The larger of the safe area and the side spacing, not both. In
        // fullscreen the body goes edge to edge.
        body: SafeArea(
          left: !fullscreen,
          top: false,
          right: !fullscreen,
          bottom: !fullscreen,
          minimum: fullscreen
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(horizontal: spacing.xs),
          child: body,
        ),
      ),
    );
  }

  /// Joins a call.
  Future<void> _connect() async {
    // Stop listening before the first await. The join stream also emits on
    // every status change the join itself causes (Idle -> Connecting ->
    // Connected), and each of those emissions would otherwise start another
    // join while this one is still in flight.
    if (_connectStarted) return;
    _connectStarted = true;
    unawaited(_joinSubscription?.cancel());
    _joinSubscription = null;

    // A player mounted on a call the app already joined, or is joining, has
    // nothing to join, and leaves that call to the app.
    final status = call.state.value.status;
    if (status.isConnecting || status.isJoining || status.isAlreadyJoined) {
      _logger.d(() => '[connect] skipped, call already joined: $status');
      return;
    }

    try {
      _logger.d(() => '[connect] no args');
      final connectOptions =
          widget.connectOptions ??
          CallConnectOptions(
            camera: TrackOption.disabled(),
            microphone: TrackOption.disabled(),
          );

      _joinedCall = call;
      final result = await call.join(connectOptions: connectOptions);
      if (result case Failure(:final error)) {
        _logger.w(() => '[connect] failed: $error');
      } else {
        _logger.v(() => '[connect] completed: $result');
      }
    } catch (e) {
      _logger.v(() => '[connect] failed: $e');
      await _leave();
    } finally {
      await _joinSubscription?.cancel();
      _joinSubscription = null;
    }
  }

  Future<void> _leave() async {
    try {
      _logger.d(() => '[leave] no args');
      await call.leave(
        reason: const DisconnectReason.left(initiator: LeaveInitiator.app),
      );
      // play tone
      await _popSelf();
    } finally {
      await _joinSubscription?.cancel();
      _joinSubscription = null;
    }
  }

  /// Closes the route this player is in, once that is the route a pop would
  /// actually close.
  Future<void> _popSelf() async {
    if (!mounted) {
      _logger.v(() => '[leave] popped: false');
      return;
    }

    if (!(ModalRoute.of(context)?.isCurrent ?? true)) {
      _logger.v(() => '[leave] not the top route; waiting to pop');
      _popPending = true;
      setState(() {});
      return;
    }

    _popPending = false;
    if (!_closing) {
      // Rebuild the PopScope so it lets this pop through.
      setState(() => _closing = true);
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
    }
    final popped = await Navigator.maybePop(context);
    _logger.v(() => '[leave] popped: $popped');
    // Something above vetoed the pop; back handles fullscreen again.
    if (!popped && mounted) setState(() => _closing = false);
  }
}
