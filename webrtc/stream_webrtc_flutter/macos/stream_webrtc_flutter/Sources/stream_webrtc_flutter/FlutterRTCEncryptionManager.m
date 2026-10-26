#import "include/stream_webrtc_flutter/FlutterRTCEncryptionManager.h"

/** Dart sends -1 when it wants native to infer audio vs video from RTP. */
static const NSInteger kTrackTypeUnspecified = -1;

/**
 * Manager registry.
 *
 * The plugin is a singleton (`+[FlutterWebRTCPlugin sharedSingleton]`) and a
 * category cannot add storage, so the registry lives here. Guarded by
 * @synchronized because Dart calls arrive on the platform thread while
 * `dispose` can run from teardown.
 */
static NSMutableDictionary<NSString*, FlutterRTCEncryptionManagerHandle*>* gHandles;

static NSMutableDictionary<NSString*, FlutterRTCEncryptionManagerHandle*>* handleRegistry(void) {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gHandles = [NSMutableDictionary dictionary];
  });
  return gHandles;
}

#pragma mark - Argument coercion

/**
 * Method-channel arguments are untrusted: Dart's `null` arrives as `NSNull`,
 * which raises on `integerValue`/`boolValue`. Returns nil unless the value is
 * a real number, so callers can reject or default without converting first.
 */
