import '../stream_video_filters.dart';
import 'native_video_filter.dart';

/// How strongly [BackgroundBlurFilter] blurs.
enum BlurIntensity {
  light('BackgroundBlurLight'),
  medium('BackgroundBlurMedium'),
  heavy('BackgroundBlurHeavy');

  const BlurIntensity(this.name);
  final String name;
}

/// Blurs the background behind the person on camera.
class BackgroundBlurFilter extends NativeVideoFilter {
  BackgroundBlurFilter([this.intensity = BlurIntensity.medium]);

  final BlurIntensity intensity;

  @override
  String get effectName => intensity.name;

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
class VirtualBackgroundFilter extends NativeVideoFilter {
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
/// is moderated.
class FullFrameBlurFilter extends NativeVideoFilter {
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

/// Runs a frame processor the app registers natively under [effectName].
///
/// [onRegister] registers it, and runs before the filter is first applied.
class CustomVideoFilter extends NativeVideoFilter {
  CustomVideoFilter(this.effectName, {required this.onRegister});

  @override
  final String effectName;

  final Future<void> Function() onRegister;

  @override
  Future<void> register() => onRegister();

  @override
  bool operator ==(Object other) =>
      other is CustomVideoFilter && other.effectName == effectName;

  @override
  int get hashCode => Object.hash(CustomVideoFilter, effectName);
}
