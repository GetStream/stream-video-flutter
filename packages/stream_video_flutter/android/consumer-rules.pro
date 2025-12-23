-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Keep the specific notification payload classes
-keep class io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationPayload { *; }
-keep class io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationOptions { *; }
-keep class io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationContent { *; }
-keep class io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationAvatar { *; }

# Keep all classes that use @Parcelize annotation
-keep @kotlinx.parcelize.Parcelize class * { *; }