static NSNumber* _Nullable numberArg(id args, NSString* key) {
  if (![args isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  id value = ((NSDictionary*)args)[key];
  return [value isKindOfClass:[NSNumber class]] ? (NSNumber*)value : nil;
}

#pragma mark - Event serialization

static NSDictionary* userKeyToMap(RTCEncryptionUserKey* key) {
  return @{
    @"userId" : key.userId ?: @"",
    @"keyIndex" : @(key.keyIndex),
    @"fingerprint" : key.fingerprint ?: @""
  };
}

static NSDictionary* sharedKeyToMap(RTCEncryptionSharedKey* key) {
  return @{
    @"keyIndex" : @(key.keyIndex),
    @"fingerprint" : key.fingerprint ?: @"",
    @"isActive" : @(key.isActive)
  };
}

static NSDictionary* keyStateToMap(RTCEncryptionKeyState* keyState) {
  NSMutableArray* perUserKeys = [NSMutableArray array];
  for (RTCEncryptionUserKey* key in keyState.perUserKeys) {
    [perUserKeys addObject:userKeyToMap(key)];
  }

  NSMutableArray* sharedKeys = [NSMutableArray array];
  for (RTCEncryptionSharedKey* key in keyState.sharedKeys) {
    [sharedKeys addObject:sharedKeyToMap(key)];
  }

  return @{@"perUserKeys" : perUserKeys, @"sharedKeys" : sharedKeys};
}

static NSArray* perfToList(NSArray<RTCEncryptionTrackPerf*>* samples) {
  NSMutableArray* list = [NSMutableArray array];
  for (RTCEncryptionTrackPerf* sample in samples) {
    NSMutableDictionary* entry = [NSMutableDictionary dictionary];
    entry[@"userId"] = sample.userId ?: @"";
    entry[@"trackType"] = @(sample.trackType);
    if (sample.codec != nil) {
      entry[@"codec"] = sample.codec;
    }
    entry[@"fps"] = @(sample.fps);
    entry[@"maxCryptoMs"] = @(sample.maxCryptoMs);
    [list addObject:entry];
  }
  return list;
}

static NSDictionary* eventToMap(RTCE2eeEvent* event) {
  NSMutableDictionary* map = [NSMutableDictionary dictionary];
  map[@"type"] = @(event.type);
  map[@"name"] = event.name ?: @"";
  map[@"userId"] = event.userId ?: @"";
  if (event.trackType != nil) {
    map[@"trackType"] = event.trackType;
  }
  if (event.keyIndex != nil) {
    map[@"keyIndex"] = event.keyIndex;
  }
  if (event.version != nil) {
    map[@"version"] = event.version;
  }
  if (event.reason != nil) {
    map[@"reason"] = event.reason;
  }
  if (event.keyState != nil) {
    map[@"keyState"] = keyStateToMap(event.keyState);
  }
  if (event.encode != nil) {
    map[@"encode"] = perfToList(event.encode);
  }
  if (event.decode != nil) {
    map[@"decode"] = perfToList(event.decode);
  }
  return map;
}

#pragma mark - Handle

@implementation FlutterRTCEncryptionManagerHandle {
  FlutterEventSink _eventSink;
}

- (instancetype)initWithManager:(RTCEncryptionManager*)manager
                   eventChannel:(FlutterEventChannel*)eventChannel {
  self = [super init];
  if (self) {
    _manager = manager;
    _eventChannel = eventChannel;
  }
  return self;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
  _eventSink = events;
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  _eventSink = nil;
  return nil;
}

- (void)encryptionManager:(RTCEncryptionManager*)manager didReceiveEvent:(RTCE2eeEvent*)event {
  postEvent(_eventSink, eventToMap(event));
}

- (void)detach {
  // Dropping the delegate first stops events racing the teardown.
  _manager.delegate = nil;
  [_eventChannel setStreamHandler:nil];
  _eventSink = nil;
}

- (void)releaseNative {
  [_manager dispose];
}

@end

#pragma mark - Plugin category

@implementation FlutterWebRTCPlugin (EncryptionManager)

- (BOOL)handleEncryptionManagerMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* method = call.method;
  if (![method hasPrefix:@"encryptionManager"]) {
    return NO;
  }

  if ([@"encryptionManagerCreate" isEqualToString:method]) {
    [self encryptionManagerCreate:call result:result];
  } else if ([@"encryptionManagerSetKey" isEqualToString:method]) {
    [self encryptionManagerSetKey:call result:result];
  } else if ([@"encryptionManagerSetSharedKey" isEqualToString:method]) {
    [self encryptionManagerSetSharedKey:call result:result];
  } else if ([@"encryptionManagerRemoveKey" isEqualToString:method]) {
    [self encryptionManagerRemoveKey:call result:result];
  } else if ([@"encryptionManagerRemoveAllKeys" isEqualToString:method]) {
    [self encryptionManagerRemoveAllKeys:call result:result];
  } else if ([@"encryptionManagerRemoveSharedKey" isEqualToString:method]) {
    [self encryptionManagerRemoveSharedKey:call result:result];
  } else if ([@"encryptionManagerEncrypt" isEqualToString:method]) {
    [self encryptionManagerEncrypt:call result:result];
  } else if ([@"encryptionManagerDecrypt" isEqualToString:method]) {
    [self encryptionManagerDecrypt:call result:result];
  } else if ([@"encryptionManagerEnablePerformanceReporting" isEqualToString:method]) {
    [self encryptionManagerEnablePerformanceReporting:call result:result];
  } else if ([@"encryptionManagerRequestKeyState" isEqualToString:method]) {
    [self encryptionManagerRequestKeyState:call result:result];
  } else if ([@"encryptionManagerDispose" isEqualToString:method]) {
    [self encryptionManagerDispose:call result:result];
  } else {
    return NO;
  }

  return YES;
}

- (void)disposeAllEncryptionManagers {
  NSArray<FlutterRTCEncryptionManagerHandle*>* handles;
  @synchronized(handleRegistry()) {
    handles = handleRegistry().allValues;
    [handleRegistry() removeAllObjects];
  }
  for (FlutterRTCEncryptionManagerHandle* handle in handles) {
    [handle detach];
  }
  // Releasing joins the manager's frame-crypto worker, which would block the
  // platform thread for as long as that worker takes to drain.
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
    for (FlutterRTCEncryptionManagerHandle* handle in handles) {
      [handle releaseNative];
    }
  });
}

#pragma mark - Methods

