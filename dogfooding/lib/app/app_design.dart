import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// The design system the app's components are drawn with.
enum AppDesign {
  /// The SDK's own design system.
  stream;

  /// The accent color this design uses when no accent color is picked.
  Color defaultAccent(Brightness brightness) => switch (this) {
    stream => switch (brightness) {
      Brightness.light => StreamColorScheme.light().accentPrimary,
      Brightness.dark => StreamColorScheme.dark().accentPrimary,
    },
  };
}
