import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';

/// How much of a participant tile's chrome is drawn.
///
/// The same tile is a full-width desktop cell, a thumbnail in a spotlight
/// strip, a 140px floating self-view and a 128px picture-in-picture window, so
/// what it shows is a function of the space it was given rather than of the
/// platform. [StreamParticipantTileChromePolicy.bySize] maps a size onto one of
/// these.
///
/// Each level is a ceiling rather than a promise: the tile still measures what
/// it draws, and the name pill drops itself when the name it is left with would
/// be too narrow to read — see [StreamParticipantLabelStyle.minNameWidth].
enum StreamParticipantTileChrome {
  /// Everything: the name pill with the participant's full state, the
  /// connection quality indicator, the overflow button and any reaction.
  full,

  /// The name and the connection quality indicator.
  ///
  /// Drops what the name would otherwise be squeezed out by: the sound
  /// indicator, the camera-off icon, the overflow button and the reaction. The
  /// muted icon stays — at this size it is the one piece of state worth the
  /// room it takes.
  compact,

  /// The connection quality indicator alone.
  minimal,

  /// No chrome at all.
  bare;

  /// Widths at or above this are [full], given [fullHeight].
  ///
  /// The name is what sets it. A [full] pill spends 100px before the name gets
  /// anything — the toolbar's 8px inset on both sides, the 32px indicator and
  /// the 4px gap before it, the pill's own 16px of padding, the 24px sound
  /// indicator and the 8px gap in front of it — so this is that plus a name
  /// worth drawing.
  static const fullWidth = 140.0;

  /// Widths at or above this — and below [fullWidth] — are [compact].
  static const compactWidth = 92.0;

  /// Widths at or above this — and below [compactWidth] — are [minimal].
  ///
  /// The toolbar's inset on both sides of the indicator: 8 + 32 + 8.
  static const minimalWidth = 48.0;

  /// Heights below this are at most [minimal], whatever the width.
  static const fullHeight = 72.0;

  /// Heights below this are [bare].
  ///
  /// The same arithmetic as [minimalWidth]: the toolbar's inset above and below
  /// the indicator, which is as tall as it is wide.
  static const minimalHeight = 48.0;

  /// The level [size] calls for.
  static StreamParticipantTileChrome fromSize(Size size) {
    final width = size.width;
    final height = size.height;

    if (width >= fullWidth && height >= fullHeight) return full;
    if (width >= compactWidth && height >= fullHeight) return compact;
    if (width >= minimalWidth && height >= minimalHeight) return minimal;
    return bare;
  }

  /// Whether this is [full].
  bool get isFull => this == full;

  /// Whether this is [compact].
  bool get isCompact => this == compact;

  /// Whether this is [minimal].
  bool get isMinimal => this == minimal;

  /// Whether this is [bare].
  bool get isBare => this == bare;

  /// Whether the name pill is drawn.
  bool get showsLabel => this == full || this == compact;

  /// Whether the pill carries the participant's device state beyond the muted
  /// icon: the sound indicator and the camera-off icon.
  bool get showsLabelExtras => this == full;

  /// Whether the connection quality indicator is drawn.
  bool get showsConnectionQuality => this != bare;

  /// Whether the overflow button and the reaction are drawn.
  ///
  /// Both live in the top toolbar. This decides whether the tile is big enough
  /// to carry any of it; whether either actually fits is measured.
  bool get carriesTopToolbar => this == full;
}

/// What is available when resolving how much chrome a tile draws.
///
/// Passed to a [StreamParticipantTileChromeResolver]. Not intended to be
/// constructed directly.
@immutable
class StreamParticipantTileChromeDetails {
  /// Creates a set of details describing a tile about to be drawn.
  const StreamParticipantTileChromeDetails({
    required this.size,
    required this.participant,
  });

  /// The size the tile was laid out at.
  final Size size;

  /// The participant it draws.
  ///
  /// What the pill has to say changes what fits: a muted, camera-off
  /// participant carries two icons an unmuted one does not.
  final CallParticipantState participant;
}

/// Signature for resolving how much chrome a participant tile draws.
typedef StreamParticipantTileChromeResolver =
    StreamParticipantTileChrome Function(
      StreamParticipantTileChromeDetails details,
    );

