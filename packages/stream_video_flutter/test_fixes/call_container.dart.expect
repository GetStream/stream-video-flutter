import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../test/src/mocks.dart';

void main() {
  final call = MockCall();

  // bulkApply is set to false, so these fixes are not applied automatically.
  StreamCallContainer(
    call: call,
    callContentBuilder: (context, call, callState) {
      return const SizedBox.shrink();
    },
    incomingCallBuilder: (context, call, callState) {
      return const SizedBox.shrink();
    },
    outgoingCallBuilder: (context, call, callState) {
      return const SizedBox.shrink();
    },
  );
}
