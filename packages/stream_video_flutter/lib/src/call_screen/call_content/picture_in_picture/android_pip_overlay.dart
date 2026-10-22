// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../stream_video_flutter.dart';
import '../../../call_participants/screen_share_call_participants_content.dart';
import 'android_pip_track.dart';
import 'picture_in_picture_defaults.dart';

final _logger = taggedLogger(tag: 'SV:AndroidPipOverlay');

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
  final CallParticipantSort<CallParticipantState>? sort;
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
  CallParticipantFilter<CallParticipantState>? get participantFilter => null;

  @override
  CallParticipantSort<CallParticipantState> get participantSort =>
      widget.pictureInPictureConfiguration?.sort ??
      widget.sort ??
      CallParticipantSorts.pictureInPicture;

  @override
  void initState() {
    super.initState();
    recalculateParticipants(widget.call.state.value.callParticipants);

    // A custom `participantsThrottleIntervalResolver` that throws surfaces as
    // an error here; without `onError` it would reach the zone uncaught.
    _participantsSubscription = widget.call.participantsStream.listen(
      recalculateParticipants,
      onError: (Object error, StackTrace stackTrace) {
        _logger.e(
          () =>
              '[AndroidPipOverlay] participantsStream error: $error; '
              '$stackTrace',
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant AndroidPipOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.call == oldWidget.call) return;

    // The subscription was taken from the call this widget was given, while
    // the tiles below are drawn for whichever call it holds now.
    _participantsSubscription?.cancel();
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

    final pipTrack = customBuilder == null
        ? resolveAndroidPipTrack(
            sortedParticipants,
            widget.pictureInPictureConfiguration?.pipTrackPriority,
          )
        : null;

    if (pipTrack != null) {
      final pipParticipant = pipTrack.participant;

      if (pipTrack.trackType == SfuTrackType.screenShare) {
        pipBody = ScreenShareContent(
          key: ValueKey(
            '${pipParticipant.uniqueParticipantKey} - pipScreenShare',
          ),
          rendererScopePrefix: 'pipScreenShare',
          call: widget.call,
          participant: pipParticipant,
        );
      } else {
        pipBody = StreamParticipantTile(
          key: ValueKey(
            '${pipParticipant.uniqueParticipantKey} - pipVideo',
          ),
          rendererScopePrefix: 'pipVideo',
          call: widget.call,
          participant: pipParticipant,
          style: pictureInPictureTileStyle(context).merge(
            StreamPictureInPictureTheme.of(context).style?.tileStyle,
          ),
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
