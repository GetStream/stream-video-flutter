import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';

/// A widget that represents a semi-transparent toolbar that is displayed
/// over the [StreamCallParticipants] widget on mobile devices in landscape
/// mode.
class OverlayAppBar extends StatelessWidget {
  /// Creates a new instance of [OverlayAppBar].
  const OverlayAppBar({
    super.key,
    required this.call,
    this.showBackButton,
    this.backgroundColor,
    this.onBackPressed,
    this.onParticipantsInfoTap,
    this.participantsInfoBuilder,
  });

  /// Represents a call.
  final Call call;

  /// Whether to show the leading back button.
  final bool? showBackButton;

  /// The background color for this [CallAppBar].
  final Color? backgroundColor;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the participants info button is tapped.
  final VoidCallback? onParticipantsInfoTap;

  /// Builder used to create a custom participants info screen.
  final CallParticipantsInfoBuilder? participantsInfoBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    return ColoredBox(
      color: backgroundColor ?? theme.colorTheme.overlay,
      child: SafeArea(
        right: false,
        bottom: false,
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (showBackButton ?? true)
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (onBackPressed != null) {
                        onBackPressed!();
                      } else {
                        Navigator.maybePop(context);
                      }
                    },
                  )
                else
                  const SizedBox(),
                Expanded(
                  child: Text(
                    _getAppBarTitle(),
                    style: theme.textTheme.title3Bold.copyWith(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.group_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => _onParticipantsInfoTap(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    final callState = call.state.value;

    final screenShareParticipant = callState.callParticipants.firstWhereOrNull(
      (element) => element.screenShareTrack != null,
    );

    if (screenShareParticipant != null) {
      final participantName = screenShareParticipant.name.isNotEmpty
          ? screenShareParticipant.name
          : screenShareParticipant.userId;
      return '$participantName presenting';
    } else {
      final status = callState.status.toStatusString();
      final callId = callState.callCid.id;

      return '$status: $callId';
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
