// ignore_for_file: unused_local_variable

import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

void main() {
  // Initialize StreamVideo with push notification support
  final client = StreamVideo(
    'your-api-key',
    user: User.regular(userId: 'user-id'),
    userToken: 'your-user-token',
    pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(
        name: 'your-apn-provider-name',
      ),
      androidPushProvider: const StreamVideoPushProvider.firebase(
        name: 'your-firebase-provider-name',
      ),
    ),
  );
}
