import 'package:universal_web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart' show MediaStream;

import 'video_element_default.dart'
    if (dart.library.js_interop) 'video_element_default_web.dart'
    as impl;

/// A `<video>` element bound to a [MediaStream], abstracted so
/// `dart_webrtc`'s JS-interop-only implementation is never compiled into a
/// non-web target (e.g. `jaspr_builder`'s server-side style-extraction pass,
/// which compiles for the Dart VM even for a client-rendered project).
abstract class StreamVideoElement {
  web.HTMLElement get htmlElement;

  set srcObject(MediaStream? stream);

  set objectFit(String value);
}

StreamVideoElement createVideoElement() => impl.createVideoElement();
