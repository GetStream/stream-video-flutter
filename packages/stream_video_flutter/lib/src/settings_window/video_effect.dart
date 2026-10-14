import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';

/// A video effect offered by [StreamEffectsSettings].
///
/// Either a [StreamVideoFilter], drawn as a round icon button, or a
/// [StreamVideoBackground], drawn as an image tile.
@immutable
sealed class StreamVideoEffect {
  const StreamVideoEffect({
    required this.id,
    required this.label,
    required this.onSelected,
  });

  /// Identifies the effect, so the one in use can be marked selected.
  final String id;

  /// The effect's name, shown as a tooltip and read out by screen readers.
  final String label;

  /// Applies the effect.
  ///
  /// The effect is marked selected once this completes.
  final Future<void> Function() onSelected;
}

/// An effect drawn as a round icon button, such as a blur.
final class StreamVideoFilter extends StreamVideoEffect {
  /// Creates a filter.
  const StreamVideoFilter({
    required super.id,
    required super.label,
    required super.onSelected,
    required this.icon,
  });

  /// The icon on the button, typically an [Icon].
  final Widget icon;
}

/// An effect that replaces the background with an image, drawn as a tile of
/// that image.
final class StreamVideoBackground extends StreamVideoEffect {
  /// Creates a background.
  const StreamVideoBackground({
    required super.id,
    required super.label,
    required super.onSelected,
    required this.image,
  });

  /// The image the background is replaced with.
  final ImageProvider image;
}
