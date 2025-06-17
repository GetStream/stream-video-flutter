import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../test/src/mocks.dart';

void main() {
  StreamCallControls.withDefaultOptions(
    call: MockCall(),
    localParticipant: MockCallParticipantState(),
  );

  FlipCameraOption(
    call: MockCall(),
    localParticipant: MockCallParticipantState(),
  );

  ToggleScreenShareOption(
    call: MockCall(),
    localParticipant: MockCallParticipantState(),
  );

  ToggleMicrophoneOption(
    call: MockCall(),
    localParticipant: MockCallParticipantState(),
  );

  ToggleCameraOption(
    call: MockCall(),
    localParticipant: MockCallParticipantState(),
  );
}
