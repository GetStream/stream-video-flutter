import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../utils/knobs.dart';

Widget defaultConnectionQualityIndicator(BuildContext context) {
  return Center(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const DefaultConnectionQualityIndicator(),
    ),
  );
}

class DefaultConnectionQualityIndicator extends StatelessWidget {
  const DefaultConnectionQualityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamConnectionQualityIndicator(
      // TODO: Add color knobs once available.
      // activeColor: context.knobs.color(label: 'Active Color'),
      // inactiveColor: context.knobs.color(label: 'Inactive Color'),
      connectionQuality: context.knobs.options(
        label: 'Connection Quality',
        options: [
          const Option(label: 'Good', value: SfuConnectionQuality.excellent),
          const Option(label: 'Average', value: SfuConnectionQuality.good),
          const Option(label: 'Bad', value: SfuConnectionQuality.poor),
          const Option(label: 'Off', value: SfuConnectionQuality.unspecified),
        ],
      ),
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
