import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// The size of the navigation buttons' visual: [StreamButton]'s default.
const participantsNavigationButtonSize = StreamButtonSize.medium;

/// How far the button's tap target reaches past its visual, on each side.
///
/// The button's box is [kMinInteractiveDimension], with the visual centred
/// inside it. A layout positioning the button to the design takes this off
/// its own inset.
final participantsNavigationButtonTapInset =
    (kMinInteractiveDimension - participantsNavigationButtonSize.value) / 2;

/// A chevron on an elevated circle that moves the participants bar or grid
/// along.
///
/// While [visible] is false the button is scaled away, keeping its place in
/// the layout, and can neither be tapped nor read out.
class ParticipantsNavigationButton extends StatelessWidget {
  const ParticipantsNavigationButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.visible = true,
    this.onPressed,
  });

  /// The chevron the button carries.
  final IconData icon;

  /// Names the button for a screen reader, and on hover.
  final String tooltip;

  /// Whether the button is shown.
  final bool visible;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // A zero transform cannot be inverted, so a scaled-away button also drops
    // out of the hit test.
    return ExcludeSemantics(
      excluding: !visible,
      child: AnimatedScale(
        scale: visible ? 1 : 0,
        duration: kThemeAnimationDuration,
        child: StreamButton.icon(
          icon: Icon(icon),
          style: .secondary,
          type: .ghost,
          isFloating: true,
          tooltip: tooltip,
          onPressed: onPressed,
          themeStyle: StreamButtonThemeStyle(iconSize: .all(16)),
        ),
      ),
    );
  }
}
