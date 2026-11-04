// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// 📦 Package imports:
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

// 🌎 Project imports:
import 'app/app.dart';
import 'app/design/m3e/m3e_design.dart';

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
  // rather than a placeholder.
  await LiquidGlassWidgets.initialize();

  // Reads the device's accent color, which Material 3 Expressive takes by
  // default.
  await M3EDesign.loadDeviceAccent();

  runApp(const StreamDogFoodingApp());
}
