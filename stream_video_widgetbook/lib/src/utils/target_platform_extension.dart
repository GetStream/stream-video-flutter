import 'package:flutter/foundation.dart';

extension UtilExtension on TargetPlatform {
  bool get isMobile =>
      this == TargetPlatform.android || this == TargetPlatform.iOS;

  bool get isDesktop =>
      this == TargetPlatform.linux ||
      this == TargetPlatform.macOS ||
      this == TargetPlatform.windows;
}
