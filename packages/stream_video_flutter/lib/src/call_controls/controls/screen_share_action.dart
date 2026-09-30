import 'package:flutter/widgets.dart';

import '../../../stream_video_flutter.dart';

/// Starts or stops screen sharing, with the platform steps around it.
///
/// Turning sharing on is not one call on every platform: desktop has to be
/// asked which screen to share, and Android needs the user's permission and a
/// foreground service before the track exists — and that service has to come
/// back down again if publishing then fails. Shared by
/// [StreamScreenShareButton] and by any control that offers the same action
/// some other way, such as a row in an overflow menu.
///
/// Returns without doing anything when the user dismisses the desktop picker,
/// denies the Android permission, or the foreground service will not start.
Future<void> toggleScreenShare(
  BuildContext context, {
  required Call call,
  required bool enabled,
  ScreenShareConstraints? constraints,
  DesktopScreenSelectorBuilder? desktopScreenSelectorBuilder,
}) async {
  var shareConstraints = constraints;

  if (CurrentPlatform.isDesktop && enabled) {
    final source =
        await (desktopScreenSelectorBuilder?.call(context) ??
            showDefaultScreenSelectionDialog(context));

    if (source == null) return;

    shareConstraints = (shareConstraints ?? const ScreenShareConstraints())
        .copyWith(deviceId: source.id);
  }

  if (CurrentPlatform.isAndroid) {
    if (enabled) {
      if (!await call.requestScreenSharePermission()) return;

      final serviceStarted = await StreamBackgroundService()
          .startScreenSharingNotificationService(call);

      if (!serviceStarted) return;
    } else {
      await StreamBackgroundService().stopScreenSharingNotificationService(
        call.callCid.value,
      );
    }
  }

  final result = await call.setScreenShareEnabled(
    enabled: enabled,
    constraints: shareConstraints,
  );

  if (CurrentPlatform.isAndroid && result.isFailure) {
    await StreamBackgroundService().stopScreenSharingNotificationService(
      call.callCid.value,
    );
  }
}
