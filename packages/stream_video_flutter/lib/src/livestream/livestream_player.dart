// ignore_for_file: strict_raw_type, deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../stream_video_flutter.dart';

typedef LivestreamEndedBuilder =
    Widget Function(BuildContext context, Call call, CallState callState);

typedef LivestreamBackstageBuilder =
    Widget Function(BuildContext context, Call call, CallState callState);

typedef LivestreamControlsBuilder =
    Widget Function(BuildContext context, Call call, CallState callState);

typedef LivestreamEndedWidgetBuilder =
    Widget Function(BuildContext context, Call call);

typedef LivestreamBackstageWidgetBuilder =
    Widget Function(BuildContext context, Call call);

typedef LivestreamControlsWidgetBuilder =
    Widget Function(BuildContext context, Call call);

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
/// By default, the widget has call controls and other elements including:
/// play/pause the stream, live/backstage indicator, participant count,
/// call duration, mute/unmute call, expand/contract livestream.
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
  /// a livestream is connected but no hosts have video enabled.
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
    this.showParticipantCount = true,
    this.showRecordingsWhenEnded = true,
    this.backButtonBuilder,
    @Deprecated('Use livestreamEndedWidgetBuilder instead.')
    this.livestreamEndedBuilder,
    this.livestreamEndedWidgetBuilder,
    @Deprecated('Use livestreamBackstageWidgetBuilder instead.')
    this.livestreamBackstageBuilder,
    this.livestreamBackstageWidgetBuilder,
    @Deprecated('Use livestreamControlsWidgetBuilder instead.')
    this.livestreamControlsBuilder,
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
    this.videoFit = VideoFit.contain,
    this.pictureInPictureConfiguration = const PictureInPictureConfiguration(),
  });

  /// The livestream call to display.
  final Call call;

  /// Defines the behavior for automatically joining the livestream.
  final LivestreamJoinBehaviour joinBehaviour;

  /// Options used when joining the livestream.
  /// If null, defaults to disabling camera and microphone.
  final CallConnectOptions? connectOptions;

  /// Boolean to display participant count.
  ///
  /// Defaults to true.
  final bool showParticipantCount;

  /// Boolean to display list of recordings when the livestream has ended.
  ///
  /// Defaults to true.
  final bool showRecordingsWhenEnded;

  /// Determines whether the livestream should start in fullscreen mode.
  /// When true, the video will expand to cover the entire available space.
  /// When false, the video will be contained within its boundaries.
  /// Defaults to false.
  final bool startInFullscreenMode;

  /// [WidgetBuilder] used to build an action button on the top left side of
  /// the screen.
  final WidgetBuilder? backButtonBuilder;

  /// The builder used to create a custom widget when the livestream has ended.
  ///
  /// Recommend to use [livestreamEndedWidgetBuilder] and listen to the partialState of the call.
  @Deprecated('Use livestreamEndedWidgetBuilder instead.')
  final LivestreamEndedBuilder? livestreamEndedBuilder;

  /// The builder used to create a custom widget when the livestream has ended.
  final LivestreamEndedWidgetBuilder? livestreamEndedWidgetBuilder;

  /// The builder used to create a custom widget when the livestream is in backstage mode.
  ///
  /// Recommend to use [livestreamBackstageWidgetBuilder] and listen to the partialState of the call.
  @Deprecated('Use livestreamBackstageWidgetBuilder instead.')
  final LivestreamBackstageBuilder? livestreamBackstageBuilder;

  /// The builder used to create a custom widget when the livestream is in backstage mode.
  final LivestreamBackstageWidgetBuilder? livestreamBackstageWidgetBuilder;

  /// The builder used to create custom controls for the livestream player.
  /// This allows customization of the control UI elements displayed during the livestream.
  ///
  /// Recommend to use [livestreamControlsWidgetBuilder] and listen to the partialState of the call.
  @Deprecated('Use livestreamControlsWidgetBuilder instead.')
  final LivestreamControlsBuilder? livestreamControlsBuilder;

  /// The builder used to create custom controls for the livestream player.
  /// This allows customization of the control UI elements displayed during the livestream.
  final LivestreamControlsWidgetBuilder? livestreamControlsWidgetBuilder;

  /// Builder function used to build a video placeholder.
  final VideoPlaceholderBuilder? videoPlaceholderBuilder;

  /// Builder function used to build a video renderer.
  final VideoRendererBuilder? videoRendererBuilder;

  /// Builder function used to create a custom widget when a livestream is connected
  /// but no hosts have video enabled.
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
  /// If null, participants that have video enabled will be treated as hosts.
  /// If [showMultipleHosts] is false, only the first streaming participant will be shown.
  final LivestreamHostsParticipantsFilter? livestreamHostsParticipantsFilter;

  /// The action to perform when the call is disconnected. By default, it pops the current route.
  final void Function(CallDisconnectedProperties)? onCallDisconnected;

  /// The action to perform when the recording shown when livestream is ended is tapped.
  final FutureOr<void> Function(String)? onRecordingTapped;

  /// The action to perform when dfullscreen button is tapped.
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

  /// Denotes if the video fits the width (contain) or expands to
  /// the whole size (cover).
  final VideoFit videoFit;

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

  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  @Deprecated(PartialStateDeprecationMessage.callState)
  late CallState _callState;

  /// Controls the visibility of diagnostic data.
  bool _isStatsVisible = false;

  /// Stores if the livestream is in cover or contain mode.
  bool _fullscreen = false;

  @override
  void initState() {
    super.initState();

    //Remove once partial state deprecation is complete.
    _callState = call.state.value;

    _fullscreen = widget.startInFullscreenMode;

    if (widget.joinBehaviour != LivestreamJoinBehaviour.manualJoin) {
      _joinWhenPossible();
    }

    _leaveOnDisconnect();

    // Only listen to call state if any of the builders that depend on it are provided.
    // Remove once partial state deprecation is complete.
    if (widget.livestreamEndedBuilder != null ||
        widget.livestreamBackstageBuilder != null ||
        widget.livestreamControlsBuilder != null) {
      _compositeSubscription.add(
        widget.call.state.listen((callState) {
          setState(() {
            _callState = callState;
          });
        }),
      );
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PartialCallStateBuilder(
      call: call,
      selector: (state) =>
          (isBackstage: state.isBackstage, hasEnded: state.endedAt != null),
      builder: (context, data) {
        final isBackstage = data.isBackstage;
        final hasEnded = data.hasEnded;

        if (hasEnded) {
          return widget.livestreamEndedWidgetBuilder?.call(context, call) ??
              widget.livestreamEndedBuilder?.call(context, call, _callState) ??
              LivestreamEndedContent(
                call: call,
                showRecordings: widget.showRecordingsWhenEnded,
                onRecordingTapped: widget.onRecordingTapped,
              );
        }

        if (isBackstage) {
          return widget.livestreamBackstageWidgetBuilder?.call(context, call) ??
              widget.livestreamBackstageBuilder?.call(
                context,
                call,
                _callState,
              ) ??
              LivestreamBackstageContent(call: widget.call);
        }

        return GestureDetector(
          onDoubleTap: () {
            if (widget.allowDiagnostics) {
              setState(() {
                _isStatsVisible = !_isStatsVisible;
              });
            }
          },
          child: Scaffold(
            body: Stack(
              children: [
                LivestreamContent(
                  call: call,
                  callState: _callState,
                  backButtonBuilder: widget.backButtonBuilder,
                  videoPlaceholderBuilder: widget.videoPlaceholderBuilder,
                  videoRendererBuilder: widget.videoRendererBuilder,
                  livestreamHostsUnavailableBuilder:
                      widget.livestreamHostsUnavailableBuilder,
                  livestreamNotConnectedBuilder:
                      widget.livestreamNotConnectedBuilder,
                  livestreamFastReconnectingOverlayBuilder:
                      widget.livestreamFastReconnectingOverlayBuilder,
                  livestreamHostsParticipantBuilder:
                      widget.livestreamHostsParticipantBuilder,
                  livestreamHostsParticipantsFilter:
                      widget.livestreamHostsParticipantsFilter,
                  displayDiagnostics: _isStatsVisible,
                  videoFit: _fullscreen ? VideoFit.cover : widget.videoFit,
                  showMultipleHosts: widget.showMultipleHosts,
                  layoutMode: widget.layoutMode,
                  screenShareMode: widget.screenShareMode,
                  pictureInPictureConfiguration:
                      widget.pictureInPictureConfiguration,
                ),
                widget.livestreamControlsWidgetBuilder?.call(context, call) ??
                    widget.livestreamControlsBuilder?.call(
                      context,
                      call,
                      _callState,
                    ) ??
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: StreamBuilder<Duration>(
                        stream: call.callDurationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data ?? Duration.zero;

                          return LivestreamInfo(
                            call: call,
                            fullscreen: _fullscreen,
                            onFullscreenTapped: () {
                              if (widget.onFullscreenTapped != null) {
                                widget.onFullscreenTapped?.call();
                              } else {
                                setState(() {
                                  _fullscreen = !_fullscreen;
                                });
                              }
                            },
                            duration: duration,
                            showParticipantCount: widget.showParticipantCount,
                          );
                        },
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Joins a call.
  Future<void> _connect() async {
    try {
      _logger.d(() => '[connect] no args');
      final connectOptions =
          widget.connectOptions ??
          CallConnectOptions(
            camera: TrackOption.disabled(),
            microphone: TrackOption.disabled(),
          );

      final result = await call.join(connectOptions: connectOptions);
      _logger.v(() => '[connect] completed: $result');
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
      await call.leave();
      // play tone
      final bool popped;
      if (mounted) {
        popped = await Navigator.maybePop(context);
      } else {
        popped = false;
      }
      _logger.v(() => '[leave] popped: $popped');
    } finally {
      await _joinSubscription?.cancel();
      _joinSubscription = null;
    }
  }
}
