import 'package:flutter/foundation.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

/// Registers the WebRTC plugin's engine, which stream_video uses on Android,
/// iOS, macOS, Windows and Linux.
///
/// Flutter's plugin registrant calls [registerWith] before the app's `main`,
/// and before the entry point of every Flutter engine the app starts, such as
/// one for a background push.
@internal
// ignore: avoid_classes_with_only_static_members, the shape Flutter's plugin registrant calls
class StreamVideoFlutterEngineRegistrant {
  /// Registers a [NativeWebRtcEngine] as `WebRtcEngine.instance`, unless an
  /// engine is registered already.
  static void registerWith() {
    if (WebRtcEngine.isRegistered) return;
    WebRtcEngine.instance = NativeWebRtcEngine();
  }
}
