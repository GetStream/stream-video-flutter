import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';

export 'controls/controls.dart';

/// Model class for the call control option.
class CallControlOption extends StatelessWidget {
  /// Creates a new instance of [CallControlOption].
  const CallControlOption({
    super.key,
    required this.icon,
    this.iconColor,
    this.elevation,
    this.backgroundColor,
    this.shape,
    this.padding,
    this.onPressed,
  });

  /// The icon of the option.
  final Widget icon;

  /// The color of the icon.
  final Color? iconColor;

  final double? elevation;

  final Color? backgroundColor;

  final OutlinedBorder? shape;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final barTheme = theme.callControlsBarTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? barTheme.optionElevation,
        backgroundColor: backgroundColor ?? barTheme.optionBackgroundColor,
        shape: shape ?? barTheme.optionShape,
        padding: padding ?? barTheme.optionPadding,
      ),
      onPressed: onPressed,
      child: IconTheme.merge(
        data: IconThemeData(color: iconColor ?? barTheme.optionIconColor),
        child: icon,
      ),
    );
  }
}

class CallControlToggleOption extends StatelessWidget {
  const CallControlToggleOption({
    super.key,
    required this.icon,
    this.iconColor,
    this.inactiveIconColor,
    this.elevation,
    this.inactiveElevation,
    this.backgroundColor,
    this.inactiveBackgroundColor,
    this.shape,
    this.padding,
    required this.value,
    required this.onChanged,
  });

  /// The icon of the option.
  final Widget icon;

  /// The color of the icon.
  final Color? iconColor;
  final Color? inactiveIconColor;

  final double? elevation;
  final double? inactiveElevation;

  final Color? backgroundColor;
  final Color? inactiveBackgroundColor;

  final OutlinedBorder? shape;

  final EdgeInsetsGeometry? padding;

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final barTheme = theme.callControlsBarTheme;

    final active = value == true;
    final iconColor = this.iconColor ??
        (active ? barTheme.optionIconColor : barTheme.inactiveOptionIconColor);
    final elevation = this.elevation ??
        (active ? barTheme.optionElevation : barTheme.inactiveOptionElevation);
    final backgroundColor = this.backgroundColor ??
        (active
            ? barTheme.optionBackgroundColor
            : barTheme.inactiveOptionBackgroundColor);

    return CallControlOption(
      icon: icon,
      iconColor: iconColor,
      elevation: elevation,
      backgroundColor: backgroundColor,
      shape: shape,
      padding: padding,
      onPressed: () => onChanged(!value),
    );
  }
}

/// Widget which takes a list of [CallControlOption] such as microphone, video,
/// switch camera, disconnect etc and displays them in a Wrap.
class StreamCallControlsBar extends StatefulWidget {
  const StreamCallControlsBar({
    super.key,
    required this.options,
    this.backgroundColor,
    this.elevation,
    this.spacing,
    this.padding,
    this.borderRadius,
  });

  factory StreamCallControlsBar.withDefaultOptions({
    required Call call,
    required VoidCallback onHangup,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? elevation,
    EdgeInsets? padding,
    double? spacing,
  }) {
    return StreamCallControlsBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      padding: padding,
      spacing: spacing,
      borderRadius: borderRadius,
      options: defaultCallControlOptions(
        call: call,
        onHangup: onHangup,
      ),
    );
  }

  final List<Widget> options;

  /// Style of borders of container bar.
  final BorderRadius? borderRadius;

  /// Color of the background of the bar.
  final Color? backgroundColor;

  /// Elevation effect of the bar. This changes the top shadow in the Widget.
  final double? elevation;

  ///Paging of the container Widget. You can use to increase/decrease the padding
  ///of the bar and its inner buttons.
  final EdgeInsets? padding;

  final double? spacing;

  @override
  State<StreamCallControlsBar> createState() => _StreamCallControlsBarState();
}

class _StreamCallControlsBarState extends State<StreamCallControlsBar> {
  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final barTheme = theme.callControlsBarTheme;

    Widget callControlOptions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.options.insertBetween(
        // Spacing between the buttons.
        SizedBox(width: widget.spacing ?? barTheme.spacing),
      ),
    );

    if (widget.options.length > 5) {
      callControlOptions = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: widget.padding ?? barTheme.padding,
        child: callControlOptions,
      );
    } else {
      callControlOptions = Padding(
        padding: widget.padding ?? barTheme.padding,
        child: callControlOptions,
      );
    }

    return Material(
      elevation: widget.elevation ?? barTheme.elevation,
      borderRadius: widget.borderRadius ?? barTheme.borderRadius,
      color: widget.backgroundColor ?? barTheme.backgroundColor,
      child: callControlOptions,
    );
  }
}
