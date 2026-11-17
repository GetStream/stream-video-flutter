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

/**
 * Posted to do what -[FlutterWebRTCAudioEngineControl setAudioEngineAvailable:]
 * does, from code that does not link this plugin. The userInfo carries
 * FlutterWebRTCAudioEngineAvailableKey as an NSNumber BOOL. It may also carry
 * FlutterWebRTCAudioSessionActiveKey as an NSNumber BOOL, which does what
 * -setCallKitAudioSessionActive: does: an activation is applied before the
 * availability, a deactivation after it. May be posted from any thread.
 */
FOUNDATION_EXPORT NSNotificationName _Nonnull const FlutterWebRTCAudioEngineAvailabilityNotification;
FOUNDATION_EXPORT NSString* _Nonnull const FlutterWebRTCAudioEngineAvailableKey;
FOUNDATION_EXPORT NSString* _Nonnull const FlutterWebRTCAudioSessionActiveKey;

/**
 * Posted, on the main thread, when a factory's audio engine could not be
 * started after it became available. The audio session it was given will not
 * start the engine again; an app that owns the session through CallKit can get
 * a fresh one by registering the call with CallKit again. Any number of
 * observers may listen.
 */
FOUNDATION_EXPORT NSNotificationName _Nonnull const FlutterWebRTCAudioEngineStartFailedNotification;

/**
 * Controls the audio engine of every peer-connection factory of every
 * registration of this plugin, for an app that activates the audio session
 * itself, such as through CallKit. Get it from
 * FlutterWebRTCPlugin.audioEngineControl. The notifications above do the same
 * for code that does not link this plugin.
 */
@protocol FlutterWebRTCAudioEngineControl <NSObject>

/**
 * Allows or stops the AVAudioEngine of every factory, the ones that exist and
 * the ones built later, until the next call. A registration made later takes
 * the value set last. Stopping an engine that is already stopped does nothing.
 * May be called from any thread.
 *
 * The audio device module starts and stops its engine as playout and recording
 * are enabled. When the app activates the audio session itself, that timing is
 * wrong: the engine has to stay down while the app does not hold the session,
 * or it runs silently. Pass NO when the session is taken away and YES once it
 * is back; playout and recording keep their state, and the engine stops and
 * starts with the value.
 *
 * A factory whose playout is running when the engine is stopped keeps pulling
 * received audio through the audio device module's manual rendering mode, an
 * engine without hardware, so it resumes on live audio. A factory built while
 * the engine is stopped, or whose playout starts afterwards, does not, and may
 * play the last seconds it received when the engine is back.
 *
 * When the engine cannot be started on becoming available,
 * FlutterWebRTCAudioEngineStartFailedNotification is posted and
 * audioEngineStartFailedHandler is called.
 */
- (void)setAudioEngineAvailable:(BOOL)available;

/**
 * Tells WebRTC's audio session that the app's audio session was activated
 * (YES) or deactivated (NO) by CallKit, through RTCAudioSession's
 * audioSessionDidActivate: and audioSessionDidDeactivate:. Without it, WebRTC
 * activates or deactivates the session itself after an interruption ends or
 * when the app returns to the foreground, which it must not do while CallKit
 * owns the session. Call it with YES before allowing the engine and with NO
 * after stopping it. Applies once for the process however many registrations
 * there are; a repeated value does nothing. iOS only; no effect on macOS.
 */
- (void)setCallKitAudioSessionActive:(BOOL)active;

/**
 * Called on the main thread, once per factory, when a factory's audio engine
 * could not be started after it became available. It is called alongside
 * FlutterWebRTCAudioEngineStartFailedNotification, so use one or the other.
 * There is one handler for the process and setting it replaces the previous
 * one, so only one owner may set it; any number of observers can use the
 * notification instead. Set it on the main thread.
 */
@property(nonatomic, copy, nullable) void (^audioEngineStartFailedHandler)(void);

@end

@interface FlutterWebRTCPlugin : NSObject <FlutterPlugin,
                                           RTCPeerConnectionDelegate,
                                           RTCAudioDeviceModuleDelegate,
#if TARGET_OS_OSX
                                           RTCDesktopMediaListDelegate,
                                           RTCDesktopCapturerDelegate,
#endif
                                           FlutterStreamHandler>

/**
 * The audio engine control of the process. The audio session belongs to the
 * process, so one control serves every registration of this plugin, one per
 * Flutter engine, including registrations made later.
 */
@property(class, nonatomic, readonly, nonnull) id<FlutterWebRTCAudioEngineControl> audioEngineControl;

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
