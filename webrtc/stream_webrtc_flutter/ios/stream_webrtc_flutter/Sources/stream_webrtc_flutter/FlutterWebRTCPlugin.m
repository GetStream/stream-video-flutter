#import "include/stream_webrtc_flutter/FlutterWebRTCPlugin.h"
#if TARGET_OS_IPHONE
#import "include/stream_webrtc_flutter/AudioUtils.h"
#endif
#import "include/stream_webrtc_flutter/CameraUtils.h"

#import "include/stream_webrtc_flutter/AudioManager.h"
#import "include/stream_webrtc_flutter/FlutterDataPacketCryptor.h"
#import "include/stream_webrtc_flutter/FlutterRTCDataChannel.h"
#import "include/stream_webrtc_flutter/FlutterRTCDesktopCapturer.h"
#import "include/stream_webrtc_flutter/FlutterRTCEncryptionManager.h"
#import "include/stream_webrtc_flutter/FlutterRTCMediaStream.h"
#import "include/stream_webrtc_flutter/FlutterRTCPeerConnection.h"
#if TARGET_OS_IPHONE
#import "include/stream_webrtc_flutter/FlutterRTCMediaRecorder.h"
#import "include/stream_webrtc_flutter/FlutterRTCVideoPlatformViewController.h"
#import "include/stream_webrtc_flutter/FlutterRTCVideoPlatformViewFactory.h"
#endif
#import "include/stream_webrtc_flutter/FlutterRTCVideoRenderer.h"
#import "include/stream_webrtc_flutter/ProcessorProvider.h"
#import "include/stream_webrtc_flutter/VideoEffectProcessor.h"
#import "include/stream_webrtc_flutter/VideoFrameProcessor.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import <StreamWebRTC/RTCCallbackLogger.h>
#import <StreamWebRTC/RTCFieldTrials.h>
#import <StreamWebRTC/RTCLogging.h>
#import <StreamWebRTC/StreamWebRTC.h>

#import "include/stream_webrtc_flutter/LocalAudioTrack.h"
#import "include/stream_webrtc_flutter/LocalTrack.h"
#import "include/stream_webrtc_flutter/LocalVideoTrack.h"
#import "include/stream_webrtc_flutter/NativePeerConnectionFactory.h"
#import "include/stream_webrtc_flutter/VideoFactoriesPrivate.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"

NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo) *>* motifyH264ProfileLevelId(
    NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo) *>* codecs) {
  NSMutableArray* newCodecs = [[NSMutableArray alloc] init];
  NSInteger count = codecs.count;
  for (NSInteger i = 0; i < count; i++) {
    RTC_OBJC_TYPE(RTCVideoCodecInfo)* info = [codecs objectAtIndex:i];
    if ([info.name isEqualToString:kRTCVideoCodecH264Name]) {
      NSString* hexString = info.parameters[@"profile-level-id"];
      RTCH264ProfileLevelId* profileLevelId =
          [[RTCH264ProfileLevelId alloc] initWithHexString:hexString];
      if (profileLevelId.level < RTCH264Level5_1) {
        RTCH264ProfileLevelId* newProfileLevelId =
            [[RTCH264ProfileLevelId alloc] initWithProfile:profileLevelId.profile
                                                     level:RTCH264Level5_1];
        // NSLog(@"profile-level-id: %@ => %@", hexString, [newProfileLevelId hexString]);
        NSMutableDictionary* parametersCopy = [[NSMutableDictionary alloc] init];
        [parametersCopy addEntriesFromDictionary:info.parameters];
        [parametersCopy setObject:[newProfileLevelId hexString] forKey:@"profile-level-id"];
        [newCodecs insertObject:[[RTCVideoCodecInfo alloc] initWithName:kRTCVideoCodecH264Name
                                                             parameters:parametersCopy]
                        atIndex:i];
      } else {
        [newCodecs insertObject:info atIndex:i];
      }
    } else {
      [newCodecs insertObject:info atIndex:i];
    }
  }
  return newCodecs;
}

@implementation VideoEncoderFactory
- (NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo) *>*)supportedCodecs {
  NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo)*>* codecs = [super supportedCodecs];
  return motifyH264ProfileLevelId(codecs);
}
@end

@implementation VideoDecoderFactory
- (NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo) *>*)supportedCodecs {
  NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo)*>* codecs = [super supportedCodecs];
  return motifyH264ProfileLevelId(codecs);
}
@end

@implementation VideoEncoderFactorySimulcast
- (NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo) *>*)supportedCodecs {
  NSArray<RTC_OBJC_TYPE(RTCVideoCodecInfo)*>* codecs = [super supportedCodecs];
  return motifyH264ProfileLevelId(codecs);
}
@end

void postEvent(FlutterEventSink _Nullable sink, id _Nullable event) {
  if (sink == nil) {
    return;
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    sink(event);
  });
}

/**
 * Immutable snapshot of the arguments passed to the most-recent
 * [WebRTC.initialize] call. Used as build defaults for the implicit
 * factory, since the implicit factory is built lazily on first use
 * rather than eagerly during initialize.
 */
@interface RTCInitializeSnapshot : NSObject
@property(nonatomic, assign) BOOL bypassVoiceProcessing;
@property(nonatomic, copy) NSArray<NSString*>* networkIgnoreMask;
@property(nonatomic, copy, nullable) NSDictionary* appleAudioConfiguration;
@end

@implementation RTCInitializeSnapshot
@end

@implementation FlutterWebRTCPlugin {
#pragma clang diagnostic pop
  FlutterMethodChannel* _methodChannel;
  FlutterEventSink _eventSink;
  FlutterEventChannel* _eventChannel;
  id _registry;
  id _messenger;
  id _textures;
  BOOL _speakerOn;
  BOOL _speakerOnButPreferBluetooth;
#if TARGET_OS_IPHONE
  AVAudioSessionPort _preferredInput;
#endif
  AudioManager* _audioManager;
  BOOL _stereoPlayoutPreferred;
#if TARGET_OS_IPHONE
  FLutterRTCVideoPlatformViewFactory* _platformViewFactory;
  dispatch_block_t _stereoRefreshDebounceBlock;
  /**
   * Serial queue for AVAudioSession reconfiguration, both requested from Dart
   * and triggered internally (track / peer-connection lifecycle).
   * setCategory / setMode / setActive block for hundreds of milliseconds while
   * the audio route changes, and since Flutter 3.29 the platform main thread is
   * also the Dart UI thread, so running them there freezes the app. Serial so
   * the requests still apply in the order they were made.
   */
  dispatch_queue_t _audioSessionQueue;
  /**
   * Ids of factories whose audio is suspended, as seen from _audioSessionQueue.
   * Suspend and resume pass through that queue before the factory's ADM queue,
   * so resume can tell there, in order, whether to restore the configuration.
   * _audioSessionQueue only.
   */
  NSMutableSet<NSString*>* _audioSuspendedFactoryIds;
#endif
  /**
   * Serial queue for device enumeration (`getSources`). Enumeration calls
   * into the media daemons and can take hundreds of milliseconds, and the main
   * thread also runs Dart.
   * Kept apart from `_audioSessionQueue` so that a camera lookup (e.g. on a
   * camera flip) never waits behind a slow audio session reconfiguration.
   */
  dispatch_queue_t _deviceEnumerationQueue;

  RTC_OBJC_TYPE(RTCCallbackLogger) * loggerCallback;

  /**
   * Serial queue for `-[RTCPeerConnection close]`. Close is a synchronous call
   * into WebRTC's signaling thread that waits for the whole teardown, hundreds
   * of milliseconds with media running, and since Flutter 3.29 the main thread
   * also runs Dart. Serial so factory disposal can wait for pending closes.
   */
  dispatch_queue_t _peerConnectionCloseQueue;

  /**
   * Peer connections closing on `_peerConnectionCloseQueue`. They are already
   * out of `peerConnections`, so engine detach finds them here. Main thread only.
   */
  NSMutableSet<RTCPeerConnection*>* _closingPeerConnections;

  /**
   * Factories whose disposal is waiting for their connections to close.
   * `createPeerConnection` rejects them, so no connection can appear on a
   * factory after its connections were closed. Main thread only.
   */
  NSMutableSet<NSString*>* _disposingFactoryIds;

  /** Snapshot of the most-recent [WebRTC.initialize] options. */
  RTCInitializeSnapshot* _initializeSnapshot;
}

static FlutterWebRTCPlugin* sharedSingleton;

+ (FlutterWebRTCPlugin*)sharedSingleton {
  @synchronized(self) {
    return sharedSingleton;
  }
}

@synthesize messenger = _messenger;
@synthesize eventSink = _eventSink;
#if TARGET_OS_IPHONE
@synthesize preferredInput = _preferredInput;
#endif
@synthesize audioManager = _audioManager;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"FlutterWebRTC.Method"
                                  binaryMessenger:[registrar messenger]];
#if TARGET_OS_IPHONE
  UIViewController* viewController = (UIViewController*)registrar.messenger;
#endif
  FlutterWebRTCPlugin* instance =
      [[FlutterWebRTCPlugin alloc] initWithChannel:channel
                                         registrar:registrar
                                         messenger:[registrar messenger]
#if TARGET_OS_IPHONE
                                    viewController:viewController
#endif
                                      withTextures:[registrar textures]];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel
                      registrar:(NSObject<FlutterPluginRegistrar>*)registrar
                      messenger:(NSObject<FlutterBinaryMessenger>*)messenger
#if TARGET_OS_IPHONE
                 viewController:(UIViewController*)viewController
#endif
                   withTextures:(NSObject<FlutterTextureRegistry>*)textures {

  self = [super init];
  sharedSingleton = self;

  FlutterEventChannel* eventChannel =
      [FlutterEventChannel eventChannelWithName:@"FlutterWebRTC.Event" binaryMessenger:messenger];
  [eventChannel setStreamHandler:self];

  if (self) {
    _methodChannel = channel;
    _registry = registrar;
    _textures = textures;
    _messenger = messenger;
    _speakerOn = NO;
    _speakerOnButPreferBluetooth = NO;
    _eventChannel = eventChannel;
    _audioManager = AudioManager.sharedInstance;
    _peerConnectionCloseQueue = dispatch_queue_create(
        "io.getstream.webrtc.flutter.peerConnectionClose",
        dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0));
    _closingPeerConnections = [NSMutableSet set];
    _disposingFactoryIds = [NSMutableSet set];

    _deviceEnumerationQueue = dispatch_queue_create(
        "io.getstream.webrtc.flutter.deviceEnumeration",
        dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0));
#if TARGET_OS_IPHONE
    _preferredInput = AVAudioSessionPortHeadphones;
    _audioSessionQueue = dispatch_queue_create(
        "io.getstream.webrtc.flutter.audioSession",
        dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0));
    _audioSuspendedFactoryIds = [NSMutableSet set];
    self.viewController = viewController;
    _platformViewFactory = [[FLutterRTCVideoPlatformViewFactory alloc] initWithMessenger:messenger];
    [registrar registerViewFactory:_platformViewFactory
                            withId:FLutterRTCVideoPlatformViewFactoryID];
#endif
  }

  NSDictionary* fieldTrials = @{kRTCFieldTrialUseNWPathMonitor : kRTCFieldTrialEnabledValue};
  RTCInitFieldTrialDictionary(fieldTrials);

  self.peerConnections = [NSMutableDictionary new];
  self.localStreams = [NSMutableDictionary new];
  self.localTracks = [NSMutableDictionary new];
  self.renders = [NSMutableDictionary new];
  self.videoCapturerStopHandlers = [NSMutableDictionary new];
  self.videoCaptureState = [NSMutableDictionary new];
#if TARGET_OS_IPHONE
  self.recorders = [NSMutableDictionary new];
#endif
  self.trackVolumeCache = [NSMutableDictionary new];
  self.pausedTrackVolumes = [NSMutableDictionary new];
  _factories = [NSMutableDictionary new];
  _pcFactoryId = [NSMutableDictionary new];
  _trackFactoryId = [NSMutableDictionary new];
  self.isAudioPlayoutPaused = NO;
#if TARGET_OS_IPHONE
  self.focusMode = @"locked";
  self.exposureMode = @"locked";
  AVAudioSession* session = [AVAudioSession sharedInstance];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didSessionRouteChange:)
                                               name:AVAudioSessionRouteChangeNotification
                                             object:session];
#endif

  return self;
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [self disposeAllEncryptionManagers];

  // Connections still closing fire their last state changes from the close
  // queue, so they must stop posting to this engine too.
  NSArray<RTCPeerConnection*>* peerConnections =
      [_peerConnections.allValues arrayByAddingObjectsFromArray:_closingPeerConnections.allObjects];
  for (RTCPeerConnection* peerConnection in peerConnections) {
    for (RTCDataChannel* dataChannel in peerConnection.dataChannels.allValues) {
      dataChannel.eventSink = nil;
    }
    peerConnection.eventSink = nil;
  }
  _eventSink = nil;
}

#pragma mark - FlutterStreamHandler methods

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  _eventSink = nil;
  return nil;
}

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)sink {
  _eventSink = sink;
  return nil;
}

- (dispatch_queue_t)deviceEnumerationQueue {
  return _deviceEnumerationQueue;
}

