import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:stream_video/globals.dart';

void main() {
  // test run on the root of the package, so the relative path is just pubspec.yaml
  const pubspecPath = 'pubspec.yaml';

  test('verify version number', () {
    final pubspec = Pubspec.parse(File(pubspecPath).readAsStringSync());
    final version = pubspec.version!;

    // The full version, including any pre-release suffix (e.g. `2.0.0-alpha`),
    // since that is what `tools/generate_version.dart` writes into globals.dart.
    expect(streamVideoVersion, version.toString());
  });
}
