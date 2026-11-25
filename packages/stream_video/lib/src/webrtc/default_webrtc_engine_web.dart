import 'package:meta/meta.dart';
import 'package:stream_dart_webrtc/stream_dart_webrtc.dart';

/// The browser's engine, used on web when no engine is registered.
@internal
WebRtcEngine? createDefaultWebRtcEngine() => BrowserWebRtcEngine();
