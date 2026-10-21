#import "include/stream_webrtc_flutter/NativePeerConnectionFactory.h"
#import "include/stream_webrtc_flutter/VideoFactoriesPrivate.h"

#import <StreamWebRTC/StreamWebRTC.h>

@implementation NativePeerConnectionFactory {
  RTCPeerConnectionFactory* _factory;
  RTCAudioDeviceModule* _audioDeviceModule;
  BOOL _disposed;
}

- (instancetype)initWithFactoryId:(NSString*)factoryId
            bypassVoiceProcessing:(BOOL)bypassVoiceProcessing
                networkIgnoreMask:(NSArray<NSString*>*)networkIgnoreMask
            audioProcessingModule:(RTCDefaultAudioProcessingModule*)apm
          appleAudioConfiguration:(NSDictionary*)appleAudioConfiguration
                      admObserver:(id<RTCAudioDeviceModuleDelegate>)admObserver {
  if (self = [super init]) {
    _factoryId = [factoryId copy];
    _bypassVoiceProcessing = bypassVoiceProcessing;
    _audioConfigSnapshot = [appleAudioConfiguration copy];
    _ownedPcIds = [NSMutableSet new];
    _ownedTrackIds = [NSMutableSet new];
    _ownedStreamIds = [NSMutableSet new];
    _disposed = NO;
    // Ensure ADM operations are executed sequentially in order of invocation.
    _admQueue = dispatch_queue_create(
        [[NSString stringWithFormat:@"io.getstream.webrtc.adm.%@", factoryId] UTF8String],
        dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED,
                                                0));

    // appleAudioConfiguration is not applied here: the plugin applies it on its
    // audio-session queue, serialized with the other AVAudioSession work, so
    // building a factory does not reconfigure the session on the main thread.

    VideoDecoderFactory* decoderFactory = [[VideoDecoderFactory alloc] init];
    VideoEncoderFactory* encoderFactory = [[VideoEncoderFactory alloc] init];
    VideoEncoderFactorySimulcast* simulcastFactory =
        [[VideoEncoderFactorySimulcast alloc] initWithPrimary:encoderFactory
                                                     fallback:encoderFactory];

    _factory = [[RTCPeerConnectionFactory alloc]
        initWithAudioDeviceModuleType:RTCAudioDeviceModuleTypeAudioEngine
                bypassVoiceProcessing:bypassVoiceProcessing
                       encoderFactory:simulcastFactory
                       decoderFactory:decoderFactory
                audioProcessingModule:apm];

    RTCPeerConnectionFactoryOptions* options = [[RTCPeerConnectionFactoryOptions alloc] init];
    for (NSString* adapter in networkIgnoreMask) {
      if ([@"adapterTypeEthernet" isEqualToString:adapter]) {
        options.ignoreEthernetNetworkAdapter = YES;
      } else if ([@"adapterTypeWifi" isEqualToString:adapter]) {
        options.ignoreWiFiNetworkAdapter = YES;
      } else if ([@"adapterTypeCellular" isEqualToString:adapter]) {
        options.ignoreCellularNetworkAdapter = YES;
      } else if ([@"adapterTypeVpn" isEqualToString:adapter]) {
        options.ignoreVPNNetworkAdapter = YES;
      } else if ([@"adapterTypeLoopback" isEqualToString:adapter]) {
        options.ignoreLoopbackNetworkAdapter = YES;
      } else if ([@"adapterTypeAny" isEqualToString:adapter]) {
        options.ignoreEthernetNetworkAdapter = YES;
        options.ignoreWiFiNetworkAdapter = YES;
        options.ignoreCellularNetworkAdapter = YES;
        options.ignoreVPNNetworkAdapter = YES;
        options.ignoreLoopbackNetworkAdapter = YES;
      }
    }
    [_factory setOptions:options];

    _audioDeviceModule = _factory.audioDeviceModule;
    if (admObserver != nil) {
      _audioDeviceModule.observer = admObserver;
    }

    NSLog(@"[NativePeerConnectionFactory] built id: %@ bypass: %d", factoryId,
          bypassVoiceProcessing);
  }
  return self;
}

- (void)dispose {
  if (_disposed) {
    return;
  }
  _disposed = YES;

  RTCAudioDeviceModule* adm = _audioDeviceModule;
  _audioDeviceModule = nil;

  RTCPeerConnectionFactory* factory = _factory;
  _factory = nil;
  NSString* factoryId = _factoryId;

  if (adm != nil) {
    // No further events should reach a factory that is going away.
    adm.observer = nil;
    // Stop through the ADM queue rather than inline: operations enqueued before
    // dispose (start recording, mute, resume, ...) captured the ADM strongly and
    // would otherwise run after these stops and leave capture running on a
    // disposed factory. Tailing the queue makes the stops the last ADM calls.
    // Enqueued asynchronously so dispose never blocks its caller and can never
    // deadlock when invoked from the ADM queue itself; the block holds the last
    // references to the ADM and the factory, so both outlive the queued work.
    dispatch_async(_admQueue, ^{
      @try {
        [adm stopRecording];
        [adm stopPlayout];
      } @catch (NSException* e) {
        NSLog(@"[NativePeerConnectionFactory] stopRecording/stopPlayout failed: %@", e);
      }
      NSLog(@"[NativePeerConnectionFactory] ADM stopped id: %@ (factory %p)", factoryId, factory);
    });
  }

  NSLog(@"[NativePeerConnectionFactory] disposed id: %@", factoryId);
}

- (BOOL)isDisposed {
  return _disposed;
}

@end
