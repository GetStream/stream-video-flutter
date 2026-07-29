import 'dart:io' show File;

/// Syncs the SDK version across the workspace from `stream_video`'s
/// `pubspec.yaml`.
///
/// Updates `streamVideoVersion` in `stream_video`'s `globals.dart` and the
/// dogfooding app's version, which follows the SDK version with its major
/// bumped by one (e.g. `1.4.2` -> `2.4.2`). Runs automatically as a
/// post-bootstrap hook, so both track the package version without a manual edit.
void main() {
  const pubspecPath = 'packages/stream_video/pubspec.yaml';
  const globalsPath = 'packages/stream_video/lib/globals.dart';
  const dogfoodingPubspecPath = 'dogfooding/pubspec.yaml';

  final versionMatch = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(File(pubspecPath).readAsStringSync());
  if (versionMatch == null) {
    throw StateError('Could not find a version in $pubspecPath');
  }
  final version = versionMatch.group(1)!;

  // Sync streamVideoVersion in globals.dart with the SDK version.
  final globals = File(globalsPath);
  final content = globals.readAsStringSync();
  final updated = content.replaceFirst(
    RegExp("const String streamVideoVersion = '.*';"),
    "const String streamVideoVersion = '$version';",
  );
  if (updated == content) {
    print('streamVideoVersion already at $version');
  } else {
    globals.writeAsStringSync(updated);
    print('Updated streamVideoVersion to $version in $globalsPath');
  }

  // Update the dogfooding app version, bumping the SDK major version by one
  // (e.g. `1.4.2` -> `2.4.2`).
  final base = version.split(RegExp('[-+]')).first.split('.');
  final dogfoodingVersion = '${int.parse(base[0]) + 1}.${base[1]}.${base[2]}';

  final dogfoodingPubspec = File(dogfoodingPubspecPath);
  final dogfoodingContent = dogfoodingPubspec.readAsStringSync();
  final updatedDogfooding = dogfoodingContent.replaceFirst(
    RegExp(r'^version:\s*\S+', multiLine: true),
    'version: $dogfoodingVersion',
  );
  if (updatedDogfooding == dogfoodingContent) {
    print('Dogfooding app already at $dogfoodingVersion');
  } else {
    dogfoodingPubspec.writeAsStringSync(updatedDogfooding);
    print('Updated dogfooding app version to $dogfoodingVersion in $dogfoodingPubspecPath');
  }
}
