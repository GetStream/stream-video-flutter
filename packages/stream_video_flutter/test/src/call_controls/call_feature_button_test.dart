import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';

void main() {
  const icons = StreamIcons();

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'CallFeatureButton takes the accent when selected',
      fileName: 'call_feature_button',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 2,
        children: [
          GoldenTestScenario(
            name: 'unselected',
            child: CallFeatureButton(
              icon: Icon(icons.presentDesktopFill),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'selected',
            child: CallFeatureButton(
              icon: Icon(icons.presentDesktopFill),
              selected: true,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'unselected disabled',
            child: CallFeatureButton(icon: Icon(icons.captionFill)),
          ),
          GoldenTestScenario(
            name: 'selected disabled',
            child: CallFeatureButton(
              icon: Icon(icons.captionFill),
              selected: true,
            ),
          ),
          GoldenTestScenario(
            name: 'error badge',
            child: CallFeatureButton(
              icon: Icon(icons.recordingFill),
              showErrorBadge: true,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
