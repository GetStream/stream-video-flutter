import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'fold_layout_style.g.theme.dart';

/// How a participant layout keeps its tiles off the fold of a half-open
/// foldable.
///
/// Nested in `StreamCallParticipantsGridThemeData.foldStyle` and
/// `StreamCallParticipantsSpotlightThemeData.foldStyle`, so the grid and the
/// speaker layouts can be tuned apart.
@themeGen
@immutable
class StreamFoldLayoutStyle with _$StreamFoldLayoutStyle {
  /// Creates a fold layout style with optional property overrides.
  const StreamFoldLayoutStyle({
    this.foldGap,
    this.minTileSize,
    this.avoidFold,
    this.centerOnFold,
  }) : assert(foldGap == null || foldGap >= 0, 'A gap cannot be negative.');

  /// The gutter centred on the middle of a fold.
  ///
  /// Tiles have room inside their own edges, so they may run into a hinge's
  /// reported width; only this gutter is kept clear.
  ///
  /// Defaults to the layout's own gap between tiles.
  final double? foldGap;

  /// The smallest a tile on either side of the fold may be.
  ///
  /// A side too small for one tile of this size is left empty, and every tile
  /// goes on the other side.
  ///
  /// Defaults to the spotlight's `barTileSize`, `Size(222, 125)` unless the
  /// app changed it.
  final Size? minTileSize;

  /// Whether the layout keeps its tiles off the fold.
  ///
  /// False lays the participants out as if there were no fold.
  ///
  /// Defaults to true.
  final bool? avoidFold;

  /// Whether the layout centres itself on the fold.
  ///
  /// True gives both sides the same size, with the room left over empty on the
  /// wider side. False fills both sides, so their tiles differ in size.
  ///
  /// Defaults to true.
  final bool? centerOnFold;

  /// Linearly interpolate between two styles.
  static StreamFoldLayoutStyle? lerp(
    StreamFoldLayoutStyle? a,
    StreamFoldLayoutStyle? b,
    double t,
  ) => _$StreamFoldLayoutStyle.lerp(a, b, t);
}