- (void)didSessionRouteChange:(NSNotification*)notification {
#if TARGET_OS_IPHONE
  NSDictionary* interuptionDict = notification.userInfo;
  NSInteger routeChangeReason =
      [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
  if (self.eventSink && (routeChangeReason == AVAudioSessionRouteChangeReasonNewDeviceAvailable ||
                         routeChangeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable ||
                         routeChangeReason == AVAudioSessionRouteChangeReasonCategoryChange ||
                         routeChangeReason == AVAudioSessionRouteChangeReasonOverride)) {
    postEvent(self.eventSink, @{@"event" : @"onDeviceChange"});

    // Report the newly-active audio output
    AVAudioSessionPortDescription* output =
        [RTCAudioSession sharedInstance].currentRoute.outputs.firstObject;
    if (output != nil) {
      postEvent(self.eventSink, @{
        @"event" : @"onAudioRouteChange",
        @"deviceId" : output.UID ?: @"",
        @"label" : output.portName ?: @"",
        @"groupId" : output.portType ?: @"",
      });
    }
  }

  // When stereo playout is preferred, debounce-refresh stereo playout state
  // after route changes so stereo is re-evaluated for the new audio device.
  if (_stereoPlayoutPreferred) {
    // Cancel any previously scheduled debounce block
    if (_stereoRefreshDebounceBlock != nil) {
      dispatch_block_cancel(_stereoRefreshDebounceBlock);
      _stereoRefreshDebounceBlock = nil;
    }

    __weak typeof(self) weakSelf = self;
    _stereoRefreshDebounceBlock = dispatch_block_create(0, ^{
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (strongSelf == nil)
        return;
      // Refresh every active factory's ADM so the new route is re-evaluated
      NSLog(@"FlutterWebRTCPlugin: refreshing stereo playout state on all factories");
      NSArray<NativePeerConnectionFactory*>* snapshot;
      @synchronized(strongSelf) {
        snapshot = [strongSelf.factories.allValues copy];
      }
      for (NativePeerConnectionFactory* nf in snapshot) {
        RTCAudioDeviceModule* adm = nf.audioDeviceModule;
        if (adm != nil) {
          // Run on the factory's serial ADM queue
          dispatch_async(nf.admQueue, ^{
            [adm refreshStereoPlayoutState];
          });
        }
      }
      strongSelf->_stereoRefreshDebounceBlock = nil;
    });

    // Debounce for 2 seconds (matching Swift SDK behavior)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), _stereoRefreshDebounceBlock);
  }
#endif
}

- (void)handleInterruption:(NSNotification*)notification {
#if TARGET_OS_IPHONE
  NSDictionary* info = notification.userInfo;
  AVAudioSessionInterruptionType type =
      [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];

  if (type == AVAudioSessionInterruptionTypeBegan) {
    postEvent(self.eventSink, @{@"event" : @"onInterruptionStart"});
  } else if (type == AVAudioSessionInterruptionTypeEnded) {
    postEvent(self.eventSink, @{@"event" : @"onInterruptionEnd"});
  }
#endif
}

- (void)initLoggerCallback:(RTCLoggingSeverity)severity {
  if (loggerCallback == nil) {
    loggerCallback = [RTC_OBJC_TYPE(RTCCallbackLogger) new];
    [loggerCallback start:^(NSString* logMessage) {
      postEvent(self.eventSink, @{@"event" : @"onLogData", @"data" : logMessage});
    }];
  }

  loggerCallback.severity = severity;
}

- (RTCLoggingSeverity)str2LogSeverity:(NSString*)str {
  if ([@"verbose" isEqualToString:str]) {
    return RTCLoggingSeverityVerbose;
  } else if ([@"info" isEqualToString:str]) {
    return RTCLoggingSeverityInfo;
  } else if ([@"warning" isEqualToString:str]) {
    return RTCLoggingSeverityWarning;
  } else if ([@"error" isEqualToString:str]) {
    return RTCLoggingSeverityError;
  } else if ([@"none" isEqualToString:str]) {
    return RTCLoggingSeverityNone;
  }

  return RTCLoggingSeverityNone;
}

- (void)initialize:(NSArray*)networkIgnoreMask
    bypassVoiceProcessing:(BOOL)bypassVoiceProcessing
         appleAudioConfig:(NSDictionary*)appleAudioConfig
                 severity:(RTCLoggingSeverity)severity {
  // RTCSetMinDebugLogLevel(severity);
  [self initLoggerCallback:severity];

  RTCInitializeSnapshot* snapshot = [RTCInitializeSnapshot new];
  snapshot.bypassVoiceProcessing = bypassVoiceProcessing;
  snapshot.networkIgnoreMask = networkIgnoreMask ?: @[];
  snapshot.appleAudioConfiguration = appleAudioConfig;
  @synchronized(self) {
    _initializeSnapshot = snapshot;
  }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"initialize" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSDictionary* options = argsMap[@"options"];
    BOOL enableBypassVoiceProcessing = NO;
    if (options[@"bypassVoiceProcessing"] != nil) {
      enableBypassVoiceProcessing = ((NSNumber*)options[@"bypassVoiceProcessing"]).boolValue;
    }
    NSArray* networkIgnoreMask = [NSArray new];
    if (options[@"networkIgnoreMask"] != nil) {
      networkIgnoreMask = ((NSArray*)options[@"networkIgnoreMask"]);
    }
    RTCLoggingSeverity severity = RTCLoggingSeverityNone;
    if (options[@"logSeverity"] != nil) {
      NSString* severityStr = ((NSString*)options[@"logSeverity"]);
      severity = [self str2LogSeverity:severityStr];
    }
    NSDictionary* appleAudioConfig = nil;
    if ([options[@"appleAudioConfiguration"] isKindOfClass:[NSDictionary class]]) {
      appleAudioConfig = options[@"appleAudioConfiguration"];
    }

    [self initialize:networkIgnoreMask
        bypassVoiceProcessing:enableBypassVoiceProcessing
             appleAudioConfig:appleAudioConfig
                     severity:severity];
    result(@"");
  } else if ([@"createPeerConnectionFactory" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSDictionary* createOptions = argsMap[@"options"] ?: @{};
    BOOL bypass = NO;
    if (createOptions[@"bypassVoiceProcessing"] != nil) {
      bypass = ((NSNumber*)createOptions[@"bypassVoiceProcessing"]).boolValue;
    }
    NSArray* mask = createOptions[@"networkIgnoreMask"] ?: @[];
    NSDictionary* audioConfig = nil;
    if ([createOptions[@"appleAudioConfiguration"] isKindOfClass:[NSDictionary class]]) {
      audioConfig = createOptions[@"appleAudioConfiguration"];
    }
    NSString* factoryId = [[NSUUID UUID] UUIDString];
    NativePeerConnectionFactory* nf =
        [[NativePeerConnectionFactory alloc] initWithFactoryId:factoryId
                                         bypassVoiceProcessing:bypass
                                             networkIgnoreMask:mask
                                         audioProcessingModule:_audioManager.audioProcessingModule
                                       appleAudioConfiguration:audioConfig
                                                   admObserver:self];
    @synchronized(self) {
      _factories[factoryId] = nf;
    }
    NSLog(@"[createPeerConnectionFactory] built id: %@", factoryId);
#if TARGET_OS_IPHONE
    // Replay any process-wide ADM prefs that were set before this factory
    // existed (notably the stereo-playout preference set by the SDK during
    // StreamVideo init). Without this, per-call factories created later
    // miss the stereo-playout settings and incoming Opus stereo plays mono.
    [self applyPersistentAdmStateToFactory:nf];
    if (audioConfig != nil) {
      // Apply the factory's audio configuration on the audio-session queue
      // rather than on main, ordered with every other AVAudioSession change,
      // and reply once it has been attempted so the factory id only reaches
      // Dart after the session was configured, as before. A configuration the
      // session rejects is logged and does not fail the factory, as before.
      NSDictionary* configuration = [audioConfig copy];
      dispatch_async(_audioSessionQueue, ^{
        NSError* error = nil;
        if ([AudioUtils setAppleAudioConfiguration:configuration error:&error]) {
          // A setAppleAudioConfiguration queued earlier may have already merged
          // its configuration into this factory's snapshot; the session is now
          // on this configuration, so the snapshot has to be as well.
          nf.audioConfigSnapshot = configuration;
        } else {
          NSLog(@"[createPeerConnectionFactory] audio configuration failed for id %@: %@",
                factoryId, error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
          result(@{@"factoryId" : factoryId});
        });
      });
      return;
    }
#endif
    result(@{@"factoryId" : factoryId});
  } else if ([@"disposePeerConnectionFactory" isEqualToString:call.method]) {
    // Close the connections the SDK left open the same way peerConnectionClose
    // does: off main, behind the calls still queued for them, with the cleanup
    // back on main.
    NSString* factoryIdArg = call.arguments[@"factoryId"];
    NativePeerConnectionFactory* disposing = nil;
    if (factoryIdArg != nil) {
      @synchronized(self) {
        disposing = _factories[factoryIdArg];
      }
    }
    if (disposing != nil) {
      [_disposingFactoryIds addObject:factoryIdArg];
    }
    for (NSString* pcId in [disposing.ownedPcIds.allObjects copy]) {
      if (self.peerConnections[pcId] != nil) {
        [self closePeerConnectionWithId:pcId
                                 result:^(id _Nullable value){
                                 }];
      }
    }
    // Peer connections of this factory may still be closing on
    // _peerConnectionCloseQueue. Going through that queue first waits for them,
    // and their main-thread cleanup is queued ahead of this disposal.
    dispatch_async(_peerConnectionCloseQueue, ^{
      dispatch_async(dispatch_get_main_queue(), ^{
        [self disposePeerConnectionFactory:call result:result];
        if (factoryIdArg != nil) {
          [self->_disposingFactoryIds removeObject:factoryIdArg];
        }
      });
    });
  } else if ([@"setVideoEffects" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    NSArray* names = argsMap[@"names"];

    [self mediaStreamTrackSetVideoEffects:trackId names:names];
    result(nil);
  } else if ([@"handleCallInterruptionCallbacks" isEqualToString:call.method]) {
#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
#endif
    result(@"");
  } else if ([@"createPeerConnection" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSDictionary* configuration = argsMap[@"configuration"];
    NSDictionary* constraints = argsMap[@"constraints"];
    NSString* factoryIdArg = argsMap[@"factoryId"];

    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryIdArg];
    if (nf == nil) {
      result([FlutterError
          errorWithCode:@"createPeerConnection"
                message:[NSString stringWithFormat:@"unknown factoryId %@", factoryIdArg]
                details:nil]);
      return;
    }
    if ([_disposingFactoryIds containsObject:factoryIdArg]) {
      result([FlutterError
          errorWithCode:@"createPeerConnection"
                message:[NSString stringWithFormat:@"factoryId %@ is being disposed", factoryIdArg]
                details:nil]);
      return;
    }

    RTCPeerConnection* peerConnection =
        [nf.factory peerConnectionWithConfiguration:[self RTCConfiguration:configuration]
                                        constraints:[self parseMediaConstraints:constraints]
                                           delegate:self];

    peerConnection.remoteStreams = [NSMutableDictionary new];
    peerConnection.remoteTracks = [NSMutableDictionary new];
    peerConnection.dataChannels = [NSMutableDictionary new];

    NSString* peerConnectionId = [[NSUUID UUID] UUIDString];
    peerConnection.flutterId = peerConnectionId;
    peerConnection.operationQueue = dispatch_queue_create(
        "io.getstream.webrtc.flutter.peerConnectionOperation",
        dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0));

    /*Create Event Channel.*/
    peerConnection.eventChannel = [FlutterEventChannel
        eventChannelWithName:[NSString stringWithFormat:@"FlutterWebRTC/peerConnectionEvent%@",
                                                        peerConnectionId]
             binaryMessenger:_messenger];
    [peerConnection.eventChannel setStreamHandler:peerConnection];

    self.peerConnections[peerConnectionId] = peerConnection;

    self.pcFactoryId[peerConnectionId] = factoryIdArg;
    [nf.ownedPcIds addObject:peerConnectionId];
    result(@{@"peerConnectionId" : peerConnectionId});
  } else if ([@"getUserMedia" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSDictionary* constraints = argsMap[@"constraints"];
    NSString* factoryId = argsMap[@"factoryId"];
    [self getUserMedia:constraints factoryId:factoryId result:result];
  } else if ([@"getDisplayMedia" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSDictionary* constraints = argsMap[@"constraints"];
    NSString* factoryId = argsMap[@"factoryId"];
    [self getDisplayMedia:constraints factoryId:factoryId result:result];
  } else if ([@"createLocalMediaStream" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    [self createLocalMediaStream:factoryId result:result];
  } else if ([@"getSources" isEqualToString:call.method]) {
    [self getSources:result];
  } else if ([@"selectAudioInput" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* deviceId = argsMap[@"deviceId"];
    [self selectAudioInput:deviceId result:result];
  } else if ([@"selectAudioOutput" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* deviceId = argsMap[@"deviceId"];
    [self selectAudioOutput:deviceId result:result];
  } else if ([@"triggeriOSAudioRouteSelectionUI" isEqualToString:call.method]) {
    [self triggeriOSAudioRouteSelectionUI:result];
  } else if ([@"mediaStreamGetTracks" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* streamId = argsMap[@"streamId"];
    [self mediaStreamGetTracks:streamId result:result];
  } else if ([@"createOffer" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSDictionary* constraints = argsMap[@"constraints"];
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      [self peerConnectionCreateOffer:constraints peerConnection:peerConnection result:result];
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"createAnswer" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSDictionary* constraints = argsMap[@"constraints"];
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      [self peerConnectionCreateAnswer:constraints peerConnection:peerConnection result:result];
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"addStream" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;

    NSString* streamId = ((NSString*)argsMap[@"streamId"]);
    RTCMediaStream* stream = self.localStreams[streamId];

    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];

    if (peerConnection && stream) {
      // On the connection's queue, in order with the description calls.
      FlutterResult reply = FlutterRTCReplyOnMain(result);
      FlutterRTCRunOnOperationQueue(peerConnection, ^{
        [peerConnection addStream:stream];
        reply(@"");
      });
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString
                            stringWithFormat:@"Error: peerConnection or mediaStream not found!"]
                details:nil]);
    }
  } else if ([@"removeStream" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;

    NSString* streamId = ((NSString*)argsMap[@"streamId"]);
    RTCMediaStream* stream = self.localStreams[streamId];

    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];

    if (peerConnection && stream) {
      // On the connection's queue, in order with the description calls.
      FlutterResult reply = FlutterRTCReplyOnMain(result);
      FlutterRTCRunOnOperationQueue(peerConnection, ^{
        [peerConnection removeStream:stream];
        reply(nil);
      });
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString
                            stringWithFormat:@"Error: peerConnection or mediaStream not found!"]
                details:nil]);
    }
  } else if ([@"captureFrame" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* path = argsMap[@"path"];
    NSString* trackId = argsMap[@"trackId"];
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];

    RTCMediaStreamTrack* track = [self trackForId:trackId peerConnectionId:peerConnectionId];
    if (track != nil && [track isKindOfClass:[RTCVideoTrack class]]) {
      RTCVideoTrack* videoTrack = (RTCVideoTrack*)track;
      [self mediaStreamTrackCaptureFrame:videoTrack toPath:path result:result];
    } else {
      if (track == nil) {
        result([FlutterError errorWithCode:@"Track is nil" message:nil details:nil]);
      } else {
        result([FlutterError errorWithCode:[@"Track is class of "
                                               stringByAppendingString:[[track class] description]]
                                   message:nil
                                   details:nil]);
      }
    }
  } else if ([@"setLocalDescription" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    NSDictionary* descriptionMap = argsMap[@"description"];
    NSString* sdp = descriptionMap[@"sdp"];
    RTCSdpType sdpType = [RTCSessionDescription typeForString:descriptionMap[@"type"]];
    RTCSessionDescription* description = [[RTCSessionDescription alloc] initWithType:sdpType
                                                                                 sdp:sdp];
    if (peerConnection) {
      [self peerConnectionSetLocalDescription:description
                               peerConnection:peerConnection
                                       result:result];
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"setRemoteDescription" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    NSDictionary* descriptionMap = argsMap[@"description"];
    NSString* sdp = descriptionMap[@"sdp"];
    RTCSdpType sdpType = [RTCSessionDescription typeForString:descriptionMap[@"type"]];
    RTCSessionDescription* description = [[RTCSessionDescription alloc] initWithType:sdpType
                                                                                 sdp:sdp];

    if (peerConnection) {
      [self peerConnectionSetRemoteDescription:description
                                peerConnection:peerConnection
                                        result:result];
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"sendDtmf" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* tone = argsMap[@"tone"];
    int duration = ((NSNumber*)argsMap[@"duration"]).intValue;
    int interToneGap = ((NSNumber*)argsMap[@"gap"]).intValue;

    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      RTCRtpSender* audioSender = nil;
      for (RTCRtpSender* rtpSender in peerConnection.senders) {
        if ([[[rtpSender track] kind] isEqualToString:@"audio"]) {
          audioSender = rtpSender;
        }
      }
      if (audioSender) {
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
          double durationMs = duration / 1000.0;
          double interToneGapMs = interToneGap / 1000.0;
          [audioSender.dtmfSender insertDtmf:(NSString*)tone
                                    duration:(NSTimeInterval)durationMs
                                interToneGap:(NSTimeInterval)interToneGapMs];
          NSLog(@"DTMF Tone played ");
        }];
      }

      result(@{@"result" : @"success"});
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"addCandidate" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSDictionary* candMap = argsMap[@"candidate"];
    NSString* sdp = candMap[@"candidate"];
    id sdpMLineIndexValue = candMap[@"sdpMLineIndex"];
    int sdpMLineIndex = 0;
    if (![sdpMLineIndexValue isKindOfClass:[NSNull class]]) {
      sdpMLineIndex = ((NSNumber*)candMap[@"sdpMLineIndex"]).intValue;
    }
    NSString* sdpMid = candMap[@"sdpMid"];

    RTCIceCandidate* candidate = [[RTCIceCandidate alloc] initWithSdp:sdp
                                                        sdpMLineIndex:sdpMLineIndex
                                                               sdpMid:sdpMid];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];

    if (peerConnection) {
      [self peerConnectionAddICECandidate:candidate peerConnection:peerConnection result:result];
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"getStats" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    id trackId = argsMap[@"trackId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      // Off main, behind the connection's queued calls: collecting stats is a
      // blocking call into the signaling thread, which a description call may
      // hold for as long as it waits for the audio session.
      FlutterResult reply = FlutterRTCReplyOnMain(result);
      FlutterRTCRunOnOperationQueue(peerConnection, ^{
        if (trackId != nil && trackId != [NSNull null]) {
          [self peerConnectionGetStatsForTrackId:trackId
                                  peerConnection:peerConnection
                                          result:reply];
        } else {
          [self peerConnectionGetStats:peerConnection result:reply];
        }
      });
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"createDataChannel" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* label = argsMap[@"label"];
    NSDictionary* dataChannelDict = (NSDictionary*)argsMap[@"dataChannelDict"];
    [self createDataChannel:peerConnectionId
                      label:label
                     config:[self RTCDataChannelConfiguration:dataChannelDict]
                  messenger:_messenger
                     result:result];
  } else if ([@"dataChannelSend" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* dataChannelId = argsMap[@"dataChannelId"];
    NSString* type = argsMap[@"type"];
    id data = argsMap[@"data"];

    [self dataChannelSend:peerConnectionId dataChannelId:dataChannelId data:data type:type];
    result(nil);
  } else if ([@"dataChannelGetBufferedAmount" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* dataChannelId = argsMap[@"dataChannelId"];

    [self dataChannelGetBufferedAmount:peerConnectionId dataChannelId:dataChannelId result:result];
  } else if ([@"dataChannelClose" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* dataChannelId = argsMap[@"dataChannelId"];
    [self dataChannelClose:peerConnectionId dataChannelId:dataChannelId];
    result(nil);
  } else if ([@"streamDispose" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* streamId = argsMap[@"streamId"];
    RTCMediaStream* stream = self.localStreams[streamId];
    NativePeerConnectionFactory* ownerNf = [self resolveFactoryForStreamId:streamId];
    BOOL shouldCallResult = YES;
    if (stream) {
      for (RTCVideoTrack* track in stream.videoTracks) {
        [_localTracks removeObjectForKey:track.trackId];
        [self.trackFactoryId removeObjectForKey:track.trackId];
        if (ownerNf != nil) {
          [ownerNf.ownedTrackIds removeObject:track.trackId];
        }
        RTCVideoTrack* videoTrack = (RTCVideoTrack*)track;
        FlutterRTCVideoRenderer* renderer = [self findRendererByTrackId:videoTrack.trackId];
        if (renderer != nil) {
          renderer.videoTrack = nil;
        }
        CapturerStopHandler stopHandler = self.videoCapturerStopHandlers[videoTrack.trackId];
        if (stopHandler) {
          shouldCallResult = NO;
          stopHandler(^{
            // The stop handler itself clears `videoCapturer`, and only when it
            // is still the capturer that stopped.
            NSLog(@"video capturer stopped, trackID = %@", videoTrack.trackId);
            result(nil);
          });
          [self.videoCapturerStopHandlers removeObjectForKey:videoTrack.trackId];
          [self.videoCaptureState removeObjectForKey:videoTrack.trackId];
        }
      }
      for (RTCAudioTrack* track in stream.audioTracks) {
        [_localTracks removeObjectForKey:track.trackId];
        [self.trackFactoryId removeObjectForKey:track.trackId];
        if (ownerNf != nil) {
          [ownerNf.ownedTrackIds removeObject:track.trackId];
        }
      }
      [self.localStreams removeObjectForKey:streamId];
      [self deactiveRtcAudioSession];
    }
    if (ownerNf != nil) {
      [ownerNf.ownedStreamIds removeObject:streamId];
    }
    if (shouldCallResult) {
      // do not call if will be called in stopCapturer above.
      result(nil);
    }
  } else if ([@"mediaStreamTrackSetEnable" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    NSNumber* enabled = argsMap[@"enabled"];
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];

    RTCMediaStreamTrack* track = [self trackForId:trackId peerConnectionId:peerConnectionId];
    if (track != nil) {
      @try {
        track.isEnabled = enabled.boolValue;
      } @catch (NSException* e) {
        NSLog(@"mediaStreamTrackSetEnable: track %@ stale: %@", trackId, e);
      }
    }
    result(nil);
  } else if ([@"mediaStreamAddTrack" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* streamId = argsMap[@"streamId"];
    NSString* trackId = argsMap[@"trackId"];

    RTCMediaStream* stream = self.localStreams[streamId];
    if (stream) {
      RTCMediaStreamTrack* track = [self trackForId:trackId peerConnectionId:nil];
      if (track != nil) {
        if ([track isKindOfClass:[RTCAudioTrack class]]) {
          RTCAudioTrack* audioTrack = (RTCAudioTrack*)track;
          [stream addAudioTrack:audioTrack];
        } else if ([track isKindOfClass:[RTCVideoTrack class]]) {
          RTCVideoTrack* videoTrack = (RTCVideoTrack*)track;
          [stream addVideoTrack:videoTrack];
        }
      } else {
        result([FlutterError errorWithCode:@"mediaStreamAddTrack: Track is nil"
                                   message:nil
                                   details:nil]);
      }
    } else {
      result([FlutterError errorWithCode:@"mediaStreamAddTrack: Stream is nil"
                                 message:nil
                                 details:nil]);
    }
    result(nil);
  } else if ([@"mediaStreamRemoveTrack" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* streamId = argsMap[@"streamId"];
    NSString* trackId = argsMap[@"trackId"];
    RTCMediaStream* stream = self.localStreams[streamId];
    if (stream) {
      id<LocalTrack> track = self.localTracks[trackId];
      if (track != nil) {
        if ([track isKindOfClass:[LocalAudioTrack class]]) {
          RTCAudioTrack* audioTrack = ((LocalAudioTrack*)track).audioTrack;
          [stream removeAudioTrack:audioTrack];
        } else if ([track isKindOfClass:[LocalVideoTrack class]]) {
          RTCVideoTrack* videoTrack = ((LocalVideoTrack*)track).videoTrack;
          [stream removeVideoTrack:videoTrack];
        }
      } else {
        result([FlutterError errorWithCode:@"mediaStreamRemoveTrack: Track is nil"
                                   message:nil
                                   details:nil]);
      }
    } else {
      result([FlutterError errorWithCode:@"mediaStreamRemoveTrack: Stream is nil"
                                 message:nil
                                 details:nil]);
    }
    result(nil);
  } else if ([@"trackDispose" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    BOOL audioTrack = NO;
    for (NSString* streamId in self.localStreams) {
      RTCMediaStream* stream = [self.localStreams objectForKey:streamId];
      for (RTCAudioTrack* track in stream.audioTracks) {
        if ([trackId isEqualToString:track.trackId]) {
          [stream removeAudioTrack:track];
          audioTrack = YES;
        }
      }
      for (RTCVideoTrack* track in stream.videoTracks) {
        if ([trackId isEqualToString:track.trackId]) {
          [stream removeVideoTrack:track];
          CapturerStopHandler stopHandler = self.videoCapturerStopHandlers[track.trackId];
          if (stopHandler) {
            stopHandler(^{
              NSLog(@"video capturer stopped, trackID = %@", track.trackId);
            });
            [self.videoCapturerStopHandlers removeObjectForKey:track.trackId];
            [self.videoCaptureState removeObjectForKey:track.trackId];
          }
        }
      }
    }
    NSString* ownerFactoryId = self.trackFactoryId[trackId];
    [_localTracks removeObjectForKey:trackId];
    [self.trackFactoryId removeObjectForKey:trackId];
    if (ownerFactoryId != nil) {
      NativePeerConnectionFactory* ownerNf = [self resolveFactoryForId:ownerFactoryId];
      if (ownerNf != nil) {
        [ownerNf.ownedTrackIds removeObject:trackId];
      }
    }
    if (audioTrack) {
      [self ensureAudioSession];
    }
    FlutterRTCVideoRenderer* renderer = [self findRendererByTrackId:trackId];
    if (renderer != nil) {
      renderer.videoTrack = nil;
    }
    result(nil);
  } else if ([@"restartIce" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (!peerConnection) {
      result([FlutterError errorWithCode:@"restartIce: peerConnection is nil"
                                 message:nil
                                 details:nil]);
    } else {
      // On the connection's queue, in order with the description calls.
      FlutterResult reply = FlutterRTCReplyOnMain(result);
      FlutterRTCRunOnOperationQueue(peerConnection, ^{
        [peerConnection restartIce];
        reply(nil);
      });
    }
  } else if ([@"peerConnectionClose" isEqualToString:call.method] ||
             [@"peerConnectionDispose" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    if (peerConnectionId == nil) {
      // Nothing to close; removeObjectForKey:nil below would throw.
      result(nil);
      return;
    }

    [self closePeerConnectionWithId:peerConnectionId result:result];
  } else if ([@"createVideoRenderer" isEqualToString:call.method]) {
    FlutterRTCVideoRenderer* render = [self createWithTextureRegistry:_textures
                                                            messenger:_messenger];
    self.renders[@(render.textureId)] = render;
    result(@{@"textureId" : @(render.textureId)});
  } else if ([@"videoRendererDispose" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSNumber* textureId = argsMap[@"textureId"];
    FlutterRTCVideoRenderer* render = self.renders[textureId];
    if (render != nil) {
      render.videoTrack = nil;
      [render dispose];
      [self.renders removeObjectForKey:textureId];
    }
    result(nil);
  } else if ([@"videoRendererSetSrcObject" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSNumber* textureId = argsMap[@"textureId"];
    FlutterRTCVideoRenderer* render = self.renders[textureId];
    NSString* streamId = argsMap[@"streamId"];
    NSString* ownerTag = argsMap[@"ownerTag"];
    NSString* trackId = argsMap[@"trackId"];
    if (!render) {
      result([FlutterError errorWithCode:@"videoRendererSetSrcObject: render is nil"
                                 message:nil
                                 details:nil]);
      return;
    }
    RTCMediaStream* stream = nil;
    RTCVideoTrack* videoTrack = nil;
    if ([ownerTag isEqualToString:@"local"]) {
      stream = _localStreams[streamId];
    }
    if (!stream) {
      stream = [self streamForId:streamId peerConnectionId:ownerTag];
    }
    if (stream) {
      NSArray* videoTracks = stream ? stream.videoTracks : nil;
      videoTrack = videoTracks && videoTracks.count ? videoTracks[0] : nil;
      for (RTCVideoTrack* track in videoTracks) {
        if ([track.trackId isEqualToString:trackId]) {
          videoTrack = track;
        }
      }
      if (!videoTrack) {
        NSLog(@"Not found video track for RTCMediaStream: %@", streamId);
      }
    }
    [self rendererSetSrcObject:render stream:videoTrack];
    result(nil);
  }
#if TARGET_OS_IPHONE
  else if ([@"videoPlatformViewRendererSetSrcObject" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSNumber* viewId = argsMap[@"viewId"];
    FlutterRTCVideoPlatformViewController* render = _platformViewFactory.renders[viewId];
    NSString* streamId = argsMap[@"streamId"];
    NSString* ownerTag = argsMap[@"ownerTag"];
    NSString* trackId = argsMap[@"trackId"];
    if (!render) {
      result([FlutterError errorWithCode:@"videoRendererSetSrcObject: render is nil"
                                 message:nil
                                 details:nil]);
      return;
    }
    RTCMediaStream* stream = nil;
    RTCVideoTrack* videoTrack = nil;
    if ([ownerTag isEqualToString:@"local"]) {
      stream = _localStreams[streamId];
    }
    if (!stream) {
      stream = [self streamForId:streamId peerConnectionId:ownerTag];
    }
    if (stream) {
      NSArray* videoTracks = stream ? stream.videoTracks : nil;
      videoTrack = videoTracks && videoTracks.count ? videoTracks[0] : nil;
      for (RTCVideoTrack* track in videoTracks) {
        if ([track.trackId isEqualToString:trackId]) {
          videoTrack = track;
        }
      }
      if (!videoTrack) {
        NSLog(@"Not found video track for RTCMediaStream: %@", streamId);
      }
    }
    render.videoTrack = videoTrack;
    result(nil);
  } else if ([@"videoPlatformViewRendererDispose" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSNumber* viewId = argsMap[@"viewId"];
    FlutterRTCVideoPlatformViewController* render = _platformViewFactory.renders[viewId];
    if (render != nil) {
      render.videoTrack = nil;
      [_platformViewFactory.renders removeObjectForKey:viewId];
    }
    result(nil);
  }
#endif
  else if ([@"enableIOSMultitaskingCameraAccess" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    BOOL enable = [argsMap[@"enable"] boolValue];

    [self enableMultitaskingCameraAccess:enable result:result];
  } else if ([@"isIOSMultitaskingCameraAccessSupported" isEqualToString:call.method]) {
    [self multitaskingCameraAccessSupported:result];
  } else if ([@"mediaStreamTrackHasTorch" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    id<LocalTrack> track = self.localTracks[trackId];
    if (track != nil && [track isKindOfClass:[LocalVideoTrack class]]) {
      RTCVideoTrack* videoTrack = ((LocalVideoTrack*)track).videoTrack;
      [self mediaStreamTrackHasTorch:videoTrack result:result];
    } else {
      if (track == nil) {
        result([FlutterError errorWithCode:@"Track is nil" message:nil details:nil]);
      } else {
        result([FlutterError errorWithCode:[@"Track is class of "
                                               stringByAppendingString:[[track class] description]]
                                   message:nil
                                   details:nil]);
      }
    }
  } else if ([@"mediaStreamTrackSetTorch" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    BOOL torch = [argsMap[@"torch"] boolValue];
    id<LocalTrack> track = self.localTracks[trackId];
    if (track != nil && [track isKindOfClass:[LocalVideoTrack class]]) {
      RTCVideoTrack* videoTrack = ((LocalVideoTrack*)track).videoTrack;
      [self mediaStreamTrackSetTorch:videoTrack torch:torch result:result];
    } else {
      if (track == nil) {
        result([FlutterError errorWithCode:@"Track is nil" message:nil details:nil]);
      } else {
        result([FlutterError errorWithCode:[@"Track is class of "
                                               stringByAppendingString:[[track class] description]]
                                   message:nil
                                   details:nil]);
      }
    }
  } else if ([@"mediaStreamTrackSetZoom" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    double zoomLevel = [argsMap[@"zoomLevel"] doubleValue];
    id<LocalTrack> track = self.localTracks[trackId];
    if (track != nil && [track isKindOfClass:[LocalVideoTrack class]]) {
      RTCVideoTrack* videoTrack = ((LocalVideoTrack*)track).videoTrack;
      [self mediaStreamTrackSetZoom:videoTrack zoomLevel:zoomLevel result:result];
    } else {
      if (track == nil) {
        result([FlutterError errorWithCode:@"Track is nil" message:nil details:nil]);
      } else {
        result([FlutterError errorWithCode:[@"Track is class of "
                                               stringByAppendingString:[[track class] description]]
                                   message:nil
                                   details:nil]);
      }
    }
  } else if ([@"mediaStreamTrackSetFocusMode" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    NSString* focusMode = argsMap[@"focusMode"];
    id<LocalTrack> track = self.localTracks[trackId];
    if (track != nil && focusMode != nil && [track isKindOfClass:[LocalVideoTrack class]]) {
      RTCVideoTrack* videoTrack = (RTCVideoTrack*)track.track;
      [self mediaStreamTrackSetFocusMode:videoTrack focusMode:focusMode result:result];
    } else {
      if (track == nil) {
        result([FlutterError errorWithCode:@"Track is nil" message:nil details:nil]);
      } else {
        result([FlutterError errorWithCode:[@"Track is class of "
                                               stringByAppendingString:[[track class] description]]
                                   message:nil
                                   details:nil]);
      }
    }
  } else if ([@"mediaStreamTrackSetFocusPoint" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    NSDictionary* focusPoint = argsMap[@"focusPoint"];
    id<LocalTrack> track = self.localTracks[trackId];
    if (track != nil && focusPoint != nil && [track isKindOfClass:[LocalVideoTrack class]]) {
      RTCVideoTrack* videoTrack = (RTCVideoTrack*)track.track;
      [self mediaStreamTrackSetFocusPoint:videoTrack focusPoint:focusPoint result:result];
    } else {
      if (track == nil) {
        result([FlutterError errorWithCode:@"Track is nil" message:nil details:nil]);
      } else {
        result([FlutterError errorWithCode:[@"Track is class of "
                                               stringByAppendingString:[[track class] description]]
                                   message:nil
                                   details:nil]);
      }
    }
  } else if ([@"mediaStreamTrackSetExposureMode" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    NSString* exposureMode = argsMap[@"exposureMode"];
    id<LocalTrack> track = self.localTracks[trackId];
    if (track != nil && exposureMode != nil && [track isKindOfClass:[LocalVideoTrack class]]) {
      RTCVideoTrack* videoTrack = (RTCVideoTrack*)track.track;
      [self mediaStreamTrackSetExposureMode:videoTrack exposureMode:exposureMode result:result];
    } else {
      if (track == nil) {
        result([FlutterError errorWithCode:@"Track is nil" message:nil details:nil]);
      } else {
        result([FlutterError errorWithCode:[@"Track is class of "
                                               stringByAppendingString:[[track class] description]]
                                   message:nil
                                   details:nil]);
      }
    }
  } else if ([@"mediaStreamTrackSetExposurePoint" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    NSDictionary* exposurePoint = argsMap[@"exposurePoint"];
    id<LocalTrack> track = self.localTracks[trackId];
    if (track != nil && exposurePoint != nil && [track isKindOfClass:[LocalVideoTrack class]]) {
      RTCVideoTrack* videoTrack = (RTCVideoTrack*)track.track;
      [self mediaStreamTrackSetExposurePoint:videoTrack exposurePoint:exposurePoint result:result];
    } else {
      if (track == nil) {
        result([FlutterError errorWithCode:@"Track is nil" message:nil details:nil]);
      } else {
        result([FlutterError errorWithCode:[@"Track is class of "
                                               stringByAppendingString:[[track class] description]]
                                   message:nil
                                   details:nil]);
      }
    }
  } else if ([@"mediaStreamTrackSwitchCamera" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    id<LocalTrack> track = self.localTracks[trackId];
    if (track != nil && [track isKindOfClass:[LocalVideoTrack class]]) {
      RTCVideoTrack* videoTrack = (RTCVideoTrack*)track.track;
      [self mediaStreamTrackSwitchCamera:videoTrack result:result];
    } else {
      if (track == nil) {
        result([FlutterError errorWithCode:@"Track is nil" message:nil details:nil]);
      } else {
        result([FlutterError errorWithCode:[@"Track is class of "
                                               stringByAppendingString:[[track class] description]]
                                   message:nil
                                   details:nil]);
      }
    }
  } else if ([@"setVolume" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    NSNumber* volume = argsMap[@"volume"];
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];

    RTCMediaStreamTrack* track = [self trackForId:trackId peerConnectionId:peerConnectionId];
    if (track != nil && [track isKindOfClass:[RTCAudioTrack class]]) {
      RTCAudioTrack* audioTrack = (RTCAudioTrack*)track;
      RTCAudioSource* audioSource = audioTrack.source;
      self.trackVolumeCache[trackId] = volume;
      if (self.pausedTrackVolumes[trackId] != nil) {
        self.pausedTrackVolumes[trackId] = volume;
        audioSource.volume = 0.0;
      } else {
        audioSource.volume = [volume doubleValue];
      }
    }
    result(nil);
  } else if ([@"trackClone" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    RTCMediaStreamTrack* track = [self cloneTrack:trackId];

    if (track == nil) {
      result([FlutterError errorWithCode:@"TRACK_CLONE_FAILED"
                                 message:@"Cannot clone track: source factory not found"
                                 details:@{@"trackId" : trackId ?: [NSNull null]}]);
    } else {
      result([self mediaTrackToMap:track]);
    }
  } else if ([@"setMicrophoneMute" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* trackId = argsMap[@"trackId"];
    NSNumber* mute = argsMap[@"mute"];
    id<LocalTrack> track = self.localTracks[trackId];
    if (track != nil && [track isKindOfClass:[LocalAudioTrack class]]) {
      RTCAudioTrack* audioTrack = ((LocalAudioTrack*)track).audioTrack;
      audioTrack.isEnabled = !mute.boolValue;
    }
    result(nil);
  }
#if TARGET_OS_IPHONE
  else if ([@"enableSpeakerphone" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSNumber* enable = argsMap[@"enable"];
    BOOL speakerOn = enable.boolValue;
    dispatch_async(_audioSessionQueue, ^{
      [AudioUtils setSpeakerphoneOn:speakerOn];
      dispatch_async(dispatch_get_main_queue(), ^{
        // Only flip the flags once the route is applied.
        self->_speakerOn = speakerOn;
        self->_speakerOnButPreferBluetooth = NO;
        postEvent(self.eventSink, @{@"event" : @"onDeviceChange"});
        result(nil);
      });
    });
  } else if ([@"ensureAudioSession" isEqualToString:call.method]) {
    [self ensureAudioSession];
    // Reply once the enqueued reconfiguration has run.
    dispatch_async(_audioSessionQueue, ^{
      dispatch_async(dispatch_get_main_queue(), ^{
        result(nil);
      });
    });
  } else if ([@"enableSpeakerphoneButPreferBluetooth" isEqualToString:call.method]) {
    dispatch_async(_audioSessionQueue, ^{
      [AudioUtils setSpeakerphoneOnButPreferBluetooth];
      dispatch_async(dispatch_get_main_queue(), ^{
        self->_speakerOn = YES;
        self->_speakerOnButPreferBluetooth = YES;
        result(nil);
      });
    });
  } else if ([@"setAppleAudioConfiguration" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSDictionary* configuration = argsMap[@"configuration"];
    if (![configuration isKindOfClass:[NSDictionary class]]) {
      configuration = nil;
    }
    dispatch_async(_audioSessionQueue, ^{
      NSError* error = nil;
      if (![AudioUtils setAppleAudioConfiguration:configuration error:&error]) {
        // The snapshots are left as they were: resume must not restore a
        // configuration the session has rejected.
        dispatch_async(dispatch_get_main_queue(), ^{
          result([FlutterError errorWithCode:@"setAppleAudioConfiguration"
                                     message:error.localizedDescription
                                     details:nil]);
        });
        return;
      }
      if (configuration != nil) {
        // resumeAudioPeerConnectionFactory restores each factory's snapshot, so
        // keep it in step with the latest configuration; otherwise a speaker or
        // earpiece choice made after the factory was built is lost on resume.
        NSArray<NativePeerConnectionFactory*>* factories;
        @synchronized(self) {
          factories = [self.factories.allValues copy];
        }
        // Merged rather than replaced: a configuration may carry only some of
        // the keys (nulls are left out on the Dart side), and resume should
        // restore the whole configuration, not only the keys sent last.
        //
        // Suspended factories are skipped: the configuration belongs to the
        // call that is active now, and a suspended call must resume with its
        // own. _audioSuspendedFactoryIds is only touched on this queue, so the
        // check is in order with suspend and resume.
        for (NativePeerConnectionFactory* nf in factories) {
          if ([self->_audioSuspendedFactoryIds containsObject:nf.factoryId]) {
            continue;
          }
          NSMutableDictionary* merged =
              [nf.audioConfigSnapshot mutableCopy] ?: [NSMutableDictionary dictionary];
          // A category sent without options is applied with no options, so
          // drop the old ones rather than restore them with the new category.
          if (configuration[@"appleAudioCategory"] != nil &&
              configuration[@"appleAudioCategoryOptions"] == nil) {
            [merged removeObjectForKey:@"appleAudioCategoryOptions"];
          }
          [merged addEntriesFromDictionary:configuration];
          nf.audioConfigSnapshot = merged;
        }
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        result(nil);
      });
    });
  }
#endif
  else if ([@"getLocalDescription" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      // On the connection's queue: reading it is a blocking call into the
      // signaling thread, and it must see the description calls queued before.
      FlutterResult reply = FlutterRTCReplyOnMain(result);
      FlutterRTCRunOnOperationQueue(peerConnection, ^{
        RTCSessionDescription* sdp = peerConnection.localDescription;
        if (nil == sdp) {
          reply(nil);
        } else {
          NSString* type = [RTCSessionDescription stringForType:sdp.type];
          reply(@{@"sdp" : sdp.sdp, @"type" : type});
        }
      });
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"getRemoteDescription" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      // On the connection's queue: reading it is a blocking call into the
      // signaling thread, and it must see the description calls queued before.
      FlutterResult reply = FlutterRTCReplyOnMain(result);
      FlutterRTCRunOnOperationQueue(peerConnection, ^{
        RTCSessionDescription* sdp = peerConnection.remoteDescription;
        if (nil == sdp) {
          reply(nil);
        } else {
          NSString* type = [RTCSessionDescription stringForType:sdp.type];
          reply(@{@"sdp" : sdp.sdp, @"type" : type});
        }
      });
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"setConfiguration" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSDictionary* configuration = argsMap[@"configuration"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      // On the connection's queue, in order with the description calls.
      RTCConfiguration* rtcConfiguration = [self RTCConfiguration:configuration];
      FlutterResult reply = FlutterRTCReplyOnMain(result);
      FlutterRTCRunOnOperationQueue(peerConnection, ^{
        [self peerConnectionSetConfiguration:rtcConfiguration peerConnection:peerConnection];
        reply(nil);
      });
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"addTrack" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* trackId = argsMap[@"trackId"];
    NSArray* streamIds = argsMap[@"streamIds"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }

    RTCMediaStreamTrack* track = [self trackForId:trackId peerConnectionId:nil];
    if (track == nil) {
      result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                                 message:[NSString stringWithFormat:@"Error: track not found!"]
                                 details:nil]);
      return;
    }
    // On the connection's queue, in order with the description calls.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpSender* sender = [peerConnection addTrack:track streamIds:streamIds];
      if (sender == nil) {
        reply([FlutterError
            errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                  message:[NSString stringWithFormat:@"Error: peerConnection.addTrack failed!"]
                  details:nil]);
        return;
      }
      reply([self rtpSenderToMap:sender]);
    });
  } else if ([@"removeTrack" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* senderId = argsMap[@"senderId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }
    // On the connection's queue, in order with the description calls.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpSender* sender = [self getRtpSenderById:peerConnection Id:senderId];
      if (sender == nil) {
        reply([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                                  message:[NSString stringWithFormat:@"Error: sender not found!"]
                                  details:nil]);
        return;
      }
      reply(@{@"result" : @([peerConnection removeTrack:sender])});
    });
  } else if ([@"addTransceiver" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSDictionary* transceiverInit = argsMap[@"transceiverInit"];
    NSString* trackId = argsMap[@"trackId"];
    NSString* mediaType = argsMap[@"mediaType"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }
    if (trackId == nil && mediaType == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: Incomplete parameters!"]
                details:nil]);
      return;
    }
    RTCMediaStreamTrack* track = trackId != nil ? [self trackForId:trackId peerConnectionId:nil] : nil;
    RTCRtpTransceiverInit* init =
        transceiverInit != nil ? [self mapToTransceiverInit:transceiverInit] : nil;

    // On the connection's queue, in order with the description calls: a
    // transceiver added after setRemoteDescription must see the offer's m-lines.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpTransceiver* transceiver = nil;
      if (trackId != nil) {
        if (init != nil) {
          transceiver = [peerConnection addTransceiverWithTrack:track init:init];
        } else {
          transceiver = [peerConnection addTransceiverWithTrack:track];
        }
      } else {
        RTCRtpMediaType rtpMediaType = [self stringToRtpMediaType:mediaType];
        if (init != nil) {
          transceiver = [peerConnection addTransceiverOfType:rtpMediaType init:init];
        } else {
          transceiver = [peerConnection addTransceiverOfType:rtpMediaType];
        }
      }

      if (transceiver == nil) {
        reply([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                                  message:[NSString stringWithFormat:@"Error: can't addTransceiver!"]
                                  details:nil]);
        return;
      }
      reply([self transceiverToMap:transceiver]);
    });
  } else if ([@"rtpTransceiverSetDirection" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* direction = argsMap[@"direction"];
    NSString* transceiverId = argsMap[@"transceiverId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }
    // On the connection's queue, in order with the description calls.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpTransceiver* transcevier = [self getRtpTransceiverById:peerConnection Id:transceiverId];
      if (transcevier == nil) {
        reply([FlutterError
            errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                  message:[NSString stringWithFormat:@"Error: transcevier not found!"]
                  details:nil]);
        return;
      }
      [transcevier setDirection:[self stringToTransceiverDirection:direction] error:nil];
      reply(nil);
    });
  } else if ([@"rtpTransceiverGetCurrentDirection" isEqualToString:call.method] ||
             [@"rtpTransceiverGetDirection" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* transceiverId = argsMap[@"transceiverId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }
    // On the connection's queue, in order with the description calls.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpTransceiver* transcevier = [self getRtpTransceiverById:peerConnection Id:transceiverId];
      if (transcevier == nil) {
        reply([FlutterError
            errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                  message:[NSString stringWithFormat:@"Error: transcevier not found!"]
                  details:nil]);
        return;
      }

      if ([@"rtpTransceiverGetDirection" isEqualToString:method]) {
        reply(@{@"result" : [self transceiverDirectionString:transcevier.direction]});
      } else if ([@"rtpTransceiverGetCurrentDirection" isEqualToString:method]) {
        RTCRtpTransceiverDirection directionOut = transcevier.direction;
        if ([transcevier currentDirection:&directionOut]) {
          reply(@{@"result" : [self transceiverDirectionString:directionOut]});
        } else {
          reply(nil);
        }
      }
    });
  } else if ([@"rtpTransceiverStop" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* transceiverId = argsMap[@"transceiverId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }
    // On the connection's queue, in order with the description calls.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpTransceiver* transcevier = [self getRtpTransceiverById:peerConnection Id:transceiverId];
      if (transcevier == nil) {
        reply([FlutterError
            errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                  message:[NSString stringWithFormat:@"Error: transcevier not found!"]
                  details:nil]);
        return;
      }
      [transcevier stopInternal];
      reply(nil);
    });
  } else if ([@"rtpSenderSetParameters" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* senderId = argsMap[@"rtpSenderId"];
    NSDictionary* parameters = argsMap[@"parameters"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }
    // On the connection's queue, in order with the description calls.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpSender* sender = [self getRtpSenderById:peerConnection Id:senderId];
      if (sender == nil) {
        reply([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                                  message:[NSString stringWithFormat:@"Error: sender not found!"]
                                  details:nil]);
        return;
      }
      [sender setParameters:[self updateRtpParameters:sender.parameters with:parameters]];
      reply(@{@"result" : @(YES)});
    });
  } else if ([@"rtpSenderReplaceTrack" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* senderId = argsMap[@"rtpSenderId"];
    NSString* trackId = argsMap[@"trackId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }
    RTCMediaStreamTrack* track = nil;
    if ([trackId length] > 0) {
      track = [self trackForId:trackId peerConnectionId:nil];
      if (track == nil) {
        result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                                   message:[NSString stringWithFormat:@"Error: track not found!"]
                                   details:nil]);
        return;
      }
    }
    // On the connection's queue, in order with the description calls.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpSender* sender = [self getRtpSenderById:peerConnection Id:senderId];
      if (sender == nil) {
        reply([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                                  message:[NSString stringWithFormat:@"Error: sender not found!"]
                                  details:nil]);
        return;
      }
      [sender setTrack:track];
      reply(nil);
    });
  } else if ([@"rtpSenderSetTrack" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* senderId = argsMap[@"rtpSenderId"];
    NSString* trackId = argsMap[@"trackId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }
    RTCMediaStreamTrack* track = nil;
    if ([trackId length] > 0) {
      track = [self trackForId:trackId peerConnectionId:nil];
      if (track == nil) {
        result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                                   message:[NSString stringWithFormat:@"Error: track not found!"]
                                   details:nil]);
        return;
      }
    }
    // On the connection's queue, in order with the description calls.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpSender* sender = [self getRtpSenderById:peerConnection Id:senderId];
      if (sender == nil) {
        reply([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                                  message:[NSString stringWithFormat:@"Error: sender not found!"]
                                  details:nil]);
        return;
      }
      [sender setTrack:track];
      reply(nil);
    });
  } else if ([@"rtpSenderSetStreams" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* senderId = argsMap[@"rtpSenderId"];
    NSArray* streamIds = argsMap[@"streamIds"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }
    // On the connection's queue, in order with the description calls.
    NSString* method = call.method;
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      RTCRtpSender* sender = [self getRtpSenderById:peerConnection Id:senderId];
      if (sender == nil) {
        reply([FlutterError errorWithCode:[NSString stringWithFormat:@"%@Failed", method]
                                  message:[NSString stringWithFormat:@"Error: sender not found!"]
                                  details:nil]);
        return;
      }
      [sender setStreamIds:streamIds];
      reply(nil);
    });
  } else if ([@"getSenders" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }

    // On the connection's queue, like the description getters.
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      NSMutableArray* senders = [NSMutableArray array];
      for (RTCRtpSender* sender in peerConnection.senders) {
        [senders addObject:[self rtpSenderToMap:sender]];
      }
      reply(@{@"senders" : senders});
    });
  } else if ([@"getReceivers" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }

    // On the connection's queue, like the description getters.
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      NSMutableArray* receivers = [NSMutableArray array];
      for (RTCRtpReceiver* receiver in peerConnection.receivers) {
        [receivers addObject:[self receiverToMap:receiver]];
      }
      reply(@{@"receivers" : receivers});
    });
  } else if ([@"getTransceivers" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection == nil) {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
      return;
    }

    // On the connection's queue, like the description getters.
    FlutterResult reply = FlutterRTCReplyOnMain(result);
    FlutterRTCRunOnOperationQueue(peerConnection, ^{
      NSMutableArray* transceivers = [NSMutableArray array];
      for (RTCRtpTransceiver* transceiver in peerConnection.transceivers) {
        [transceivers addObject:[self transceiverToMap:transceiver]];
      }
      reply(@{@"transceivers" : transceivers});
    });
  } else if ([@"getDesktopSources" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    [self getDesktopSources:argsMap result:result];
  } else if ([@"isSystemContentPickerSupported" isEqualToString:call.method]) {
    BOOL supported = NO;
#if TARGET_OS_OSX
    if (@available(macOS 14.0, *)) {
      supported = YES;
    }
#endif
    result(@{@"result" : @(supported)});
  } else if ([@"updateDesktopSources" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    [self updateDesktopSources:argsMap result:result];
  } else if ([@"getDesktopSourceThumbnail" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    [self getDesktopSourceThumbnail:argsMap result:result];
  } else if ([@"setCodecPreferences" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    [self transceiverSetCodecPreferences:argsMap result:result];
  } else if ([@"getRtpReceiverCapabilities" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    [self peerConnectionGetRtpReceiverCapabilities:argsMap result:result];
  } else if ([@"getRtpSenderCapabilities" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    [self peerConnectionGetRtpSenderCapabilities:argsMap result:result];
  } else if ([@"getSignalingState" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      result(@{@"state" : [self stringForSignalingState:peerConnection.signalingState]});
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"getIceGatheringState" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      result(@{@"state" : [self stringForICEGatheringState:peerConnection.iceGatheringState]});
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"getIceConnectionState" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      result(@{@"state" : [self stringForICEConnectionState:peerConnection.iceConnectionState]});
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"getConnectionState" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
    if (peerConnection) {
      result(@{@"state" : [self stringForPeerConnectionState:peerConnection.connectionState]});
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@Failed", call.method]
                message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
                details:nil]);
    }
  } else if ([@"setLogSeverity" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSString* severityStr = argsMap[@"severity"];
    RTCLoggingSeverity severity = [self str2LogSeverity:severityStr];
    [self initLoggerCallback:severity];
#if TARGET_OS_IOS
  } else if ([@"startRecordToFile" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSNumber* recorderId = argsMap[@"recorderId"];
    NSString* path = argsMap[@"path"];
    NSString* trackId = argsMap[@"videoTrackId"];
    NSString* peerConnectionId = argsMap[@"peerConnectionId"];
    NSString* audioTrackId = [self audioTrackIdForVideoTrackId:trackId];

    RTCMediaStreamTrack* track = [self trackForId:trackId peerConnectionId:peerConnectionId];
    RTCMediaStreamTrack* audioTrack = [self trackForId:audioTrackId
                                      peerConnectionId:peerConnectionId];
    if (track != nil && [track isKindOfClass:[RTCVideoTrack class]]) {
      NSURL* pathUrl = [NSURL fileURLWithPath:path];
      self.recorders[recorderId] =
          [[FlutterRTCMediaRecorder alloc] initWithVideoTrack:(RTCVideoTrack*)track
                                                   audioTrack:(RTCAudioTrack*)audioTrack
                                                   outputFile:pathUrl];
    }
    result(nil);
  } else if ([@"stopRecordToFile" isEqualToString:call.method]) {
    NSDictionary* argsMap = call.arguments;
    NSNumber* recorderId = argsMap[@"recorderId"];
    FlutterRTCMediaRecorder* recorder = self.recorders[recorderId];
    if (recorder != nil) {
      [recorder stop:result];
      [self.recorders removeObjectForKey:recorderId];
    } else {
      result([FlutterError
          errorWithCode:[NSString stringWithFormat:@"%@ failed", call.method]
                message:[NSString
                            stringWithFormat:@"Error: recorder with id %@ not found!", recorderId]
                details:nil]);
    }
#endif
  } else if ([@"resumeAudioPlayout" isEqualToString:call.method]) {
    self.isAudioPlayoutPaused = NO;

    if (self.pausedTrackVolumes.count == 0) {
      result(nil);
      return;
    }

    NSDictionary<NSString*, NSNumber*>* volumesToRestore =
        [NSDictionary dictionaryWithDictionary:self.pausedTrackVolumes];
    [self.pausedTrackVolumes removeAllObjects];

    for (NSString* trackId in volumesToRestore) {
      double targetVolume = [volumesToRestore[trackId] doubleValue];
      RTCMediaStreamTrack* track = [self trackForId:trackId peerConnectionId:nil];
      if (track != nil && [track isKindOfClass:[RTCAudioTrack class]]) {
        RTCAudioTrack* audioTrack = (RTCAudioTrack*)track;
        audioTrack.source.volume = targetVolume;
        self.trackVolumeCache[trackId] = @(targetVolume);
      }
    }

    result(nil);
  } else if ([@"pauseAudioPlayout" isEqualToString:call.method]) {
    self.isAudioPlayoutPaused = YES;

    for (NSString* peerConnectionId in _peerConnections) {
      RTCPeerConnection* peerConnection = _peerConnections[peerConnectionId];
      for (NSString* trackId in peerConnection.remoteTracks) {
        RTCMediaStreamTrack* track = peerConnection.remoteTracks[trackId];
        if ([track isKindOfClass:[RTCAudioTrack class]]) {
          RTCAudioTrack* audioTrack = (RTCAudioTrack*)track;
          if (self.pausedTrackVolumes[trackId] == nil) {
            NSNumber* previousVolume = self.trackVolumeCache[trackId];
            if (previousVolume == nil) {
              previousVolume = @(1.0);
            }
            self.pausedTrackVolumes[trackId] = previousVolume;
          }
          audioTrack.source.volume = 0.0;
        }
      }
    }

    result(nil);
  } else if ([@"startLocalRecording" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
    if (nf == nil) {
      result([FlutterError
          errorWithCode:@"startLocalRecording"
                message:[NSString stringWithFormat:@"unknown factoryId %@", factoryId]
                details:nil]);
      return;
    }
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (adm == nil) {
      result([FlutterError
          errorWithCode:@"startLocalRecording"
                message:[NSString
                            stringWithFormat:@"factory %@ has no audio device module", factoryId]
                details:nil]);
      return;
    }
    // Run on the factory's serial ADM queue
    dispatch_async(nf.admQueue, ^{
      NSInteger admResult = [adm initAndStartRecording];

      // Return to main queue
      dispatch_async(dispatch_get_main_queue(), ^{
        if (admResult == 0) {
          result(nil);
        } else {
          result([FlutterError
              errorWithCode:[NSString stringWithFormat:@"%@ failed", call.method]
                    message:[NSString stringWithFormat:@"Error: adm api failed with code: %ld",
                                                       (long)admResult]
                    details:nil]);
        }
      });
    });
  } else if ([@"stopLocalRecording" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
    if (nf == nil) {
      result([FlutterError
          errorWithCode:@"stopLocalRecording"
                message:[NSString stringWithFormat:@"unknown factoryId %@", factoryId]
                details:nil]);
      return;
    }
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (adm == nil) {
      result([FlutterError
          errorWithCode:@"stopLocalRecording"
                message:[NSString
                            stringWithFormat:@"factory %@ has no audio device module", factoryId]
                details:nil]);
      return;
    }
    // Run on the factory's serial ADM queue
    dispatch_async(nf.admQueue, ^{
      NSInteger admResult = [adm stopRecording];

      // Return to main queue
      dispatch_async(dispatch_get_main_queue(), ^{
        if (admResult == 0) {
          result(nil);
        } else {
          result([FlutterError
              errorWithCode:[NSString stringWithFormat:@"%@ failed", call.method]
                    message:[NSString stringWithFormat:@"Error: adm api failed with code: %ld",
                                                       (long)admResult]
                    details:nil]);
        }
      });
    });
  } else if ([@"appleAdmSetMicrophoneMuted" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    NSNumber* muted = call.arguments[@"muted"];
    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
    if (nf == nil) {
      result([FlutterError
          errorWithCode:@"appleAdmSetMicrophoneMuted"
                message:[NSString stringWithFormat:@"unknown factoryId %@", factoryId]
                details:nil]);
      return;
    }
    if (![muted isKindOfClass:[NSNumber class]]) {
      result([FlutterError errorWithCode:@"appleAdmSetMicrophoneMuted"
                                 message:@"missing or non-boolean 'muted' argument"
                                 details:nil]);
      return;
    }
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (adm == nil) {
      result([FlutterError
          errorWithCode:@"appleAdmSetMicrophoneMuted"
                message:[NSString
                            stringWithFormat:@"factory %@ has no audio device module", factoryId]
                details:nil]);
      return;
    }
    // Run on the factory's serial ADM queue: mute is an absolute set, so two
    // rapid toggles must not be reordered.
    dispatch_async(nf.admQueue, ^{
      // Mutes capture inside the Voice-Processing I/O unit while the audio
      // engine keeps running, so Apple's muted-talker detection stays armed
      // and the ADM keeps delivering didReceiveSpeechActivityEvent while the
      // user speaks muted.
      NSInteger admResult = [adm setMicrophoneMuted:muted.boolValue];

      // Return to main queue
      dispatch_async(dispatch_get_main_queue(), ^{
        if (admResult == 0) {
          result(nil);
        } else {
          result([FlutterError
              errorWithCode:[NSString stringWithFormat:@"%@ failed", call.method]
                    message:[NSString stringWithFormat:@"Error: adm api failed with code: %ld",
                                                       (long)admResult]
                    details:nil]);
        }
      });
    });
  } else if ([@"appleAdmIsMicrophoneMuted" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
    if (nf == nil) {
      result([FlutterError
          errorWithCode:@"appleAdmIsMicrophoneMuted"
                message:[NSString stringWithFormat:@"unknown factoryId %@", factoryId]
                details:nil]);
      return;
    }
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (adm == nil) {
      result([FlutterError
          errorWithCode:@"appleAdmIsMicrophoneMuted"
                message:[NSString
                            stringWithFormat:@"factory %@ has no audio device module", factoryId]
                details:nil]);
      return;
    }
    dispatch_async(nf.admQueue, ^{
      BOOL muted = adm.isMicrophoneMuted;
      dispatch_async(dispatch_get_main_queue(), ^{
        result(@(muted));
      });
    });
  } else if ([@"suspendAudioPeerConnectionFactory" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
    if (nf == nil) {
      result([FlutterError
          errorWithCode:@"suspendAudioPeerConnectionFactory"
                message:[NSString stringWithFormat:@"unknown factoryId %@", factoryId]
                details:nil]);
      return;
    }
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (adm == nil) {
      // Nothing to suspend: the factory already released its ADM.
      dispatch_async(nf.admQueue, ^{
        nf.wasPlayingBeforeSuspend = NO;
        nf.wasRecordingBeforeSuspend = NO;
        nf.audioSuspended = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
          result(nil);
        });
      });
      return;
    }
    dispatch_block_t suspendAdm = ^{
      dispatch_async(nf.admQueue, ^{
        // Idempotent: only the first suspend snapshots and stops. A disposed
        // factory has queued its own stops and is left alone.
        if (!nf.isDisposed && !nf.audioSuspended) {
          BOOL wasPlaying = adm.isPlaying;
          BOOL wasRecording = adm.isRecording;
          nf.wasPlayingBeforeSuspend = wasPlaying;
          nf.wasRecordingBeforeSuspend = wasRecording;
          nf.audioSuspended = YES;
          if (wasRecording)
            [adm stopRecording];
          if (wasPlaying)
            [adm stopPlayout];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
          result(nil);
        });
      });
    };
#if TARGET_OS_IPHONE
    // Through _audioSessionQueue first, like resume, so a suspend and a resume
    // reach the ADM queue in the order they were made.
    NSString* suspendedFactoryId = nf.factoryId;
    dispatch_async(_audioSessionQueue, ^{
      if (!nf.isDisposed) {
        [self->_audioSuspendedFactoryIds addObject:suspendedFactoryId];
      }
      suspendAdm();
    });
#else
    suspendAdm();
#endif
  } else if ([@"resumeAudioPeerConnectionFactory" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
    if (nf == nil) {
      result([FlutterError
          errorWithCode:@"resumeAudioPeerConnectionFactory"
                message:[NSString stringWithFormat:@"unknown factoryId %@", factoryId]
                details:nil]);
      return;
    }
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (adm == nil) {
      // Nothing to restore: the factory already released its ADM.
      dispatch_async(nf.admQueue, ^{
        nf.wasPlayingBeforeSuspend = NO;
        nf.wasRecordingBeforeSuspend = NO;
        nf.audioSuspended = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
          result(nil);
        });
      });
      return;
    }
    dispatch_block_t resumeAdm = ^{
      dispatch_async(nf.admQueue, ^{
        // A resume that was waiting on _audioSessionQueue can land here after
        // dispose queued its stops; restarting then would leave the disposed
        // factory's ADM running with no owner. dispose sets isDisposed on main
        // before queuing the stops, so the check is reliable on this queue.
        if (!nf.isDisposed && nf.audioSuspended) {
          BOOL restorePlaying = nf.wasPlayingBeforeSuspend;
          BOOL restoreRecording = nf.wasRecordingBeforeSuspend;
          if (restorePlaying) {
            [adm initPlayout];
            [adm startPlayout];
          }
          if (restoreRecording) {
            [adm initRecording];
            [adm startRecording];
          }
          nf.wasPlayingBeforeSuspend = NO;
          nf.wasRecordingBeforeSuspend = NO;
          nf.audioSuspended = NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
          result(nil);
        });
      });
    };
#if TARGET_OS_IPHONE
    // Restore the configuration on _audioSessionQueue, ordered with every other
    // AVAudioSession change so a concurrent setAppleAudioConfiguration cannot be
    // overwritten by an older one, then restart the ADM as before. Chained
    // asynchronously: neither queue ever waits on the other.
    NSString* resumedFactoryId = nf.factoryId;
    dispatch_async(_audioSessionQueue, ^{
      if ([self->_audioSuspendedFactoryIds containsObject:resumedFactoryId]) {
        [self->_audioSuspendedFactoryIds removeObject:resumedFactoryId];
        // A disposed factory's call has ended; its configuration must not
        // overwrite the one the remaining call has set.
        NSDictionary* audioConfigSnapshot = nf.audioConfigSnapshot;
        NSError* error = nil;
        if (!nf.isDisposed && audioConfigSnapshot != nil &&
            ![AudioUtils setAppleAudioConfiguration:audioConfigSnapshot error:&error]) {
          // Audio is still restarted below; a rejected configuration should not
          // also leave the call without audio.
          NSLog(@"[resumeAudioPeerConnectionFactory] audio configuration failed for id %@: %@",
                resumedFactoryId, error);
        }
      }
      resumeAdm();
    });
#else
    resumeAdm();
#endif
  } else if ([@"isVoiceProcessingEnabled" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
    if (nf == nil) {
      result(@(NO));
      return;
    }
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (adm == nil) {
      result(@(NO));
      return;
    }
    dispatch_async(nf.admQueue, ^{
      BOOL enabled = adm.isVoiceProcessingEnabled;

      // Return to main queue
      dispatch_async(dispatch_get_main_queue(), ^{
        result(@(enabled));
      });
    });
  } else if ([@"isVoiceProcessingBypassed" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
    if (nf == nil) {
      result(@(NO));
      return;
    }
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (adm == nil) {
      result(@(NO));
      return;
    }
    dispatch_async(nf.admQueue, ^{
      BOOL bypassed = adm.isVoiceProcessingBypassed;

      // Return to main queue
      dispatch_async(dispatch_get_main_queue(), ^{
        result(@(bypassed));
      });
    });
  } else if ([@"setIsVoiceProcessingBypassed" isEqualToString:call.method]) {
    NSString* factoryId = call.arguments[@"factoryId"];
    NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
    if (nf == nil) {
      result([FlutterError
          errorWithCode:@"setIsVoiceProcessingBypassed"
                message:[NSString stringWithFormat:@"unknown factoryId %@", factoryId]
                details:nil]);
      return;
    }
    NSNumber* value = call.arguments[@"value"];
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (adm == nil) {
      // Factory already released its ADM: nothing to bypass.
      result(nil);
      return;
    }
    BOOL bypassed = value.boolValue;
    // Run on the factory's serial ADM queue
    dispatch_async(nf.admQueue, ^{
      adm.voiceProcessingBypassed = bypassed;

      // Return to main queue
      dispatch_async(dispatch_get_main_queue(), ^{
        result(nil);
      });
    });
  } else if ([@"setStereoPlayoutPreferred" isEqualToString:call.method]) {
    NSNumber* value = call.arguments[@"preferred"];
    BOOL preferred = value.boolValue;
    _stereoPlayoutPreferred = preferred;
    NSArray<NativePeerConnectionFactory*>* snapshot;
    @synchronized(self) {
      snapshot = [self.factories.allValues copy];
    }
    if (snapshot.count == 0) {
      // Nothing to apply yet; will take effect when implicit/per-call
      // factory is built. Track the preference via _stereoPlayoutPreferred.
      result(nil);
      return;
    }
    dispatch_group_t group = dispatch_group_create();
    for (NativePeerConnectionFactory* nf in snapshot) {
      RTCAudioDeviceModule* adm = nf.audioDeviceModule;
      if (adm == nil)
        continue;
      dispatch_group_async(group, nf.admQueue, ^{
        adm.prefersStereoPlayout = preferred;
        adm.voiceProcessingBypassed = preferred;
        [adm setMuteMode:preferred ? RTCAudioEngineMuteModeInputMixer
                                   : RTCAudioEngineMuteModeVoiceProcessing];
      });
    }

    // Return to main queue
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      result(nil);
    });
  } else if ([@"isStereoPlayoutEnabled" isEqualToString:call.method]) {
    // Sample any active factory's ADM. Stereo preference is process-wide
    // so the value is consistent across factories; use the implicit one
    // (or the first explicit factory) as the source of truth.
    NativePeerConnectionFactory* nf;
    @synchronized(self) {
      nf = self.factories.allValues.firstObject;
    }
    RTCAudioDeviceModule* adm = nf.audioDeviceModule;
    if (nf == nil || adm == nil) {
      result(@(NO));
      return;
    }
    dispatch_async(nf.admQueue, ^{
      BOOL enabled = adm.isStereoPlayoutEnabled;

      // Return to main queue
      dispatch_async(dispatch_get_main_queue(), ^{
        result(@(enabled));
      });
    });
  } else if ([@"refreshStereoPlayoutState" isEqualToString:call.method]) {
    // Broadcast across every factory's ADM (stereo preference is
    // process-wide).
    NSArray<NativePeerConnectionFactory*>* snapshot;
    @synchronized(self) {
      snapshot = [self.factories.allValues copy];
    }
    dispatch_group_t group = dispatch_group_create();
    for (NativePeerConnectionFactory* nf in snapshot) {
      RTCAudioDeviceModule* adm = nf.audioDeviceModule;
      if (adm != nil) {
        // Run on the factory's serial ADM queue
        dispatch_group_async(group, nf.admQueue, ^{
          [adm refreshStereoPlayoutState];
        });
      }
    }

    // Return to main queue
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      result(nil);
    });
  } else {
    if ([self handleEncryptionManagerMethodCall:call result:result]) {
      return;
    }

    [self handleDataPacketCryptorMethodCall:call result:result];
  }
}

- (void)dealloc {
  [_localTracks removeAllObjects];
  _localTracks = nil;
  [_localStreams removeAllObjects];
  _localStreams = nil;

  for (NSString* peerConnectionId in _peerConnections) {
    RTCPeerConnection* peerConnection = _peerConnections[peerConnectionId];
    peerConnection.delegate = nil;
    [peerConnection close];
  }
  [_peerConnections removeAllObjects];

  // Drain every registered factory (explicit per-call factories the SDK
  // forgot to dispose, plus the implicit factory if still around). The
  // PCs above were already closed; NativePeerConnectionFactory.dispose now just
  // releases the underlying RTCPeerConnectionFactory + ADM.
  @synchronized(self) {
    for (NSString* fid in _factories.allKeys) {
      NativePeerConnectionFactory* nf = _factories[fid];
      @try {
        [nf dispose];
      } @catch (NSException* e) {
        NSLog(@"[dealloc] native factory dispose failed: %@", e);
      }
    }
    [_factories removeAllObjects];
  }
  [_pcFactoryId removeAllObjects];
  [_trackFactoryId removeAllObjects];
}

- (BOOL)hasLocalAudioTrack {
  for (id key in _localTracks.allKeys) {
    id<LocalTrack> track = [_localTracks objectForKey:key];
    if (track != nil && [track isKindOfClass:[LocalAudioTrack class]]) {
      return YES;
    }
  }
  return NO;
}

#pragma mark - Per-call factory resolution

- (NativePeerConnectionFactory*)resolveFactoryForId:(NSString*)factoryId {
  if (factoryId == nil || factoryId.length == 0) {
    return nil;
  }
  @synchronized(self) {
    return _factories[factoryId];
  }
}

- (NativePeerConnectionFactory*)resolveFactoryForStreamId:(NSString*)streamId {
  if (streamId == nil || streamId.length == 0)
    return nil;
  @synchronized(self) {
    for (NativePeerConnectionFactory* nf in _factories.allValues) {
      if ([nf.ownedStreamIds containsObject:streamId])
        return nf;
    }
  }
  return nil;
}

#if TARGET_OS_IPHONE
/**
 * Replays process-wide ADM state (stereo playout preference, mute mode,
 * voice-processing bypass) onto a freshly-built factory's ADM.
 */
- (void)applyPersistentAdmStateToFactory:(NativePeerConnectionFactory*)factory {
  if (!_stereoPlayoutPreferred) {
    return;
  }
  RTCAudioDeviceModule* adm = factory.audioDeviceModule;
  if (adm == nil) {
    return;
  }
  // Serialize with the factory's ADM queue like every other ADM mutation. The
  // queue is empty at this point — the factory was just built and its id has
  // not reached Dart yet — so this does not block meaningfully.
  dispatch_sync(factory.admQueue, ^{
    adm.prefersStereoPlayout = YES;
    adm.voiceProcessingBypassed = YES;
    [adm setMuteMode:RTCAudioEngineMuteModeInputMixer];
  });
}
#endif

/**
 * Both helpers run on _audioSessionQueue and read the track / peer-connection
 * state when the block executes, not when it is enqueued: by then the state may
 * have changed (e.g. the last peer connection closed and a new call started
 * while a slow reconfiguration was still ahead in the queue), and the new
 * call's ADM activates the session outside this queue.
 *
 * That state is owned by main, so the check hops there with dispatch_sync. This
 * is deadlock-free as long as main never dispatch_syncs onto _audioSessionQueue.
 */
- (void)ensureAudioSession {
#if TARGET_OS_IPHONE
  dispatch_async(_audioSessionQueue, ^{
    __block BOOL recording = NO;
    dispatch_sync(dispatch_get_main_queue(), ^{
      recording = [self hasLocalAudioTrack];
    });
    [AudioUtils ensureAudioSessionWithRecording:recording];
  });
#endif
}

/**
 * Closes and unregisters a peer connection. Main thread only. The close itself
 * runs on `_peerConnectionCloseQueue`, behind the connection's queued calls on
 * its operation queue; the cleanup and `result` follow on main.
 */
- (void)closePeerConnectionWithId:(nonnull NSString*)peerConnectionId
                           result:(nonnull FlutterResult)result {
  RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
  // Unregister it right away, so no call made while it closes can reach it.
  [self.peerConnections removeObjectForKey:peerConnectionId];

  // What has to happen once the connection is closed, on the main thread.
  void (^finish)(void) = ^{
    if (peerConnection) {
      [self->_closingPeerConnections removeObject:peerConnection];
      for (NSString* trackId in peerConnection.remoteTracks) {
        [self.pausedTrackVolumes removeObjectForKey:trackId];
        [self.trackVolumeCache removeObjectForKey:trackId];
      }

      // Clean up peerConnection's streams and tracks
      [peerConnection.remoteStreams removeAllObjects];
      [peerConnection.remoteTracks removeAllObjects];

      // Clean up peerConnection's dataChannels.
      NSMutableDictionary<NSString*, RTCDataChannel*>* dataChannels = peerConnection.dataChannels;
      for (NSString* dataChannelId in dataChannels) {
        dataChannels[dataChannelId].delegate = nil;
        // There is no need to close the RTCDataChannel because it is owned by the
        // RTCPeerConnection and the latter will close the former.
      }
      [dataChannels removeAllObjects];
    }

    NSString* factoryIdForPc = self.pcFactoryId[peerConnectionId];
    if (factoryIdForPc != nil) {
      [self.pcFactoryId removeObjectForKey:peerConnectionId];
      NativePeerConnectionFactory* nf;
      @synchronized(self) {
        nf = self.factories[factoryIdForPc];
      }
      if (nf != nil) {
        [nf.ownedPcIds removeObject:peerConnectionId];
      }
    }
    [self deactiveRtcAudioSession];
    result(nil);
  };

  if (peerConnection == nil) {
    // A close of this connection may still be running, e.g. a dispose sent
    // without awaiting the close. Queue behind it, so the reply still means
    // closed and the audio session isn't deactivated under running I/O.
    BOOL isClosing = NO;
    for (RTCPeerConnection* closing in _closingPeerConnections) {
      if ([closing.flutterId isEqualToString:peerConnectionId]) {
        isClosing = YES;
        break;
      }
    }
    if (isClosing) {
      dispatch_async(_peerConnectionCloseQueue, ^{
        dispatch_async(dispatch_get_main_queue(), finish);
      });
    } else {
      finish();
    }
    return;
  }

  // Close off the main thread (see _peerConnectionCloseQueue) and reply once
  // it is done, so the caller still sees a closed connection. The close runs
  // on the connection's operation queue, after the description and candidate
  // calls already queued there, while the close queue waits for it so factory
  // disposal still waits for pending closes. Nothing on an operation queue
  // waits for the close queue or main, so the dispatch_sync cannot deadlock.
  [_closingPeerConnections addObject:peerConnection];
  dispatch_queue_t operationQueue = peerConnection.operationQueue;
  dispatch_async(_peerConnectionCloseQueue, ^{
    if (operationQueue != nil) {
      dispatch_sync(operationQueue, ^{
        [peerConnection close];
      });
    } else {
      [peerConnection close];
    }
    dispatch_async(dispatch_get_main_queue(), finish);
  });
}

- (void)disposePeerConnectionFactory:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSDictionary* argsMap = call.arguments;
  NSString* factoryId = argsMap[@"factoryId"];
  if (factoryId == nil || factoryId.length == 0) {
    result([FlutterError errorWithCode:@"disposePeerConnectionFactory"
                               message:@"factoryId argument is required"
                               details:nil]);
    return;
  }
  NativePeerConnectionFactory* nf;
  @synchronized(self) {
    nf = _factories[factoryId];
    [_factories removeObjectForKey:factoryId];
  }
  if (nf == nil) {
    NSLog(@"[disposePeerConnectionFactory] unknown factoryId: %@", factoryId);
    result(nil);
    return;
  }
#if TARGET_OS_IPHONE
  dispatch_async(_audioSessionQueue, ^{
    [self->_audioSuspendedFactoryIds removeObject:factoryId];
  });
#endif
  NSLog(@"[disposePeerConnectionFactory] disposing id: %@, ownedPcs: %lu, "
         "ownedTracks: %lu, ownedStreams: %lu",
        factoryId, (unsigned long)nf.ownedPcIds.count, (unsigned long)nf.ownedTrackIds.count,
        (unsigned long)nf.ownedStreamIds.count);

  // 1. Defensively drain any PCs the SDK forgot.
  NSArray<NSString*>* pcIdsSnapshot = [nf.ownedPcIds.allObjects copy];
  for (NSString* pcId in pcIdsSnapshot) {
    RTCPeerConnection* peerConnection = self.peerConnections[pcId];
    if (peerConnection != nil) {
      // Not expected: handleMethodCall closes this factory's connections off
      // main before calling this, and rejects createPeerConnection for it while
      // they close. If one is still open, close it behind the calls still
      // queued for it, which must not reach it once its factory is gone.
      dispatch_queue_t operationQueue = peerConnection.operationQueue;
      if (operationQueue != nil) {
        dispatch_sync(operationQueue, ^{
          [peerConnection close];
        });
      } else {
        [peerConnection close];
      }
      [self.peerConnections removeObjectForKey:pcId];
    }
    [self.pcFactoryId removeObjectForKey:pcId];
  }
  [nf.ownedPcIds removeAllObjects];

  // 2. Evict every track wrapper this factory created.
  NSArray<NSString*>* trackIdsSnapshot = [nf.ownedTrackIds.allObjects copy];
  for (NSString* trackId in trackIdsSnapshot) {
    id<LocalTrack> lt = self.localTracks[trackId];
    if (lt != nil) {
      @try {
        lt.track.isEnabled = NO;
      } @catch (NSException* e) {
        // Native peer may already be gone; ignore.
      }
    }
    CapturerStopHandler stopHandler = self.videoCapturerStopHandlers[trackId];
    if (stopHandler) {
      @try {
        stopHandler(^{
          NSLog(@"[disposePeerConnectionFactory] capturer stopped, trackId = %@", trackId);
        });
      } @catch (NSException* e) {
        NSLog(@"[disposePeerConnectionFactory] capturer stop failed: %@", e);
      }
      [self.videoCapturerStopHandlers removeObjectForKey:trackId];
      [self.videoCaptureState removeObjectForKey:trackId];
    }
    [self.localTracks removeObjectForKey:trackId];
    [self.trackFactoryId removeObjectForKey:trackId];
  }
  [nf.ownedTrackIds removeAllObjects];

  // 3. Evict every stream wrapper this factory created.
  NSArray<NSString*>* streamIdsSnapshot = [nf.ownedStreamIds.allObjects copy];
  for (NSString* streamId in streamIdsSnapshot) {
    [self.localStreams removeObjectForKey:streamId];
  }
  [nf.ownedStreamIds removeAllObjects];

  // 4. Tear down the native factory itself.
  @try {
    [nf dispose];
  } @catch (NSException* e) {
    NSLog(@"[disposePeerConnectionFactory] dispose failed: %@", e);
  }

  result(nil);
}

- (void)deactiveRtcAudioSession {
#if TARGET_OS_IPHONE
  // Cheap early out; the condition is checked again when the block runs.
  // Connections still closing are already out of peerConnections but may
  // still be running audio I/O.
  if ([self hasLocalAudioTrack] || self.peerConnections.count > 0 ||
      _closingPeerConnections.count > 0) {
    return;
  }
  dispatch_async(_audioSessionQueue, ^{
    __block BOOL shouldDeactivate = NO;
    dispatch_sync(dispatch_get_main_queue(), ^{
      shouldDeactivate = ![self hasLocalAudioTrack] && self.peerConnections.count == 0 &&
                         self->_closingPeerConnections.count == 0;
    });
    if (shouldDeactivate) {
      [AudioUtils deactiveRtcAudioSession];
    }
  });
#endif
}

- (void)mediaStreamTrackSetVideoEffects:(nonnull NSString*)trackId
                                  names:(nonnull NSArray<NSString*>*)names {
  RTCMediaStreamTrack* track = [self trackForId:trackId peerConnectionId:nil];

  if (track) {
    NSLog(@"mediaStreamTrackSetVideoEffects: track found");

    RTCVideoTrack* videoTrack = (RTCVideoTrack*)track;
    RTCVideoSource* videoSource = videoTrack.source;

    NSMutableArray* processors = [[NSMutableArray alloc] init];
    for (NSString* name in names) {
      NSObject<VideoFrameProcessorDelegate>* processor = [ProcessorProvider getProcessor:name];
      if (processor != nil) {
        [processors addObject:processor];
      }
    }

    self.videoEffectProcessor = [[VideoEffectProcessor alloc] initWithProcessors:processors
                                                                     videoSource:videoSource];

    self.videoCapturer.delegate = self.videoEffectProcessor;
  } else {
    NSLog(@"mediaStreamTrackSetVideoEffects: track not found");
  }
}

/// Applies the remembered multitasking camera access request to the capture
/// session in use.
///
/// A capture session is created per `getUserMedia` call and starts without
/// multitasking camera access, so the request is applied again every time one
/// is created.
- (void)applyMultitaskingCameraAccessToCaptureSession {
#if !TARGET_OS_OSX
  if (!self.multitaskingCameraAccessRequested) {
    return;
  }

  if (@available(iOS 16.0, *)) {
    AVCaptureSession* session = self.videoCapturer.captureSession;
    if (session == nil || !session.isMultitaskingCameraAccessSupported ||
        session.multitaskingCameraAccessEnabled) {
      return;
    }

    @try {
      [session beginConfiguration];
      [session setMultitaskingCameraAccessEnabled:YES];
      [session commitConfiguration];
    } @catch (NSException* exception) {
      NSLog(@"applyMultitaskingCameraAccessToCaptureSession: Exception occurred: %@ - %@",
            exception.name, exception.reason);
    }
  }
#endif
}

/// Reports whether the capture session in use supports camera access while
/// multitasking, or nil when there is no capture session to ask.
- (void)multitaskingCameraAccessSupported:(FlutterResult)result {
#if TARGET_OS_OSX
  result(@NO);
#else
  if (@available(iOS 16.0, *)) {
    AVCaptureSession* session = self.videoCapturer.captureSession;
    if (session == nil) {
      result(nil);
      return;
    }

    result(@(session.isMultitaskingCameraAccessSupported));
  } else {
    result(@NO);
  }
#endif
}

- (void)enableMultitaskingCameraAccess:(BOOL)enable result:(FlutterResult)result {
#if TARGET_OS_OSX
  NSLog(@"enableMultitaskingCameraAccess: Multitasking camera access is not available on macOS.");
  result(@NO);
#else
  @try {
    self.multitaskingCameraAccessRequested = enable;

    AVCaptureSession* session = self.videoCapturer.captureSession;
    if (session == nil) {
      NSLog(@"enableMultitaskingCameraAccess: Capture session is nil.");
      result(@NO);
      return;
    }

    if (@available(iOS 16.0, *)) {
      BOOL shouldChange = session.multitaskingCameraAccessEnabled != enable;
      BOOL canChange = !enable || (enable && session.isMultitaskingCameraAccessSupported);

      if (shouldChange && canChange) {
        [session beginConfiguration];
        [session setMultitaskingCameraAccessEnabled:enable];
        [session commitConfiguration];

        result(enable ? @YES : @NO);
      } else {
        if (!canChange) {
          NSLog(@"enableMultitaskingCameraAccess: Multitasking camera access is not supported on "
                @"this device.");
          result(@NO);
        } else {
          NSLog(@"enableMultitaskingCameraAccess: Multitasking camera access is already %@.",
                enable ? @"enabled" : @"disabled");
          result(enable ? @YES : @NO);
        }
      }
    } else {
      NSLog(
          @"enableMultitaskingCameraAccess: Multitasking camera access requires iOS 16 or later.");
      result(@NO);
    }
  } @catch (NSException* exception) {
    NSLog(@"enableMultitaskingCameraAccess: Exception occurred: %@ - %@", exception.name,
          exception.reason);
    result(@NO);
  }
#endif
}

- (void)mediaStreamGetTracks:(NSString*)streamId result:(FlutterResult)result {
  RTCMediaStream* stream = [self streamForId:streamId peerConnectionId:@""];
  if (stream) {
    NativePeerConnectionFactory* streamFactory = [self resolveFactoryForStreamId:streamId];
    NSMutableArray* audioTracks = [NSMutableArray array];
    NSMutableArray* videoTracks = [NSMutableArray array];

    for (RTCMediaStreamTrack* track in stream.audioTracks) {
      NSString* trackId = track.trackId;
      [self.localTracks setObject:[[LocalAudioTrack alloc] initWithTrack:(RTCAudioTrack*)track]
                           forKey:trackId];
      if (streamFactory != nil) {
        [streamFactory.ownedTrackIds addObject:trackId];
        if (streamFactory.factoryId != nil) {
          self.trackFactoryId[trackId] = streamFactory.factoryId;
        }
      }
      [audioTracks addObject:@{
        @"enabled" : @(track.isEnabled),
        @"id" : trackId,
        @"kind" : track.kind,
        @"label" : trackId,
        @"readyState" : @"live",
        @"remote" : @(NO)
      }];
    }

    for (RTCMediaStreamTrack* track in stream.videoTracks) {
      NSString* trackId = track.trackId;
      [_localTracks setObject:[[LocalVideoTrack alloc] initWithTrack:(RTCVideoTrack*)track]
                       forKey:trackId];
      if (streamFactory != nil) {
        [streamFactory.ownedTrackIds addObject:trackId];
        if (streamFactory.factoryId != nil) {
          self.trackFactoryId[trackId] = streamFactory.factoryId;
        }
      }
      [videoTracks addObject:@{
        @"enabled" : @(track.isEnabled),
        @"id" : trackId,
        @"kind" : track.kind,
        @"label" : trackId,
        @"readyState" : @"live",
        @"remote" : @(NO)
      }];
    }

    result(@{@"audioTracks" : audioTracks, @"videoTracks" : videoTracks});
  } else {
    result(nil);
  }
}

- (RTCMediaStream*)streamForId:(NSString*)streamId peerConnectionId:(NSString*)peerConnectionId {
  RTCMediaStream* stream = nil;
  if (peerConnectionId.length > 0) {
    RTCPeerConnection* peerConnection = [_peerConnections objectForKey:peerConnectionId];
    stream = peerConnection.remoteStreams[streamId];
  } else {
    for (RTCPeerConnection* peerConnection in _peerConnections.allValues) {
      stream = peerConnection.remoteStreams[streamId];
      if (stream) {
        break;
      }
    }
  }
  if (!stream) {
    stream = _localStreams[streamId];
  }
  return stream;
}

- (RTCMediaStreamTrack* _Nullable)remoteTrackForId:(NSString* _Nonnull)trackId {
  RTCMediaStreamTrack* mediaStreamTrack = nil;
  for (NSString* currentId in _peerConnections.allKeys) {
    RTCPeerConnection* peerConnection = _peerConnections[currentId];
    mediaStreamTrack = peerConnection.remoteTracks[trackId];
    if (!mediaStreamTrack) {
      for (RTCRtpTransceiver* transceiver in peerConnection.transceivers) {
        if (transceiver.receiver.track != nil &&
            [transceiver.receiver.track.trackId isEqual:trackId]) {
          mediaStreamTrack = transceiver.receiver.track;
          break;
        }
      }
    }
    if (mediaStreamTrack) {
      break;
    }
  }

  return mediaStreamTrack;
}

- (NSString*)audioTrackIdForVideoTrackId:(NSString*)videoTrackId {
  NSString* audioTrackId = nil;

  // Iterate through all peerConnections
  for (NSString* peerConnectionId in self.peerConnections) {
    RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];

    // Iterate through the receivers to find the video track
    for (RTCRtpReceiver* receiver in peerConnection.receivers) {
      RTCMediaStreamTrack* track = [receiver valueForKey:@"track"];
      if ([track.kind isEqualToString:@"video"] && [track.trackId isEqualToString:videoTrackId]) {
        // Found the video track, now look for the audio track in the same peerConnection
        for (RTCRtpReceiver* audioReceiver in peerConnection.receivers) {
          RTCMediaStreamTrack* audioTrack = [audioReceiver valueForKey:@"track"];
          if ([audioTrack.kind isEqualToString:@"audio"]) {
            audioTrackId = audioTrack.trackId;
            break;
          }
        }
        break;
      }
    }

    // If the audioTrackId is found, break out of the loop
    if (audioTrackId != nil) {
      break;
    }
  }

  return audioTrackId;
}

- (RTCMediaStreamTrack*)trackForId:(NSString*)trackId peerConnectionId:(NSString*)peerConnectionId {
  id<LocalTrack> track = _localTracks[trackId];
  RTCMediaStreamTrack* mediaStreamTrack = nil;
  if (!track) {
    for (NSString* currentId in _peerConnections.allKeys) {
      if (peerConnectionId && [currentId isEqualToString:peerConnectionId] == false) {
        continue;
      }
      RTCPeerConnection* peerConnection = _peerConnections[currentId];
      mediaStreamTrack = peerConnection.remoteTracks[trackId];
      if (!mediaStreamTrack) {
        for (RTCRtpTransceiver* transceiver in peerConnection.transceivers) {
          if (transceiver.receiver.track != nil &&
              [transceiver.receiver.track.trackId isEqual:trackId]) {
            mediaStreamTrack = transceiver.receiver.track;
            break;
          }
        }
      }
      if (mediaStreamTrack) {
        break;
      }
    }
  } else {
    mediaStreamTrack = [track track];
  }
  return mediaStreamTrack;
}

- (RTCIceServer*)RTCIceServer:(id)json {
  if (!json) {
    NSLog(@"a valid iceServer value");
    return nil;
  }

  if (![json isKindOfClass:[NSDictionary class]]) {
    NSLog(@"must be an object");
    return nil;
  }

  NSArray<NSString*>* urls;
  if ([json[@"url"] isKindOfClass:[NSString class]]) {
    // TODO: 'url' is non-standard
    urls = @[ json[@"url"] ];
  } else if ([json[@"urls"] isKindOfClass:[NSString class]]) {
    urls = @[ json[@"urls"] ];
  } else {
    urls = (NSArray*)json[@"urls"];
  }

  if (json[@"username"] != nil || json[@"credential"] != nil) {
    return [[RTCIceServer alloc] initWithURLStrings:urls
                                           username:json[@"username"]
                                         credential:json[@"credential"]];
  }

  return [[RTCIceServer alloc] initWithURLStrings:urls];
}

- (nonnull RTCConfiguration*)RTCConfiguration:(id)json {
  RTCConfiguration* config = [[RTCConfiguration alloc] init];

  if (!json) {
    return config;
  }

  if (![json isKindOfClass:[NSDictionary class]]) {
    NSLog(@"must be an object");
    return config;
  }

  if (json[@"audioJitterBufferMaxPackets"] != nil &&
      [json[@"audioJitterBufferMaxPackets"] isKindOfClass:[NSNumber class]]) {
    config.audioJitterBufferMaxPackets = [json[@"audioJitterBufferMaxPackets"] intValue];
  }

  if (json[@"bundlePolicy"] != nil && [json[@"bundlePolicy"] isKindOfClass:[NSString class]]) {
    NSString* bundlePolicy = json[@"bundlePolicy"];
    if ([bundlePolicy isEqualToString:@"balanced"]) {
      config.bundlePolicy = RTCBundlePolicyBalanced;
    } else if ([bundlePolicy isEqualToString:@"max-compat"]) {
      config.bundlePolicy = RTCBundlePolicyMaxCompat;
    } else if ([bundlePolicy isEqualToString:@"max-bundle"]) {
      config.bundlePolicy = RTCBundlePolicyMaxBundle;
    }
  }

  if (json[@"iceBackupCandidatePairPingInterval"] != nil &&
      [json[@"iceBackupCandidatePairPingInterval"] isKindOfClass:[NSNumber class]]) {
    config.iceBackupCandidatePairPingInterval =
        [json[@"iceBackupCandidatePairPingInterval"] intValue];
  }

  if (json[@"iceConnectionReceivingTimeout"] != nil &&
      [json[@"iceConnectionReceivingTimeout"] isKindOfClass:[NSNumber class]]) {
    config.iceConnectionReceivingTimeout = [json[@"iceConnectionReceivingTimeout"] intValue];
  }

  if (json[@"iceServers"] != nil && [json[@"iceServers"] isKindOfClass:[NSArray class]]) {
    NSMutableArray<RTCIceServer*>* iceServers = [NSMutableArray new];
    for (id server in json[@"iceServers"]) {
      RTCIceServer* convert = [self RTCIceServer:server];
      if (convert != nil) {
        [iceServers addObject:convert];
      }
    }
    config.iceServers = iceServers;
  }

  if (json[@"iceTransportPolicy"] != nil &&
      [json[@"iceTransportPolicy"] isKindOfClass:[NSString class]]) {
    NSString* iceTransportPolicy = json[@"iceTransportPolicy"];
    if ([iceTransportPolicy isEqualToString:@"all"]) {
      config.iceTransportPolicy = RTCIceTransportPolicyAll;
    } else if ([iceTransportPolicy isEqualToString:@"none"]) {
      config.iceTransportPolicy = RTCIceTransportPolicyNone;
    } else if ([iceTransportPolicy isEqualToString:@"nohost"]) {
      config.iceTransportPolicy = RTCIceTransportPolicyNoHost;
    } else if ([iceTransportPolicy isEqualToString:@"relay"]) {
      config.iceTransportPolicy = RTCIceTransportPolicyRelay;
    }
  }

  if (json[@"rtcpMuxPolicy"] != nil && [json[@"rtcpMuxPolicy"] isKindOfClass:[NSString class]]) {
    NSString* rtcpMuxPolicy = json[@"rtcpMuxPolicy"];
    if ([rtcpMuxPolicy isEqualToString:@"negotiate"]) {
      config.rtcpMuxPolicy = RTCRtcpMuxPolicyNegotiate;
    } else if ([rtcpMuxPolicy isEqualToString:@"require"]) {
      config.rtcpMuxPolicy = RTCRtcpMuxPolicyRequire;
    }
  }

  if (json[@"sdpSemantics"] != nil && [json[@"sdpSemantics"] isKindOfClass:[NSString class]]) {
    NSString* sdpSemantics = json[@"sdpSemantics"];
    if ([sdpSemantics isEqualToString:@"plan-b"]) {
      config.sdpSemantics = RTCSdpSemanticsPlanB;
    } else if ([sdpSemantics isEqualToString:@"unified-plan"]) {
      config.sdpSemantics = RTCSdpSemanticsUnifiedPlan;
    }
  }

  if (json[@"maxIPv6Networks"] != nil &&
      [json[@"maxIPv6Networks"] isKindOfClass:[NSNumber class]]) {
    NSNumber* maxIPv6Networks = json[@"maxIPv6Networks"];
    config.maxIPv6Networks = [maxIPv6Networks intValue];
  }

  // === below is private api in webrtc ===
  if (json[@"tcpCandidatePolicy"] != nil &&
      [json[@"tcpCandidatePolicy"] isKindOfClass:[NSString class]]) {
    NSString* tcpCandidatePolicy = json[@"tcpCandidatePolicy"];
    if ([tcpCandidatePolicy isEqualToString:@"enabled"]) {
      config.tcpCandidatePolicy = RTCTcpCandidatePolicyEnabled;
    } else if ([tcpCandidatePolicy isEqualToString:@"disabled"]) {
      config.tcpCandidatePolicy = RTCTcpCandidatePolicyDisabled;
    }
  }

  // candidateNetworkPolicy (private api)
  if (json[@"candidateNetworkPolicy"] != nil &&
      [json[@"candidateNetworkPolicy"] isKindOfClass:[NSString class]]) {
    NSString* candidateNetworkPolicy = json[@"candidateNetworkPolicy"];
    if ([candidateNetworkPolicy isEqualToString:@"all"]) {
      config.candidateNetworkPolicy = RTCCandidateNetworkPolicyAll;
    } else if ([candidateNetworkPolicy isEqualToString:@"low_cost"]) {
      config.candidateNetworkPolicy = RTCCandidateNetworkPolicyLowCost;
    }
  }

  // KeyType (private api)
  if (json[@"keyType"] != nil && [json[@"keyType"] isKindOfClass:[NSString class]]) {
    NSString* keyType = json[@"keyType"];
    if ([keyType isEqualToString:@"RSA"]) {
      config.keyType = RTCEncryptionKeyTypeRSA;
    } else if ([keyType isEqualToString:@"ECDSA"]) {
      config.keyType = RTCEncryptionKeyTypeECDSA;
    }
  }

  // continualGatheringPolicy (private api)
  if (json[@"continualGatheringPolicy"] != nil &&
      [json[@"continualGatheringPolicy"] isKindOfClass:[NSString class]]) {
    NSString* continualGatheringPolicy = json[@"continualGatheringPolicy"];
    if ([continualGatheringPolicy isEqualToString:@"gather_once"]) {
      config.continualGatheringPolicy = RTCContinualGatheringPolicyGatherOnce;
    } else if ([continualGatheringPolicy isEqualToString:@"gather_continually"]) {
      config.continualGatheringPolicy = RTCContinualGatheringPolicyGatherContinually;
    }
  }

  // audioJitterBufferMaxPackets (private api)
  if (json[@"audioJitterBufferMaxPackets"] != nil &&
      [json[@"audioJitterBufferMaxPackets"] isKindOfClass:[NSNumber class]]) {
    NSNumber* audioJitterBufferMaxPackets = json[@"audioJitterBufferMaxPackets"];
    config.audioJitterBufferMaxPackets = [audioJitterBufferMaxPackets intValue];
  }

  // iceConnectionReceivingTimeout (private api)
  if (json[@"iceConnectionReceivingTimeout"] != nil &&
      [json[@"iceConnectionReceivingTimeout"] isKindOfClass:[NSNumber class]]) {
    NSNumber* iceConnectionReceivingTimeout = json[@"iceConnectionReceivingTimeout"];
    config.iceConnectionReceivingTimeout = [iceConnectionReceivingTimeout intValue];
  }

  // iceBackupCandidatePairPingInterval (private api)
  if (json[@"iceBackupCandidatePairPingInterval"] != nil &&
      [json[@"iceBackupCandidatePairPingInterval"] isKindOfClass:[NSNumber class]]) {
    NSNumber* iceBackupCandidatePairPingInterval = json[@"iceConnectionReceivingTimeout"];
    config.iceBackupCandidatePairPingInterval = [iceBackupCandidatePairPingInterval intValue];
  }

  // audioJitterBufferFastAccelerate (private api)
  if (json[@"audioJitterBufferFastAccelerate"] != nil &&
      [json[@"audioJitterBufferFastAccelerate"] isKindOfClass:[NSNumber class]]) {
    NSNumber* audioJitterBufferFastAccelerate = json[@"audioJitterBufferFastAccelerate"];
    config.audioJitterBufferFastAccelerate = [audioJitterBufferFastAccelerate boolValue];
  }

  // pruneTurnPorts (private api)
  if (json[@"pruneTurnPorts"] != nil && [json[@"pruneTurnPorts"] isKindOfClass:[NSNumber class]]) {
    NSNumber* pruneTurnPorts = json[@"pruneTurnPorts"];
    config.shouldPruneTurnPorts = [pruneTurnPorts boolValue];
  }

  // presumeWritableWhenFullyRelayed (private api)
  if (json[@"presumeWritableWhenFullyRelayed"] != nil &&
      [json[@"presumeWritableWhenFullyRelayed"] isKindOfClass:[NSNumber class]]) {
    NSNumber* presumeWritableWhenFullyRelayed = json[@"presumeWritableWhenFullyRelayed"];
    config.shouldPresumeWritableWhenFullyRelayed = [presumeWritableWhenFullyRelayed boolValue];
  }

  // cryptoOptions (private api)
  if (json[@"cryptoOptions"] != nil &&
      [json[@"cryptoOptions"] isKindOfClass:[NSDictionary class]]) {
    id options = json[@"cryptoOptions"];
    BOOL srtpEnableGcmCryptoSuites = NO;
    BOOL sframeRequireFrameEncryption = NO;
    BOOL srtpEnableEncryptedRtpHeaderExtensions = NO;
    BOOL srtpEnableAes128Sha1_32CryptoCipher = NO;

    if (options[@"enableGcmCryptoSuites"] != nil &&
        [options[@"enableGcmCryptoSuites"] isKindOfClass:[NSNumber class]]) {
      NSNumber* value = options[@"enableGcmCryptoSuites"];
      srtpEnableGcmCryptoSuites = [value boolValue];
    }

    if (options[@"requireFrameEncryption"] != nil &&
        [options[@"requireFrameEncryption"] isKindOfClass:[NSNumber class]]) {
      NSNumber* value = options[@"requireFrameEncryption"];
      sframeRequireFrameEncryption = [value boolValue];
    }

    if (options[@"enableEncryptedRtpHeaderExtensions"] != nil &&
        [options[@"enableEncryptedRtpHeaderExtensions"] isKindOfClass:[NSNumber class]]) {
      NSNumber* value = options[@"enableEncryptedRtpHeaderExtensions"];
      srtpEnableEncryptedRtpHeaderExtensions = [value boolValue];
    }

    if (options[@"enableAes128Sha1_32CryptoCipher"] != nil &&
        [options[@"enableAes128Sha1_32CryptoCipher"] isKindOfClass:[NSNumber class]]) {
      NSNumber* value = options[@"enableAes128Sha1_32CryptoCipher"];
      srtpEnableAes128Sha1_32CryptoCipher = [value boolValue];
    }

    config.cryptoOptions = [[RTCCryptoOptions alloc]
             initWithSrtpEnableGcmCryptoSuites:srtpEnableGcmCryptoSuites
           srtpEnableAes128Sha1_32CryptoCipher:srtpEnableAes128Sha1_32CryptoCipher
        srtpEnableEncryptedRtpHeaderExtensions:srtpEnableEncryptedRtpHeaderExtensions
                  sframeRequireFrameEncryption:(BOOL)sframeRequireFrameEncryption];
  }

  return config;
}

- (RTCDataChannelConfiguration*)RTCDataChannelConfiguration:(id)json {
  if (!json) {
    return nil;
  }
  if ([json isKindOfClass:[NSDictionary class]]) {
    RTCDataChannelConfiguration* init = [RTCDataChannelConfiguration new];

    if (json[@"id"]) {
      [init setChannelId:(int)[json[@"id"] integerValue]];
    }
    if (json[@"ordered"]) {
      init.isOrdered = [json[@"ordered"] boolValue];
    }
    if (json[@"maxRetransmits"]) {
      init.maxRetransmits = [json[@"maxRetransmits"] intValue];
    }
    if (json[@"negotiated"]) {
      init.isNegotiated = [json[@"negotiated"] boolValue];
    }
    if (json[@"protocol"]) {
      init.protocol = json[@"protocol"];
    }
    return init;
  }
  return nil;
}

- (CGRect)parseRect:(NSDictionary*)rect {
  return CGRectMake(
      [[rect valueForKey:@"left"] doubleValue], [[rect valueForKey:@"top"] doubleValue],
      [[rect valueForKey:@"width"] doubleValue], [[rect valueForKey:@"height"] doubleValue]);
}

- (NSDictionary*)dtmfSenderToMap:(id<RTCDtmfSender>)dtmf Id:(NSString*)Id {
  return @{
    @"dtmfSenderId" : Id,
    @"interToneGap" : @(dtmf.interToneGap / 1000.0),
    @"duration" : @(dtmf.duration / 1000.0),
  };
}

- (NSDictionary*)rtpParametersToMap:(RTCRtpParameters*)parameters {
  NSDictionary* rtcp = @{
    @"cname" : parameters.rtcp.cname,
    @"reducedSize" : @(parameters.rtcp.isReducedSize),
  };

  NSMutableArray* headerExtensions = [NSMutableArray array];
  for (RTCRtpHeaderExtension* headerExtension in parameters.headerExtensions) {
    [headerExtensions addObject:@{
      @"uri" : headerExtension.uri,
      @"encrypted" : @(headerExtension.encrypted),
      @"id" : @(headerExtension.id),
    }];
  }

  NSMutableArray* encodings = [NSMutableArray array];
  for (RTCRtpEncodingParameters* encoding in parameters.encodings) {
    // non-nil values
    NSMutableDictionary* obj = [@{@"active" : @(encoding.isActive)} mutableCopy];
    // optional values
    if (encoding.rid != nil)
      [obj setObject:encoding.rid forKey:@"rid"];
    if (encoding.minBitrateBps != nil)
      [obj setObject:encoding.minBitrateBps forKey:@"minBitrate"];
    if (encoding.maxBitrateBps != nil)
      [obj setObject:encoding.maxBitrateBps forKey:@"maxBitrate"];
    if (encoding.maxFramerate != nil)
      [obj setObject:encoding.maxFramerate forKey:@"maxFramerate"];
    if (encoding.numTemporalLayers != nil)
      [obj setObject:encoding.numTemporalLayers forKey:@"numTemporalLayers"];
    if (encoding.scaleResolutionDownBy != nil)
      [obj setObject:encoding.scaleResolutionDownBy forKey:@"scaleResolutionDownBy"];
    if (encoding.scalabilityMode != nil)
      [obj setObject:encoding.scalabilityMode forKey:@"scalabilityMode"];
    if (encoding.ssrc != nil)
      [obj setObject:encoding.ssrc forKey:@"ssrc"];

    [encodings addObject:obj];
  }

  NSMutableArray* codecs = [NSMutableArray array];
  for (RTCRtpCodecParameters* codec in parameters.codecs) {
    [codecs addObject:@{
      @"name" : codec.name,
      @"payloadType" : @(codec.payloadType),
      @"clockRate" : codec.clockRate,
      @"numChannels" : codec.numChannels ? codec.numChannels : @(1),
      @"parameters" : codec.parameters,
      @"kind" : codec.kind
    }];
  }

  NSString* degradationPreference = @"balanced";
  if (parameters.degradationPreference != nil) {
    if ([parameters.degradationPreference intValue] == RTCDegradationPreferenceMaintainFramerate) {
      degradationPreference = @"maintain-framerate";
    } else if ([parameters.degradationPreference intValue] ==
               RTCDegradationPreferenceMaintainResolution) {
      degradationPreference = @"maintain-resolution";
    } else if ([parameters.degradationPreference intValue] == RTCDegradationPreferenceBalanced) {
      degradationPreference = @"balanced";
    } else if ([parameters.degradationPreference intValue] == RTCDegradationPreferenceDisabled) {
      degradationPreference = @"disabled";
    }
  }

  return @{
    @"transactionId" : parameters.transactionId,
    @"rtcp" : rtcp,
    @"headerExtensions" : headerExtensions,
    @"encodings" : encodings,
    @"codecs" : codecs,
    @"degradationPreference" : degradationPreference,
  };
}

- (NSString*)streamTrackStateToString:(RTCMediaStreamTrackState)state {
  switch (state) {
    case RTCMediaStreamTrackStateLive:
      return @"live";
    case RTCMediaStreamTrackStateEnded:
      return @"ended";
    default:
      break;
  }
  return @"";
}

- (NSDictionary*)mediaStreamToMap:(RTCMediaStream*)stream ownerTag:(NSString*)ownerTag {
  NSMutableArray* audioTracks = [NSMutableArray array];
  NSMutableArray* videoTracks = [NSMutableArray array];

  for (RTCMediaStreamTrack* track in stream.audioTracks) {
    [audioTracks addObject:[self mediaTrackToMap:track]];
  }

  for (RTCMediaStreamTrack* track in stream.videoTracks) {
    [videoTracks addObject:[self mediaTrackToMap:track]];
  }

  return @{
    @"streamId" : stream.streamId,
    @"ownerTag" : ownerTag,
    @"audioTracks" : audioTracks,
    @"videoTracks" : videoTracks,

  };
}

- (NSDictionary*)mediaTrackToMap:(RTCMediaStreamTrack*)track {
  if (track == nil)
    return @{};
  NSDictionary* params = @{
    @"enabled" : @(track.isEnabled),
    @"id" : track.trackId,
    @"kind" : track.kind,
    @"label" : track.trackId,
    @"readyState" : [self streamTrackStateToString:track.readyState],
    @"remote" : @(YES)
  };
  return params;
}

- (NSDictionary*)rtpSenderToMap:(RTCRtpSender*)sender {
  NSDictionary* params = @{
    @"senderId" : sender.senderId,
    @"ownsTrack" : @(YES),
    @"rtpParameters" : [self rtpParametersToMap:sender.parameters],
    @"track" : [self mediaTrackToMap:sender.track],
    @"dtmfSender" : [self dtmfSenderToMap:sender.dtmfSender Id:sender.senderId]
  };
  return params;
}

- (NSDictionary*)receiverToMap:(RTCRtpReceiver*)receiver {
  NSDictionary* params = @{
    @"receiverId" : receiver.receiverId,
    @"rtpParameters" : [self rtpParametersToMap:receiver.parameters],
    @"track" : [self mediaTrackToMap:receiver.track],
  };
  return params;
}

- (RTCRtpTransceiver*)getRtpTransceiverById:(RTCPeerConnection*)peerConnection Id:(NSString*)Id {
  for (RTCRtpTransceiver* transceiver in peerConnection.transceivers) {
    NSString* mid = transceiver.mid ? transceiver.mid : @"";
    if ([mid isEqualToString:Id]) {
      return transceiver;
    }
  }
  return nil;
}

- (RTCRtpSender*)getRtpSenderById:(RTCPeerConnection*)peerConnection Id:(NSString*)Id {
  for (RTCRtpSender* sender in peerConnection.senders) {
    if ([sender.senderId isEqualToString:Id]) {
      return sender;
    }
  }
  return nil;
}

- (RTCRtpReceiver*)getRtpReceiverById:(RTCPeerConnection*)peerConnection Id:(NSString*)Id {
  for (RTCRtpReceiver* receiver in peerConnection.receivers) {
    if ([receiver.receiverId isEqualToString:Id]) {
      return receiver;
    }
  }
  return nil;
}

- (RTCRtpEncodingParameters*)mapToEncoding:(NSDictionary*)map {
  RTCRtpEncodingParameters* encoding = [[RTCRtpEncodingParameters alloc] init];
  encoding.isActive = YES;
  encoding.scaleResolutionDownBy = [NSNumber numberWithDouble:1.0];
  encoding.numTemporalLayers = [NSNumber numberWithInt:1];
#if TARGET_OS_IPHONE
  encoding.networkPriority = RTCPriorityLow;
  encoding.bitratePriority = 1.0;
#endif
  [encoding setRid:map[@"rid"]];

  if (map[@"active"] != nil) {
    [encoding setIsActive:((NSNumber*)map[@"active"]).boolValue];
  }

  if (map[@"minBitrate"] != nil) {
    [encoding setMinBitrateBps:(NSNumber*)map[@"minBitrate"]];
  }

  if (map[@"maxBitrate"] != nil) {
    [encoding setMaxBitrateBps:(NSNumber*)map[@"maxBitrate"]];
  }

  if (map[@"maxFramerate"] != nil) {
    [encoding setMaxFramerate:(NSNumber*)map[@"maxFramerate"]];
  }

  if (map[@"numTemporalLayers"] != nil) {
    [encoding setNumTemporalLayers:(NSNumber*)map[@"numTemporalLayers"]];
  }

  if (map[@"scaleResolutionDownBy"] != nil) {
    [encoding setScaleResolutionDownBy:(NSNumber*)map[@"scaleResolutionDownBy"]];
  }

  if (map[@"scalabilityMode"] != nil) {
    [encoding setScalabilityMode:(NSString*)map[@"scalabilityMode"]];
  }

  return encoding;
}

- (RTCRtpTransceiverInit*)mapToTransceiverInit:(NSDictionary*)map {
  NSArray<NSString*>* streamIds = map[@"streamIds"];
  NSArray<NSDictionary*>* encodingsParams = map[@"sendEncodings"];
  NSString* direction = map[@"direction"];

  RTCRtpTransceiverInit* init = [RTCRtpTransceiverInit alloc];

  if (direction != nil) {
    init.direction = [self stringToTransceiverDirection:direction];
  }

  if (streamIds != nil) {
    init.streamIds = streamIds;
  }

  if (encodingsParams != nil) {
    NSMutableArray<RTCRtpEncodingParameters*>* sendEncodings = [[NSMutableArray alloc] init];
    for (NSDictionary* map in encodingsParams) {
      [sendEncodings addObject:[self mapToEncoding:map]];
    }
    [init setSendEncodings:sendEncodings];
  }
  return init;
}

- (RTCRtpMediaType)stringToRtpMediaType:(NSString*)type {
  if ([type isEqualToString:@"audio"]) {
    return RTCRtpMediaTypeAudio;
  } else if ([type isEqualToString:@"video"]) {
    return RTCRtpMediaTypeVideo;
  } else if ([type isEqualToString:@"data"]) {
    return RTCRtpMediaTypeData;
  }
  return RTCRtpMediaTypeAudio;
}

- (RTCRtpTransceiverDirection)stringToTransceiverDirection:(NSString*)type {
  if ([type isEqualToString:@"sendrecv"]) {
    return RTCRtpTransceiverDirectionSendRecv;
  } else if ([type isEqualToString:@"sendonly"]) {
    return RTCRtpTransceiverDirectionSendOnly;
  } else if ([type isEqualToString:@"recvonly"]) {
    return RTCRtpTransceiverDirectionRecvOnly;
  } else if ([type isEqualToString:@"inactive"]) {
    return RTCRtpTransceiverDirectionInactive;
  }
  return RTCRtpTransceiverDirectionInactive;
}

- (RTCRtpParameters*)updateRtpParameters:(RTCRtpParameters*)parameters
                                    with:(NSDictionary*)newParameters {
  // current encodings
  NSArray<RTCRtpEncodingParameters*>* currentEncodings = parameters.encodings;
  // new encodings
  NSArray* newEncodings = [newParameters objectForKey:@"encodings"];

  NSString* degradationPreference = [newParameters objectForKey:@"degradationPreference"];

  if (degradationPreference != nil) {
    if ([degradationPreference isEqualToString:@"maintain-framerate"]) {
      parameters.degradationPreference =
          [NSNumber numberWithInt:RTCDegradationPreferenceMaintainFramerate];
    } else if ([degradationPreference isEqualToString:@"maintain-resolution"]) {
      parameters.degradationPreference =
          [NSNumber numberWithInt:RTCDegradationPreferenceMaintainResolution];
    } else if ([degradationPreference isEqualToString:@"balanced"]) {
      parameters.degradationPreference = [NSNumber numberWithInt:RTCDegradationPreferenceBalanced];
    } else if ([degradationPreference isEqualToString:@"disabled"]) {
      parameters.degradationPreference = [NSNumber numberWithInt:RTCDegradationPreferenceDisabled];
    }
  }

  for (int i = 0; i < [newEncodings count]; i++) {
    RTCRtpEncodingParameters* currentParams = nil;
    NSDictionary* newParams = [newEncodings objectAtIndex:i];
    NSString* rid = [newParams objectForKey:@"rid"];

    // update by matching RID
    if ([rid isKindOfClass:[NSString class]] && [rid length] != 0) {
      // try to find current encoding with same rid
      NSUInteger result =
          [currentEncodings indexOfObjectPassingTest:^BOOL(RTCRtpEncodingParameters* _Nonnull obj,
                                                           NSUInteger idx, BOOL* _Nonnull stop) {
            // stop if found object with matching rid
            return (*stop = ([rid isEqualToString:obj.rid]));
          }];

      if (result != NSNotFound) {
        currentParams = [currentEncodings objectAtIndex:result];
      }
    }

    // fall back to update by index
    if (currentParams == nil && i < [currentEncodings count]) {
      currentParams = [currentEncodings objectAtIndex:i];
    }

    if (currentParams != nil) {
      // update values
      NSNumber* active = [newParams objectForKey:@"active"];
      if (active != nil)
        currentParams.isActive = [active boolValue];
      NSNumber* maxBitrate = [newParams objectForKey:@"maxBitrate"];
      if (maxBitrate != nil)
        currentParams.maxBitrateBps = maxBitrate;
      NSNumber* minBitrate = [newParams objectForKey:@"minBitrate"];
      if (minBitrate != nil)
        currentParams.minBitrateBps = minBitrate;
      NSNumber* maxFramerate = [newParams objectForKey:@"maxFramerate"];
      if (maxFramerate != nil)
        currentParams.maxFramerate = maxFramerate;
      NSNumber* numTemporalLayers = [newParams objectForKey:@"numTemporalLayers"];
      if (numTemporalLayers != nil)
        currentParams.numTemporalLayers = numTemporalLayers;
      NSNumber* scaleResolutionDownBy = [newParams objectForKey:@"scaleResolutionDownBy"];
      if (scaleResolutionDownBy != nil)
        currentParams.scaleResolutionDownBy = scaleResolutionDownBy;
      NSString* scalabilityMode = [newParams objectForKey:@"scalabilityMode"];
      if (scalabilityMode != nil)
        currentParams.scalabilityMode = scalabilityMode;
    }
  }

  return parameters;
}

- (NSString*)transceiverDirectionString:(RTCRtpTransceiverDirection)direction {
  switch (direction) {
    case RTCRtpTransceiverDirectionSendRecv:
      return @"sendrecv";
    case RTCRtpTransceiverDirectionSendOnly:
      return @"sendonly";
    case RTCRtpTransceiverDirectionRecvOnly:
      return @"recvonly";
    case RTCRtpTransceiverDirectionInactive:
      return @"inactive";
    case RTCRtpTransceiverDirectionStopped:
      return @"stopped";
      break;
  }
  return nil;
}

- (NSDictionary*)transceiverToMap:(RTCRtpTransceiver*)transceiver {
  NSString* mid = transceiver.mid ? transceiver.mid : @"";
  NSDictionary* params = @{
    @"transceiverId" : mid,
    @"mid" : mid,
    @"direction" : [self transceiverDirectionString:transceiver.direction],
    @"sender" : [self rtpSenderToMap:transceiver.sender],
    @"receiver" : [self receiverToMap:transceiver.receiver]
  };
  return params;
}

- (FlutterRTCVideoRenderer*)findRendererByTrackId:(NSString*)trackId {
  for (FlutterRTCVideoRenderer* renderer in self.renders.allValues) {
    if (renderer.videoTrack != nil && [renderer.videoTrack.trackId isEqualToString:trackId]) {
      return renderer;
    }
  }
  return nil;
}

#pragma mark - Event Posting Helper

- (void)postEventWithName:(NSString*)eventName data:(NSDictionary*)data {
  if (!self.eventSink) {
    return;
  }

  NSMutableDictionary* eventData = [NSMutableDictionary dictionaryWithObject:eventName
                                                                      forKey:@"event"];
  if (data) {
    [eventData addEntriesFromDictionary:data];
  }

  postEvent(self.eventSink, eventData);
}

#pragma mark - RTCAudioDeviceModuleDelegate methods

// All RTCAudioDeviceModuleDelegate methods are @required (no @optional).
- (void)audioDeviceModuleDidUpdateDevices:(RTCAudioDeviceModule*)audioDeviceModule {
  NSLog(@"audioDeviceModule did update devices");
  if (self.eventSink) {
    postEvent(self.eventSink, @{@"event" : @"onDeviceChange"});
  }
}

- (void)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
    didUpdateAudioProcessingState:(RTCAudioProcessingState)state {
  NSLog(@"audioDeviceModule did update audio processing state - stereoPlayoutEnabled: %d, "
        @"voiceProcessingEnabled: %d, voiceProcessingBypassed: %d, voiceProcessingAGCEnabled: %d",
        state.stereoPlayoutEnabled, state.voiceProcessingEnabled, state.voiceProcessingBypassed,
        state.voiceProcessingAGCEnabled);
  if (self.eventSink) {
    postEvent(self.eventSink, @{
      @"event" : @"onAudioProcessingStateChanged",
      @"stereoPlayoutEnabled" : @(state.stereoPlayoutEnabled),
      @"voiceProcessingEnabled" : @(state.voiceProcessingEnabled),
      @"voiceProcessingBypassed" : @(state.voiceProcessingBypassed),
      @"voiceProcessingAGCEnabled" : @(state.voiceProcessingAGCEnabled)
    });
  }
}

- (void)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
    didReceiveSpeechActivityEvent:(RTCSpeechActivityEvent)speechActivityEvent {
  if (!self.eventSink)
    return;
  NSString* type = (speechActivityEvent == RTCSpeechActivityEventStarted) ? @"started" : @"ended";
  postEvent(self.eventSink, @{
    @"event" : @"onSpeechActivityChanged",
    @"type" : type,
  });
}

- (NSInteger)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
               didCreateEngine:(AVAudioEngine*)engine {
  return 0;
}

- (NSInteger)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
              willEnableEngine:(AVAudioEngine*)engine
              isPlayoutEnabled:(BOOL)isPlayoutEnabled
            isRecordingEnabled:(BOOL)isRecordingEnabled {
  return 0;
}

- (NSInteger)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
               willStartEngine:(AVAudioEngine*)engine
              isPlayoutEnabled:(BOOL)isPlayoutEnabled
            isRecordingEnabled:(BOOL)isRecordingEnabled {
  return 0;
}

- (NSInteger)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
                 didStopEngine:(AVAudioEngine*)engine
              isPlayoutEnabled:(BOOL)isPlayoutEnabled
            isRecordingEnabled:(BOOL)isRecordingEnabled {
  return 0;
}

- (NSInteger)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
              didDisableEngine:(AVAudioEngine*)engine
              isPlayoutEnabled:(BOOL)isPlayoutEnabled
            isRecordingEnabled:(BOOL)isRecordingEnabled {
  return 0;
}

- (NSInteger)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
             willReleaseEngine:(AVAudioEngine*)engine {
  return 0;
}

- (NSInteger)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
                        engine:(AVAudioEngine*)engine
      configureInputFromSource:(AVAudioNode*)source
                 toDestination:(AVAudioNode*)destination
                    withFormat:(AVAudioFormat*)format
                       context:(NSDictionary*)context {
  return 0;
}

- (NSInteger)audioDeviceModule:(RTCAudioDeviceModule*)audioDeviceModule
                        engine:(AVAudioEngine*)engine
     configureOutputFromSource:(AVAudioNode*)source
                 toDestination:(AVAudioNode*)destination
                    withFormat:(AVAudioFormat*)format
                       context:(NSDictionary*)context {
  return 0;
}

@end
