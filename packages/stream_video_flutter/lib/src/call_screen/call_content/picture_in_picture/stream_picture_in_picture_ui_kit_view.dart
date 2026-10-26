// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_video/stream_video.dart';

import '../../../call_participants/call_participants.dart';
import 'picture_in_picture_configuration.dart';

/// A widget that handles the picture-in-picture mode on iOS.
/// If you are implementing custom call content widget and want to include PiP support
/// add this widget to your widget tree.
/// ```dart
///   StreamCallContainer(
///     call: widget.call,
///     callContentBuilder: (
///         BuildContext context,
///         Call call,
///         CallState callState,
///         ) {
///       return Stack(
///         children: [
///           StreamPictureInPictureUiKitView(call: call),
///           /// YOUR CUSTOM WIDGET
///         ],
///       );
///     },
///   );
/// ```
///
/// On iOS, **multitasking camera access** must be enabled to allow the user's
/// camera to remain active while the app is in the background.
///
/// If multitasking camera access is enabled, setting `includeLocalParticipantVideo`
/// to `true` allows the local camera feed to be used in PiP mode (`true` by default).
///
/// For more details, visit:
/// https://getstream.io/video/docs/flutter/advanced/picture_in_picture/
class StreamPictureInPictureUiKitView extends StatefulWidget {
  const StreamPictureInPictureUiKitView({
    super.key,
    required this.call,
    @Deprecated(
      'Pass PictureInPictureConfiguration [pictureInPictureConfiguration] instead',
    )
    this.configuration,
    this.pictureInPictureConfiguration,
    @Deprecated(
      'Pass PictureInPictureConfiguration [pictureInPictureConfiguration] instead',
    )
    this.participantSort,
  }) : assert(
         configuration != null || pictureInPictureConfiguration != null,
         'Either configuration or pictureInPictureConfiguration must be provided',
       );

  final Call call;
  final PictureInPictureConfiguration? pictureInPictureConfiguration;
  @Deprecated('Use [pictureInPictureConfiguration.sort] instead')
  final CallParticipantSort<CallParticipantState>? participantSort;
  @Deprecated('Use [pictureInPictureConfiguration.iOSPiPConfiguration] instead')
  final IOSPictureInPictureConfiguration? configuration;

  @override
  State<StreamPictureInPictureUiKitView> createState() =>
      _StreamPictureInPictureUiKitViewState();
}

