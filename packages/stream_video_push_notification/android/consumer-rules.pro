-keep class com.fasterxml.** { *; }
-dontwarn com.fasterxml.jackson.**

-keepattributes *Annotation*

-keepclassmembers class * {
    @com.fasterxml.jackson.annotation.* <fields>;
    @com.fasterxml.jackson.annotation.* <methods>;
}

-keepclassmembers class * {
    public <init>();
}

-keep class io.getstream.video.flutter.stream_video_push_notification.** { *; }