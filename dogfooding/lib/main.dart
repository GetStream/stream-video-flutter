// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// 📦 Package imports:
import 'package:marionette_flutter/marionette_flutter.dart';

// 🌎 Project imports:
import 'app/app.dart';

void main() {
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

  runApp(const StreamDogFoodingApp());
}
