// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

// 📦 Package imports:
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

// 🌎 Project imports:
import 'app/app.dart';
import 'app/design/m3e/m3e_design.dart';

/// Whether a web build keeps the route after a `#`, set with
/// `--dart-define=WEB_HASH_URLS=true`.
///
/// For hosts that do not serve the app's `index.html` for its routes.
// ignore: do_not_use_environment
const bool _kWebHashUrls = bool.fromEnvironment('WEB_HASH_URLS');

Future<void> main() async {
  // Needed to initialize the plugin bindings.
  //
  // In debug builds we install the Marionette binding instead, which lets an
  // MCP client drive the running app. It extends WidgetsFlutterBinding, so the
  // plugin bindings are initialized either way.
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // Loads the Liquid Glass design's shaders, so its first frames draw glass
  // rather than a placeholder. The app starts without them if they fail.
  try {
    await LiquidGlassWidgets.initialize();
  } catch (e) {
    debugPrint('Liquid Glass shaders failed to load: $e');
  }

  // Reads the device's accent color, which Material 3 Expressive takes by
  // default.
  await M3EDesign.loadDeviceAccent();

  // Web URLs carry the route as a path (`/join/<id>`) rather than after a `#`.
  if (!_kWebHashUrls) usePathUrlStrategy();

  runApp(const StreamDogFoodingApp());
}