- (void)encryptionManagerCreate:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSDictionary* args = call.arguments;
  NSString* userId = args[@"userId"];
  if (![userId isKindOfClass:[NSString class]] || userId.length == 0) {
    result([FlutterError errorWithCode:@"encryptionManagerCreateFailed"
                               message:@"userId is required"
                               details:nil]);
    return;
  }

  // A missing algorithm keeps the AES-128 default; a malformed one is rejected
  // rather than silently downgraded.
  id algorithmValue = [args isKindOfClass:[NSDictionary class]] ? args[@"algorithm"] : nil;
  if (algorithmValue != nil && ![algorithmValue isKindOfClass:[NSNumber class]]) {
    [self failCall:call result:result message:@"algorithm must be a number"];
    return;
  }
  RTCEncryptionAlgorithm algorithm =
      [algorithmValue integerValue] == RTCEncryptionAlgorithmAes256Gcm
          ? RTCEncryptionAlgorithmAes256Gcm
          : RTCEncryptionAlgorithmAes128Gcm;

  NSError* error = nil;
  RTCEncryptionManager* manager = [RTCEncryptionManager createWithUserId:userId
                                                               algorithm:algorithm
                                                                   error:&error];
  if (manager == nil) {
    result([FlutterError errorWithCode:@"encryptionManagerCreateFailed"
                               message:error.localizedDescription ?: @"create failed"
                               details:nil]);
    return;
  }

  NSString* managerId = [[NSUUID UUID] UUIDString];
  FlutterEventChannel* eventChannel = [FlutterEventChannel
      eventChannelWithName:[NSString stringWithFormat:@"FlutterWebRTC/e2ee/%@", managerId]
           binaryMessenger:self.messenger];

  FlutterRTCEncryptionManagerHandle* handle =
      [[FlutterRTCEncryptionManagerHandle alloc] initWithManager:manager eventChannel:eventChannel];
  [eventChannel setStreamHandler:handle];
  manager.delegate = handle;

  @synchronized(handleRegistry()) {
    handleRegistry()[managerId] = handle;
  }

  result(@{@"managerId" : managerId});
}

- (void)encryptionManagerSetKey:(FlutterMethodCall*)call result:(FlutterResult)result {
  RTCEncryptionManager* manager = [self requireManagerForCall:call result:result];
  if (manager == nil) {
    return;
  }

  NSDictionary* args = call.arguments;
  NSString* userId = args[@"userId"];
  NSNumber* keyIndex = numberArg(args, @"keyIndex");
  FlutterStandardTypedData* rawKey = args[@"rawKey"];
  if (userId == nil || keyIndex == nil || rawKey == nil) {
    [self failCall:call result:result message:@"userId, keyIndex and rawKey are required"];
    return;
  }

  NSError* error = nil;
  if (![manager setKey:userId keyIndex:keyIndex.intValue rawKey:rawKey.data error:&error]) {
    [self failCall:call result:result message:error.localizedDescription ?: @"setKey failed"];
    return;
  }
  result(nil);
}

- (void)encryptionManagerSetSharedKey:(FlutterMethodCall*)call result:(FlutterResult)result {
  RTCEncryptionManager* manager = [self requireManagerForCall:call result:result];
  if (manager == nil) {
    return;
  }

  NSDictionary* args = call.arguments;
  NSNumber* keyIndex = numberArg(args, @"keyIndex");
  FlutterStandardTypedData* rawKey = args[@"rawKey"];
  if (keyIndex == nil || rawKey == nil) {
    [self failCall:call result:result message:@"keyIndex and rawKey are required"];
    return;
  }

  NSError* error = nil;
  if (![manager setSharedKey:keyIndex.intValue rawKey:rawKey.data error:&error]) {
    [self failCall:call result:result message:error.localizedDescription ?: @"setSharedKey failed"];
    return;
  }
  result(nil);
}

