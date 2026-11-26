// Tests of the audio engine gate of FlutterWebRTCPlugin, shared by the iOS and
// macOS RunnerTests targets of the example.
//
// The plugin is linked into the example app, and how depends on the build: a
// static library or a framework, through CocoaPods or Swift Package Manager.
// So these tests reach it through the Objective-C runtime only: classes by
// name, and the private selectors declared below. They need no plugin header
// and link against nothing but XCTest.

#import <TargetConditionals.h>
#import <XCTest/XCTest.h>
#import <objc/runtime.h>

static NSString* const kAvailableKey = @"available";
static NSString* const kSessionActiveKey = @"audioSessionActive";
static NSString* const kAvailabilityNotification = @"io.getstream.webrtc.audioEngineAvailability";

// FlutterWebRTCAudioEngineHub, the plugin and the Flutter classes, as far as
// these tests use them.
@interface NSObject (AudioEngineGateTests)
+ (instancetype)shared;
+ (id)audioEngineControl;
+ (id)methodChannelWithName:(NSString*)name binaryMessenger:(id)messenger;
+ (id)methodCallWithMethodName:(NSString*)method arguments:(id)arguments;
- (void)addPlugin:(id)plugin;
- (void)handleAudioEngineAvailabilityNotification:(NSNotification*)notification;
- (void)gateAudioEngine:(BOOL)available;
- (void)recordCallKitAudioSessionActive:(BOOL)active;
- (void)applyAudioEngineAvailability:(BOOL)available toFactory:(id)factory;
- (void)handleMethodCall:(id)call result:(void (^)(id))result;
- (NSMutableDictionary*)factories;
#if TARGET_OS_IPHONE
- (instancetype)initWithChannel:(id)channel
                      registrar:(id)registrar
                      messenger:(id)messenger
                 viewController:(id)viewController
                   withTextures:(id)textures;
#else
- (instancetype)initWithChannel:(id)channel
                      registrar:(id)registrar
                      messenger:(id)messenger
                   withTextures:(id)textures;
#endif
@end

/// The plugin registrar and binary messenger a registration is built with.
/// Nothing reaches Dart: the tests only drive the plugin's method handler.
@interface AudioEngineGateTestsHost : NSObject
@end

@implementation AudioEngineGateTestsHost

- (void)registerViewFactory:(id)factory withId:(NSString*)factoryId {
}

- (int64_t)setMessageHandlerOnChannel:(NSString*)channel binaryMessageHandler:(id)handler {
  return 0;
}

- (int64_t)setMessageHandlerOnChannel:(NSString*)channel
                 binaryMessageHandler:(id)handler
                            taskQueue:(id)taskQueue {
  return 0;
}

- (void)sendOnChannel:(NSString*)channel message:(NSData*)message {
}

- (void)sendOnChannel:(NSString*)channel message:(NSData*)message binaryReply:(id)callback {
}

- (void)cleanUpConnection:(int64_t)connection {
}

@end

static char kEventsKey;

