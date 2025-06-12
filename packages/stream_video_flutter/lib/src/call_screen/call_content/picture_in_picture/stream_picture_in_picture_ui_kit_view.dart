import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_video/stream_video.dart';

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
    this.includeLocalParticipantVideo = true,
    this.participantSort,
  });

  final Call call;
  final bool includeLocalParticipantVideo;
  final Comparator<CallParticipantState>? participantSort;

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
        ? widget.call.state.value.callParticipants
        : widget.call.state.value.otherParticipants;

    mergeSort(
      participants,
      compare: widget.participantSort ?? CallParticipantSortingPresets.speaker,
    );

    if (participants.isNotEmpty) {
      final participant = participants.first;

      final videoTrack = widget.call.getTrack(
        participants.first.trackIdPrefix,
        participants.first.isScreenShareEnabled
            ? SfuTrackType.screenShare
            : SfuTrackType.video,
      );

      await _channel.invokeMethod(
        'updateParticipant',
        {
          'trackId': videoTrack?.mediaTrack.id,
          'name':
              participant.name.isEmpty ? participant.userId : participant.name,
          'imageUrl': participant.image,
          'isAudioEnabled': participant.isAudioEnabled,
          'isVideoEnabled':
              participant.isVideoEnabled || participant.isScreenShareEnabled,
          'connectionQuality': participant.connectionQuality.name,
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
            widget.includeLocalParticipantVideo &&
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
