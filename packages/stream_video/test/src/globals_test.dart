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

    expect(
      streamVideoVersion,
      '${version.major}.${version.minor}.${version.patch}',
    );
  });
}
