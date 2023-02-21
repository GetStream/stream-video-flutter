import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Builds the default set of call control options.
List<Widget> defaultCallControlOptions({
  required Call call,
  required CallParticipantState localParticipant,
  required VoidCallback onLeaveCall,
}) {
  return [
    const ToggleSpeakerphoneOption(),
    ToggleMicrophoneOption(call: call, localParticipant: localParticipant),
    ToggleCameraOption(call: call, localParticipant: localParticipant),
    FlipCameraOption(call: call, localParticipant: localParticipant),
    LeaveCallOption(onLeaveCall: onLeaveCall),
  ];
}
