import 'package:dart_webrtc/dart_webrtc.dart' as rtc;
import 'package:universal_web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart' show MediaStream;

import 'video_element.dart';

StreamVideoElement createVideoElement() =>
    _DartWebRtcVideoElement(rtc.RTCVideoElement());

class _DartWebRtcVideoElement implements StreamVideoElement {
  _DartWebRtcVideoElement(this._inner);

  final rtc.RTCVideoElement _inner;

  @override
  web.HTMLElement get htmlElement => _inner.htmlElement;

  @override
  set srcObject(MediaStream? stream) => _inner.srcObject = stream;

  @override
  set objectFit(String value) => _inner.objectFit = value;
}
