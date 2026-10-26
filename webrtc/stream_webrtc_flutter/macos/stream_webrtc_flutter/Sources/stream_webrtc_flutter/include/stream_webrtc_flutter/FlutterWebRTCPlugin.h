#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#else
#import <FlutterMacOS/FlutterMacOS.h>
#endif
#import <Foundation/Foundation.h>
#import <StreamWebRTC/StreamWebRTC.h>
#import "LocalTrack.h"

@class VideoEffectProcessor;
@class FlutterRTCVideoRenderer;
@class FlutterRTCFrameCapturer;
#if TARGET_OS_IPHONE
@class FlutterRTCMediaRecorder;
#endif
@class AudioManager;
@class NativePeerConnectionFactory;

void postEvent(FlutterEventSink _Nullable sink, id _Nullable event);

typedef void (^CompletionHandler)(void);

typedef void (^CapturerStopHandler)(CompletionHandler _Nonnull handler);

@interface FlutterWebRTCPlugin : NSObject <FlutterPlugin,
                                           RTCPeerConnectionDelegate,
                                           RTCAudioDeviceModuleDelegate,
#if TARGET_OS_OSX
                                           RTCDesktopMediaListDelegate,
                                           RTCDesktopCapturerDelegate,
#endif
                                           FlutterStreamHandler>

/**
 * Per-call factory registry, keyed by factoryId.
 */
@property(nonatomic, strong, readonly, nonnull)
    NSMutableDictionary<NSString*, NativePeerConnectionFactory*>* factories;

/**
 * Maps a peer connection id to the factoryId of the NativePeerConnectionFactory
 * that built it.
 */
@property(nonatomic, strong, readonly, nonnull)
    NSMutableDictionary<NSString*, NSString*>* pcFactoryId;

/**
 * Maps a track id (audio or video) to the factoryId of the
 * NativePeerConnectionFactory whose RTCPeerConnectionFactory created the
 * underlying RTCMediaSource.
 */
@property(nonatomic, strong, readonly, nonnull)
    NSMutableDictionary<NSString*, NSString*>* trackFactoryId;

@property(nonatomic, strong)
    NSMutableDictionary<NSString*, RTCPeerConnection*>* _Nullable peerConnections;
@property(nonatomic, strong)
    NSMutableDictionary<NSString*, RTCMediaStream*>* _Nullable localStreams;
@property(nonatomic, strong) NSMutableDictionary<NSString*, id<LocalTrack>>* _Nullable localTracks;
@property(nonatomic, strong)
    NSMutableDictionary<NSNumber*, FlutterRTCVideoRenderer*>* _Nullable renders;
#if TARGET_OS_IPHONE
@property(nonatomic, strong)
    NSMutableDictionary<NSNumber*, FlutterRTCMediaRecorder*>* _Nonnull recorders;
#endif
@property(nonatomic, strong)
    NSMutableDictionary<NSString*, CapturerStopHandler>* _Nullable videoCapturerStopHandlers;
@property(nonatomic, strong)
    NSMutableDictionary<NSString*, NSMutableDictionary*>* _Nullable videoCaptureState;

#if TARGET_OS_IPHONE
@property(nonatomic, retain)
    UIViewController* _Nullable viewController; /*for broadcast or ReplayKit */
#endif

@property(nonatomic, strong) FlutterEventSink _Nullable eventSink;
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger>* _Nonnull messenger;
@property(nonatomic, strong) RTCCameraVideoCapturer* _Nullable videoCapturer;
@property(nonatomic, strong) FlutterRTCFrameCapturer* _Nullable frameCapturer;
#if TARGET_OS_IPHONE
@property(nonatomic, strong) AVAudioSessionPort _Nullable preferredInput;
#endif
@property(nonatomic, strong) VideoEffectProcessor* _Nullable videoEffectProcessor;

@property(nonatomic, strong) NSString* _Nonnull focusMode;
@property(nonatomic, strong) NSString* _Nonnull exposureMode;

