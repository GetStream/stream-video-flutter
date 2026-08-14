import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isRunningInCi =
      Platform.environment.containsKey('CI') ||
      Platform.environment.containsKey('GITHUB_ACTIONS');

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      // CI goldens (platform-agnostic rendering) only run on CI, and
      // platform goldens (host-specific rendering) only run locally. This
      // keeps CI deterministic while still letting developers eyeball
      // realistic renders on their own machine.
      ciGoldensConfig: CiGoldensConfig(enabled: isRunningInCi),
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isRunningInCi),
    ),
    run: testMain,
  );
}
