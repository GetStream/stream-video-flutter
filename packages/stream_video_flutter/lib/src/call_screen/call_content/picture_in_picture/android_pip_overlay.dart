import 'package:flutter/material.dart';
import '../../../../stream_video_flutter.dart';

/// A dedicated overlay widget for Android Picture-in-Picture mode.
/// This widget creates a floating overlay that shows only the video content
/// optimized for PiP viewing.
class AndroidPipOverlay extends StatefulWidget {
  const AndroidPipOverlay({
    super.key,
    required this.call,
    this.sort,
    this.customBuilder,
  });

  final Call call;
  final Comparator<CallParticipantState>? sort;
  final CallWidgetBuilder? customBuilder;

  @override
  State<AndroidPipOverlay> createState() => _AndroidPipOverlayState();
}

class _AndroidPipOverlayState extends State<AndroidPipOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SizedBox.expand(
        child: widget.customBuilder?.call(context, widget.call) ??
            StreamCallParticipants(
              call: widget.call,
              layoutMode: ParticipantLayoutMode.pictureInPicture,
              sort: widget.sort,
            ),
      ),
    );
  }
}
