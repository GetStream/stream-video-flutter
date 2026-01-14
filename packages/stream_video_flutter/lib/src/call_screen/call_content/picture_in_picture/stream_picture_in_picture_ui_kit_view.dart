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

    _subscriptions.add(
      _idCallState,
      widget.call.state.listen(
        (state) {
          if (state.status is CallStatusDisconnected) {
            return;
          }

          _handleParticipantsChange(
            state.callParticipants,
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

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _subscriptions.cancel(_idCallState);
        _toggleSubscribedTracks(true);
        break;
      case AppLifecycleState.paused:
        _toggleSubscribedTracks(false);
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

  // When app goes to background disable video tracks of all participants except
  // the one shown in PiP to save bandwidth and resources.
  // Re-enable them when app comes back to foreground.
  void _toggleSubscribedTracks(bool enable) {
    final participants = widget.call.state.value.callParticipants;

    for (final participant in participants.where(
      (p) => p.isVideoEnabled,
    )) {
      if (!enable && participant.isSpeaking) {
        // Do not disable video track of speaking participant
        continue;
      }

      final videoTrackState = participant.publishedTracks[SfuTrackType.video];
      if ((videoTrackState is RemoteTrackState && videoTrackState.subscribed) ||
          participant.isLocal) {
        final track = widget.call.getTrack(
          participant.trackIdPrefix,
          SfuTrackType.video,
        );
        if (track != null) {
          track.mediaTrack.enabled = enable;
        }
      }
    }

    for (final participant in participants.where(
      (p) => p.isScreenShareEnabled,
    )) {
      if (!enable && participant.isSpeaking) {
        // Do not disable video track of speaking participant
        continue;
      }

      final screenShareTrackState =
          participant.publishedTracks[SfuTrackType.screenShare];
      if ((screenShareTrackState is RemoteTrackState &&
              screenShareTrackState.subscribed) ||
          participant.isLocal) {
        final track = widget.call.getTrack(
          participant.trackIdPrefix,
          SfuTrackType.screenShare,
        );
        if (track != null) {
          track.mediaTrack.enabled = enable;
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscriptions.cancelAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const UiKitView(
      viewType: 'stream-pip-view',
    );
  }
}
