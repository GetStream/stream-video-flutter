import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

import 'test_wrapper.dart';

/// A [goldenTest] that renders [builder] inside a [TestWrapper].
///
/// Every snapshot in this package should go through here rather than build its
/// own [MaterialApp]: the wrapper is where the debug banner, the platform, the
/// locale and the Stream themes are pinned, and a snapshot that skips it picks
/// up Flutter's defaults instead — which is how the debug banner ended up
/// painted across the corner of the committed goldens.
///
/// [brightness] is appended to the description and to [fileName], so a widget
/// snapshotted in both brightnesses gets one PNG per brightness:
///
/// ```dart
/// for (final brightness in Brightness.values) {
///   streamGoldenTest(
///     'StreamRadioIndicator renders selected and unselected',
///     fileName: 'stream_radio_indicator',
///     brightness: brightness,
///     builder: () => ...,
///   );
/// }
/// ```
///
/// Widgets that paint into an [Overlay] — menus, tooltips, dialogs — need
/// [constraints] large enough to fit the overlay as well as the anchor, since
/// anything outside the snapshot's box is clipped away.
void streamGoldenTest(
  String description, {
  required String fileName,
  required ValueGetter<Widget> builder,
  Brightness brightness = Brightness.light,
  BoxConstraints constraints = const BoxConstraints(),
  double textScaleFactor = 1.0,
  PumpAction pumpBeforeTest = onlyPumpAndSettle,
  Interaction? whilePerforming,
}) {
  goldenTest(
    '[${brightness.name}] $description',
    fileName: '${fileName}_${brightness.name}',
    constraints: constraints,
    textScaleFactor: textScaleFactor,
    pumpBeforeTest: pumpBeforeTest,
    whilePerforming: whilePerforming,
    builder: () => TestWrapper(brightness: brightness, child: builder()),
  );
}
