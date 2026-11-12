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
 * Posted to gate the audio engine of every peer-connection factory, from
 * code that does not link this plugin. It does what the matching calls on
 * +audioEngineControl do. The
 * userInfo carries FlutterWebRTCAudioEngineAvailableKey as an NSNumber BOOL.
 * It may also carry FlutterWebRTCAudioSessionActiveKey as an NSNumber BOOL,
 * meaning CallKit activated (YES) or deactivated (NO) the audio session; see
 * -setCallKitAudioSessionActive:. May be posted from any thread.
 */
FOUNDATION_EXPORT NSNotificationName _Nonnull const FlutterWebRTCAudioEngineAvailabilityNotification;
FOUNDATION_EXPORT NSString* _Nonnull const FlutterWebRTCAudioEngineAvailableKey;
FOUNDATION_EXPORT NSString* _Nonnull const FlutterWebRTCAudioSessionActiveKey;

/**
 * Posted, on the main thread, when a factory's audio engine could not be
 * started after it became available. A CallKit integration can register the
 * call with CallKit again on it, for a fresh activation of the audio session.
 */
FOUNDATION_EXPORT NSNotificationName _Nonnull const FlutterWebRTCAudioEngineStartFailedNotification;

/**
 * The audio engine controls for code that links this plugin, such as the
 * CallKit plugin. They do what the notifications above do. Get them from
 * +[FlutterWebRTCPlugin audioEngineControl].
 */
@protocol FlutterWebRTCAudioEngineControl <NSObject>

/**
 * Allows or stops the audio engine of every factory of every registration of
 * this plugin. A factory or a registration created later takes the value set
 * last. Stopping an engine that is already stopped does nothing. May be called
 * from any thread.
 */
- (void)setAudioEngineAvailable:(BOOL)available;

/**
 * Tells WebRTC that CallKit activated (YES) or deactivated (NO) the app's
 * audio session, once for the process however many registrations there are.
 * A repeated value does nothing. iOS only; no effect on macOS.
 */
- (void)setCallKitAudioSessionActive:(BOOL)active;

/**
 * Called on the main thread when a factory's audio engine could not be
 * started after it became available, once per such factory, and alongside
 * FlutterWebRTCAudioEngineStartFailedNotification: use one or the other. Set
 * it on the main thread.
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
 * The process-wide audio engine control. CallKit and the audio session belong
 * to the process, so one control serves every registration of this plugin,
 * one per Flutter engine, including registrations made later. Never nil.
 */
+ (id<FlutterWebRTCAudioEngineControl> _Nonnull)audioEngineControl;

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

#pragma mark - Audio engine availability

/**
 * Gates the AVAudioEngine of every peer-connection factory, the ones that
 * exist and the ones built later, until the next call.
 *
 * The audio device module starts and stops its engine on its own as playout
 * and recording are enabled. Under CallKit that timing is wrong: the engine
 * must stay down from provider:didDeactivate: until the next
 * provider:didActivate:, and an engine started in between runs silently and
 * never recovers. Pass NO when CallKit takes the session away and YES once it
 * hands it back; the engine stops and restarts accordingly while playout and
 * recording keep their state.
 *
 * While unavailable, a factory whose playout runs keeps pulling received
 * audio through the audio device module's manual rendering mode, an engine
 * without hardware, so the jitter buffer stays current and the engine resumes
 * on live audio rather than replaying what arrived while it was down.
 *
 * When the engine fails to start on becoming available,
 * FlutterWebRTCAudioEngineStartFailedNotification is posted. CallKit may
 * activate the session for a call it takes off hold while the app is still
 * in the background, behind the phone app whose call the user just ended;
 * iOS refuses microphone input to an app in the background, and the engine
 * does not recover from that on its own, nor from a later start on the same
 * session.
 */
- (void)setAudioEngineAvailable:(BOOL)available;

/**
 * Tells WebRTC's audio session that CallKit activated or deactivated the
 * app's audio session, through RTCAudioSession's audioSessionDidActivate: and
 * audioSessionDidDeactivate:. WebRTC keeps its own idea of whether the session
 * is active and how many activations it holds, and acts on it: after an
 * interruption ends, or the app returns to the foreground, it activates or
 * deactivates the session by itself. During a CallKit call only CallKit may do
 * that, and a session the app activated keeps CallKit from activating its own.
 * Keeping WebRTC informed is what the Swift and React Native SDKs do in their
 * CallKit callbacks. Repeated calls with the same value are ignored, since
 * CallKit deactivates more than once for one activation. iOS only.
 */
- (void)setCallKitAudioSessionActive:(BOOL)active;

@property(nonatomic, copy, nullable) void (^audioEngineStartFailedHandler)(void);

@end
