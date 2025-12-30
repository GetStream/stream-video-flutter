// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../stream_video_flutter.dart';
import '../../../call_participants/screen_share_call_participants_content.dart';

/// A dedicated overlay widget for Android Picture-in-Picture mode.
/// This widget creates a floating overlay that shows only the video content
/// optimized for PiP viewing.
class AndroidPipOverlay extends StatefulWidget {
  const AndroidPipOverlay({
    super.key,
    required this.call,
    this.pictureInPictureConfiguration,
    @Deprecated(
      'Pass PictureInPictureConfiguration [pictureInPictureConfiguration] instead',
    )
    this.sort,
    @Deprecated(
      'Pass PictureInPictureConfiguration [pictureInPictureConfiguration] instead',
    )
    this.customBuilder,
  });

  final Call call;
  final PictureInPictureConfiguration? pictureInPictureConfiguration;
  @Deprecated('Use [pictureInPictureConfiguration.sort] instead')
  final Sort<CallParticipantState>? sort;
  @Deprecated(
    'Use [pictureInPictureConfiguration.androidPiPConfiguration.customBuilder] instead',
  )
  final CallWidgetBuilder? customBuilder;

  @override
  State<AndroidPipOverlay> createState() => _AndroidPipOverlayState();
}

class _AndroidPipOverlayState extends State<AndroidPipOverlay>
    with CallParticipantsSortingMixin {
  StreamSubscription<List<CallParticipantState>?>? _participantsSubscription;

  @override
  Filter<CallParticipantState>? get participantFilter => null;

  @override
  Sort<CallParticipantState>? get participantSort =>
      widget.pictureInPictureConfiguration?.sort ??
      widget.sort ??
      CallParticipantSortingPresets.pictureInPicture;

  @override
  void initState() {
    super.initState();
    recalculateParticipants(widget.call.state.value.callParticipants);

    _participantsSubscription = widget.call
        .partialState((state) => state.callParticipants)
        .listen(recalculateParticipants);
  }

  @override
  void dispose() {
    _participantsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget pipBody = const SizedBox.shrink();

    final customBuilder =
        widget
            .pictureInPictureConfiguration
            ?.androidPiPConfiguration
            .callPictureInPictureWidgetBuilder ??
        widget.customBuilder;

    if (customBuilder == null && sortedParticipants.isNotEmpty) {
      final pipParticipant = sortedParticipants.first;

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

      if (shouldShowScreenShare) {
        pipBody = ScreenShareContent(
          key: ValueKey(
            '${pipParticipant.uniqueParticipantKey} - screenShareContent',
          ),
          call: widget.call,
          participant: pipParticipant,
        );
      } else {
        pipBody = StreamCallParticipant(
          // We use the sessionId as the key to map the state to the participant.
          key: Key(pipParticipant.uniqueParticipantKey),
          call: widget.call,
          participant: pipParticipant,
        );
      }
    }

    return Material(
      color: Colors.black,
      child: SizedBox.expand(
        child: customBuilder?.call(context, widget.call) ?? pipBody,
      ),
    );
  }
}
