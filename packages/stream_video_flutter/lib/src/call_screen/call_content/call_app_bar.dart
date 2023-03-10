import 'package:flutter/material.dart' hide ConnectionState;

import '../../../stream_video_flutter.dart';
import '../../utils/extensions.dart';

/// Builder used to create a custom participants info widget.
typedef CallParticipantsInfoBuilder = Widget Function(
  BuildContext context,
  Call call,
);

/// Widget that represents the default app bar that's shown in calls.
class CallAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a new instance of [CallAppBar].
  const CallAppBar({
    super.key,
    required this.call,
    this.showBackButton = true,
    this.elevation = 1,
    this.backgroundColor,
    this.onBackPressed,
    this.onParticipantsInfoTap,
    this.onSettingsTap,
    this.participantsInfoBuilder,
    this.leading,
    this.title,
    this.actions,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  /// Represents a call.
  final Call call;

  /// Whether to show the leading back button.
  final bool showBackButton;

  /// The elevation for this [CallAppBar].
  final double elevation;

  /// The background color for this [CallAppBar].
  final Color? backgroundColor;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the participants info button is tapped.
  final VoidCallback? onParticipantsInfoTap;

  //settings callback
  final VoidCallback? onSettingsTap;

  /// Builder used to create a custom participants info screen.
  final CallParticipantsInfoBuilder? participantsInfoBuilder;

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
      backgroundColor: backgroundColor ?? theme.colorTheme.barsBg,
      centerTitle: false,
      actions: actions ??
          <Widget>[
            IconButton(
              icon: Icon(
                //vertical settings icon
                Icons.more_vert,
                color: theme.colorTheme.textHighEmphasis,
              ),
              onPressed: () => _onSettingsTap(context),
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
    final callId = callState.callCid.id;
    return '$status: $callId';
  }

  void _onSettingsTap(BuildContext context) {
    if (onSettingsTap != null) {
      onSettingsTap!();
    } else {
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          children: [
            SimpleDialogOption(
              child: IconButton(
                icon: Icon(
                  Icons.group_rounded,
                  color:
                      StreamVideoTheme.of(context).colorTheme.textHighEmphasis,
                ),
                onPressed: () => _onParticipantsInfoTap(context),
              ),
            ),
            SimpleDialogOption(
              child: IconButton(
                icon: Icon(
                  Icons.transcribe,
                  color:
                      StreamVideoTheme.of(context).colorTheme.textHighEmphasis,
                ),
                onPressed: () async {
                  print("transcribing");
                  Navigator.of(context).pop();
                  await call.startTranscription();
                  //transcribe call
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  void _onParticipantsInfoTap(BuildContext context) {
    if (onParticipantsInfoTap != null) {
      onParticipantsInfoTap!();
    } else {
      final usersProvider = StreamUsersConfiguration.of(context);

      Navigator.of(context).push(
        MaterialPageRoute<Widget>(
          builder: (context) =>
              participantsInfoBuilder?.call(context, call) ??
              StreamCallParticipantsInfoMenu(
                call: call,
                usersProvider: usersProvider,
              ),
        ),
      );
    }
  }
}
