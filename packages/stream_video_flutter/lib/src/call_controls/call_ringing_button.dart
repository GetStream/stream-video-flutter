import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// The oversized round button a ringing screen is built on: answering,
/// declining, and hanging up a call that has not been picked up yet.
///
/// It is the same button as [CallControlButton] — same tones, same colours —
/// drawn at the size the ringing designs give it, which no [StreamButtonSize]
/// names. Use [CallControlButton] for the controls that sit alongside it, and
/// anywhere inside a call.
///
/// {@tool snippet}
///
/// ```dart
/// CallRingingButton(
///   icon: Icon(context.streamIcons.phoneFill),
///   tone: .positive,
///   label: 'Accept',
///   onPressed: call.accept,
/// )
/// ```
/// {@end-tool}
class CallRingingButton extends StatelessWidget {
  /// Creates a new instance of [CallRingingButton].
  const CallRingingButton({
    super.key,
    required this.icon,
    required this.tone,
    this.label,
    this.labelStyle,
    this.onPressed,
    this.tooltip,
  });

  /// The diameter of the button.
  ///
  /// Already well past the minimum tap target, which is why the button drops
  /// the padding Material would otherwise add around it.
  static const double diameter = 64;

  /// The size of the icon the button carries.
  static const double iconSize = 32;

  /// The icon of the button.
  final Widget icon;

  /// What pressing this button means.
  final CallControlTone tone;

  /// The text under the button, or null to leave it unlabelled.
  final String? label;

  /// The style of [label].
  ///
  /// Defaults to `textTheme.captionEmphasis` in `colorScheme.textSecondary`,
  /// which is text on a surface. A button placed on top of video or an image
  /// needs a color that reads there instead.
  final TextStyle? labelStyle;

  /// The callback to invoke when the user taps on the button.
  ///
  /// Null renders the button disabled.
  final VoidCallback? onPressed;

  /// The message shown when the button is long-pressed or hovered.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = CallControlButton(
      icon: icon,
      tone: tone,
      onPressed: onPressed,
      tooltip: tooltip,
      themeStyle: StreamButtonThemeStyle.from(
        fixedSize: const Size.square(diameter),
        minimumSize: const Size.square(diameter),
        iconSize: iconSize,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    if (label case final label?) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
          SizedBox(height: context.streamSpacing.sm),
          Text(
            label,
            textAlign: TextAlign.center,
            style:
                labelStyle ??
                context.streamTextTheme.captionEmphasis.copyWith(
                  color: context.streamColorScheme.textSecondary,
                ),
          ),
        ],
      );
    }

    return button;
  }
}
