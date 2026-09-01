import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class BadgedCallOption extends StatelessWidget {
  const BadgedCallOption({
    super.key,
    required this.callControlOption,
    this.badgeCount = 0,
  });

  final Widget callControlOption;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final count = badgeCount;
    if (count == null) return callControlOption;

    final colorScheme = StreamTheme.of(context).colorScheme;

    return StreamBadgeNotificationTheme(
      data: StreamBadgeNotificationThemeData(
        primaryBackgroundColor: colorScheme.accentSuccess,
      ),
      child: StreamBadgeNotification(
        label: count.toString(),
        child: callControlOption,
      ),
    );
  }
}