- (void)encryptionManagerRemoveKey:(FlutterMethodCall*)call result:(FlutterResult)result {
  RTCEncryptionManager* manager = [self requireManagerForCall:call result:result];
  if (manager == nil) {
    return;
  }

  NSDictionary* args = call.arguments;
  NSString* userId = args[@"userId"];
  NSNumber* keyIndex = numberArg(args, @"keyIndex");
  if (userId == nil || keyIndex == nil) {
    [self failCall:call result:result message:@"userId and keyIndex are required"];
    return;
  }

  NSError* error = nil;
  if (![manager removeKey:userId keyIndex:keyIndex.intValue error:&error]) {
    [self failCall:call result:result message:error.localizedDescription ?: @"removeKey failed"];
    return;
  }
  result(nil);
}

- (void)encryptionManagerRemoveAllKeys:(FlutterMethodCall*)call result:(FlutterResult)result {
  RTCEncryptionManager* manager = [self requireManagerForCall:call result:result];
  if (manager == nil) {
    return;
  }

  NSString* userId = call.arguments[@"userId"];
  if (userId == nil) {
    [self failCall:call result:result message:@"userId is required"];
    return;
  }

  NSError* error = nil;
  if (![manager removeAllKeys:userId error:&error]) {
    [self failCall:call
            result:result
           message:error.localizedDescription ?: @"removeAllKeys failed"];
    return;
  }
  result(nil);
}

- (void)encryptionManagerRemoveSharedKey:(FlutterMethodCall*)call result:(FlutterResult)result {
  RTCEncryptionManager* manager = [self requireManagerForCall:call result:result];
  if (manager == nil) {
    return;
  }

  NSNumber* keyIndex = numberArg(call.arguments, @"keyIndex");
  if (keyIndex == nil) {
    [self failCall:call result:result message:@"keyIndex is required"];
    return;
  }

  NSError* error = nil;
  if (![manager removeSharedKey:keyIndex.intValue error:&error]) {
    [self failCall:call
            result:result
           message:error.localizedDescription ?: @"removeSharedKey failed"];
    return;
  }
  result(nil);
}

- (void)encryptionManagerEncrypt:(FlutterMethodCall*)call result:(FlutterResult)result {
  RTCEncryptionManager* manager = [self requireManagerForCall:call result:result];
  if (manager == nil) {
    return;
  }

  RTCPeerConnection* peerConnection = [self requirePeerConnectionForCall:call result:result];
  if (peerConnection == nil) {
    return;
  }

  NSString* senderId = call.arguments[@"rtpSenderId"];
  if (senderId == nil) {
    [self failCall:call result:result message:@"rtpSenderId is required"];
    return;
  }

  RTCRtpSender* sender = [self getRtpSenderById:peerConnection Id:senderId];
  if (sender == nil) {
    [self failCall:call
            result:result
           message:[NSString stringWithFormat:@"sender %@ not found", senderId]];
    return;
  }

  NSString* codec = call.arguments[@"codec"];
  if (![codec isKindOfClass:[NSString class]]) {
    codec = nil;
  }

  NSError* error = nil;
  if (![manager encrypt:sender codec:codec trackType:[self trackTypeForCall:call] error:&error]) {
    [self failCall:call result:result message:error.localizedDescription ?: @"encrypt failed"];
    return;
  }
  result(nil);
}

- (void)encryptionManagerDecrypt:(FlutterMethodCall*)call result:(FlutterResult)result {
  RTCEncryptionManager* manager = [self requireManagerForCall:call result:result];
  if (manager == nil) {
    return;
  }

  RTCPeerConnection* peerConnection = [self requirePeerConnectionForCall:call result:result];
  if (peerConnection == nil) {
    return;
  }

  NSDictionary* args = call.arguments;
  NSString* receiverId = args[@"rtpReceiverId"];
  NSString* userId = args[@"userId"];
  if (receiverId == nil || userId == nil || userId.length == 0) {
    [self failCall:call result:result message:@"rtpReceiverId and userId are required"];
    return;
  }

  RTCRtpReceiver* receiver = [self getRtpReceiverById:peerConnection Id:receiverId];
  if (receiver == nil) {
    [self failCall:call
            result:result
           message:[NSString stringWithFormat:@"receiver %@ not found", receiverId]];
    return;
  }

  NSError* error = nil;
  if (![manager decrypt:receiver
                 userId:userId
              trackType:[self trackTypeForCall:call]
                  error:&error]) {
    [self failCall:call result:result message:error.localizedDescription ?: @"decrypt failed"];
    return;
  }
  result(nil);
}

