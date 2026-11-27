import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import 'browser_effect.dart';
import 'web_video_filters_options.dart';

/// Whether this browser can run the background effects. Never outside a
/// browser.
Future<bool> isBrowserEffectSupported(WebVideoFiltersOptions options) async =>
    false;

/// Runs [effect] on [input] in the browser. Not supported outside one.
Future<rtc.MediaStreamFilterResult> applyBrowserEffect(
  rtc.MediaStreamFilterInput input,
  BrowserEffect effect,
  WebVideoFiltersOptions options,
) {
  throw UnsupportedError('Browser video effects run on web only');
}
