// ignore_for_file: implementation_imports, invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_dart_webrtc/src/browser_capabilities.dart';
import 'package:stream_webrtc_flutter/src/native/native_webrtc_capabilities.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

/// The capabilities the WebRTC packages report on [platform].
WebRtcCapabilities webRtcCapabilitiesOf(PlatformType platform) {
  if (platform == PlatformType.web) {
    return webRtcCapabilitiesFor(supportsAudioOutputSelection: true);
  }
  return nativeWebRtcCapabilitiesFor(
    isAndroid: platform == PlatformType.android,
    isIOS: platform == PlatformType.ios,
    isMacOS: platform == PlatformType.macOS,
    isWindows: platform == PlatformType.windows,
    isLinux: platform == PlatformType.linux,
  );
}

/// Makes the WebRTC packages report [capabilities], or those of [platform],
/// until the current test ends.
void overrideWebRtcCapabilities({
  PlatformType? platform,
  WebRtcCapabilities? capabilities,
}) {
  assert(
    (platform == null) != (capabilities == null),
    'Pass a platform or capabilities',
  );
  debugWebRtcCapabilitiesOverride =
      capabilities ?? webRtcCapabilitiesOf(platform!);
  addTearDown(() => debugWebRtcCapabilitiesOverride = null);
}
