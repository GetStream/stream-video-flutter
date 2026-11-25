import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

/// The engine of the WebRTC plugin.
@internal
WebRtcEngine createDefaultWebRtcEngine() => NativeWebRtcEngine();
