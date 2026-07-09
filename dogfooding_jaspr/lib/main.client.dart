/// The entrypoint for the **client** app.
///
/// This file is compiled to javascript and executed on the client when
/// loading the page.
library;

import 'package:jaspr/client.dart';

import 'app.dart';

void main() {
  runApp(const App());
}
