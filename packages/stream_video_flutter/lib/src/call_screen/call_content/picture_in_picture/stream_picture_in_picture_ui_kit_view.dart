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
class StreamPictureInPictureUiKitView extends StatefulWidget {
  const StreamPictureInPictureUiKitView({
    super.key,
    required this.call,
    this.ignoreLocalParticipantVideo = true,
  });

  final Call call;
  final bool ignoreLocalParticipantVideo;

  @override
  State<StreamPictureInPictureUiKitView> createState() =>
      _StreamPictureInPictureUiKitViewState();
}

class _StreamPictureInPictureUiKitViewState
    extends State<StreamPictureInPictureUiKitView> {
  static const _idCallEvents = 1;
  static const _idCallState = 2;

  final platformMethodChannel = const MethodChannel('stream_video_flutter_pip');

  final Subscriptions _subscriptions = Subscriptions();

  @override
  void initState() {
    final callEventsSubscription = widget.call.callEvents.listen((event) {
      final participants = widget.ignoreLocalParticipantVideo
          ? widget.call.state.value.otherParticipants
          : widget.call.state.value.callParticipants;
      mergeSort(participants, compare: CallParticipantSortingPresets.speaker);

      final screenShareParticipant = participants.firstWhereOrNull(
        (it) {
          final screenShareTrack = it.screenShareTrack;
          final isScreenShareEnabled = it.isScreenShareEnabled;

          return screenShareTrack != null && isScreenShareEnabled;
        },
      );

      if (participants.isNotEmpty) {
        final videoTrack = widget.call.getTrack(
          screenShareParticipant?.trackIdPrefix ??
              participants.first.trackIdPrefix,
          screenShareParticipant != null
              ? SfuTrackType.screenShare
              : SfuTrackType.video,
        );

        platformMethodChannel.invokeMethod(
          'setTrack',
          {
            'trackId': videoTrack?.mediaTrack.id,
          },
        );
      }

      if (event is StreamCallEndedEvent) {
        platformMethodChannel.invokeMethod(
          'callEnded',
        );
      }
    });

    _subscriptions.add(_idCallEvents, callEventsSubscription);

    _subscriptions.add(
      _idCallState,
      widget.call.state.listen(
        (callState) {
          if (callState.status is CallStatusDisconnected) {
            platformMethodChannel.invokeMethod(
              'callEnded',
            );
          }
        },
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
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
