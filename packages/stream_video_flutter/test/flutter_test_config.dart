import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isRunningInCi =
      Platform.environment.containsKey('CI') ||
      Platform.environment.containsKey('GITHUB_ACTIONS');

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      // Alchemist's standard theme pads nothing, which leaves scenario labels
      // touching their widget and the widget touching the image edge. The
      // colors are the standard ones: they're deliberately unrelated to any
      // theme, so an SDK color change can't silently move the frame.
      goldenTestTheme: GoldenTestTheme(
        backgroundColor: const Color(0xFF2B54A1),
        borderColor: const Color(0xFF3D394A),
        nameTextStyle: const TextStyle(fontSize: 14),
        padding: const EdgeInsets.all(8),
      ),
      // Each host only compares the variant it can reproduce: the CI goldens
      // — the ones committed to the repository — on CI, the platform goldens
      // locally. Leaving the CI config at its default (always enabled) makes a
      // local `flutter test` compare the Linux-generated `goldens/ci` PNGs as
      // well, which differ on host font rasterization alone.
      //
      // The CI variant keeps Alchemist's text obscuring: replacing every glyph
      // with a black bar is what keeps the committed goldens from churning on
      // every Flutter upgrade that touches text layout. Two things to know
      // about it — the committed PNGs show shape, not text, so read the
      // `goldens/<platform>` ones when reviewing a visual change; and the
      // capture path it uses drops everything painted into an [Overlay], so a
      // menu, tooltip or dialog snapshots blank rather than failing. Assert
      // those in a widget test instead (see
      // `stream_context_menu_anchor_test.dart`), or snapshot the content
      // widget directly rather than through the route that shows it.
      ciGoldensConfig: CiGoldensConfig(enabled: isRunningInCi),
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isRunningInCi),
    ),
    run: testMain,
  );
}
