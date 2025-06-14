import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  // bulkApply is set to false, so these fixes are not applied automatically.
  AndroidPictureInPictureConfiguration(
    callPictureInPictureBuilder: (context, call, callState) {
      return const SizedBox.shrink();
    },
  );
}
