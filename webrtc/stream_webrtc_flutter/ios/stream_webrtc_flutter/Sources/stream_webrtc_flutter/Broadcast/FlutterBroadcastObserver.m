#import "FlutterBroadcastObserver.h"

#import "../include/stream_webrtc_flutter/FlutterWebRTCPlugin.h"

static NSString* const kBroadcastStartedNotification =
    @"io.getstream.video.screen_sharing.broadcastStarted";
static NSString* const kBroadcastStoppedNotification =
    @"io.getstream.video.screen_sharing.broadcastStopped";

/** Whether the extension is broadcasting. Read and written on the main queue. */
static BOOL sBroadcastActive = NO;

/** Whether a stop was posted while no Dart listener was attached. Main queue. */
static BOOL sStopMissed = NO;

static void FlutterBroadcastNotificationCallback(CFNotificationCenterRef center,
                                                 void* observer,
                                                 CFNotificationName name,
                                                 const void* object,
                                                 CFDictionaryRef userInfo) {
  NSString* notification = (__bridge NSString*)name;
  BOOL started = [notification isEqualToString:kBroadcastStartedNotification];
  BOOL stopped = [notification isEqualToString:kBroadcastStoppedNotification];
  if (!started && !stopped) {
    return;
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    sBroadcastActive = started;
    FlutterWebRTCPlugin* plugin = [FlutterWebRTCPlugin sharedSingleton];
    sStopMissed = stopped && plugin.eventSink == nil;
    [plugin postEventWithName:started ? @"screenSharingStarted" : @"screenSharingStopped"
                         data:nil];
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

+ (void)replayState {
  dispatch_async(dispatch_get_main_queue(), ^{
    FlutterWebRTCPlugin* plugin = [FlutterWebRTCPlugin sharedSingleton];
    if (plugin.eventSink == nil) {
      return;
    }
    if (sBroadcastActive) {
      [plugin postEventWithName:@"screenSharingStarted" data:nil];
    } else if (sStopMissed) {
      [plugin postEventWithName:@"screenSharingStopped" data:nil];
    }
    sStopMissed = NO;
  });
}

@end
