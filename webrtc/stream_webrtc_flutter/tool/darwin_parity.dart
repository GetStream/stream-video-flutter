// Keeps the iOS and macOS Objective-C trees honest.
//
// SPM requires sources to live under the target path and will not follow
// symlinks, so the Darwin plugin code exists twice:
//
//   ios/stream_webrtc_flutter/Sources/stream_webrtc_flutter/
//   macos/stream_webrtc_flutter/Sources/stream_webrtc_flutter/
//
// Every file that exists in both trees is byte-identical: platform differences
// live inside `#if TARGET_OS_IPHONE` / `#if TARGET_OS_OSX` guards rather than in
// separate copies of the file. A file that genuinely belongs to one platform
// only exists in one tree and is declared in [iosOnly] or [macosOnly] below.
//
// That makes the check a byte comparison, with no normalization and nothing to
// keep in sync by hand beyond the two lists.
//
// Usage:
//   dart tool/darwin_parity.dart              # check, exit non-zero on findings
//   dart tool/darwin_parity.dart check
//   dart tool/darwin_parity.dart fix --to=macos
//   dart tool/darwin_parity.dart fix --to=ios
//
// `test/unit/darwin_parity_test.dart` runs the same check, so `flutter test`
// (already wired into CI) fails on drift.

import 'dart:io';

const iosTree = 'ios/stream_webrtc_flutter/Sources/stream_webrtc_flutter';
const macosTree = 'macos/stream_webrtc_flutter/Sources/stream_webrtc_flutter';

/// Files that exist only in the iOS tree, as paths relative to [iosTree].
///
/// Adding a Darwin source file means either giving it a counterpart in the
/// other tree or naming it here.
const iosOnly = <String>{
  'AudioUtils.m',
  'Broadcast/FlutterBroadcastScreenCapturer.m',
  'Broadcast/FlutterSocketConnection.m',
  'Broadcast/FlutterSocketConnectionFrameReader.m',
  'FlutterRPScreenRecorder.m',
  'FlutterRTCMediaRecorder.m',
  'FlutterRTCVideoPlatformView.m',
  'FlutterRTCVideoPlatformViewController.m',
  'FlutterRTCVideoPlatformViewFactory.m',
  'include/stream_webrtc_flutter/AudioUtils.h',
  'include/stream_webrtc_flutter/Broadcast/FlutterBroadcastScreenCapturer.h',
  'include/stream_webrtc_flutter/Broadcast/FlutterSocketConnection.h',
  'include/stream_webrtc_flutter/Broadcast/FlutterSocketConnectionFrameReader.h',
  'include/stream_webrtc_flutter/FlutterRPScreenRecorder.h',
  'include/stream_webrtc_flutter/FlutterRTCMediaRecorder.h',
  'include/stream_webrtc_flutter/FlutterRTCVideoPlatformView.h',
  'include/stream_webrtc_flutter/FlutterRTCVideoPlatformViewController.h',
  'include/stream_webrtc_flutter/FlutterRTCVideoPlatformViewFactory.h',
};

/// Files that exist only in the macOS tree, as paths relative to [macosTree].
const macosOnly = <String>{
  'FlutterSCStreamCapturer.m',
  'StreamMacAudioDevices.m',
  'include/stream_webrtc_flutter/FlutterSCStreamCapturer.h',
  'include/stream_webrtc_flutter/StreamMacAudioDevices.h',
};

/// Walks up from [start] until it finds the directory holding `pubspec.yaml`.
Directory findRepoRoot([Directory? start]) {
  var dir = start ?? Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir;
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError(
        'could not find pubspec.yaml above ${Directory.current.path}',
      );
    }
    dir = parent;
  }
}

Set<String> _filesUnder(Directory root) {
  if (!root.existsSync()) {
    throw StateError('missing Darwin source tree: ${root.path}');
  }
  final prefix = '${root.path}/';
  return root
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.path.substring(prefix.length))
      .where((p) => !p.split('/').any((seg) => seg.startsWith('.')))
      .toSet();
}

