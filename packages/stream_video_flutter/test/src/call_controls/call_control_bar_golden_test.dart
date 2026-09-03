import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';

/// The three breakpoints the bar has a layout for, at a width well inside each.
const _widths = <String, double>{'small': 402, 'medium': 768, 'large': 1440};

void main() {
  const icons = StreamIcons();

  CallControlButton control(IconData icon, {CallControlTone tone = .neutral}) =>
      CallControlButton(icon: Icon(icon), tone: tone, onPressed: () {});

  CallFeatureButton feature(
    IconData icon, {
    bool selected = false,
    CallFeatureTone tone = .accent,
  }) => CallFeatureButton(
    icon: Icon(icon),
    selected: selected,
    tone: tone,
    onPressed: () {},
  );

  // What the design shows on a phone: the bar split in two, with no centre.
  final compact = CallControlBarLayout(
    leading: [
      feature(icons.moreVerticalFill),
      control(icons.voiceFill),
      control(icons.videoOffFill, tone: .negative),
    ],
    trailing: [feature(icons.usersFill), feature(icons.messageBubblesFill)],
  );

  // And on a desktop: a full centre row, with the sides pinned to the edges.
  final expanded = CallControlBarLayout(
    leading: [feature(icons.settingsFill), feature(icons.gridFill)],
    center: [
      control(icons.voiceFill),
      control(icons.videoOffFill, tone: .negative),
      feature(icons.captionFill),
      feature(icons.emojiAddFill),
      feature(icons.presentDesktopFill, selected: true),
      feature(icons.recordingStopFill, selected: true, tone: .destructive),
      control(icons.phoneDownFill, tone: .negative),
    ],
    trailing: [
      feature(icons.statsFill),
      feature(icons.usersFill),
      feature(icons.messageBubblesFill),
    ],
  );

  Widget bar(double width, {CallControlBarStyle? style}) => MediaQuery(
    // The bar picks its layout off MediaQuery.sizeOf, so sizing the alchemist
    // surface alone would leave every scenario reporting the same breakpoint.
    data: MediaQueryData(size: Size(width, 800)),
    child: SizedBox(
      width: width,
      child: CallControlBar(compact, large: expanded, style: style),
    ),
  );

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'CallControlBar across the breakpoints',
      fileName: 'call_control_bar',
      brightness: brightness,
      constraints: const BoxConstraints(maxWidth: 1440),
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          for (final MapEntry(key: name, value: width) in _widths.entries)
            GoldenTestScenario(name: name, child: bar(width)),
        ],
      ),
    );

    streamGoldenTest(
      'CallControlBar fades into the call when floating',
      fileName: 'call_control_bar_floating',
      brightness: brightness,
      constraints: const BoxConstraints(maxWidth: 1440),
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          for (final MapEntry(key: name, value: width) in _widths.entries)
            GoldenTestScenario(
              name: name,
              child: bar(
                width,
                style: const CallControlBarStyle(
                  surfaceStyle: StreamSurfaceStyle.floating,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
