// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

// 🌎 Project imports:
import 'app/app.dart';

void main() {
  // Needed to initialize the plugin bindings.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const StreamDogFoodingApp());
}
