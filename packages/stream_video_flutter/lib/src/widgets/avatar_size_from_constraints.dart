import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// The design-system avatar diameter that covers [constraints].
///
/// The deprecated themes size an avatar with box constraints; the design system
/// has a fixed set of diameters. Round up to the first one that fits, so an
/// avatar never comes out smaller than it was asked to be.
///
/// Constraints wider than the largest diameter land on that one instead: there
/// is nothing bigger to round up to, so a legacy theme asking for 200px gets
/// the largest diameter the design system has.
@internal
StreamAvatarSize avatarSizeFromConstraints(BoxConstraints constraints) {
  final diameter = constraints.constrain(Size.infinite).shortestSide;
  final largest = StreamAvatarSize.values.last;

  // Rounding up is the promise above, and this is the one case it cannot keep:
  // an app whose avatars quietly got smaller during the migration finds out
  // from a debug log rather than from a screenshot. Unbounded constraints land
  // here too, where the largest diameter is the only sensible answer.
  assert(() {
    if (diameter.isFinite && diameter > largest.value) {
      debugPrint(
        'StreamUserAvatar: a deprecated theme asked for ${diameter}px, which '
        'is larger than the biggest design-system avatar '
        '(${largest.value}px); it will be drawn at that size.',
      );
    }
    return true;
  }());

  return StreamAvatarSize.values.firstWhere(
    (it) => it.value >= diameter,
    orElse: () => largest,
  );
}
