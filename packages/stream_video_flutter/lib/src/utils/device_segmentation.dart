import 'package:flutter/foundation.dart';

/// Returns true if the app is running in a mobile device.
bool get isMobileDevice =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.android;

/// Returns true if the app is running in a desktop device.
bool get isDesktopDevice =>
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows ||
    defaultTargetPlatform == TargetPlatform.linux;
