import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

extension StreamVideoKnobs on BuildContext {
  int createParticipantCountKnob() {
    final count = knobs.slider(
      label: 'Participant Count',
      initialValue: 5,
      min: 1,
      max: 16,
      divisions: 15,
    );

    return count.toInt();
  }

  double createDoubleKnob(
    String label, {
    double min = 0,
    double max = 24,
    double initialValue = 8,
    double divisionFactor = 1,
    bool enableDivision = false,
  }) {
    final padding = knobs.slider(
      label: label,
      initialValue: initialValue,
      min: min,
      max: max,
      divisions: enableDivision
          ? (max - min) ~/ divisionFactor //
          : null,
    );

    return padding;
  }

  Alignment createAlignmentKnob(
    String label, {
    Alignment? initialAlignment,
  }) {
    final alignment = knobs.options(
      label: label,
      options: [
        const Option(label: 'Top Left', value: Alignment.topLeft),
        const Option(label: 'Top Right', value: Alignment.topRight),
        const Option(label: 'Bottom Left', value: Alignment.bottomLeft),
        const Option(label: 'Bottom Right', value: Alignment.bottomRight),
      ]..sort((a, b) {
          // Sort based on initialAlignment.
          return initialAlignment == a.value ? -1 : 1;
        }),
    );

    return alignment;
  }
}
