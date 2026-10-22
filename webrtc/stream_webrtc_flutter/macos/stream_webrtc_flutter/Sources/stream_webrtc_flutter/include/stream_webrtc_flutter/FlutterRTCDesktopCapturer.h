#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#else
#import <FlutterMacOS/FlutterMacOS.h>
#endif
#import <Foundation/Foundation.h>
#import <StreamWebRTC/StreamWebRTC.h>

#import "FlutterWebRTCPlugin.h"

@interface FlutterWebRTCPlugin (DesktopCapturer)

- (void)getDisplayMedia:(nonnull NSDictionary*)constraints
              factoryId:(nullable NSString*)factoryId
                 result:(nonnull FlutterResult)result;

- (void)getDesktopSources:(nonnull NSDictionary*)argsMap result:(nonnull FlutterResult)result;

- (void)updateDesktopSources:(nonnull NSDictionary*)argsMap result:(nonnull FlutterResult)result;

- (void)getDesktopSourceThumbnail:(nonnull NSDictionary*)argsMap
                           result:(nonnull FlutterResult)result;

@end