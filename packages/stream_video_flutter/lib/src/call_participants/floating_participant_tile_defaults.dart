import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Default style values for [StreamFloatingParticipantTile].
///
/// Shared with [StreamLocalVideo], which needs the self-view's dimensions
/// before the floating tile is built. Deliberately not exported.
@internal
class StreamFloatingParticipantTileStyleDefaults
    extends StreamFloatingParticipantTileStyle {
  /// Resolves the floating tile's defaults from the theme on the given
  /// context.
  StreamFloatingParticipantTileStyleDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;
  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;
  late final _elevation = _context.streamElevation;

  @override
  Size get size => const Size(140, 228);

  @override
  double get padding => _spacing.md;

  @override
  BorderRadius get borderRadius => BorderRadius.all(_radius.lg);

  @override
  BoxBorder get border => Border.all(color: _colorScheme.borderOpacitySubtle);

  @override
  double get elevation => _elevation.level2;

  @override
  FloatingViewAlignment get initialAlignment => FloatingViewAlignment.topRight;

  @override
  bool get enableSnapping => true;

  // The radius is left out on purpose: the tile takes it from the surface it
  // sits in, which the caller may have overridden.
  @override
  StreamParticipantTileStyle get tileStyle => const StreamParticipantTileStyle(
    // The chrome that does not fit at this size. The name pill is not a
    // default — see [DefaultStreamFloatingParticipantTile.build].
    showSpeakerBorder: false,
    showMoreButton: false,
    // The tile draws no border of its own — the floating surface owns it, and
    // two hairlines on the same corner read as one thick one.
    border: Border(),
  );
}
