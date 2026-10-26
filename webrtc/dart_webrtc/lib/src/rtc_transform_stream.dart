import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

extension PropsRTCRtpScriptTransformer on RTCRtpScriptTransformer {
  set handled(bool value) {
    setProperty('handled'.toJS, value.toJS);
  }
}
