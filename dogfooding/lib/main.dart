// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// 📦 Package imports:
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

// 🌎 Project imports:
import 'app/app.dart';

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

  runApp(const StreamDogFoodingApp());
}
