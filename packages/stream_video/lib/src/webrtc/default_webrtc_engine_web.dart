import 'package:meta/meta.dart';
import 'package:stream_dart_webrtc/stream_dart_webrtc.dart';

/// The engine of the browser.
@internal
WebRtcEngine createDefaultWebRtcEngine() => BrowserWebRtcEngine();
