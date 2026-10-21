import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

extension VideoRendererExtension on RTCVideoRenderer {
  RTCVideoValue get videoValue => value;
}

abstract class AudioControl {
  Future<void> setVolume(double volume);
}