/// What the stub registration was told, in order: `session:YES`, `gate:NO`,
/// `factory:NO:<factory id>`.
static NSMutableArray<NSString*>* EventsOf(id plugin) {
  NSMutableArray<NSString*>* events = objc_getAssociatedObject(plugin, &kEventsKey);
  if (events == nil) {
    events = [NSMutableArray array];
    objc_setAssociatedObject(plugin, &kEventsKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return events;
}

static NSString* YesNo(BOOL value) {
  return value ? @"YES" : @"NO";
}

/// A subclass of FlutterWebRTCPlugin that records what the gate tells it, and
/// then does what the plugin does. Built at runtime, since the plugin's class
/// is only known by name here.
static Class StubPluginClass(void) {
  static Class stub;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    Class plugin = NSClassFromString(@"FlutterWebRTCPlugin");
    NSCAssert(plugin != Nil, @"FlutterWebRTCPlugin is not linked into the test host");
    stub = objc_allocateClassPair(plugin, "AudioEngineGateTestsPlugin", 0);

    SEL gate = @selector(gateAudioEngine:);
    void (*gateSuper)(id, SEL, BOOL) =
        (void (*)(id, SEL, BOOL))class_getMethodImplementation(plugin, gate);
    class_addMethod(stub, gate, imp_implementationWithBlock(^(id self, BOOL available) {
                      [EventsOf(self)
                          addObject:[@"gate:" stringByAppendingString:YesNo(available)]];
                      gateSuper(self, gate, available);
                    }),
                    method_getTypeEncoding(class_getInstanceMethod(plugin, gate)));

    SEL session = @selector(recordCallKitAudioSessionActive:);
    void (*sessionSuper)(id, SEL, BOOL) =
        (void (*)(id, SEL, BOOL))class_getMethodImplementation(plugin, session);
    class_addMethod(stub, session, imp_implementationWithBlock(^(id self, BOOL active) {
                      [EventsOf(self)
                          addObject:[@"session:" stringByAppendingString:YesNo(active)]];
                      sessionSuper(self, session, active);
                    }),
                    method_getTypeEncoding(class_getInstanceMethod(plugin, session)));

    // Records instead of touching the factory's audio device module.
    SEL apply = @selector(applyAudioEngineAvailability:toFactory:);
    class_addMethod(
        stub, apply, imp_implementationWithBlock(^(id self, BOOL available, id factory) {
          [EventsOf(self) addObject:[NSString stringWithFormat:@"factory:%@:%@", YesNo(available),
                                                               [factory valueForKey:@"factoryId"]]];
        }),
        method_getTypeEncoding(class_getInstanceMethod(plugin, apply)));

    objc_registerClassPair(stub);
  });
  return stub;
}

@interface AudioEngineGateTests : XCTestCase
@end

@implementation AudioEngineGateTests {
  /// A hub of its own for each test, so the process-wide one, which the
  /// example app's registration uses, is left alone.
  id _hub;
}

- (void)setUp {
  [super setUp];
  Class hubClass = NSClassFromString(@"FlutterWebRTCAudioEngineHub");
  XCTAssertNotNil(hubClass);
  _hub = [[hubClass alloc] init];
}

- (void)tearDown {
#if TARGET_OS_IPHONE
  // Hands the shared RTCAudioSession back as it was, deactivated.
  [self notify:@{kAvailableKey : @YES, kSessionActiveKey : @NO}];
#endif
  _hub = nil;
  [super tearDown];
}

- (void)notify:(NSDictionary*)userInfo {
  [_hub handleAudioEngineAvailabilityNotification:[NSNotification
                                                      notificationWithName:kAvailabilityNotification
                                                                    object:nil
                                                                  userInfo:userInfo]];
}

/// A registration added to the test's hub, with what it was told on being
/// added already cleared.
- (id)addStubPlugin {
  id plugin = [[StubPluginClass() alloc] init];
  [_hub addPlugin:plugin];
  [EventsOf(plugin) removeAllObjects];
  return plugin;
}

#pragma mark - The control

- (void)testAudioEngineControlIsOneHubForTheProcess {
  Class plugin = NSClassFromString(@"FlutterWebRTCPlugin");
  id control = [plugin audioEngineControl];

  XCTAssertEqualObjects(NSStringFromClass([control class]), @"FlutterWebRTCAudioEngineHub");
  XCTAssertEqual(control, [plugin audioEngineControl]);
  XCTAssertEqual(control, [NSClassFromString(@"FlutterWebRTCAudioEngineHub") shared]);
}

#pragma mark - Parsing the notification

- (void)testANotificationWithoutAvailableIsIgnored {
  id plugin = [self addStubPlugin];

  [self notify:nil];
  [self notify:@{}];
  [self notify:@{kSessionActiveKey : @YES}];

  XCTAssertEqualObjects(EventsOf(plugin), @[]);
}

- (void)testANotificationWhoseAvailableIsNotANumberIsIgnored {
  id plugin = [self addStubPlugin];

  [self notify:@{kAvailableKey : @"NO"}];
  [self notify:@{kAvailableKey : [NSNull null], kSessionActiveKey : @YES}];

  XCTAssertEqualObjects(EventsOf(plugin), @[]);
}

- (void)testAvailabilityAloneGatesAndAllows {
  id plugin = [self addStubPlugin];

  [self notify:@{kAvailableKey : @NO}];
  [self notify:@{kAvailableKey : @YES}];

  XCTAssertEqualObjects(EventsOf(plugin), (@[ @"gate:NO", @"gate:YES" ]));
}

