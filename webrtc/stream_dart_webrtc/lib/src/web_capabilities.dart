import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';
import 'package:web/web.dart' as web;

import 'browser_capabilities.dart';
import 'user_agent.dart';

/// The capabilities of the browser the app runs in.
WebRtcCapabilities get webRtcCapabilities =>
    // ignore: invalid_use_of_visible_for_testing_member, the override's reader
    debugWebRtcCapabilitiesOverride ?? _browserCapabilities;

final WebRtcCapabilities _browserCapabilities = webRtcCapabilitiesFor(
  supportsAudioOutputSelection: supportsAudioOutputSelectionFor(
    web.window.navigator.userAgent,
  ),
);

/// Whether remote audio can be routed to a chosen output with `setSinkId`, in
/// a browser with [userAgent].
///
/// False on WebKit even where the method exists. Safari rejects `setSinkId`
/// without a user gesture, so applying it to each new track fails. Where it
/// succeeds, the output it creates keeps the sample rate the device had at
/// that moment, and a Bluetooth headset changes rate as its mic turns on and
/// off, so voices come out pitched up or down. And when the chosen device
/// disconnects, that output is rebuilt on the missing device and goes silent.
/// The system default output has none of these problems.
@visibleForTesting
bool supportsAudioOutputSelectionFor(String userAgent) {
  if (isWebKitUserAgent(userAgent)) return false;

  // Detect the capability by looking the method up rather than calling it:
  // `setSinkId` returns a promise, so invoking it would route audio and leave
  // a rejection unhandled instead of reporting support.
  final element = web.document.createElement('audio');
  return element.hasProperty('setSinkId'.toJS).toDart;
}
