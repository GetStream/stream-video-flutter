// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_video/stream_video.dart';

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
  final Comparator<CallParticipantState>? participantSort;
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

  bool _isInBackground = false;

  // The tracks [_disableTracksInBackground] turned off, so the same ones are
  // turned back on. The participants can look different by the time the app
  // is back: one whose subscription lapsed in the background, or who turned
  // their camera off and on again, would otherwise be left with a disabled
  // track and a black tile.
  final _tracksDisabledInBackground =
      <({String trackIdPrefix, SfuTrackTypeVideo trackType})>{};

  // The tracks the window was given while the app was not active. The native
  // side turns off the one picture-in-picture moves away from and leaves
  // turning it back on to this widget, which does it with the app rather than
  // when the window closes: closed in the background, it would decode with
  // nobody watching.
  final _tracksShownInPictureInPicture =
      <({String trackIdPrefix, SfuTrackTypeVideo trackType})>{};

  // The track the window holds. The native side keeps it until the call ends,
  // across trips to the foreground and through updates without a track, and
  // turns it off once given another one while picture-in-picture is open.
  // Kept past resuming so a track shown in an earlier trip is turned back on
  // when the window moves away from it.
  ({String trackIdPrefix, SfuTrackTypeVideo trackType})?
  _trackInPictureInPicture;

  Future<void> _handleParticipantsChange(
    List<CallParticipantState> callParticipants,
    bool includeLocalParticipantVideo,
  ) async {
    final participants = includeLocalParticipantVideo
        ? callParticipants
        : callParticipants.where((element) => !element.isLocal).toList();

    final sorted = List<CallParticipantState>.from(participants);
    mergeSort(
      sorted,
      compare:
          widget.pictureInPictureConfiguration?.sort ??
          widget.participantSort ??
          CallParticipantSortingPresets.pictureInPicture,
    );

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

      if (videoTrack == null &&
          (pipParticipant.isVideoEnabled ||
              pipParticipant.isScreenShareEnabled)) {
        // If the video track is not available, we need to update the subscription
        // to ensure that the participant's video is displayed correctly.
        await widget.call.updateSubscription(
          userId: pipParticipant.userId,
          sessionId: pipParticipant.sessionId,
          trackIdPrefix: pipParticipant.trackIdPrefix,
          trackType: priorityTrack,
          videoDimension: RtcVideoDimensionPresets.h360_169,
        );

        return;
      }

      final shownTrack = videoTrack == null
          ? null
          : (
              trackIdPrefix: pipParticipant.trackIdPrefix,
              trackType: priorityTrack,
            );

      // Without a track the native side keeps drawing the one it holds.
      if (shownTrack != null) {
        // Picture-in-picture can be open from as soon as the app is not
        // active.
        if (WidgetsBinding.instance.lifecycleState !=
            AppLifecycleState.resumed) {
          _tracksShownInPictureInPicture.add(shownTrack);
          // The one the window moves away from, which the native side turns
          // off.
          if (_trackInPictureInPicture case final previous?
              when previous != shownTrack) {
            _tracksShownInPictureInPicture.add(previous);
          }
        }
        _trackInPictureInPicture = shownTrack;
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

    super.initState();
  }

  @override
  void didUpdateWidget(covariant StreamPictureInPictureUiKitView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.call == oldWidget.call) return;

    // The tracks turned off in the background belong to the previous call.
    _restoreTracksFromBackground(oldWidget.call);
    _trackInPictureInPicture = null;

    // The listeners were taken from the previous call's state.
    _subscriptions.cancelAll();
    _listenForCallEnded();
    if (_isInBackground) _subscribeToCallEvents();
  }

  void _listenForCallEnded() {
    _subscriptions.add(
      _idCallEnded,
      widget.call.state.listen(
        (state) async {
          if (state.status is CallStatusDisconnected) {
            // The native side lets go of its track when the call ends.
            _trackInPictureInPicture = null;
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
        _subscriptions.cancel(_idCallState);
        _restoreTracksFromBackground(widget.call);
        break;
      case AppLifecycleState.paused:
        _isInBackground = true;
        _disableTracksInBackground();
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

  // When app goes to background disable video tracks of all participants
  // except speaking ones to save bandwidth and resources. The one shown in
  // PiP is kept enabled by the native side.
  void _disableTracksInBackground() {
    for (final participant in widget.call.state.value.callParticipants) {
      // Do not disable video track of speaking participant
      if (participant.isSpeaking) continue;

      _disableTrackInBackground(participant, SfuTrackType.video);
      _disableTrackInBackground(participant, SfuTrackType.screenShare);
    }
  }

  void _disableTrackInBackground(
    CallParticipantState participant,
    SfuTrackTypeVideo trackType,
  ) {
    if (!_isPublishing(participant, trackType)) return;

    final trackState = participant.publishedTracks[trackType];
    final isSubscribed =
        trackState is RemoteTrackState && trackState.subscribed;
    if (!isSubscribed && !participant.isLocal) return;

    final track = widget.call.getTrack(participant.trackIdPrefix, trackType);
    if (track == null || !track.mediaTrack.enabled) return;

    track.mediaTrack.enabled = false;
    _tracksDisabledInBackground.add((
      trackIdPrefix: participant.trackIdPrefix,
      trackType: trackType,
    ));
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
