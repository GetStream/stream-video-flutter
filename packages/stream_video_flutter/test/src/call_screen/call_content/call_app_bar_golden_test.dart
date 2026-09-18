import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/goldens.dart';
import '../../mocks.dart';

/// The widths the bar is snapshotted at, well inside each breakpoint.
///
/// The bar itself draws the same thing at every one — unlike [CallControlBar],
/// it takes no per-size layouts — so what these catch is the centred title
/// drifting as the sides get more room.
const _widths = <String, double>{'small': 402, 'medium': 768, 'large': 1440};

void main() {
  const icons = StreamIcons();

  final call = MockCall();
  final callState = MockCallState();

  when(() => callState.status).thenReturn(CallStatus.joined());
  when(() => call.state).thenAnswer(
    (_) => MutableStateEmitter<CallState>(callState, sync: true),
  );

  CallFeatureButton feature(IconData icon) =>
      CallFeatureButton(icon: Icon(icon), onPressed: () {});

  Widget bar(double width, {CallAppBarStyle? style}) => MediaQuery(
    // The bar reads its inset off MediaQuery, so pinning one here keeps the
    // snapshot from picking up the host surface's.
    data: MediaQueryData(size: Size(width, 800)),
    child: SizedBox(
      width: width,
      child: CallAppBar(
        call: call,
        showBackButton: false,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [feature(icons.gridFill), feature(icons.cameraFlipFill)],
        ),
        title: const Text('00:00'),
        style: style,
      ),
    ),
  );

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'CallAppBar across the breakpoints',
      fileName: 'call_app_bar',
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
      'CallAppBar fades into the call when floating',
      fileName: 'call_app_bar_floating',
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
                style: const CallAppBarStyle(
                  surfaceStyle: StreamSurfaceStyle.floating,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