- (void)encryptionManagerEnablePerformanceReporting:(FlutterMethodCall*)call
                                             result:(FlutterResult)result {
  RTCEncryptionManager* manager = [self requireManagerForCall:call result:result];
  if (manager == nil) {
    return;
  }

  NSNumber* enabled = numberArg(call.arguments, @"enabled");
  if (enabled == nil) {
    [self failCall:call result:result message:@"enabled is required"];
    return;
  }

  NSError* error = nil;
  if (![manager enablePerformanceReporting:enabled.boolValue error:&error]) {
    [self failCall:call
            result:result
           message:error.localizedDescription ?: @"enablePerformanceReporting failed"];
    return;
  }
  result(nil);
}

- (void)encryptionManagerRequestKeyState:(FlutterMethodCall*)call result:(FlutterResult)result {
  RTCEncryptionManager* manager = [self requireManagerForCall:call result:result];
  if (manager == nil) {
    return;
  }

  NSError* error = nil;
  if (![manager requestKeyState:&error]) {
    [self failCall:call
            result:result
           message:error.localizedDescription ?: @"requestKeyState failed"];
    return;
  }
  result(nil);
}

- (void)encryptionManagerDispose:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* managerId = call.arguments[@"managerId"];
  FlutterRTCEncryptionManagerHandle* handle = nil;
  if (managerId != nil) {
    @synchronized(handleRegistry()) {
      handle = handleRegistry()[managerId];
      [handleRegistry() removeObjectForKey:managerId];
    }
  }
  [handle detach];
  if (handle != nil) {
    // Off the platform thread: releasing joins the frame-crypto worker.
    // Answering first is fine — the handle is already out of the registry.
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
      [handle releaseNative];
    });
  }
  // Disposing an unknown manager is not an error: Dart may retry teardown.
  result(nil);
}

#pragma mark - Helpers

- (nullable RTCEncryptionManager*)requireManagerForCall:(FlutterMethodCall*)call
                                                 result:(FlutterResult)result {
  NSString* managerId = call.arguments[@"managerId"];
  FlutterRTCEncryptionManagerHandle* handle = nil;
  if (managerId != nil) {
    @synchronized(handleRegistry()) {
      handle = handleRegistry()[managerId];
    }
  }
  if (handle == nil) {
    [self failCall:call
            result:result
           message:[NSString stringWithFormat:@"EncryptionManager %@ not found", managerId]];
    return nil;
  }
  return handle.manager;
}

- (nullable RTCPeerConnection*)requirePeerConnectionForCall:(FlutterMethodCall*)call
                                                     result:(FlutterResult)result {
  NSString* peerConnectionId = call.arguments[@"peerConnectionId"];
  RTCPeerConnection* peerConnection =
      peerConnectionId == nil ? nil : self.peerConnections[peerConnectionId];
  if (peerConnection == nil) {
    [self failCall:call
            result:result
           message:[NSString stringWithFormat:@"peerConnection %@ not found", peerConnectionId]];
    return nil;
  }
  return peerConnection;
}

/** Maps Dart's `trackType` to a boxed enum, or nil to let RTP decide. */
- (nullable NSNumber*)trackTypeForCall:(FlutterMethodCall*)call {
  NSNumber* value = numberArg(call.arguments, @"trackType");
  if (value == nil || value.integerValue == kTrackTypeUnspecified) {
    return nil;
  }
  return value;
}

- (void)failCall:(FlutterMethodCall*)call result:(FlutterResult)result message:(NSString*)message {
  result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                             message:message
                             details:nil]);
}

@end