/// How much chrome a tile of [size] drawing [participant] draws, under the
/// policy the ambient [StreamParticipantTileTheme] carries.
///
/// Resolved in one place so that a tile measured by [StreamParticipantTile] and
/// one measuring itself — a [DefaultStreamParticipantTile] handed props nobody
/// measured, as the deprecated `StreamCallParticipant` does — answer the same
/// question the same way.
@internal
StreamParticipantTileChrome resolveParticipantTileChrome(
  BuildContext context, {
  required Size size,
  required CallParticipantState participant,
}) {
  final policy =
      StreamParticipantTileTheme.of(context).chromePolicy ??
      StreamParticipantTileChromePolicy.bySize;

  return policy.resolve(
    StreamParticipantTileChromeDetails(size: size, participant: participant),
  );
}

/// Decides how much chrome a [StreamParticipantTile] draws at the size it was
/// given.
///
/// Set it on [StreamParticipantTileThemeData.chromePolicy] to change it for
/// every tile in an app:
///
/// ```dart
/// StreamVideoTheme(
///   brightness: Brightness.dark,
///   participantTileTheme: StreamParticipantTileThemeData(
///     chromePolicy: StreamParticipantTileChromePolicy.custom(_keepNames),
///   ),
/// )
///
/// StreamParticipantTileChrome _keepNames(
///   StreamParticipantTileChromeDetails details,
/// ) => details.size.width >= 80
///     ? StreamParticipantTileChrome.compact
///     : StreamParticipantTileChrome.bare;
/// ```
///
/// Hoist the function to a field or a top-level function rather than
/// allocating a closure on each build, so that equal themes compare as equal.
///
/// See also:
///
///  * [StreamParticipantTileChrome], which enumerates what can be drawn.
///  * [StreamParticipantTileChromeDetails], which describes the tile.
///  * [StreamParticipantTileThemeData.styleResolver], for restyling per size
///    rather than choosing between these levels.
abstract class StreamParticipantTileChromePolicy {
  const StreamParticipantTileChromePolicy._();

  /// Resolves the level using the provided `resolve` function.
  const factory StreamParticipantTileChromePolicy.custom(
    StreamParticipantTileChromeResolver resolve,
  ) = _CustomChromePolicy;

  /// Steps down through [StreamParticipantTileChrome] as the tile gets
  /// smaller, by [StreamParticipantTileChrome.fromSize].
  ///
  /// This is the default policy.
  static const StreamParticipantTileChromePolicy bySize = _BySizeChromePolicy();

  /// Draws the full chrome whatever the size.
  ///
  /// The tile still measures what it draws, so a piece with no room for it is
  /// left out regardless.
  static const StreamParticipantTileChromePolicy always = _AlwaysChromePolicy();

  /// Draws no chrome at any size, leaving the video on its own.
  static const StreamParticipantTileChromePolicy none = _NoneChromePolicy();

  /// Resolves the level to draw for the given `details`.
  StreamParticipantTileChrome resolve(
    StreamParticipantTileChromeDetails details,
  );
}

class _BySizeChromePolicy extends StreamParticipantTileChromePolicy {
  const _BySizeChromePolicy() : super._();

  @override
  StreamParticipantTileChrome resolve(
    StreamParticipantTileChromeDetails details,
  ) => StreamParticipantTileChrome.fromSize(details.size);
}

class _AlwaysChromePolicy extends StreamParticipantTileChromePolicy {
  const _AlwaysChromePolicy() : super._();

  @override
  StreamParticipantTileChrome resolve(
    StreamParticipantTileChromeDetails details,
  ) => StreamParticipantTileChrome.full;
}

class _NoneChromePolicy extends StreamParticipantTileChromePolicy {
  const _NoneChromePolicy() : super._();

  @override
  StreamParticipantTileChrome resolve(
    StreamParticipantTileChromeDetails details,
  ) => StreamParticipantTileChrome.bare;
}

@immutable
class _CustomChromePolicy extends StreamParticipantTileChromePolicy {
  const _CustomChromePolicy(this._resolve) : super._();

  final StreamParticipantTileChromeResolver _resolve;

  @override
  StreamParticipantTileChrome resolve(
    StreamParticipantTileChromeDetails details,
  ) => _resolve(details);

  @override
  bool operator ==(Object other) =>
      other is _CustomChromePolicy && other._resolve == _resolve;

  @override
  int get hashCode => _resolve.hashCode;
}
