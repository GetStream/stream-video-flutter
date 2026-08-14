import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// A banner-free host for golden tests.
///
/// Wraps [child] in a [Theme] (carrying a [StreamTheme] extension) and a
/// [Material] painted with the design-system background, deliberately without
/// a [MaterialApp]. Only a [WidgetsApp]/[MaterialApp] paints Flutter's debug
/// checked-mode banner, so omitting it keeps goldens banner-free by
/// construction rather than relying on `debugShowCheckedModeBanner: false`.
///
/// Use [brightness] to pick the design-system light/dark palette; the
/// [Material] background follows it via [StreamColorScheme.backgroundApp],
/// which is what makes light-on-dark content (e.g. white control icons)
/// visible in the snapshot.
class GoldenWrapper extends StatelessWidget {
  const GoldenWrapper({
    super.key,
    required this.child,
    this.brightness = Brightness.light,
    this.padding = const EdgeInsets.all(16),
  });

  /// The widget under test.
  final Widget child;

  /// The design-system palette to render with.
  final Brightness brightness;

  /// Padding around [child], giving the snapshot some breathing room.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final streamTheme = StreamTheme(brightness: brightness);
    return Theme(
      data: ThemeData(brightness: brightness, extensions: [streamTheme]),
      child: Builder(
        builder: (context) => Material(
          color: StreamTheme.of(context).colorScheme.backgroundApp,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
