import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../utils/knobs.dart';

Widget defaultAudioIndicator(BuildContext context) {
  return Center(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const DefaultAudioIndicator(),
    ),
  );
}

class DefaultAudioIndicator extends StatelessWidget {
  const DefaultAudioIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamAudioIndicator(
      // TODO: Add color knobs once available.
      // enabledMicrophoneColor: ...,
      // disabledMicrophoneColor: ...,
      // audioLevelIndicatorColor: ...,
      isSpeaking: context.knobs.boolean(label: 'Is Speaking'),
      isAudioEnabled: context.knobs.boolean(label: 'Is Audio Enabled'),
      // TODO: Add size knob once implemented.
      // size: context.createDoubleKnob(
      //   'Size',
      //   min: 16,
      //   max: 16 * 4,
      //   divisionFactor: 4,
      //   enableDivision: true,
      //   initialValue: 32,
      // ),
    );
  }
}
