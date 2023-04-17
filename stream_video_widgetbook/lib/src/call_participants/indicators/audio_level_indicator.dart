import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../utils/knobs.dart';

Widget defaultAudioLevelIndicator(BuildContext context) {
  return Center(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const DefaultAudioLevelIndicator(),
    ),
  );
}

class DefaultAudioLevelIndicator extends StatelessWidget {
  const DefaultAudioLevelIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const StreamAudioLevelIndicator(
      // TODO: Add color knob once available.
      // color: context.knobs.color(label: 'Color'),
      // TODO: Add size knob once implemented.
      // size: context.createDoubleKnob(
      //   'Size',
      //   min: 24,
      //   max: 24 * 4,
      //   divisionFactor: 4,
      //   enableDivision: true,
      //   initialValue: 48,
      // ),
    );
  }
}
