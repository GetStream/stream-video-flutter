import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/goldens.dart';

void main() {
  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'StreamRadioIndicator fills when selected and outlines when it is not',
      fileName: 'stream_radio_indicator',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 2,
        // The indicator is 16px wide, which is narrower than its own scenario
        // label; without a floor the two columns overlap.
        scenarioConstraints: const BoxConstraints.tightFor(width: 100),
        children: [
          GoldenTestScenario(
            name: 'selected',
            child: const StreamRadioIndicator(selected: true),
          ),
          GoldenTestScenario(
            name: 'unselected',
            child: const StreamRadioIndicator(selected: false),
          ),
        ],
      ),
    );
  }
}
