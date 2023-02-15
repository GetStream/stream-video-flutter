#import "StreamVideoFlutterBackgroundPlugin.h"
#if __has_include(<stream_video_flutter_background/stream_video_flutter_background-Swift.h>)
#import <stream_video_flutter_background/stream_video_flutter_background-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "stream_video_flutter_background-Swift.h"
#endif

@implementation StreamVideoFlutterBackgroundPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStreamVideoFlutterBackgroundPlugin registerWithRegistrar:registrar];
}
@end