class _StreamPictureInPictureUiKitViewState
    extends State<StreamPictureInPictureUiKitView>
    with WidgetsBindingObserver {
  static const _idCallState = 2;
  static const _idCallEnded = 3;

  static const MethodChannel _channel = MethodChannel(
    'stream_video_flutter_pip',
  );

  final Subscriptions _subscriptions = Subscriptions();

  /// The native window's place in the call's viewport registry.
  ///
  /// It draws one participant's track at a time, like any other viewport, and
  /// is the one still drawing once the app is backgrounded.
  late ViewportHandle _viewport = widget.call.viewportVisibility.attach();

  bool _isInBackground = false;

  Future<void> _handleParticipantsChange(
    List<CallParticipantState> callParticipants,
    bool includeLocalParticipantVideo,
  ) async {
    final participants = includeLocalParticipantVideo
        ? callParticipants
        : callParticipants.where((element) => !element.isLocal).toList();

    final sorted = List<CallParticipantState>.from(participants);
    final sort =
        widget.pictureInPictureConfiguration?.sort ??
        widget.participantSort ??
        CallParticipantSorts.pictureInPicture;
    mergeSort(sorted, compare: sort.compare);

    if (sorted.isNotEmpty) {
      final pipParticipant = sorted.first;

      final hasScreenShare =
          pipParticipant.isScreenShareEnabled &&
          pipParticipant.screenShareTrack != null;

      // Show screen share if:
      // 1. prioritise is true and screen share is available, OR
      // 2. video is disabled but screen share is available (fallback)
      final shouldShowScreenShare =
          hasScreenShare &&
          (widget.pictureInPictureConfiguration?.pipTrackPriority !=
                  PipTrackPriority.camera ||
              !pipParticipant.isVideoEnabled);

      final priorityTrack = shouldShowScreenShare
          ? SfuTrackType.screenShare
          : SfuTrackType.video;

      final videoTrack = widget.call.getTrack(
        pipParticipant.trackIdPrefix,
        priorityTrack,
      );

      // What this window draws, reported like any other viewport. Kept while
      // hidden: the Flutter tiles go off screen when the app is backgrounded,
      // which is exactly when this window is the one being watched. In the
      // foreground the tiles ask for what is on screen.
      if (_isInBackground) {
        _viewport.report(
          ViewportTrack(
            userId: pipParticipant.userId,
            sessionId: pipParticipant.sessionId,
            trackIdPrefix: pipParticipant.trackIdPrefix,
            trackType: priorityTrack,
          ),
          const ViewportMeasurement(
            visibility: ViewportVisibility.visible,
            dimension: RtcVideoDimensionPresets.h360_169,
            persistWhenHidden: true,
          ),
        );
      }

      if (videoTrack == null &&
          (pipParticipant.isVideoEnabled ||
              pipParticipant.isScreenShareEnabled)) {
        // The track has not arrived yet. In the background the report above
        // is what asks for it; the state change it causes comes back through
        // here.
        return;
      }

      // The native side turns off the track it moves away from, so every
      // remote one it is given is turned back on with the app.
      if (videoTrack != null && !pipParticipant.isLocal) {
        _tracksShownInPictureInPicture.add((
          trackIdPrefix: pipParticipant.trackIdPrefix,
          trackType: priorityTrack,
        ));
      }

      await _channel.invokeMethod(
        'updateParticipant',
        {
          'trackId': videoTrack?.mediaTrack.id,
          'name': pipParticipant.name.isEmpty
              ? pipParticipant.userId
              : pipParticipant.name,
          'imageUrl': pipParticipant.image,
          'isAudioEnabled': pipParticipant.isAudioEnabled,
          'isVideoEnabled':
              videoTrack != null &&
              (pipParticipant.isVideoEnabled || shouldShowScreenShare),
          'connectionQuality': pipParticipant.connectionQuality.name,
          'showParticipantName':
              widget
                  .pictureInPictureConfiguration
                  ?.iOSPiPConfiguration
                  .showParticipantName ??
              widget.configuration?.showParticipantName,
          'showMicrophoneIndicator':
              widget
                  .pictureInPictureConfiguration
                  ?.iOSPiPConfiguration
                  .showMicrophoneIndicator ??
              widget.configuration?.showMicrophoneIndicator,
          'showConnectionQualityIndicator':
              widget
                  .pictureInPictureConfiguration
                  ?.iOSPiPConfiguration
                  .showConnectionQualityIndicator ??
              widget.configuration?.showConnectionQualityIndicator,
        },
      );
    } else {
      // Nobody to draw, so nothing to hold a track for.
      _viewport.release();
    }
  }

  void _subscribeToCallEvents() {
    if (widget.call.state.value.status is CallStatusDisconnected) {
      return;
    }

    // Follows the participant list, so a status-only state change does not
    // re-run the sort.
    _subscriptions.add(
      _idCallState,
      widget.call.participantsStream.listen(
        (callParticipants) {
          if (widget.call.state.value.status is CallStatusDisconnected) {
            return;
          }

          _handleParticipantsChange(
            callParticipants,
            (widget
                        .pictureInPictureConfiguration
                        ?.iOSPiPConfiguration
                        .includeLocalParticipantVideo ??
                    widget.configuration?.includeLocalParticipantVideo ??
                    true) &&
                widget.call.state.value.iOSMultitaskingCameraAccessEnabled,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _listenForCallEnded();
    // Picture-in-picture can start from inline before the app is paused, so
    // the window is given its participant in the foreground too. It then
    // opens in the shape of that participant's video.
    _subscribeToCallEvents();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant StreamPictureInPictureUiKitView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.call == oldWidget.call) return;

    // The tracks turned off in the background belong to the previous call.
    _restoreTracksFromBackground(oldWidget.call);

    // Everything here was taken from the call it was given: the handle belongs
    // to that call's registry, and the listeners to its state.
    _viewport.dispose();
    _viewport = widget.call.viewportVisibility.attach();

    _subscriptions.cancelAll();
    _listenForCallEnded();
    _subscribeToCallEvents();
  }

  void _listenForCallEnded() {
    _subscriptions.add(
      _idCallEnded,
      widget.call.state.listen(
        (state) async {
          if (state.status is CallStatusDisconnected) {
            await _channel.invokeMethod(
              'callEnded',
            );
          }
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _isInBackground = false;
        _restoreTracksFromBackground(widget.call);
        break;
      case AppLifecycleState.paused:
        _isInBackground = true;
        _disableTracksInBackground();
        // Subscribed again so the participants are replayed, and the window
        // reports its participant as a viewport now that the tiles are hidden.
        _subscribeToCallEvents();

        // Check status with a small delay to catch the race condition where
        // the call disconnects at nearly the same time as backgrounding
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) return;
          if (widget.call.state.value.status is CallStatusDisconnected) {
            try {
              _channel.invokeMethod('callEnded');
            } catch (e) {
              // Silent catch
            }
          }
        });
        break;
      default:
        break;
    }
  }

  /// The tracks [_disableTracksInBackground] turned off, so the same ones are
  /// turned back on. The participants can look different by the time the app
  /// is back: one whose subscription lapsed in the background, or who turned
  /// their camera off and on again, would otherwise be left with a disabled
  /// track and a black tile.
  final _tracksDisabledInBackground =
      <({String trackIdPrefix, SfuTrackTypeVideo trackType})>{};

  /// The remote tracks the window was given to draw while in the background.
  /// The native side turns off the one it moves away from and turns it back
  /// on once picture-in-picture ends; they are turned on with the app as well,
  /// so a participant shown earlier is never left black should that be missed.
  final _tracksShownInPictureInPicture =
      <({String trackIdPrefix, SfuTrackTypeVideo trackType})>{};

  // When app goes to background disable video tracks of all participants
  // except speaking ones to save bandwidth and resources. The one shown in
  // PiP is kept enabled by the native side.
  void _disableTracksInBackground() {
    final participants = widget.call.state.value.callParticipants;

    for (final participant in participants) {
      // Do not disable video track of speaking participant
      if (participant.isSpeaking) continue;

      for (final (trackType, isEnabled) in [
        (SfuTrackType.video, participant.isVideoEnabled),
        (SfuTrackType.screenShare, participant.isScreenShareEnabled),
      ]) {
        if (!isEnabled) continue;

        final trackState = participant.publishedTracks[trackType];
        final isSubscribed =
            trackState is RemoteTrackState && trackState.subscribed;
        if (!isSubscribed && !participant.isLocal) continue;

        final track = widget.call.getTrack(
          participant.trackIdPrefix,
          trackType,
        );
        if (track == null || !track.mediaTrack.enabled) continue;

        track.mediaTrack.enabled = false;
        _tracksDisabledInBackground.add((
          trackIdPrefix: participant.trackIdPrefix,
          trackType: trackType,
        ));
      }
    }
  }

  // Re-enable the tracks disabled in background when app comes back to
  // foreground, looked up again in case a track was replaced meanwhile.
  void _restoreTracksFromBackground(Call call) {
    final localParticipant = call.state.value.localParticipant;

    for (final (:trackIdPrefix, :trackType) in {
      ..._tracksDisabledInBackground,
      ..._tracksShownInPictureInPicture,
    }) {
      // A local track turned off meanwhile, such as the camera the LLC stops
      // in the background, is left to the LLC: it only recreates a stopped
      // track it finds disabled.
      if (localParticipant case final local?
          when local.trackIdPrefix == trackIdPrefix &&
              !_isPublishing(local, trackType)) {
        continue;
      }

      call.getTrack(trackIdPrefix, trackType)?.mediaTrack.enabled = true;
    }
    _tracksDisabledInBackground.clear();
    _tracksShownInPictureInPicture.clear();
  }

  static bool _isPublishing(
    CallParticipantState participant,
    SfuTrackTypeVideo trackType,
  ) => trackType.isScreenShare
      ? participant.isScreenShareEnabled
      : participant.isVideoEnabled;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _restoreTracksFromBackground(widget.call);
    _subscriptions.cancelAll();
    _viewport.dispose();
    unawaited(
      _channel.invokeMethod('callEnded').catchError((_) {
        // Best-effort cleanup; intentionally ignored.
      }),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const UiKitView(
      viewType: 'stream-pip-view',
    );
  }
}
