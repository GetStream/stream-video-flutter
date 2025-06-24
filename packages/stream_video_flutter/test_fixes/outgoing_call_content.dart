import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../test/src/mocks.dart';

void main() {
  // bulkApply is set to false, so these fixes are not applied automatically.
  StreamOutgoingCallContent(
    call: MockCall(),
    callBackgroundBuilder: (context, call, callState, child) {
      return child;
    },
    participantsAvatarBuilder: (context, call, callState, participants) {
      return const SizedBox.shrink();
    },
    participantsDisplayNameBuilder: (context, call, callState, participants) {
      return const SizedBox.shrink();
    },
  );

  StreamOutgoingCallContent(
    call: MockCall(),
    callState: MockCallState(),
  );
}
