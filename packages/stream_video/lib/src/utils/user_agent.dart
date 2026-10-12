/// Whether [userAgent] belongs to a WebKit-engine browser.
///
/// True for desktop Safari, iOS Safari, bare WKWebView hosts and the
/// Chromium- or Gecko-branded iOS browsers (`CriOS`, `EdgiOS`, `FxiOS`), which
/// Apple forces onto WebKit and so share its media quirks.
///
/// False for desktop Chromium builds, which reuse the `AppleWebKit/` token but
/// carry a `Chrome/` or `Chromium/` marker, and for Android's Blink stack.
/// Mirrors `isWebKit` in the JS SDK so both gate the same workarounds.
bool isWebKitUserAgent(String userAgent) {
  if (!userAgent.contains('AppleWebKit/')) return false;
  return !RegExp('Chrome/|Chromium/|Android').hasMatch(userAgent);
}
