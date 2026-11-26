@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/darwin_parity.dart';

/// The plugin's copy of the broadcast notification names.
const _pluginNames = '$iosTree/Broadcast/FlutterBroadcastObserver.m';

/// The broadcast extension's copy, in `stream_video_screen_sharing`.
const _extensionNames =
    '../../packages/stream_video_screen_sharing/ios/stream_video_screen_sharing/'
    'Sources/stream_video_screen_sharing/BroadcastSampleHandler.swift';

Set<String> _names(String path, RegExp declaration) {
  final source = File('${findRepoRoot().path}/$path').readAsStringSync();
  return declaration.allMatches(source).map((match) => match[1]!).toSet();
}

void main() {
  test('the plugin and the broadcast extension use the same notification '
      'names', () {
    final plugin = _names(
      _pluginNames,
      RegExp(r'static NSString\* const k\w+Notification =\s*@"([^"]+)"'),
    );
    final extension = _names(
      _extensionNames,
      RegExp(r'static let \w+Notification = "([^"]+)"'),
    );

    expect(plugin, isNotEmpty);
    expect(plugin, extension);
  });
}
