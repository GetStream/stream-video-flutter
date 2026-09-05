import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to start/stop screen sharing
class StreamScreenShareButton extends StatelessWidget {
  /// Creates a new instance of [StreamScreenShareButton].
  const StreamScreenShareButton({
    super.key,
    required this.call,
    this.localParticipant,
    this.enabledScreenShareIcon,
    this.disabledScreenShareIcon,
    this.screenShareConstraints,
    this.screenSharingNotificationOptionsBuilder,
    this.desktopScreenSelectorBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  /// If provided this [localParticipant] will be used, otherwise the localParticipant of the [call] will be used.
  final CallParticipantState? localParticipant;

  /// The icon that is shown when the screen sharing is enabled.
  ///
  /// Defaults to `context.streamIcons.presentDesktopFill`.
  final IconData? enabledScreenShareIcon;

  /// The icon that is shown when the screen sharing is disabled.
  ///
  /// Defaults to `context.streamIcons.presentDesktopFill`.
  final IconData? disabledScreenShareIcon;

  /// Constraints for screen sharing
  final ScreenShareConstraints? screenShareConstraints;

  final NotificationOptionsBuilder? screenSharingNotificationOptionsBuilder;

  final DesktopScreenSelectorBuilder? desktopScreenSelectorBuilder;

  @override
  Widget build(BuildContext context) {
    var screenShareConstraints = this.screenShareConstraints;
    final icons = context.streamIcons;

    final defaultIcon = CurrentPlatform.isMobile
        ? icons.presentMobileFill
        : icons.presentDesktopFill;

    Widget buildContent(bool enabled) => CallFeatureButton(
      // One glyph in both states: a live screen share is marked by the
      // selected accent, not by a different picture.
      icon: Icon(
        enabled
            ? enabledScreenShareIcon ?? defaultIcon
            : disabledScreenShareIcon ?? defaultIcon,
      ),
      selected: enabled,
      onPressed: () async {
        final toggledEnabled = !enabled;

        if (CurrentPlatform.isDesktop && toggledEnabled) {
          final source =
              await (desktopScreenSelectorBuilder?.call(context) ??
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

            final serviceStarted = await StreamBackgroundService()
                .startScreenSharingNotificationService(call);

            if (!serviceStarted) {
              return;
            }
          } else {
            await StreamBackgroundService()
                .stopScreenSharingNotificationService(
                  call.callCid.value,
                );
          }
        }

        final result = await call.setScreenShareEnabled(
          enabled: toggledEnabled,
          constraints: screenShareConstraints,
        );

        if (CurrentPlatform.isAndroid && result.isFailure) {
          await StreamBackgroundService().stopScreenSharingNotificationService(
            call.callCid.value,
          );
        }
      },
    );

    if (localParticipant != null) {
      return buildContent(localParticipant!.isScreenShareEnabled);
    }

    return PartialCallStateBuilder(
      call: call,
      selector: (state) => state.localParticipant,
      builder: (_, participant) =>
          buildContent(participant?.isScreenShareEnabled ?? false),
    );
  }
}

/// ToggleScreenShareOption is [StreamScreenShareButton] now.
@Deprecated(
  'ToggleScreenShareOption is StreamScreenShareButton now, matching the rest of the '
  'call controls. Will be removed in the next major version.',
)
typedef ToggleScreenShareOption = StreamScreenShareButton;
