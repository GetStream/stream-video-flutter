// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../stream_video_flutter.dart';
import '../../../call_participants/indicators/connection_quality_indicator_defaults.dart';
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
          style: _pipTileStyle(context),
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

  /// The tile the window draws, merged under
  /// [StreamPictureInPictureStyle.tileStyle].
  StreamParticipantTileStyle _pipTileStyle(BuildContext context) {
    final radius = context.streamRadius;

    // The chrome sits in the corners of the window, so the corner each piece
    // occupies is square and only the inner one is rounded. Directional: the
    // toolbar puts the pill at the start and the indicator at the end, and
    // which corner each of those is comes out in the layout.
    final cornerRadius = radius.lg;
    final labelRadius = BorderRadiusDirectional.only(topEnd: cornerRadius);
    final indicatorRadius = BorderRadiusDirectional.only(
      topStart: cornerRadius,
    );

    return StreamParticipantTileStyle(
      // The window is rounded by the system, so a tile rounding itself as well
      // leaves the Material behind it showing in the corners. Which also rules
      // out an outline: it would be drawn square and then have its corners
      // clipped away by the window.
      borderRadius: BorderRadius.zero,
      border: const Border(),
      showSpeakerBorder: false,
      showMoreButton: false,
      // Flush into the window's own corners: at this size an inset costs more
      // video than it buys in breathing room.
      toolbarPadding: EdgeInsets.zero,
      labelStyle: StreamParticipantLabelStyle(
        showAudioIndicator: false,
        showVideoOffIcon: false,
        borderRadius: labelRadius,
      ),
      connectionQualityIndicatorStyle: StreamConnectionQualityIndicatorStyle(
        // Only the shape changes, so it is taken off the decoration the
        // indicator would have drawn — resolved the way the indicator resolves
        // it — rather than described again here, which would drop an app's own
        // fill. A rounded rectangle where the default is a circle, and
        // BoxDecoration allows a radius on neither shape but the rectangle.
        decoration: _indicatorDecoration(
          context,
        ).copyWith(shape: BoxShape.rectangle, borderRadius: indicatorRadius),
      ),
    ).merge(StreamPictureInPictureTheme.of(context).style?.tileStyle);
  }

  /// The decoration the connection quality indicator would draw here.
  BoxDecoration _indicatorDecoration(BuildContext context) {
    final style = StreamConnectionQualityIndicatorTheme.of(context).style;
    return style?.decoration ??
        StreamConnectionQualityIndicatorStyleDefaults(context).decoration;
  }
}
