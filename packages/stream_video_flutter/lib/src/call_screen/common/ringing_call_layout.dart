import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../utils/display_fold.dart';

/// Arranges a ringing screen: the caller's [details] centred above the
/// [controls].
///
/// On a half-open foldable the details take the leading or top half and the
/// controls the other, so neither sits on the fold.
@internal
class RingingCallLayout extends StatelessWidget {
  /// Creates the layout of a ringing screen.
  const RingingCallLayout({
    super.key,
    required this.details,
    required this.controls,
    required this.controlsPadding,
    required this.foldGap,
  });

  /// Who is calling or being called.
  final Widget details;

  /// The buttons that answer or end the call.
  final Widget controls;

  /// The room around [controls].
  final EdgeInsetsGeometry controlsPadding;

  /// The least room between the two halves of a folded window.
  final double foldGap;

  @override
  Widget build(BuildContext context) {
    // The details scroll rather than overflow when their space is too short.
    final scrollingDetails = Center(
      child: SingleChildScrollView(child: details),
    );
    final paddedControls = Padding(padding: controlsPadding, child: controls);

    final fold = StreamDisplayFold.maybeOf(context);
    if (fold != null) {
      return SplitAtFold(
        posture: fold.posture,
        gap: foldGap,
        start: scrollingDetails,
        end: Center(child: paddedControls),
      );
    }

    return Column(
      children: [
        Expanded(child: scrollingDetails),
        paddedControls,
      ],
    );
  }
}
