import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Resolves the screen-sharing glyph for the surrounding platform.
extension StreamPresentIconContext on BuildContext {
  /// [StreamIcons.presentMobileFill] on Android and iOS,
  /// [StreamIcons.presentDesktopFill] everywhere else.
  ///
  /// Read off the ambient theme rather than off a platform detector, so a test
  /// — and an app deliberately emulating another platform — gets the glyph it
  /// asked for.
  IconData get streamPresentIcon => switch (Theme.of(this).platform) {
    TargetPlatform.android ||
    TargetPlatform.iOS => streamIcons.presentMobileFill,
    _ => streamIcons.presentDesktopFill,
  };
}
