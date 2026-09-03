// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Builds the default set of call control options.
List<Widget> defaultCallControlOptions({
  required Call call,
  CallParticipantState? localParticipant,
}) {
  return [
    StreamSpeakerphoneButton(call: call),
    StreamCameraButton(call: call, localParticipant: localParticipant),
    StreamMicrophoneButton(call: call, localParticipant: localParticipant),
    StreamFlipCameraButton(call: call, localParticipant: localParticipant),
  ];
}