- (void)testASessionStateThatIsNotANumberIsIgnored {
  id plugin = [self addStubPlugin];

  [self notify:@{kAvailableKey : @NO, kSessionActiveKey : @"YES"}];

  XCTAssertEqualObjects(EventsOf(plugin), @[ @"gate:NO" ]);
}

#if TARGET_OS_IPHONE

- (void)testAnActivationIsAppliedBeforeTheAvailability {
  id plugin = [self addStubPlugin];

  [self notify:@{kAvailableKey : @YES, kSessionActiveKey : @YES}];

  XCTAssertEqualObjects(EventsOf(plugin), (@[ @"session:YES", @"gate:YES" ]));
}

- (void)testADeactivationIsAppliedAfterTheAvailability {
  id plugin = [self addStubPlugin];
  [self notify:@{kAvailableKey : @YES, kSessionActiveKey : @YES}];
  [EventsOf(plugin) removeAllObjects];

  [self notify:@{kAvailableKey : @NO, kSessionActiveKey : @NO}];

  XCTAssertEqualObjects(EventsOf(plugin), (@[ @"gate:NO", @"session:NO" ]));
}

- (void)testARepeatedSessionStateDoesNothing {
  id plugin = [self addStubPlugin];

  [self notify:@{kAvailableKey : @YES, kSessionActiveKey : @YES}];
  [self notify:@{kAvailableKey : @YES, kSessionActiveKey : @YES}];
  [self notify:@{kAvailableKey : @YES, kSessionActiveKey : @NO}];
  [self notify:@{kAvailableKey : @YES, kSessionActiveKey : @NO}];

  XCTAssertEqualObjects(
      EventsOf(plugin),
      (@[ @"session:YES", @"gate:YES", @"gate:YES", @"gate:YES", @"session:NO", @"gate:YES" ]));
}

#else

- (void)testTheSessionStateIsNotRecordedOnMacOS {
  id plugin = [self addStubPlugin];

  [self notify:@{kAvailableKey : @NO, kSessionActiveKey : @YES}];
  [self notify:@{kAvailableKey : @YES, kSessionActiveKey : @NO}];

  XCTAssertEqualObjects(EventsOf(plugin), (@[ @"gate:NO", @"gate:YES" ]));
}

#endif

#pragma mark - Repeated stops

- (void)testARepeatedStopIsIgnored {
  id plugin = [self addStubPlugin];

  [self notify:@{kAvailableKey : @NO}];
  [self notify:@{kAvailableKey : @NO}];
  [self notify:@{kAvailableKey : @YES}];
  [self notify:@{kAvailableKey : @NO}];

  XCTAssertEqualObjects(EventsOf(plugin), (@[ @"gate:NO", @"gate:YES", @"gate:NO" ]));
}

#pragma mark - Registrations made later

- (void)testARegistrationMadeWhileTheGateIsOpenIsOnlyToldTheSessionState {
  id plugin = [[StubPluginClass() alloc] init];

  [_hub addPlugin:plugin];

  XCTAssertEqualObjects(EventsOf(plugin), @[ @"session:NO" ]);
}

- (void)testARegistrationMadeLaterGetsTheClosedGateAndTheSessionState {
#if TARGET_OS_IPHONE
  [self notify:@{kAvailableKey : @NO, kSessionActiveKey : @YES}];
  NSArray* expected = @[ @"session:YES", @"gate:NO" ];
#else
  [self notify:@{kAvailableKey : @NO}];
  NSArray* expected = @[ @"session:NO", @"gate:NO" ];
#endif
  id plugin = [[StubPluginClass() alloc] init];

  [_hub addPlugin:plugin];

  XCTAssertEqualObjects(EventsOf(plugin), expected);
}

- (void)testARegistrationMadeLaterIsGatedAndAllowedWithTheOthers {
  id earlier = [self addStubPlugin];
  [self notify:@{kAvailableKey : @NO}];
  id later = [self addStubPlugin];

  [self notify:@{kAvailableKey : @YES}];

  XCTAssertEqualObjects(EventsOf(earlier), (@[ @"gate:NO", @"gate:YES" ]));
  XCTAssertEqualObjects(EventsOf(later), @[ @"gate:YES" ]);
}

