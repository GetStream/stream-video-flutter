import 'package:flutter/material.dart' hide ConnectionState;

import '../../../stream_video_flutter.dart';
import '../../utils/extensions.dart';

/// Widget that represents the default app bar that's shown in calls.
class CallAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a new instance of [CallAppBar].
  const CallAppBar({
    super.key,
    required this.call,
    this.showBackButton = true,
    this.showLeaveCallAction = true,
    this.elevation = 1,
    this.backgroundColor,
    this.onBackPressed,
    this.leading,
    this.leadingWidth,
    this.title,
    this.actions,
  });

  /// Represents a call.
  final Call call;

  /// Whether to show the leading back button.
  final bool showBackButton;

  /// Whether to show the leave call action button.
  final bool showLeaveCallAction;

  /// The elevation for this [CallAppBar].
  final double elevation;

  /// The background color for this [CallAppBar].
  final Color? backgroundColor;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The leading widget to display.
  final Widget? leading;

  /// The width of the leading widget.
  final double? leadingWidth;

  /// The title widget to display.
  final Widget? title;

  /// Displays the participants button by default.
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
                onPressed: () {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
              )
            : const SizedBox());

    return AppBar(
      elevation: elevation,
      leading: leadingWidget,
      leadingWidth: leadingWidth,
      backgroundColor: backgroundColor ?? theme.colorTheme.barsBg,
      centerTitle: true,
      actions: actions ??
          <Widget>[
            if (showLeaveCallAction)
              Transform.scale(
                scale: 0.8,
                child: LeaveCallOption(call: call),
              ),
          ],
      title: title ??
          Text(
            _getTitleText(),
            style: theme.textTheme.title3Bold,
            overflow: TextOverflow.visible,
          ),
    );
  }

  String _getTitleText() {
    final callState = call.state.value;

    final status = callState.status.toStatusString();
    return status;
  }
}
