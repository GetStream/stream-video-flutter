#import "StreamVideoPushNotificationPlugin.h"
#if __has_include(<stream_video_push_notification/stream_video_push_notification-Swift.h>)
#import <stream_video_push_notification/stream_video_push_notification-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "stream_video_push_notification-Swift.h"
#endif

@implementation StreamVideoPushNotificationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStreamVideoPushNotificationPlugin registerWithRegistrar:registrar];
}
@end
