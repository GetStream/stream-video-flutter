/// Where the filters of this package load their browser implementation from,
/// and on which browsers they run. Used on web only.
///
/// The filters run `@stream-io/video-filters-web` with MediaPipe. This
/// package ships both as web-only Flutter assets, which the app serves at
/// [defaultBaseUrl]. Nothing is loaded from a CDN.
///
/// Where the filters run in a worker (Safari), the page's
/// Content-Security-Policy has to allow `worker-src blob:`.
final class WebVideoFiltersOptions {
  const WebVideoFiltersOptions({
    this.baseUrl = defaultBaseUrl,
    this.forceSafariSupport = false,
    this.forceMobileSupport = false,
  });

  /// Where the app serves this package's copy of the files, relative to the
  /// page's base URL.
  static const defaultBaseUrl =
      'assets/packages/stream_video_filters/web_files/';

  /// The folder holding `video_filters_web.js` and the `mediapipe` folder,
  /// as in `web_files` of this package. A relative URL is resolved against
  /// the page's base URL.
  final String baseUrl;

  /// Whether the background filters run on Safari. On Safari 18 and later
  /// they run in a worker; earlier versions lose frames while the tab is in
  /// the background.
  final bool forceSafariSupport;

  /// Whether the background filters run on mobile browsers, where they are
  /// slow.
  final bool forceMobileSupport;
}
