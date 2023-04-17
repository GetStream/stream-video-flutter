import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

Widget createDummyVideoRenderer(
  BuildContext context,
  Call call,
  CallParticipantState participant,
  Widget videoPlaceholder,
) {
  return DummyVideoRenderer(
    call: call,
    participant: participant,
    videoPlaceholder: videoPlaceholder,
  );
}

class DummyVideoRenderer extends StatelessWidget {
  const DummyVideoRenderer({
    super.key,
    required this.call,
    required this.participant,
    required this.videoPlaceholder,
  });

  final Call call;
  final CallParticipantState participant;
  final Widget videoPlaceholder;

  @override
  Widget build(BuildContext context) {
    final trackState = participant.publishedTracks[SfuTrackType.video];

    if (trackState == null || trackState.muted) return videoPlaceholder;

    // We can't render the video in widgetbook, so we just return a dummy widget
    // which displays a sample video/gif.
    return Image.asset(
      'assets/handsome_squidward.gif',
      gaplessPlayback: true,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }
}
