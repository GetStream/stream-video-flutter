import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

/// Wraps [child] in the app scaffolding SDK widgets expect, configured so that
/// the same test renders the same pixels on every machine.
///
/// Everything a golden would otherwise pick up from the host or from Flutter's
/// defaults is pinned here:
///
/// * the debug banner is off — it is painted over the top-right corner of
///   every widget otherwise, since widget tests run in debug mode;
/// * the platform is [TargetPlatform.android], matching the platform
///   `defaultTargetPlatform` reports under `flutter test`, so Material's
///   platform-dependent icons, scrollbars and page transitions agree with the
///   code that reads the platform directly;
/// * the locale is `en` with the SDK's delegates installed, so localized
///   strings don't depend on the host locale;
/// * both Stream themes are installed as theme extensions, the way an app sets
///   them up — without them, widgets reading `context.streamColorScheme` fall
///   back to defaults that don't match what ships.
///
/// What can't be pinned: the SDK widgets that branch on `CurrentPlatform`
/// (picture-in-picture in [StreamCallContent], the speakerphone control) read a
/// detector with no test override, so it reports the host OS — macOS locally,
/// Linux on CI. Both are desktop, so both golden variants take the same branch,
/// but the mobile branch of such a widget cannot be snapshotted yet.
class TestWrapper extends StatelessWidget {
  const TestWrapper({
    super.key,
    this.brightness = Brightness.light,
    this.platform = TargetPlatform.android,
    required this.child,
  });

  /// The brightness both Stream themes are built for.
  final Brightness brightness;

  /// The platform `Theme.of(context).platform` reports.
  final TargetPlatform platform;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = streamTestTheme(brightness: brightness, platform: platform);

    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('en')],
      localizationsDelegates:
          StreamVideoFlutterLocalizations.localizationsDelegates,
      // A [Material] rather than a [Scaffold]: it gives [child] the same
      // background, ink and default text style, but sizes itself to the child
      // instead of filling the viewport. A Scaffold asserts under the
      // unbounded constraints a golden test uses by default, and forces every
      // snapshot to be the size of the surface rather than of the widget.
      // Widgets that need a Scaffold — those with an app bar or a snack bar —
      // either build their own or can be wrapped in one by the test.
      home: Material(color: theme.scaffoldBackgroundColor, child: child),
    );
  }
}

/// The [ThemeData] SDK widgets are tested against: both Stream themes for
/// [brightness] installed as extensions, on a [platform]-pinned base.
///
/// Mirrors how the sample apps build their theme. Prefer [TestWrapper]; reach
/// for this directly only when a test needs its own [MaterialApp] — a test
/// exercising navigation, say.
ThemeData streamTestTheme({
  Brightness brightness = Brightness.light,
  TargetPlatform platform = TargetPlatform.android,
}) {
  final baseCoreTheme = StreamTheme(brightness: brightness, platform: platform);

  // The Stream text styles carry no font family: they inherit whatever the app
  // sets, which for the sample apps is Inter through google_fonts. A style that
  // reaches a widget *without* merging into the ambient text style — the way
  // core's menu items hand theirs to a TextButton — then has no family at all,
  // and Flutter's test renderer draws such text in Ahem: a black bar per glyph.
  // Roboto is what Flutter's own Material typography asks for, so it resolves
  // on every host without loading anything extra.
  final coreTheme = StreamTheme(
    brightness: brightness,
    platform: platform,
    textTheme: baseCoreTheme.textTheme.apply(fontFamily: 'Roboto'),
  );

  final videoTheme = switch (brightness) {
    Brightness.light => StreamVideoTheme.light(),
    Brightness.dark => StreamVideoTheme.dark(),
  };

  return ThemeData(
    brightness: brightness,
    platform: platform,
    scaffoldBackgroundColor: coreTheme.colorScheme.backgroundApp,
    extensions: <ThemeExtension<dynamic>>[coreTheme, videoTheme],
  );
}
