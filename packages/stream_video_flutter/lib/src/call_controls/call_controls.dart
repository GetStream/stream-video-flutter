import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';
import 'controls/default_control_options.dart';

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
    required VoidCallback onLeaveCall,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? elevation,
    EdgeInsets? padding,
    double? spacing,
  }) {
    return StreamCallControls(
      backgroundColor: backgroundColor,
      elevation: elevation,
      padding: padding,
      spacing: spacing,
      borderRadius: borderRadius,
      options: defaultCallControlOptions(
        call: call,
        localParticipant: localParticipant,
        onLeaveCall: onLeaveCall,
      ),
    );
  }

  /// List of options to display.
  final List<Widget> options;

  /// Color of the background of the bar.
  final Color? backgroundColor;

  /// Elevation effect of the bar. This changes the top shadow in the Widget.
  final double? elevation;

  /// Spacing between the buttons.
  final double? spacing;

  /// Paging of the container Widget. You can use to increase/decrease the
  /// padding of the bar and its inner buttons.
  final EdgeInsets? padding;

  /// Style of borders of container bar.
  final BorderRadius? borderRadius;

  @override
  State<StreamCallControls> createState() => _StreamCallControlsState();
}

class _StreamCallControlsState extends State<StreamCallControls> {
  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final theme = streamVideoTheme.callControlsBarTheme;

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
