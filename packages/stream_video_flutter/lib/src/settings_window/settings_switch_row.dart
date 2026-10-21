import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// A setting that is turned on and off: a title over a description, with a
/// switch at the trailing edge.
///
/// Shared by the settings tabs. Deliberately not exported.
@internal
class StreamSettingsSwitchRow extends StatelessWidget {
  /// Creates a switch row.
  const StreamSettingsSwitchRow({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  /// What the switch turns on.
  final String title;

  /// What turning it on does.
  final String description;

  /// Whether the setting is on.
  final bool value;

  /// Called with the new value when the switch is flipped.
  ///
  /// When null, the switch is disabled.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.streamSpacing.md,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: context.streamSpacing.xxs,
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
          ),
          StreamSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
