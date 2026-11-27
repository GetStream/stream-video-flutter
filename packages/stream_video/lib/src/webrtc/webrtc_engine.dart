import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import 'default_webrtc_engine_native.dart'
    if (dart.library.js_interop) 'default_webrtc_engine_web.dart';

/// Registers the platform's default [WebRtcEngine] when none is registered:
/// the browser's on web. Native platforms have none; stream_video_flutter
/// registers theirs.
@internal
void ensureWebRtcEngine() {
  if (WebRtcEngine.isRegistered) return;
  final engine = createDefaultWebRtcEngine();
  if (engine != null) WebRtcEngine.instance = engine;
}

/// The registered [WebRtcEngine], see [ensureWebRtcEngine]. Throws a
/// [StateError] when none is registered.
@internal
WebRtcEngine get webRtcEngine {
  ensureWebRtcEngine();
  return WebRtcEngine.instance;
}
