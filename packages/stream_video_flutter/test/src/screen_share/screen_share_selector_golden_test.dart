import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import 'fake_desktop_capturer.dart';

// The selector is snapshotted on its own rather than through
// `showDefaultScreenSelectionDialog`: the CI capture path drops anything
// painted into an Overlay, so a dialog comes out blank. The dialog chrome is
// asserted in stream_modal_dialog_test.dart instead.
void main() {
  final sources = [
    FakeDesktopCapturerSource(
      id: 'screen-1',
      name: 'Screen 1',
      type: SourceType.Screen,
      thumbnail: blueThumbnail,
    ),
    FakeDesktopCapturerSource(
      id: 'screen-2',
      name: 'Screen 2',
      type: SourceType.Screen,
      thumbnail: greyThumbnail,
    ),
    FakeDesktopCapturerSource(
      id: 'window-1',
      name: 'A window with a name too long to fit in its tile',
      type: SourceType.Window,
      thumbnail: greyThumbnail,
    ),
    FakeDesktopCapturerSource(
      id: 'window-2',
      name: 'Notes',
      type: SourceType.Window,
      thumbnail: blueThumbnail,
    ),
  ];

  Widget selector(SourceType sourceType) => _DisposingSelector(
    controller: ScreenShareSourceController(
      capturer: FakeDesktopCapturer(sources: sources),
      sourceType: sourceType,
    ),
  );

  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'StreamScreenShareSelector outlines the picked screen',
      fileName: 'screen_share_selector_screens',
      brightness: brightness,
      // The selection is made by tapping, which is also what proves the
      // selected tile looks different from its neighbour.
      pumpBeforeTest: (tester) => _settle(tester, tap: 'Screen 1'),
      builder: () => selector(SourceType.Screen),
    );

    streamGoldenTest(
      'StreamScreenShareSelector ellipsises a long window name',
      fileName: 'screen_share_selector_windows',
      brightness: brightness,
      pumpBeforeTest: _settle,
      builder: () => selector(SourceType.Window),
    );
  }
}

Future<void> _settle(WidgetTester tester, {String? tap}) async {
  await tester.pumpAndSettle();
  if (tap != null) {
    await tester.tap(find.text(tap));
    await tester.pumpAndSettle();
  }
  await precacheImages(tester);
  await tester.pumpAndSettle();
}

/// Sizes the selector to the body of a 720x640 modal — its 88px header and
/// 88px footer taken off — and disposes the controller when the test is over.
class _DisposingSelector extends StatefulWidget {
  const _DisposingSelector({required this.controller});

  final ScreenShareSourceController controller;

  @override
  State<_DisposingSelector> createState() => _DisposingSelectorState();
}

class _DisposingSelectorState extends State<_DisposingSelector> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 720,
    height: 464,
    child: StreamScreenShareSelector(controller: widget.controller),
  );
}
