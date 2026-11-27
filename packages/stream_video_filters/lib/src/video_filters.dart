import 'package:meta/meta.dart';

import '../stream_video_filters.dart';
import 'web/browser_effect.dart';

/// How strongly [BackgroundBlurFilter] blurs.
final class BlurIntensity {
  const BlurIntensity._(this.effectName, this._webLevel);

  /// A light blur.
  static const light = BlurIntensity._('BackgroundBlurLight', 'low');

  /// A medium blur.
  static const medium = BlurIntensity._('BackgroundBlurMedium', 'medium');

  /// A heavy blur.
  static const heavy = BlurIntensity._('BackgroundBlurHeavy', 'high');

  /// Every intensity, lightest first.
  static const values = [light, medium, heavy];

  /// The name the blur processor of this intensity is registered under.
  final String effectName;

  /// The `backgroundBlurLevel` of `@stream-io/video-filters-web`.
  final String _webLevel;

  @override
  String toString() => 'BlurIntensity($effectName)';
}

/// Blurs the background behind the person on camera.
final class BackgroundBlurFilter extends NativeVideoFilter {
  BackgroundBlurFilter({this.intensity = BlurIntensity.medium});

  final BlurIntensity intensity;

  @override
  String get effectName => intensity.effectName;

  @internal
  @override
  BrowserEffect get browserEffect => BrowserBackgroundBlur(intensity._webLevel);

  @override
  Future<void> register() {
    return StreamVideoFilters.registerBlurEffectProcessors();
  }

  @override
  Iterable<String> get registeredEffectNames => [
    for (final intensity in BlurIntensity.values) intensity.effectName,
  ];

  @override
  bool operator ==(Object other) =>
      other is BackgroundBlurFilter && other.intensity == intensity;

  @override
  int get hashCode => Object.hash(BackgroundBlurFilter, intensity);
}

/// Replaces the background behind the person on camera with an image.
///
/// The image is loaded asynchronously. While it is loading, and if it cannot
/// be loaded, the background is blurred instead so the camera image is never
/// sent unfiltered.
final class VirtualBackgroundFilter extends NativeVideoFilter {
  VirtualBackgroundFilter(this.imageUrl);

  /// The path of an image asset, or a URL to the image.
  final String imageUrl;

  @override
  String get effectName => 'VirtualBackground-$imageUrl';

  @internal
  @override
  BrowserEffect get browserEffect => BrowserBackgroundImage(imageUrl);

  @override
  Future<void> register() {
    return StreamVideoFilters.registerImageEffectProcessors(
      backgroundImageUrl: imageUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is VirtualBackgroundFilter && other.imageUrl == imageUrl;

  @override
  int get hashCode => Object.hash(VirtualBackgroundFilter, imageUrl);
}

/// Blurs the whole camera frame.
///
/// Pass it to `VideoModerationConfig.blur` to blur the camera while the call
/// is moderated. It runs after the app's own filter.
final class FullFrameBlurFilter extends NativeVideoFilter {
  FullFrameBlurFilter();

  @override
  String get effectName => 'FullFrameBlur';

  @internal
  @override
  BrowserEffect get browserEffect => const BrowserFullFrameBlur();

  @override
  Future<void> register() {
    return StreamVideoFilters.registerFullFrameBlurEffectProcessor();
  }

  @override
  bool operator ==(Object other) => other is FullFrameBlurFilter;

  @override
  int get hashCode => (FullFrameBlurFilter).hashCode;
}

/// Runs a frame processor the app registers natively under [effectName].
///
/// [onRegister] registers it, and runs before the filter is first applied.
/// Every filter's registering, attaching and detaching waits for it, so it
/// has to complete, and must not call
/// [StreamVideoFilters.unregisterAllFilters], which waits for it too.
/// Android and iOS only; on web, see `CustomWebVideoFilter` in
/// `package:stream_video_filters/web.dart`.
final class CustomVideoFilter extends NativeVideoFilter {
  CustomVideoFilter(this.effectName, {required this.onRegister});

  @override
  final String effectName;

  /// Registers the processor natively under [effectName].
  final Future<void> Function() onRegister;

  @override
  Future<void> register() {
    return onRegister();
  }

  @override
  bool operator ==(Object other) =>
      other is CustomVideoFilter && other.effectName == effectName;

  @override
  int get hashCode => Object.hash(CustomVideoFilter, effectName);
}
