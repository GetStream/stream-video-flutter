import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Builds the default set of call control options.
List<Widget> defaultCallControlOptions({
  required Call call,
  required CallParticipantState localParticipant,
}) {
  return [
    ToggleSpeakerphoneOption(call: call),
    ToggleCameraOption(call: call, localParticipant: localParticipant),
    ToggleMicrophoneOption(call: call, localParticipant: localParticipant),
    FlipCameraOption(call: call, localParticipant: localParticipant),
  ];
}
