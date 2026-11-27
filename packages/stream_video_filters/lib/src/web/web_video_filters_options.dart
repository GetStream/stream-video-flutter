/// Where the filters of this package load their browser implementation from,
/// and on which browsers they run. Used on web only.
///
/// The filters run `@stream-io/video-filters-web`, loaded as an ES module
/// from [moduleUrl]. It loads the MediaPipe WebAssembly and segmentation
/// model from [basePath], so the page's Content-Security-Policy has to allow
/// both, and `worker-src blob:` where the filters run in a worker (Safari).
final class WebVideoFiltersOptions {
  const WebVideoFiltersOptions({
    this.moduleUrl = defaultModuleUrl,
    this.basePath,
    this.modelPath,
    this.forceSafariSupport = false,
    this.forceMobileSupport = false,
  });

  /// The `@stream-io/video-filters-web` version [defaultModuleUrl] loads.
  static const moduleVersion = '1.0.0-beta.3';

  /// `@stream-io/video-filters-web` [moduleVersion], bundled as an ES module
  /// by jsDelivr.
  static const defaultModuleUrl =
      'https://cdn.jsdelivr.net/npm/@stream-io/video-filters-web@$moduleVersion/+esm';

  /// The URL of the `@stream-io/video-filters-web` ES module.
  final String moduleUrl;

  /// The folder holding the MediaPipe `wasm` and `models` folders. When null,
  /// the module's own copy on unpkg.
  final String? basePath;

  /// The URL of the segmentation model. When null,
  /// `models/selfie_segmenter_landscape.tflite` in [basePath].
  final String? modelPath;

  /// Whether the background filters run on Safari. On Safari 18 and later
  /// they run in a worker; earlier versions lose frames while the tab is in
  /// the background.
  final bool forceSafariSupport;

  /// Whether the background filters run on mobile browsers, where they are
  /// slow.
  final bool forceMobileSupport;
}
