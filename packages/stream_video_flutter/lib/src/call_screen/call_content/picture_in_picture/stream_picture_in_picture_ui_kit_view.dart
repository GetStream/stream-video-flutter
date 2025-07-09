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
    required this.configuration,
    this.participantSort,
  });

  final Call call;
  final Comparator<CallParticipantState>? participantSort;
  final IOSPictureInPictureConfiguration configuration;

  @override
  State<StreamPictureInPictureUiKitView> createState() =>
      _StreamPictureInPictureUiKitViewState();
}

class _StreamPictureInPictureUiKitViewState
    extends State<StreamPictureInPictureUiKitView> with WidgetsBindingObserver {
  static const _idCallState = 2;

  static const MethodChannel _channel =
      MethodChannel('stream_video_flutter_pip');

  final Subscriptions _subscriptions = Subscriptions();

  Future<void> _handleCallState(
    CallState callState,
    bool includeLocalParticipantVideo,
  ) async {
    final participants = includeLocalParticipantVideo
        ? callState.callParticipants
        : callState.otherParticipants;

    final sorted = List<CallParticipantState>.from(participants);
    mergeSort(
      sorted,
      compare: widget.participantSort ?? CallParticipantSortingPresets.speaker,
    );

    if (sorted.isNotEmpty) {
      final participant = sorted.first;

      final videoTrack = widget.call.getTrack(
        participant.trackIdPrefix,
        participant.isScreenShareEnabled
            ? SfuTrackType.screenShare
            : SfuTrackType.video,
      );

      if (videoTrack == null &&
          (participant.isVideoEnabled || participant.isScreenShareEnabled)) {
        // If the video track is not available, we need to update the subscription
        // to ensure that the participant's video is displayed correctly.
        await widget.call.updateSubscription(
          userId: participant.userId,
          sessionId: participant.sessionId,
          trackIdPrefix: participant.trackIdPrefix,
          trackType: participant.isScreenShareEnabled
              ? SfuTrackType.screenShare
              : SfuTrackType.video,
          videoDimension: RtcVideoDimensionPresets.h360_169,
        );

        return;
      }

      await _channel.invokeMethod(
        'updateParticipant',
        {
          'trackId': videoTrack?.mediaTrack.id,
          'name':
              participant.name.isEmpty ? participant.userId : participant.name,
          'imageUrl': participant.image,
          'isAudioEnabled': participant.isAudioEnabled,
          'isVideoEnabled': videoTrack != null &&
              (participant.isVideoEnabled || participant.isScreenShareEnabled),
          'connectionQuality': participant.connectionQuality.name,
          'showParticipantName': widget.configuration.showParticipantName,
          'showMicrophoneIndicator':
              widget.configuration.showMicrophoneIndicator,
          'showConnectionQualityIndicator':
              widget.configuration.showConnectionQualityIndicator,
        },
      );
    }

    if (callState.status is CallStatusDisconnected) {
      await _channel.invokeMethod(
        'callEnded',
      );
    }
  }

  void _subscribeToCallEvents() {
    _subscriptions.add(
      _idCallState,
      widget.call.state.listen(
        (callState) {
          _handleCallState(
            callState,
            widget.configuration.includeLocalParticipantVideo &&
                widget.call.state.value.iOSMultitaskingCameraAccessEnabled,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _subscriptions.cancelAll();
        break;
      case AppLifecycleState.paused:
        _subscribeToCallEvents();
        break;
      default:
        break;
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
