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
  // Ends with the broadcast stopped and lets pending events reach this test's
  // sink, so the next test starts from the same state.
  [FlutterWebRTCPlugin sharedSingleton].eventSink = ^(id payload) {
  };
  CFNotificationCenterPostNotification(
      CFNotificationCenterGetDarwinNotifyCenter(),
      CFSTR("io.getstream.video.screen_sharing.broadcastStopped"), NULL, NULL, true);
  [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
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

@end
