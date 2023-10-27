import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';

/// Represents the set of controls the user can use to change their audio
/// and video device state, or browse other types of settings, leave the call,
/// or implement something custom.
class StreamCallControls extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return PortraitCallControls(
      options: options,
      elevation: elevation,
      spacing: spacing,
      padding: padding,
      borderRadius: borderRadius,
    );
  }
}

/// A widget that represents call controls on desktop devices and
/// on mobile devices in portrait mode.
class PortraitCallControls extends StatelessWidget {
  /// Creates a new instance of [PortraitCallControls].
  const PortraitCallControls({
    super.key,
    required this.options,
    this.backgroundColor,
    this.elevation,
    this.spacing,
    this.padding,
    this.borderRadius,
  });

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
  Widget build(BuildContext context) {
    final theme = StreamCallControlsTheme.of(context);

    return Material(
      elevation: elevation ?? theme.elevation,
      borderRadius: borderRadius ?? theme.borderRadius,
      color: backgroundColor ?? theme.backgroundColor,
      child: SafeArea(
        child: Center(
          heightFactor: 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: padding ?? theme.padding,
            child: Row(
              children: options.insertBetween(
                SizedBox(width: spacing ?? theme.spacing),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that represents call controls on mobile devices in landscape mode.
class LandscapeCallControls extends StatelessWidget {
  /// Creates a new instance of [LandscapeCallControls].
  const LandscapeCallControls({
    super.key,
    required this.options,
    this.backgroundColor,
    this.spacing,
  });

  /// List of options to display.
  final List<Widget> options;

  /// The background color of the call controls bar.
  final Color? backgroundColor;

  /// The spacing between the call controls.
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallControlsTheme.of(context);

    return ColoredBox(
      color: backgroundColor ?? theme.backgroundColor,
      child: SafeArea(
        left: false,
        top: false,
        bottom: false,
        child: Center(
          widthFactor: 1,
          child: SingleChildScrollView(
            child: Column(
              children: options.insertBetween(
                SizedBox(height: spacing ?? theme.spacing),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
