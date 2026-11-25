import '../stream_video_filters.dart';

/// How strongly [BackgroundBlurFilter] blurs.
final class BlurIntensity {
  const BlurIntensity._(this.effectName);

  /// A light blur.
  static const light = BlurIntensity._('BackgroundBlurLight');

  /// A medium blur.
  static const medium = BlurIntensity._('BackgroundBlurMedium');

  /// A heavy blur.
  static const heavy = BlurIntensity._('BackgroundBlurHeavy');

  /// Every intensity, lightest first.
  static const values = [light, medium, heavy];

  /// The name the blur processor of this intensity is registered under.
  final String effectName;

  @override
  String toString() => 'BlurIntensity($effectName)';
}

/// Blurs the background behind the person on camera.
final class BackgroundBlurFilter extends NativeVideoFilter {
  BackgroundBlurFilter({this.intensity = BlurIntensity.medium});

  final BlurIntensity intensity;

  @override
  String get effectName => intensity.effectName;

  @override
  Future<void> register() {
    return StreamVideoFilters().registerBlurEffectProcessors();
  }

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

  @override
  Future<void> register() {
    return StreamVideoFilters().registerImageEffectProcessors(
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

  @override
  Future<void> register() {
    return StreamVideoFilters().registerFullFrameBlurEffectProcessor();
  }

  @override
  bool operator ==(Object other) => other is FullFrameBlurFilter;

  @override
  int get hashCode => (FullFrameBlurFilter).hashCode;
}

/// What [CustomVideoFilter.onRegister] registers.
final class CustomVideoFilterRegistration {
  const CustomVideoFilterRegistration({required this.effectName});

  /// The name to register the processor under.
  final String effectName;
}

/// Runs a frame processor the app registers natively under [effectName].
///
/// [onRegister] registers it, and runs before the filter is first applied.
final class CustomVideoFilter extends NativeVideoFilter {
  CustomVideoFilter(this.effectName, {required this.onRegister});

  @override
  final String effectName;

  final Future<void> Function(CustomVideoFilterRegistration registration)
  onRegister;

  @override
  Future<void> register() {
    return onRegister(CustomVideoFilterRegistration(effectName: effectName));
  }

  @override
  bool operator ==(Object other) =>
      other is CustomVideoFilter && other.effectName == effectName;

  @override
  int get hashCode => Object.hash(CustomVideoFilter, effectName);
}
