import 'package:flutter/material.dart';
import 'package:stream_video_flutter/src/call_controls/controls/switch_camera_v2.dart';
import 'package:stream_video_flutter/src/call_controls/controls/toggle_camera_v2.dart';
import 'package:stream_video_flutter/src/call_controls/controls/toggle_mic_v2.dart';
import 'package:stream_video_flutter/src/call_controls/controls/toggle_speaker_v2.dart';

import '../../../stream_video_flutter.dart';
import 'call_hangup_v2.dart';

List<Widget> defaultCallControlOptionsV2({
  required CallV2 call,
  required VoidCallback onHangup,
}) {
  // final participant = call.localParticipant;

  final localParticipant =
      call.state.value.callParticipants.where((it) => it.isLocal)!.first;

  assert(localParticipant != null, 'The local participant is null.');

  return [
    const ToggleSpeakerV2(),
    ToggleMicV2(call: call, localParticipant: localParticipant),
    ToggleCameraV2(call: call, localParticipant: localParticipant),
    SwitchCameraV2(call: call, localParticipant: localParticipant),
    CallHangupV2(onHangup: onHangup),
  ];
}
