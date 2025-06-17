import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../test/src/mocks.dart';

void main() {
  // bulkApply is set to false, so these fixes are not applied automatically.
  StreamCallContent(
    call: MockCall(),
    callAppBarBuilder: (context, call, callState) {
      return AppBar();
    },
    callParticipantsBuilder: (context, call, callState) {
      return const SizedBox.shrink();
    },
    callControlsBuilder: (context, call, callState) {
      return const SizedBox.shrink();
    },
  );

  // `callState` should be removed
  StreamCallContent(
    call: MockCall(),
    callState: MockCallState(),
  );
}
