import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// A select field opening a device menu.
///
/// Shared by the lobby's device fields and the device settings. Deliberately
/// not exported.
@internal
class StreamDeviceSelect extends StatelessWidget {
  /// Creates a device select.
  const StreamDeviceSelect({
    super.key,
    required this.title,
    required this.sections,
    required this.icon,
    required this.value,
    this.labelText,
    this.enabled = true,
    this.tooltip,
  });

  /// The title of the menu when it opens as a sheet.
  final String title;

  /// The menu's sections.
  final List<StreamMenuSection> sections;

  /// The icon drawn before the value.
  final IconData icon;

  /// The name of the selected device, or null for the system default.
  final String? value;

  /// A heading drawn above the field.
  final String? labelText;

  /// Whether the field can be opened.
  ///
  /// A field with nothing to pick from cannot be opened either way.
  final bool enabled;

  /// A message shown on hover, typically why the field is disabled.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    // Nothing to pick from, so the field has nothing to open.
    final noChoice = sections.hasNoOptions;

    return StreamAdaptiveMenuAnchor(
      title: title,
      sections: sections,
      // A field is a wide anchor, and a narrow popup under it reads as
      // belonging to something else.
      matchAnchorWidth: true,
      builder: (context, handle) {
        Widget field = StreamSelectInput(
          labelText: labelText,
          leading: Icon(icon),
          value: value,
          hintText: context.translations.defaultDevice,
          // True for a sheet as well as a popup, so the caret points the same
          // way on every platform.
          expanded: handle.isOpen,
          onPressed: enabled && !noChoice ? handle.toggle : null,
        );

        if (tooltip case final tooltip?) {
          field = Tooltip(message: tooltip, child: field);
        }

        return field;
      },
    );
  }
}
