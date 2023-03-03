import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Returns true if the app is running in a mobile device.
bool get isMobileDevice =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.android;

/// Returns true if the app is running in a desktop device.
bool get isDesktopDevice =>
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows ||
    defaultTargetPlatform == TargetPlatform.linux;

/// Returns true if the app is running on a mobile device in landscape mode.
bool isMobileLandscape(BuildContext context) {
  return isMobileDevice &&
      MediaQuery.of(context).orientation == Orientation.landscape;
}

/// Returns true if the app is running on a mobile device in portrait mode.
bool isMobilePortrait(BuildContext context) {
  return isMobileDevice &&
      MediaQuery.of(context).orientation == Orientation.portrait;
}
