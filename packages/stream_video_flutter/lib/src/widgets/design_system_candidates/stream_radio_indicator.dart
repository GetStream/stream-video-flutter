import 'package:flutter/material.dart';
import 'package:stream_core_flutter/core.dart';

/// A non-interactive radio button, marking the selected entry of a group.
///
/// Mirrors the `Radio Button` component from the design: a 16px circle that is
/// filled with a white dot when selected, and outlined when it is not.
///
/// stream_core_flutter has no radio component yet. [StreamCheckbox.circular]
/// is the closest one, but it is the *radio check* variant of the design
/// system: a 20px circle with a checkmark rather than a dot, and it owns its
/// own tap target, which a row-selected menu item does not want.
///
/// This is a design-system candidate: it lives in this SDK until the
/// component is finalized and can graduate to stream_core_flutter.
class StreamRadioIndicator extends StatelessWidget {
  /// Creates a radio indicator.
  const StreamRadioIndicator({super.key, required this.selected});

  /// Whether the entry this indicator belongs to is the selected one.
  final bool selected;

  static const _size = 16.0;
  static const _indicatorSize = 8.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colorScheme.accentPrimary : null,
        border: selected ? null : Border.all(color: colorScheme.borderDefault),
      ),
      child: selected
          ? Center(
              child: Container(
                width: _indicatorSize,
                height: _indicatorSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.textOnAccent,
                ),
              ),
            )
          : null,
    );
  }
}
