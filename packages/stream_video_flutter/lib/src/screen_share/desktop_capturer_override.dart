import 'package:flutter/foundation.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

/// Replaces the plugin's `desktopCapturer` where the SDK reads it, so a test
/// can answer for the platform. Set it back to null once the test is done.
@internal
@visibleForTesting
DesktopCapturer? debugDesktopCapturerOverride;

/// The [DesktopCapturer] the SDK talks to: [debugDesktopCapturerOverride]
/// where one is set, the plugin's otherwise.
@internal
DesktopCapturer get resolvedDesktopCapturer =>
    debugDesktopCapturerOverride ?? desktopCapturer;
