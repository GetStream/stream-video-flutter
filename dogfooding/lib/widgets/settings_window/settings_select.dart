import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// One choice of a [SettingsSelect].
class SettingsChoice<T> {
  const SettingsChoice({required this.value, required this.label, this.icon});

  final T value;
  final String label;

  /// Drawn before the label in the menu.
  final IconData? icon;
}

/// A setting picked from a list: a heading over a description, then a select
/// opening a menu of [choices].
///
/// Laid out as the design's language tab, and shared by the tabs that look
/// the same.
class SettingsSelect<T> extends StatelessWidget {
  const SettingsSelect({
    required this.title,
    required this.description,
    required this.icon,
    required this.choices,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String description;

  /// Drawn before the value in the field.
  final IconData icon;

  final List<SettingsChoice<T>> choices;

  /// The value picked; the field is empty where no choice has it.
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;
    final selected = choices.firstWhereOrNull((it) => it.value == value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing.xs,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing.xxs,
          children: [
            Text(
              title,
              style: textTheme.headingXs.copyWith(
                color: colorScheme.textPrimary,
              ),
            ),
            Text(
              description,
              style: textTheme.metadataDefault.copyWith(
                color: colorScheme.textTertiary,
              ),
            ),
          ],
        ),
        StreamAdaptiveMenuAnchor(
          title: title,
          matchAnchorWidth: true,
          sections: [
            StreamMenuSection(
              options: [
                for (final choice in choices)
                  StreamMenuOption(
                    label: choice.label,
                    leading: switch (choice.icon) {
                      final icon? => Icon(icon),
                      null => null,
                    },
                    selected: choice.value == value,
                    onSelected: () => onChanged(choice.value),
                  ),
              ],
            ),
          ],
          builder: (context, handle) => StreamSelectInput(
            leading: Icon(icon),
            value: selected?.label,
            expanded: handle.isOpen,
            onPressed: handle.toggle,
          ),
        ),
      ],
    );
  }
}
