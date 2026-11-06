import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';
import 'package:web/web.dart' as web;

class RTCRtpCapabilitiesWeb {
  static RTCRtpCapabilities fromJsObject(web.RTCRtpCapabilities object) {
    return RTCRtpCapabilities.fromMap({
      'codecs': object.codecs.toDart.map((e) => e.dartify()),
      'headerExtensions': object.headerExtensions.toDart.map(
        (e) => e.dartify(),
      ),
      'fecMechanisms': object.getProperty('fecMechanisms'.toJS).dartify() ?? [],
    });
  }
}
