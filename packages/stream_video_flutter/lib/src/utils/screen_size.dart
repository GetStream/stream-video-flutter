import 'package:flutter/widgets.dart';

/// The size bucket a Stream Video layout adapts to.
///
/// The width breakpoints match the ones the design system uses across SDKs, so
/// a component laid out against [StreamScreenSize] lines up with the Figma
/// variant of the same name. A window shorter than [smallMaxHeight] is [small]
/// whatever its width, so a phone in landscape is [small].
///
/// This is about how much room there is, not what the app is running on — see
/// `isMobileDevice` and friends in `device_segmentation.dart` for the platform
/// question. The two are complementary: a phone-sized window on a desktop is
/// [small], and a tablet in landscape is not a phone.
enum StreamScreenSize {
  /// Narrower than [smallMaxWidth] or shorter than [smallMaxHeight]. Phones,
  /// the outer display of a foldable, and desktop windows dragged small.
  small,

  /// Between [smallMaxWidth] and [mediumMaxWidth], and at least
  /// [smallMaxHeight] tall. Tablets, split-screen.
  medium,

  /// [mediumMaxWidth] and wider, and at least [smallMaxHeight] tall.
  large;

  /// Widths below this are [small].
  static const smallMaxWidth = 768.0;

  /// Heights below this are [small].
  static const smallMaxHeight = 480.0;

  /// Widths below this — and at or above [smallMaxWidth] — are [medium].
  static const mediumMaxWidth = 1280.0;

  /// The bucket [width] falls into, whatever the height.
  static StreamScreenSize fromWidth(double width) => switch (width) {
    < smallMaxWidth => .small,
    < mediumMaxWidth => .medium,
    _ => .large,
  };

  /// The bucket a window of [size] falls into.
  ///
  /// [fromWidth], except that a window shorter than [smallMaxHeight] is
  /// [small].
  static StreamScreenSize fromSize(Size size) {
    if (size.height < smallMaxHeight) return .small;
    return fromWidth(size.width);
  }

  /// Whether this is [small].
  bool get isSmall => this == .small;

  /// Whether this is [medium].
  bool get isMedium => this == .medium;

  /// Whether this is [large].
  bool get isLarge => this == .large;
}

/// Reads the ambient [StreamScreenSize].
extension StreamScreenSizeContext on BuildContext {
  /// The size bucket of the surrounding window.
  ///
  /// Measured off `MediaQuery.sizeOf` rather than the widget's own
  /// constraints: a breakpoint describes the window, and a lobby embedded in a
  /// narrow column on a desktop should not start reporting
  /// [StreamScreenSize.small] and rearrange itself for a phone.
  StreamScreenSize get streamScreenSize =>
      StreamScreenSize.fromSize(MediaQuery.sizeOf(this));
}
