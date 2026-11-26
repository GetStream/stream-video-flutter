import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';
import 'package:web/web.dart' as web;

import 'browser_capabilities.dart';
import 'user_agent.dart';

/// The capabilities of the browser the app runs in.
WebRtcCapabilities get webRtcCapabilities {
  WebRtcCapabilities? override;
  assert(() {
    // ignore: invalid_use_of_visible_for_testing_member, the override's reader
    override = debugWebRtcCapabilitiesOverride;
    return true;
  }());
  return override ?? _browserCapabilities;
}

// ignore: invalid_use_of_visible_for_testing_member, the browser's own value
final WebRtcCapabilities _browserCapabilities = browserWebRtcCapabilitiesFor(
  supportsAudioOutputSelection: _probeAudioOutputSelection(),
  isWebKit: _probeWebKit(),
);

/// Whether this browser runs on WebKit. False where the browser cannot be
/// probed.
bool _probeWebKit() {
  try {
    return isWebKitUserAgent(web.window.navigator.userAgent);
  } catch (_) {
    return false;
  }
}

/// Whether this browser supports audio output selection. False where the
/// browser cannot be probed, such as outside a window.
bool _probeAudioOutputSelection() {
  try {
    return supportsAudioOutputSelectionFor(web.window.navigator.userAgent);
  } catch (_) {
    return false;
  }
}

/// Whether remote audio can be routed to a chosen output with `setSinkId`:
/// false for a WebKit [userAgent], otherwise whether this browser's audio
/// elements have `setSinkId`.
///
/// Safari rejects `setSinkId` without a user gesture, and the output it builds
/// breaks when a Bluetooth headset changes sample rate or the device
/// disconnects.
@visibleForTesting
bool supportsAudioOutputSelectionFor(String userAgent) {
  if (isWebKitUserAgent(userAgent)) return false;

  // Detect the capability by looking the method up rather than calling it:
  // `setSinkId` returns a promise, so invoking it would route audio and leave
  // a rejection unhandled instead of reporting support.
  final element = web.document.createElement('audio');
  return element.hasProperty('setSinkId'.toJS).toDart;
}
