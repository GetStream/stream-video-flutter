import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';

void main() {
  const icons = StreamIcons();

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'CallControlButton paints one tone per state',
      fileName: 'call_control_button',
      brightness: brightness,
      builder: () => GoldenTestGroup(
        columns: 3,
        children: [
          GoldenTestScenario(
            name: 'neutral',
            child: CallControlButton(
              icon: Icon(icons.voiceFill),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'negative',
            child: CallControlButton(
              icon: Icon(icons.voiceOffFill),
              tone: .negative,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'positive',
            child: CallControlButton(
              icon: Icon(icons.phoneFill),
              tone: .positive,
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'error badge',
            child: CallControlButton(
              icon: Icon(icons.voiceOffFill),
              tone: .negative,
              showErrorBadge: true,
              onPressed: () {},
            ),
          ),
          // A null callback is what disables the button; `showErrorBadge` is a
          // separate axis, so both can be true at once.
          GoldenTestScenario(
            name: 'disabled',
            child: CallControlButton(icon: Icon(icons.voiceFill)),
          ),
          GoldenTestScenario(
            name: 'disabled with badge',
            child: CallControlButton(
              icon: Icon(icons.videoOffFill),
              tone: .negative,
              showErrorBadge: true,
            ),
          ),
        ],
      ),
    );
  }
}