@property(nonatomic) BOOL _usingFrontCamera;
@property(nonatomic) NSInteger _lastTargetWidth;
@property(nonatomic) NSInteger _lastTargetHeight;
@property(nonatomic) NSInteger _lastTargetFps;

@property(nonatomic, strong) AudioManager* _Nullable audioManager;

@property(nonatomic, strong) NSMutableDictionary<NSString*, NSNumber*>* _Nonnull trackVolumeCache;
@property(nonatomic, strong) NSMutableDictionary<NSString*, NSNumber*>* _Nonnull pausedTrackVolumes;
@property(nonatomic) BOOL isAudioPlayoutPaused;

/// Whether camera access while multitasking was asked for. Remembered so that
/// a capture session created afterwards is started with it applied.
@property(nonatomic) BOOL multitaskingCameraAccessRequested;

- (void)mediaStreamTrackSetVideoEffects:(nonnull NSString*)trackId
                                  names:(nonnull NSArray<NSString*>*)names;
- (RTCMediaStream* _Nullable)streamForId:(NSString* _Nonnull)streamId
                        peerConnectionId:(NSString* _Nullable)peerConnectionId;
- (RTCMediaStreamTrack* _Nullable)trackForId:(NSString* _Nonnull)trackId
                            peerConnectionId:(NSString* _Nullable)peerConnectionId;
- (NSString* _Nullable)audioTrackIdForVideoTrackId:(NSString* _Nonnull)videoTrackId;
- (RTCRtpTransceiver* _Nullable)getRtpTransceiverById:(RTCPeerConnection* _Nonnull)peerConnection
                                                   Id:(NSString* _Nullable)Id;
- (NSDictionary* _Nullable)mediaStreamToMap:(RTCMediaStream* _Nonnull)stream
                                   ownerTag:(NSString* _Nullable)ownerTag;
- (NSDictionary* _Nullable)mediaTrackToMap:(RTCMediaStreamTrack* _Nonnull)track;
- (NSDictionary* _Nullable)receiverToMap:(RTCRtpReceiver* _Nonnull)receiver;
- (NSDictionary* _Nullable)transceiverToMap:(RTCRtpTransceiver* _Nonnull)transceiver;

- (RTCMediaStreamTrack* _Nullable)remoteTrackForId:(NSString* _Nonnull)trackId;

/**
 * Serial queue that device enumeration (`getSources`) runs on, off the main
 * thread. Separate from the audio-session queue, so a lookup never waits
 * behind an audio session reconfiguration.
 */
@property(nonatomic, readonly, nonnull) dispatch_queue_t deviceEnumerationQueue;

- (BOOL)hasLocalAudioTrack;
- (void)applyMultitaskingCameraAccessToCaptureSession;
- (void)ensureAudioSession;
- (void)deactiveRtcAudioSession;

- (RTCRtpReceiver* _Nullable)getRtpReceiverById:(RTCPeerConnection* _Nonnull)peerConnection
                                             Id:(NSString* _Nonnull)Id;
- (RTCRtpSender* _Nullable)getRtpSenderById:(RTCPeerConnection* _Nonnull)peerConnection
                                         Id:(NSString* _Nonnull)Id;

- (void)postEventWithName:(NSString* _Nonnull)eventName data:(NSDictionary* _Nullable)data;

#pragma mark - Per-call factory resolution

/**
 * Resolves a factoryId to a NativePeerConnectionFactory.
 */
- (NativePeerConnectionFactory* _Nullable)resolveFactoryForId:(NSString* _Nullable)factoryId;

/**
 * Resolves the NativePeerConnectionFactory that owns the local stream
 * registered under {@code streamId}. Returns nil when no registered
 * factory owns the stream.
 */
- (NativePeerConnectionFactory* _Nullable)resolveFactoryForStreamId:(NSString* _Nullable)streamId;

+ (FlutterWebRTCPlugin* _Nullable)sharedSingleton;

@end
