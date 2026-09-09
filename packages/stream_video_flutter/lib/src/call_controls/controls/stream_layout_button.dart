import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// A widget that picks how the participants of a call are laid out.
///
/// Draws the icon of the layout currently in effect. Given three or more
/// [layouts] it opens a [StreamAdaptiveMenuAnchor], so the choices are a
/// context menu on a desktop platform and a bottom sheet on Android and iOS.
/// Given fewer it toggles to the next one instead.
class StreamLayoutButton extends StatelessWidget {
  /// Creates a new instance of [StreamLayoutButton].
  const StreamLayoutButton({
    required this.onLayoutModeChanged,
    this.layout = ParticipantLayoutMode.auto,
    this.layouts = defaultLayouts,
    this.direction = StreamMenuDirection.up,
    super.key,
  });

  /// The layouts the button offers unless it is given others.
  ///
  /// Two, so the button toggles rather than opening a menu. Pass
  /// [ParticipantLayoutModeX.selectable] for every layout the SDK has.
  static const List<ParticipantLayoutMode> defaultLayouts = [
    ParticipantLayoutMode.auto,
    ParticipantLayoutMode.speakerBottom,
  ];

  /// The layout mode the button draws.
  final ParticipantLayoutMode layout;

  /// The layouts the button offers.
  ///
  /// Three or more open a menu; fewer toggle. Narrow it to keep a layout out
  /// of an app's reach — a window too narrow for a column of participants
  /// beside the speaker has no use for the left and right bar layouts.
  final List<ParticipantLayoutMode> layouts;

  /// Which way the menu is expected to open.
  ///
  /// Defaults to [StreamMenuDirection.up], for the button's usual home in a
  /// control bar along the bottom of the call. Pass [StreamMenuDirection.down]
  /// where it sits in an app bar instead. The bottom sheet ignores this, and so
  /// does a button that toggles.
  final StreamMenuDirection direction;

  /// Callback that is called when the layout mode is changed.
  ///
  /// The button holds no state of its own, so the caller is expected to pass
  /// the new mode back in through [layout].
  final void Function(ParticipantLayoutMode) onLayoutModeChanged;

  /// The layout a press moves to, or null when there is nowhere to go.
  ///
  /// The first one that isn't already in effect, so a [layout] outside
  /// [layouts] — an app driving the mode from somewhere else — lands on the
  /// first entry rather than on nothing.
  ParticipantLayoutMode? get _next =>
      layouts.where((mode) => mode.canonical != layout.canonical).firstOrNull;

  Widget _button(BuildContext context, {VoidCallback? onPressed}) =>
      CallControlButton(
        icon: Icon(layout.icon(context)),
        tooltip: context.translations.layoutSelectTooltip,
        onPressed: onPressed,
      );

  @override
  Widget build(BuildContext context) {
    if (layouts.length < 3) {
      return _button(
        context,
        onPressed: switch (_next) {
          final next? => () => onLayoutModeChanged(next),
          null => null,
        },
      );
    }

    return StreamAdaptiveMenuAnchor(
      title: context.translations.layoutMenuTitle,
      direction: direction,
      sections: [
        StreamMenuSection(
          options: [
            for (final mode in layouts)
              StreamMenuOption(
                label: mode.label(context),
                leading: Icon(mode.icon(context)),
                selected: mode.canonical == layout.canonical,
                onSelected: () => onLayoutModeChanged(mode),
              ),
          ],
        ),
      ],
      builder: (context, handle) => _button(context, onPressed: handle.toggle),
    );
  }
}

/// ToggleLayoutOption is [StreamLayoutButton] now.
@Deprecated(
  'ToggleLayoutOption is StreamLayoutButton now, matching the rest of the '
  'call controls. Will be removed in the next major version.',
)
typedef ToggleLayoutOption = StreamLayoutButton;
