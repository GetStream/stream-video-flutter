import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// On iOS, raises the top safe-area inset under [child] to at least [minimum].
///
/// iOS reports no inset for a rounded display corner, so on a display whose
/// status bar sits along the side the top inset is zero and an app bar runs
/// into the curve. Where the real inset is larger, nothing changes.
class MinimumTopInset extends StatelessWidget {
  /// Creates a minimum top inset over [child].
  const MinimumTopInset({super.key, this.minimum = 12, required this.child});

  /// The smallest top inset [child] sees.
  final double minimum;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.iOS) return child;

    final data = MediaQuery.of(context);
    final top = math.max(data.padding.top, minimum);
    if (top == data.padding.top) return child;

    return MediaQuery(
      data: data.copyWith(
        padding: data.padding.copyWith(top: top),
        viewPadding: data.viewPadding.copyWith(
          top: math.max(data.viewPadding.top, minimum),
        ),
      ),
      child: child,
    );
  }
}
