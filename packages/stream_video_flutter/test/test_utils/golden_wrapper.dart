import 'package:flutter/material.dart';

/// A banner-free host for golden tests.
///
/// Wraps [child] in a [Theme] and a [Material] painted with a brightness-aware
/// background, deliberately without a [MaterialApp]. Only a
/// [WidgetsApp]/[MaterialApp] paints Flutter's debug checked-mode banner, so
/// omitting it keeps goldens banner-free by construction rather than relying
/// on `debugShowCheckedModeBanner: false`.
///
/// Use [brightness] to pick the light/dark palette; the [Material] background
/// follows it via [ColorScheme.surface], which is what makes light-on-dark
/// content (e.g. white control icons) visible in the snapshot.
class GoldenWrapper extends StatelessWidget {
  const GoldenWrapper({
    super.key,
    required this.child,
    this.brightness = Brightness.light,
    this.padding = const EdgeInsets.all(16),
  });

  /// The widget under test.
  final Widget child;

  /// The palette to render with.
  final Brightness brightness;

  /// Padding around [child], giving the snapshot some breathing room.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(brightness: brightness);
    return Theme(
      data: theme,
      child: Material(
        color: theme.colorScheme.surface,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
