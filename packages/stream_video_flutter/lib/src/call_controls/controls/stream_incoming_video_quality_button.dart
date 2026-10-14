import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// Shows the quality other participants' video is received at, and opens a
/// menu to pick another.
///
/// Follows [call]'s [IncomingVideoQuality], so it stays in step with anything
/// else that sets it, such as [StreamDeviceSettings].
class StreamIncomingVideoQualityButton extends StatefulWidget {
  /// Creates an incoming video quality button.
  const StreamIncomingVideoQualityButton({
    super.key,
    required this.call,
    this.menuDirection = StreamMenuDirection.down,
  });

  /// The call whose incoming video quality is shown and set.
  final Call call;

  /// Which way the menu opens. A button along the bottom of the screen opens
  /// it upwards.
  final StreamMenuDirection menuDirection;

  @override
  State<StreamIncomingVideoQualityButton> createState() =>
      _StreamIncomingVideoQualityButtonState();
}

class _StreamIncomingVideoQualityButtonState
    extends State<StreamIncomingVideoQualityButton> {
  late Stream<IncomingVideoQuality> _quality =
      widget.call.incomingVideoQualityStream;

  @override
  void didUpdateWidget(StreamIncomingVideoQualityButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.call != widget.call) {
      _quality = widget.call.incomingVideoQualityStream;
    }
  }

  IconData _caret(BuildContext context, {required bool isOpen}) {
    final icons = context.streamIcons;
    // Points where the menu will appear, and back at the button while it is
    // open.
    return switch ((widget.menuDirection, isOpen)) {
      (StreamMenuDirection.down, false) => icons.caretDown,
      (StreamMenuDirection.down, true) => icons.caretUp,
      (StreamMenuDirection.up, false) => icons.caretUp,
      (StreamMenuDirection.up, true) => icons.caretDown,
    };
  }

  @override
  Widget build(BuildContext context) {
    final call = widget.call;
    final translations = context.translations;

    return StreamBuilder<IncomingVideoQuality>(
      stream: _quality,
      initialData: call.incomingVideoQuality,
      builder: (context, snapshot) {
        final quality = snapshot.data ?? IncomingVideoQuality.auto;

        return StreamAdaptiveMenuAnchor(
          title: translations.deviceSettingsIncomingVideoQuality,
          direction: widget.menuDirection,
          sections: [
            StreamMenuSection(
              options: [
                for (final value in IncomingVideoQuality.values)
                  StreamMenuOption(
                    label: value.label(context),
                    selected: value == quality,
                    onSelected: () => call.setIncomingVideoQuality(value),
                  ),
              ],
            ),
          ],
          builder: (context, handle) => Tooltip(
            message: translations.deviceSettingsIncomingVideoQuality,
            child: StreamButton(
              style: StreamButtonStyle.secondary,
              iconLeft: Icon(context.streamIcons.slidersFill),
              iconRight: Icon(_caret(context, isOpen: handle.isOpen)),
              isSelected: handle.isOpen,
              onPressed: handle.toggle,
              child: Text(quality.shortLabel(context)),
            ),
          ),
        );
      },
    );
  }
}
