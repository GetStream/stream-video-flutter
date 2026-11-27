# These rules land in every app that depends on this package, so they keep nothing beyond what the
# package needs: its own classes, and the names of the parts of Jackson it reaches.

-keep class io.getstream.video.flutter.stream_video_push_notification.** { *; }

# PrefsCallStore reads its JSON through a TypeReference, which needs the generic signature of its
# anonymous subclass, kept above.
-keepattributes Signature,InnerClasses,EnclosingMethod

# Jackson only serializes plain lists and maps here, no annotated classes, so R8 can drop what is
# not reached. Keep the names of what is left, which Jackson looks some up by, and stay quiet about
# the optional JDK types it refers to.
-keepnames class com.fasterxml.jackson.** { *; }
-dontwarn com.fasterxml.jackson.**
