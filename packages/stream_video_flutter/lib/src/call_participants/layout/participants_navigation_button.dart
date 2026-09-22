import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// The size the navigation buttons take, which is [StreamButton]'s own default.
const participantsNavigationButtonSize = StreamButtonSize.medium;

/// How far the button's tap target reaches past its visual, on each side.
///
/// The button's box is [kMinInteractiveDimension] so that a finger has
/// something to land on, while the design places the visual inside it. A
/// layout positioning the button to the design takes this off its own inset.
final participantsNavigationButtonTapInset =
    (kMinInteractiveDimension - participantsNavigationButtonSize.value) / 2;

/// A round floating button that moves a participant layout along.
///
/// The participants bar scrolls by one and the grid pages by one, but both
/// draw the same button: a chevron on an elevated circle, sitting over the
/// layout it moves.
///
/// [tooltip] names the button for a screen reader as well as on hover: the
/// chevron is all there is to go on otherwise.
class ParticipantsNavigationButton extends StatelessWidget {
  const ParticipantsNavigationButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  /// The chevron the button carries.
  final IconData icon;

  /// Names the button for a screen reader, and on hover.
  final String tooltip;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamButton.icon(
      icon: Icon(icon),
      style: .secondary,
      type: .ghost,
      isFloating: true,
      tooltip: tooltip,
      onPressed: onPressed,
      themeStyle: StreamButtonThemeStyle(iconSize: .all(16)),
    );
  }
}
