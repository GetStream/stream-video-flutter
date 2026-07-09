import 'stream_web_rtc.dart';

/// Fallback [StreamWebRtc] used when no platform-specific implementation is
/// registered. On native targets this means `StreamVideoFlutter
/// .ensureInitialized()` was never called — fail loudly rather than silently
/// producing broken calls. Selected via conditional import in
/// `stream_web_rtc.dart`; the web variant (`stream_web_rtc_default_web.dart`)
/// overrides this whenever `dart.library.js_interop` is available.
final StreamWebRtc defaultStreamWebRtc = _UnregisteredStreamWebRtc();

class _UnregisteredStreamWebRtc implements StreamWebRtc {
  Never _unregistered() {
    throw UnsupportedError(
      'No StreamWebRtc implementation is registered for this platform. '
      'Flutter apps must call StreamVideoFlutter.ensureInitialized() before '
      'constructing StreamVideo.',
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => _unregistered();
}
