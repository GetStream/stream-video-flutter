// ignore_for_file: avoid_print

import 'dart:io' show Directory, File;

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Updates the version constant in stream_video/lib/globals.dart and the
/// dogfooding app version based on the version in stream_video's pubspec.yaml.
Future<void> main() async {
  // Target the stream_video package
  const packageName = 'stream_video';
  final rootDir = Directory.current.path;
  final packageDir = p.join(rootDir, 'packages', packageName);
  final pubspecPath = p.join(packageDir, 'pubspec.yaml');
  final versionFilePath = p.join(packageDir, 'lib', 'globals.dart');

  print('Reading version from $pubspecPath');

  // Read version from pubspec.yaml
  final yamlMap = loadYaml(File(pubspecPath).readAsStringSync()) as YamlMap;
  final version = yamlMap['version'] as String;

  print('Found version: $version');

  // Read the existing version file
  final versionFile = File(versionFilePath);
  if (!versionFile.existsSync()) {
    print('Error: Version file not found at $versionFilePath');
    return;
  }

  final fileContent = versionFile.readAsStringSync();

  // Update the version constant
  final updatedContent = fileContent.replaceFirst(
    RegExp("const String streamVideoVersion = '.+';"),
    "const String streamVideoVersion = '$version';",
  );

  // Write the changes back to the file
  await versionFile.writeAsString(updatedContent);

  print('✓ Successfully updated version to $version in $versionFilePath');

  var cleanedVersion = version;
  if (cleanedVersion.contains('-')) {
    cleanedVersion = cleanedVersion.split('-').first;

    print('Cleaned version for app: $cleanedVersion');
  }

  // The dogfooding app version stays in sync with the SDK version.
  final dogfoodingPubspecPath = p.join(rootDir, 'dogfooding', 'pubspec.yaml');
  final dogfoodingPubspec = File(dogfoodingPubspecPath).readAsStringSync();
  final updatedDogfoodingPubspec = dogfoodingPubspec.replaceFirst(
    RegExp('version: .+'),
    'version: $cleanedVersion',
  );

  await File(dogfoodingPubspecPath).writeAsString(updatedDogfoodingPubspec);

  print(
    '✓ Successfully updated version to $cleanedVersion in $dogfoodingPubspecPath',
  );
}
