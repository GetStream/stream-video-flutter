import 'package:flutter/material.dart';
import 'package:stream_video_flutter/src/call_controls/controls/switch_camera.dart';
import 'package:stream_video_flutter/src/call_controls/controls/toggle_camera.dart';
import 'package:stream_video_flutter/src/call_controls/controls/toggle_mic.dart';
import 'package:stream_video_flutter/src/call_controls/controls/toggle_speaker.dart';

import '../../../stream_video_flutter.dart';
import 'call_hangup.dart';

List<Widget> defaultCallControlOptions({
  required CallV2 call,
  required VoidCallback onHangup,
}) {
  // final participant = call.localParticipant;

  final localParticipant =
      call.state.value.callParticipants.where((it) => it.isLocal)!.first;

  assert(localParticipant != null, 'The local participant is null.');

  return [
    const ToggleSpeaker(),
    ToggleMic(call: call, localParticipant: localParticipant),
    ToggleCamera(call: call, localParticipant: localParticipant),
    SwitchCamera(call: call, localParticipant: localParticipant),
    CallHangup(onHangup: onHangup),
  ];
}
