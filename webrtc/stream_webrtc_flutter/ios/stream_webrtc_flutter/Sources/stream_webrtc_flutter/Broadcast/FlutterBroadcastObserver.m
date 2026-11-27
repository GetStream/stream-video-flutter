#import "FlutterBroadcastObserver.h"

#import "../include/stream_webrtc_flutter/FlutterWebRTCPlugin.h"

// Shared with stream_video_screen_sharing's BroadcastSampleHandler. The
// extension cannot link this plugin, so each side keeps its own copy of the names.
static NSString* const kBroadcastStartedNotification =
    @"io.getstream.video.screen_sharing.broadcastStarted";
static NSString* const kBroadcastStoppedNotification =
    @"io.getstream.video.screen_sharing.broadcastStopped";
static NSString* const kBroadcastStopRequestedNotification =
    @"io.getstream.video.screen_sharing.broadcastStopRequested";

static void FlutterBroadcastNotificationCallback(CFNotificationCenterRef center,
                                                 void* observer,
                                                 CFNotificationName name,
                                                 const void* object,
                                                 CFDictionaryRef userInfo) {
  NSString* notification = (__bridge NSString*)name;
  NSString* event = nil;
  if ([notification isEqualToString:kBroadcastStartedNotification]) {
    event = @"screenSharingStarted";
  } else if ([notification isEqualToString:kBroadcastStoppedNotification]) {
    event = @"screenSharingStopped";
  }
  if (event == nil) {
    return;
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [[FlutterWebRTCPlugin sharedSingleton] postEventWithName:event data:nil];
  });
}

@implementation FlutterBroadcastObserver

+ (void)startObserving {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
    for (NSString* name in @[ kBroadcastStartedNotification, kBroadcastStoppedNotification ]) {
      CFNotificationCenterAddObserver(center, (__bridge const void*)self,
                                      FlutterBroadcastNotificationCallback,
                                      (__bridge CFStringRef)name, NULL,
                                      CFNotificationSuspensionBehaviorDeliverImmediately);
    }
  });
}

+ (void)requestStop {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       (__bridge CFStringRef)kBroadcastStopRequestedNotification,
                                       NULL, NULL, true);
}

@end
