import 'package:flutter/material.dart' hide ConnectionState;

import '../stream_video_flutter.dart';

/// Widget that represents the default app bar that's shown in calls.
class StreamCallAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a new instance of [StreamCallAppBar].
  const StreamCallAppBar({
    super.key,
    required this.call,
    this.showBackButton = true,
    this.elevation = 1,
    this.backgroundColor,
    this.onBackPressed,
    this.onParticipantsTap,
    this.leading,
    this.title,
    this.actions,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  /// Represents a call.
  final Call call;

  /// Whether to show the leading back button.
  final bool showBackButton;

  /// The elevation for this [StreamCallAppBar].
  final double elevation;

  /// The background color for this [StreamCallAppBar].
  final Color? backgroundColor;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the participants button is tapped.
  final VoidCallback? onParticipantsTap;

  /// The leading widget to display.
  final Widget? leading;

  /// The title widget to display.
  final Widget? title;

  /// Displays the participants button by default.
  final List<Widget>? actions;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    final leadingWidget = leading ??
        (showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorTheme.textHighEmphasis,
                ),
                onPressed: onBackPressed,
              )
            : const SizedBox());

    return AppBar(
      elevation: elevation,
      leading: leadingWidget,
      backgroundColor: backgroundColor ?? theme.colorTheme.barsBg,
      centerTitle: false,
      actions: actions ??
          <Widget>[
            IconButton(
              icon: Icon(
                Icons.group_rounded,
                color: theme.colorTheme.textHighEmphasis,
              ),
              onPressed: onParticipantsTap,
            ),
          ],
      title: title ??
          Text(
            _buildTitleText(),
            style: theme.textTheme.title3Bold,
            overflow: TextOverflow.visible,
          ),
    );
  }

  String _buildTitleText() {
    final callId = call.callId;

    var connectionState = '';
    switch (call.connectionState) {
      case ConnectionState.disconnected:
        connectionState = "Disconnected";
        break;
      case ConnectionState.connecting:
        connectionState = "Connecting";
        break;
      case ConnectionState.reconnecting:
        connectionState = "reconnecting";
        break;
      case ConnectionState.connected:
        connectionState = "Connected";
        break;
    }

    return callId.isEmpty ? connectionState : "$connectionState: $callId";
  }
}
