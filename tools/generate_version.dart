import 'dart:io' show File;

/// Syncs `streamVideoVersion` in `stream_video`'s `globals.dart` with the
/// version declared in its `pubspec.yaml`.
///
/// Runs automatically as a post-bootstrap hook, so the version constant always
/// tracks the package version without a manual edit.
void main() {
  const pubspecPath = 'packages/stream_video/pubspec.yaml';
  const globalsPath = 'packages/stream_video/lib/globals.dart';

  final versionMatch = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(File(pubspecPath).readAsStringSync());
  if (versionMatch == null) {
    throw StateError('Could not find a version in $pubspecPath');
  }
  final version = versionMatch.group(1)!;

  final globals = File(globalsPath);
  final content = globals.readAsStringSync();
  final updated = content.replaceFirst(
    RegExp("const String streamVideoVersion = '.*';"),
    "const String streamVideoVersion = '$version';",
  );

  if (updated == content) {
    print('streamVideoVersion already at $version');
    return;
  }

  globals.writeAsStringSync(updated);
  print('Updated streamVideoVersion to $version in $globalsPath');
}
