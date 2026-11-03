import 'package:flutter/widgets.dart';

/// The anchor point that puts a dialog in the trailing half of a folded
/// window: the top-right corner, or the top-left in a right-to-left locale.
///
/// Without one, a dialog falls back to the leading half.
Offset trailingTopAnchor(BuildContext context) =>
    switch (Directionality.of(context)) {
      TextDirection.ltr => const Offset(double.maxFinite, 0),
      TextDirection.rtl => Offset.zero,
    };
