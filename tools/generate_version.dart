import 'dart:io' show Directory, File;

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Updates the version constant in stream_video/lib/globals.dart based on
/// the version in its pubspec.yaml file.
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

  // The dogfooding app follows the SDK version with its major bumped by one
  // (e.g. `1.4.2` -> `2.4.2`).
  final parts = cleanedVersion.split('.');
  final dogfoodingVersion = '${int.parse(parts[0]) + 1}.${parts[1]}.${parts[2]}';

  // Update the version in the dogfooding pubspec.yaml
  final dogfoodingPubspecPath = p.join(rootDir, 'dogfooding', 'pubspec.yaml');
  final dogfoodingPubspec = File(dogfoodingPubspecPath).readAsStringSync();
  final updatedDogfoodingPubspec = dogfoodingPubspec.replaceFirst(
    RegExp('version: .+'),
    'version: $dogfoodingVersion',
  );

  await File(dogfoodingPubspecPath).writeAsString(updatedDogfoodingPubspec);

  print('✓ Successfully updated version to $dogfoodingVersion in $dogfoodingPubspecPath');
}
