import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

class RTCRtpCapabilitiesWeb {
  static RTCRtpCapabilities fromJsObject(web.RTCRtpCapabilities object) {
    return RTCRtpCapabilities.fromMap({
      'codecs': object.codecs.toDart.map((e) => e.dartify()),
      'headerExtensions':
          object.headerExtensions.toDart.map((e) => e.dartify()),
      'fecMechanisms': object.getProperty('fecMechanisms'.toJS).dartify() ?? []
    });
  }
}
