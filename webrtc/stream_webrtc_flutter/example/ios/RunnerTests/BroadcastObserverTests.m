#import <Flutter/Flutter.h>
#import <XCTest/XCTest.h>

@import stream_webrtc_flutter;

/// The plugin turns the broadcast extension's Darwin notifications into
/// events on its event channel.
@interface BroadcastObserverTests : XCTestCase
@property(nonatomic, strong) FlutterEventSink previousSink;
@end

@implementation BroadcastObserverTests

- (void)setUp {
  [super setUp];
  XCTAssertNotNil([FlutterWebRTCPlugin sharedSingleton],
                  @"the host app registers the plugin on launch");
  self.previousSink = [FlutterWebRTCPlugin sharedSingleton].eventSink;
}

- (void)tearDown {
  [FlutterWebRTCPlugin sharedSingleton].eventSink = self.previousSink;
  [super tearDown];
}

- (void)expectEvent:(NSString*)event afterNotification:(NSString*)notification {
  XCTestExpectation* received = [self expectationWithDescription:event];
  [FlutterWebRTCPlugin sharedSingleton].eventSink = ^(id payload) {
    if ([payload isKindOfClass:[NSDictionary class]] &&
        [((NSDictionary*)payload)[@"event"] isEqualToString:event]) {
      [received fulfill];
    }
  };

  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       (__bridge CFStringRef)notification, NULL, NULL, true);

  [self waitForExpectations:@[ received ] timeout:5];
}

- (void)testBroadcastStartedPostsScreenSharingStarted {
  [self expectEvent:@"screenSharingStarted"
      afterNotification:@"io.getstream.video.screen_sharing.broadcastStarted"];
}

- (void)testBroadcastStoppedPostsScreenSharingStopped {
  [self expectEvent:@"screenSharingStopped"
      afterNotification:@"io.getstream.video.screen_sharing.broadcastStopped"];
}

- (void)testRunningBroadcastIsReplayedWhenAListenerAttaches {
  FlutterWebRTCPlugin* plugin = [FlutterWebRTCPlugin sharedSingleton];
  plugin.eventSink = nil;
  CFNotificationCenterPostNotification(
      CFNotificationCenterGetDarwinNotifyCenter(),
      CFSTR("io.getstream.video.screen_sharing.broadcastStarted"), NULL, NULL, true);
  // Lets the notification reach the observer while nothing listens.
  [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];

  XCTestExpectation* replayed = [self expectationWithDescription:@"replayed"];
  [plugin onListenWithArguments:nil
                      eventSink:^(id payload) {
                        if ([payload isKindOfClass:[NSDictionary class]] &&
                            [((NSDictionary*)payload)[@"event"]
                                isEqualToString:@"screenSharingStarted"]) {
                          [replayed fulfill];
                        }
                      }];

  [self waitForExpectations:@[ replayed ] timeout:5];

  CFNotificationCenterPostNotification(
      CFNotificationCenterGetDarwinNotifyCenter(),
      CFSTR("io.getstream.video.screen_sharing.broadcastStopped"), NULL, NULL, true);
  [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
}

@end
