// ignore_for_file: avoid_print

import 'dart:io' show Directory, File, FileSystemEntity;

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Updates the version constant in stream_video/lib/globals.dart and the
/// dogfooding app version based on the version in stream_video's pubspec.yaml,
/// and the podspec version of every package under packages/ and webrtc/ based
/// on that package's own pubspec.yaml.
Future<void> main() async {
  _updatePodspecVersions();

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

/// Sets `s.version` in each package's ios/ and macos/ podspecs to the version
/// in its pubspec.yaml.
void _updatePodspecVersions() {
  final rootDir = Directory.current.path;
  final packageDirs = [
    for (final parent in ['packages', 'webrtc'])
      ...Directory(p.join(rootDir, parent)).listSync().whereType<Directory>(),
  ];

  for (final packageDir in packageDirs) {
    final pubspecFile = File(p.join(packageDir.path, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) continue;

    final pubspec = loadYaml(pubspecFile.readAsStringSync()) as YamlMap;
    final version = pubspec['version'] as String?;
    if (version == null) continue;

    final podspecs = [
      for (final platform in ['ios', 'macos'])
        if (FileSystemEntity.isDirectorySync(p.join(packageDir.path, platform)))
          ...Directory(p.join(packageDir.path, platform))
              .listSync()
              .whereType<File>()
              .where((file) => file.path.endsWith('.podspec')),
    ];

    for (final podspec in podspecs) {
      final content = podspec.readAsStringSync();
      final updated = content.replaceFirstMapped(
        RegExp(r"^(\s*s\.version\s*=\s*)'[^']*'", multiLine: true),
        (match) => "${match[1]}'$version'",
      );
      if (updated == content) continue;

      podspec.writeAsStringSync(updated);
      print('✓ Updated version to $version in ${podspec.path}');
    }
  }
}
