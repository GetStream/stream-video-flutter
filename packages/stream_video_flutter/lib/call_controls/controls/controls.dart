import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

export 'switch_camera.dart';
export 'toggle_mic.dart';
export 'toggle_speaker.dart';
export 'toggle_camera.dart';
export 'call_hangup.dart';

List<Widget> defaultCallControlOptions({
  required LocalParticipant participant,
  required VoidCallback onHangup,
}) {
  return [
    const ToggleSpeaker(),
    ToggleMic(participant: participant),
    ToggleCamera(participant: participant),
    SwitchCamera(participant: participant),
    CallHangup(onHangup: onHangup),
  ];
}
