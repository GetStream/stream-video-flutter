import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import 'default_webrtc_engine_native.dart'
    if (dart.library.js_interop) 'default_webrtc_engine_web.dart';

/// Registers the platform's default [WebRtcEngine] when none is registered.
@internal
void ensureWebRtcEngine() {
  if (!WebRtcEngine.isRegistered) {
    WebRtcEngine.instance = createDefaultWebRtcEngine();
  }
}

/// The registered [WebRtcEngine], see [ensureWebRtcEngine].
@internal
WebRtcEngine get webRtcEngine {
  ensureWebRtcEngine();
  return WebRtcEngine.instance;
}
