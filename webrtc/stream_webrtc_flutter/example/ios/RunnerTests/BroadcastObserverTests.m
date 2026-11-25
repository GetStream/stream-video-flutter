// Tests of how FlutterWebRTCPlugin turns the broadcast extension's Darwin
// notifications into events on its event channel.
//
// The plugin is linked into the example app, and how depends on the build: a
// static library or a framework, through CocoaPods or Swift Package Manager.
// So these tests reach it through the Objective-C runtime only: the class by
// name, and the selectors declared below. They need no plugin header and link
// against nothing but XCTest.

#import <XCTest/XCTest.h>

typedef void (^BroadcastObserverTestsSink)(id payload);

// FlutterWebRTCPlugin, as far as these tests use it.
@interface NSObject (BroadcastObserverTests)
+ (id)sharedSingleton;
- (BroadcastObserverTestsSink)eventSink;
- (void)setEventSink:(BroadcastObserverTestsSink)eventSink;
@end

@interface BroadcastObserverTests : XCTestCase
@end

@implementation BroadcastObserverTests {
  id _plugin;
  BroadcastObserverTestsSink _previousSink;
}

- (void)setUp {
  [super setUp];
  Class pluginClass = NSClassFromString(@"FlutterWebRTCPlugin");
  XCTAssertNotNil(pluginClass, @"FlutterWebRTCPlugin is not linked into the test host");
  _plugin = [pluginClass sharedSingleton];
  XCTAssertNotNil(_plugin, @"the host app registers the plugin on launch");
  _previousSink = [_plugin eventSink];
}

- (void)tearDown {
  // Ends with the broadcast stopped and lets pending events reach this test's
  // sink, so the next test starts from the same state.
  [_plugin setEventSink:^(id payload) {
  }];
  CFNotificationCenterPostNotification(
      CFNotificationCenterGetDarwinNotifyCenter(),
      CFSTR("io.getstream.video.screen_sharing.broadcastStopped"), NULL, NULL, true);
  [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
  [_plugin setEventSink:_previousSink];
  _plugin = nil;
  _previousSink = nil;
  [super tearDown];
}

- (void)expectEvent:(NSString*)event afterNotification:(NSString*)notification {
  XCTestExpectation* received = [self expectationWithDescription:event];
  [_plugin setEventSink:^(id payload) {
    if ([payload isKindOfClass:[NSDictionary class]] &&
        [((NSDictionary*)payload)[@"event"] isEqual:event]) {
      [received fulfill];
    }
  }];

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