#pragma mark - Factories

/// A registration built the way the plugin builds one, on a stand-in host. It
/// also adds itself to the process-wide hub, which these tests leave open, and
/// becomes the plugin's +sharedSingleton, which has no setter to put back. The
/// test host's own registration is idle while the tests run, so nothing reads
/// it meanwhile.
- (id)registeredStubPlugin {
  AudioEngineGateTestsHost* host = [[AudioEngineGateTestsHost alloc] init];
  id channel =
      [NSClassFromString(@"FlutterMethodChannel") methodChannelWithName:@"AudioEngineGateTests"
                                                        binaryMessenger:host];
#if TARGET_OS_IPHONE
  id plugin = [[StubPluginClass() alloc] initWithChannel:channel
                                               registrar:host
                                               messenger:host
                                          viewController:nil
                                            withTextures:nil];
#else
  id plugin = [[StubPluginClass() alloc] initWithChannel:channel
                                               registrar:host
                                               messenger:host
                                            withTextures:nil];
#endif
  [EventsOf(plugin) removeAllObjects];
  return plugin;
}

/// Builds a factory through the method channel and returns its id. Stops the
/// test if there is none, which the callers would otherwise crash on.
- (NSString*)createFactoryWith:(id)plugin {
  __block id reply = nil;
  id call = [NSClassFromString(@"FlutterMethodCall")
      methodCallWithMethodName:@"createPeerConnectionFactory"
                     arguments:@{@"options" : @{}}];
  XCTestExpectation* built = [self expectationWithDescription:@"factory built"];
  [plugin handleMethodCall:call
                    result:^(id result) {
                      reply = result;
                      [built fulfill];
                    }];
  [self waitForExpectations:@[ built ] timeout:10];
  self.continueAfterFailure = NO;
  XCTAssertTrue([reply isKindOfClass:[NSDictionary class]], @"createPeerConnectionFactory: %@",
                reply);
  NSString* factoryId = reply[@"factoryId"];
  XCTAssertNotNil(factoryId);
  XCTAssertNotNil([plugin factories][factoryId]);
  self.continueAfterFailure = YES;
  return factoryId;
}

- (void)disposeFactory:(NSString*)factoryId with:(id)plugin {
  id call = [NSClassFromString(@"FlutterMethodCall")
      methodCallWithMethodName:@"disposePeerConnectionFactory"
                     arguments:@{@"factoryId" : factoryId}];
  XCTestExpectation* disposed = [self expectationWithDescription:@"factory disposed"];
  [plugin handleMethodCall:call
                    result:^(id result) {
                      [disposed fulfill];
                    }];
  [self waitForExpectations:@[ disposed ] timeout:10];
}

- (void)testAFactoryBuiltWhileTheGateIsClosedIsGated {
  id plugin = [self registeredStubPlugin];
  [plugin gateAudioEngine:NO];
  [EventsOf(plugin) removeAllObjects];

  NSString* factoryId = [self createFactoryWith:plugin];

  XCTAssertEqualObjects(EventsOf(plugin), @[ [@"factory:NO:" stringByAppendingString:factoryId] ]);
  [self disposeFactory:factoryId with:plugin];
}

- (void)testAFactoryBuiltWhileTheGateIsOpenIsLeftAlone {
  id plugin = [self registeredStubPlugin];

  NSString* factoryId = [self createFactoryWith:plugin];

  XCTAssertEqualObjects(EventsOf(plugin), @[]);
  [self disposeFactory:factoryId with:plugin];
}

- (void)testAllowingTheEngineAgainReachesAFactoryBuiltWhileGated {
  id plugin = [self registeredStubPlugin];
  [plugin gateAudioEngine:NO];
  NSString* factoryId = [self createFactoryWith:plugin];
  [EventsOf(plugin) removeAllObjects];

  [plugin gateAudioEngine:YES];

  XCTAssertEqualObjects(EventsOf(plugin),
                        (@[ @"gate:YES", [@"factory:YES:" stringByAppendingString:factoryId] ]));
  [self disposeFactory:factoryId with:plugin];
}

@end
