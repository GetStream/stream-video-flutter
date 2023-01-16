import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

export 'switch_camera.dart';
export 'toggle_mic.dart';
export 'toggle_speaker.dart';
export 'toggle_camera.dart';
export 'call_hangup.dart';

List<Widget> defaultCallControlOptions({
  required Call call,
  required VoidCallback onHangup,
}) {
  final participant = call.localParticipant;
  assert(participant != null, 'The local participant is null.');

  return [
    const ToggleSpeaker(),
    ToggleMic(participant: participant!),
    ToggleCamera(participant: participant),
    SwitchCamera(participant: participant),
    CallHangup(onHangup: onHangup),
  ];
}
