import 'package:meta/meta.dart';

/// An effect of `@stream-io/video-filters-web` a filter runs on web.
@internal
sealed class BrowserEffect {
  const BrowserEffect();
}

/// Blurs the background, at `low`, `medium` or `high`.
@internal
final class BrowserBackgroundBlur extends BrowserEffect {
  const BrowserBackgroundBlur(this.level);

  final String level;
}

/// Replaces the background with the image at [imageUrl]: an asset key or a
/// URL.
@internal
final class BrowserBackgroundImage extends BrowserEffect {
  const BrowserBackgroundImage(this.imageUrl);

  final String imageUrl;
}

/// Blurs the whole frame.
@internal
final class BrowserFullFrameBlur extends BrowserEffect {
  const BrowserFullFrameBlur();
}
