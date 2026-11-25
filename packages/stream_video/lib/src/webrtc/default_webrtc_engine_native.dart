import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// None: on native platforms, stream_video_flutter registers the engine.
@internal
WebRtcEngine? createDefaultWebRtcEngine() => null;
