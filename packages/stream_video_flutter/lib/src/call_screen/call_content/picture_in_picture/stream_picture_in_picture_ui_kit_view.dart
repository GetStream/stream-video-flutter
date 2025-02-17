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
  });

  final Call call;
  final bool includeLocalParticipantVideo;

  @override
  State<StreamPictureInPictureUiKitView> createState() =>
      _StreamPictureInPictureUiKitViewState();
}

class _StreamPictureInPictureUiKitViewState
    extends State<StreamPictureInPictureUiKitView> with WidgetsBindingObserver {
  static const _idCallEvents = 1;
  static const _idCallState = 2;

  final platformMethodChannel = const MethodChannel('stream_video_flutter_pip');

  final Subscriptions _subscriptions = Subscriptions();

  void _handleCallEvent(
    StreamCallEvent event,
    bool includeLocalParticipantVideo,
  ) {
    final participants = includeLocalParticipantVideo
        ? widget.call.state.value.callParticipants
        : widget.call.state.value.otherParticipants;

    mergeSort(participants, compare: CallParticipantSortingPresets.speaker);

    if (participants.isNotEmpty) {
      final videoTrack = widget.call.getTrack(
        participants.first.trackIdPrefix,
        participants.first.isScreenShareEnabled
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
  }

  void _subscribeToCallEvents() {
    _subscriptions.add(
      _idCallEvents,
      widget.call.callEvents.listen((event) {
        _handleCallEvent(
          event,
          widget.includeLocalParticipantVideo &&
              widget.call.state.value.iOSMultitaskingCameraAccessEnabled,
        );
      }),
    );

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
