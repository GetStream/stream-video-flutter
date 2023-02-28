import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';

/// Represents the set of controls the user can use to change their audio
/// and video device state, or browse other types of settings, leave the call,
/// or implement something custom.
class StreamCallControls extends StatefulWidget {
  /// Creates a new instance of [StreamCallControls].
  const StreamCallControls({
    super.key,
    required this.options,
    this.backgroundColor,
    this.elevation,
    this.spacing,
    this.padding,
    this.borderRadius,
  });

  /// Builds a call controls bar with the default set of call control options.
  factory StreamCallControls.withDefaultOptions({
    required Call call,
    required CallParticipantState localParticipant,
    VoidCallback? onLeaveCallTap,
    Color? backgroundColor,
    double? elevation,
    double? spacing,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) {
    return StreamCallControls(
      options: defaultCallControlOptions(
        call: call,
        localParticipant: localParticipant,
        onLeaveCallTap: onLeaveCallTap,
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      spacing: spacing,
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  /// List of options to display.
  final List<Widget> options;

  /// The background color of the call controls bar.
  final Color? backgroundColor;

  /// The elevation of the call controls bar.
  final double? elevation;

  /// The spacing between the call controls.
  final double? spacing;

  /// The padding applied to the call controls bar.
  final EdgeInsets? padding;

  /// The border radius of the call controls bar.
  final BorderRadius? borderRadius;

  @override
  State<StreamCallControls> createState() => _StreamCallControlsState();
}

class _StreamCallControlsState extends State<StreamCallControls> {
  @override
  Widget build(BuildContext context) {
    final theme = StreamCallControlsTheme.of(context);

    Widget callControlOptions = SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.options.insertBetween(
          // Spacing between the buttons.
          SizedBox(width: widget.spacing ?? theme.spacing),
        ),
      ),
    );

    if (widget.options.length > 5) {
      callControlOptions = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: widget.padding ?? theme.padding,
        child: callControlOptions,
      );
    } else {
      callControlOptions = Padding(
        padding: widget.padding ?? theme.padding,
        child: callControlOptions,
      );
    }

    return Material(
      elevation: widget.elevation ?? theme.elevation,
      borderRadius: widget.borderRadius ?? theme.borderRadius,
      color: widget.backgroundColor ?? theme.backgroundColor,
      child: callControlOptions,
    );
  }
}