/// Every way the two trees can disagree, as human-readable findings.
///
/// An empty list means the trees are in the state this tool exists to hold them
/// in: shared files byte-identical, one-sided files declared.
List<String> checkDarwinParity({Directory? repoRoot}) {
  final root = (repoRoot ?? findRepoRoot()).path;
  final iosRoot = Directory('$root/$iosTree');
  final macosRoot = Directory('$root/$macosTree');

  final ios = _filesUnder(iosRoot);
  final macos = _filesUnder(macosRoot);
  final findings = <String>[];

  // 1. Shared files must be byte-identical.
  for (final path in (ios.intersection(macos)).toList()..sort()) {
    final a = File('${iosRoot.path}/$path').readAsBytesSync();
    final b = File('${macosRoot.path}/$path').readAsBytesSync();
    var same = a.length == b.length;
    if (same) {
      for (var i = 0; i < a.length; i++) {
        if (a[i] != b[i]) {
          same = false;
          break;
        }
      }
    }
    if (!same) {
      findings.add(
        '$path differs between the two trees.\n'
        '    A change landed in one copy only. Fold the platform difference into a\n'
        "    `#if TARGET_OS_IPHONE` / `#if TARGET_OS_OSX` guard, then run\n"
        '    `dart tool/darwin_parity.dart fix --to=macos` (or --to=ios) to copy the\n'
        '    reconciled file across.',
      );
    }
  }

  // 2. A file in one tree only must say so.
  for (final path in (ios.difference(macos)).toList()..sort()) {
    if (!iosOnly.contains(path)) {
      findings.add(
        '$path exists in the iOS tree but not the macOS tree, and is not declared.\n'
        '    Either add its macOS counterpart (`fix --to=macos` copies it) or add it\n'
        '    to `iosOnly` in tool/darwin_parity.dart.',
      );
    }
  }
  for (final path in (macos.difference(ios)).toList()..sort()) {
    if (!macosOnly.contains(path)) {
      findings.add(
        '$path exists in the macOS tree but not the iOS tree, and is not declared.\n'
        '    Either add its iOS counterpart (`fix --to=ios` copies it) or add it to\n'
        '    `macosOnly` in tool/darwin_parity.dart.',
      );
    }
  }

  // 3. The declarations themselves must still be true.
  for (final path in (iosOnly.toList()..sort())) {
    if (!ios.contains(path)) {
      findings.add(
        "$path is declared iOS-only but no longer exists in the iOS tree.\n"
        '    Remove it from `iosOnly` in tool/darwin_parity.dart.',
      );
    } else if (macos.contains(path)) {
      findings.add(
        '$path is declared iOS-only but now exists in the macOS tree too.\n'
        '    Remove it from `iosOnly` so the two copies are compared.',
      );
    }
  }
  for (final path in (macosOnly.toList()..sort())) {
    if (!macos.contains(path)) {
      findings.add(
        '$path is declared macOS-only but no longer exists in the macOS tree.\n'
        '    Remove it from `macosOnly` in tool/darwin_parity.dart.',
      );
    } else if (ios.contains(path)) {
      findings.add(
        '$path is declared macOS-only but now exists in the iOS tree too.\n'
        '    Remove it from `macosOnly` so the two copies are compared.',
      );
    }
  }

  return findings;
}

/// Copies shared files onto [to], which is either `ios` or `macos`.
///
/// Direction is always explicit and never inferred, so the tool cannot guess
/// wrong about which side moved. Files declared one-sided are left alone; an
/// undeclared file with no counterpart gets one, since "shared" is the only
/// remaining reading of a file nobody declared.
List<String> fixDarwinParity({required String to, Directory? repoRoot}) {
  if (to != 'ios' && to != 'macos') {
    throw ArgumentError.value(to, 'to', 'expected "ios" or "macos"');
  }
  final root = (repoRoot ?? findRepoRoot()).path;
  final iosRoot = Directory('$root/$iosTree');
  final macosRoot = Directory('$root/$macosTree');

  final fromRoot = to == 'macos' ? iosRoot : macosRoot;
  final toRoot = to == 'macos' ? macosRoot : iosRoot;
  final skip = to == 'macos' ? iosOnly : macosOnly;

  final changed = <String>[];
  for (final path in (_filesUnder(fromRoot).toList()..sort())) {
    if (skip.contains(path)) continue;
    final src = File('${fromRoot.path}/$path');
    final dst = File('${toRoot.path}/$path');
    if (dst.existsSync()) {
      final a = src.readAsBytesSync();
      final b = dst.readAsBytesSync();
      if (a.length == b.length) {
        var same = true;
        for (var i = 0; i < a.length; i++) {
          if (a[i] != b[i]) {
            same = false;
            break;
          }
        }
        if (same) continue;
      }
    } else {
      dst.parent.createSync(recursive: true);
    }
    src.copySync(dst.path);
    changed.add(path);
  }
  return changed;
}

void main(List<String> args) {
  final command = args.isEmpty ? 'check' : args.first;

  if (command == 'check') {
    final findings = checkDarwinParity();
    if (findings.isEmpty) {
      stdout.writeln('darwin parity: iOS and macOS trees agree.');
      return;
    }
    stderr.writeln('darwin parity: ${findings.length} finding(s).\n');
    for (final finding in findings) {
      stderr.writeln('  - $finding\n');
    }
    exitCode = 1;
    return;
  }

  if (command == 'fix') {
    String? to;
    for (final arg in args.skip(1)) {
      if (arg.startsWith('--to=')) to = arg.substring('--to='.length);
    }
    if (to == null) {
      stderr.writeln(
        'fix needs an explicit direction: --to=macos or --to=ios.\n'
        'It is never inferred, so it cannot guess wrong about which side moved.',
      );
      exitCode = 2;
      return;
    }
    final changed = fixDarwinParity(to: to);
    if (changed.isEmpty) {
      stdout.writeln('darwin parity: nothing to copy to $to.');
      return;
    }
    stdout.writeln('darwin parity: copied ${changed.length} file(s) to $to:');
    for (final path in changed) {
      stdout.writeln('  $path');
    }
    return;
  }

  stderr.writeln(
    'usage: dart tool/darwin_parity.dart [check | fix --to=macos|ios]',
  );
  exitCode = 2;
}
