import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to start/stop screen sharing
class ToggleScreenShareOption extends StatelessWidget {
  /// Creates a new instance of [ToggleScreenShareOption].
  const ToggleScreenShareOption({
    super.key,
    required this.call,
    required this.localParticipant,
    this.enabledScreenShareIcon = Icons.screen_share,
    this.disabledScreenShareIcon = Icons.stop_screen_share,
    this.screenShareConstraints,
    this.screenSharingNotificationOptionsBuilder,
    this.enabledScreenShareIconColor,
    this.disabledScreenShareIconColor,
    this.enabledScreenShareBackgroundColor,
    this.disabledScreenShareBackgroundColor,
    this.desktopScreenSelectorBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  final CallParticipantState localParticipant;

  /// The icon that is shown when the screen sharing is enabled.
  final IconData enabledScreenShareIcon;

  /// The icon that is shown when the screen sharing is disabled.
  final IconData disabledScreenShareIcon;

  /// Color of the icon when screen sharing is enabled
  final Color? enabledScreenShareIconColor;

  /// Color of the icon when screen sharing is disabled
  final Color? disabledScreenShareIconColor;

  /// Color of the background when screen sharing is enabled
  final Color? enabledScreenShareBackgroundColor;

  /// Color of the background when screen sharing is disabled
  final Color? disabledScreenShareBackgroundColor;

  /// Constraints for screen sharing
  final ScreenShareConstraints? screenShareConstraints;

  final NotificationOptionsBuilder? screenSharingNotificationOptionsBuilder;

  final DesktopScreenSelectorBuilder? desktopScreenSelectorBuilder;

  @override
  Widget build(BuildContext context) {
    final enabled = localParticipant.isScreenShareEnabled;
    var screenShareConstraints = this.screenShareConstraints;

    return CallControlOption(
      icon: enabled
          ? Icon(enabledScreenShareIcon)
          : Icon(disabledScreenShareIcon),
      iconColor:
          enabled ? enabledScreenShareIconColor : disabledScreenShareIconColor,
      backgroundColor: enabled
          ? enabledScreenShareBackgroundColor
          : disabledScreenShareBackgroundColor,
      onPressed: () async {
        final toggledEnabled = !enabled;

        if (CurrentPlatform.isDesktop && toggledEnabled) {
          final source = await (desktopScreenSelectorBuilder?.call(context) ??
              showDefaultScreenSelectionDialog(context));

          if (source != null) {
            screenShareConstraints =
                (screenShareConstraints ?? const ScreenShareConstraints())
                    .copyWith(deviceId: source.id);
          } else {
            return;
          }
        }

        if (CurrentPlatform.isAndroid) {
          if (toggledEnabled) {
            if (!await call.requestScreenSharePermission()) {
              return;
            }

            await StreamBackgroundService()
                .startScreenSharingNotificationService(call);
          } else {
            await StreamBackgroundService()
                .stopScreenSharingNotificationService(call.callCid.value);
          }
        }

        final result = await call.setScreenShareEnabled(
          enabled: toggledEnabled,
          constraints: screenShareConstraints,
        );

        if (CurrentPlatform.isAndroid && result.isFailure) {
          await StreamBackgroundService()
              .stopScreenSharingNotificationService(call.callCid.value);
        }
      },
    );
  }
}
