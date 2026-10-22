#import <Foundation/Foundation.h>
#import <StreamWebRTC/StreamWebRTC.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Encapsulates a per-call RTCPeerConnectionFactory together with the
 * RTCAudioDeviceModule it owns.
 */
@interface NativePeerConnectionFactory : NSObject

/** Id used by Dart-side callers to address this factory. */
@property(nonatomic, copy, readonly) NSString* factoryId;

/** The factory that builds peer connections + tracks. */
@property(nonatomic, strong, readonly, nullable) RTCPeerConnectionFactory* factory;

/**
 * The factory's own ADM. Not owned by this class — the underlying factory owns it.
 */
@property(nonatomic, strong, readonly, nullable) RTCAudioDeviceModule* audioDeviceModule;

/**
 * Serial queue for every ADM operation issued against this factory: start /
 * stop recording, microphone mute, suspend / resume.
 */
@property(nonatomic, strong, readonly) dispatch_queue_t admQueue;

/**
 * The appleAudioConfiguration to restore when audio resumes. Starts as the one
 * used to build this factory and follows later setAppleAudioConfiguration
 * calls that the session accepted. Read and written on the audio-session queue
 * (the initial value is set in init).
 */
@property(atomic, copy, nullable) NSDictionary* audioConfigSnapshot;

/** Whether voice-processing was bypassed at build time. */
@property(nonatomic, assign, readonly) BOOL bypassVoiceProcessing;

/**
 * Peer-connection ids whose PC was created against this factory.
 */
@property(nonatomic, strong, readonly) NSMutableSet<NSString*>* ownedPcIds;

/**
 * Track ids created via this factory.
 */
@property(nonatomic, strong, readonly) NSMutableSet<NSString*>* ownedTrackIds;

/**
 * Stream ids created via this factory.
 */
@property(nonatomic, strong, readonly) NSMutableSet<NSString*>* ownedStreamIds;

@property(nonatomic, assign, readonly) BOOL isDisposed;

/**
 * Snapshot of the ADM's playout/recording state captured at suspend time
 * so resumeAudio can restore only what was active. Toggled by the
 * suspendAudio/resumeAudio method-channel handlers in FlutterWebRTCPlugin.
 */
@property(nonatomic, assign) BOOL wasPlayingBeforeSuspend;
@property(nonatomic, assign) BOOL wasRecordingBeforeSuspend;

/**
 * Whether audio is currently suspended.
 */
@property(nonatomic, assign) BOOL audioSuspended;

- (instancetype)initWithFactoryId:(NSString*)factoryId
            bypassVoiceProcessing:(BOOL)bypassVoiceProcessing
                networkIgnoreMask:(NSArray<NSString*>*)networkIgnoreMask
            audioProcessingModule:(RTCDefaultAudioProcessingModule*)apm
          appleAudioConfiguration:(nullable NSDictionary*)appleAudioConfiguration
                      admObserver:(nullable id<RTCAudioDeviceModuleDelegate>)admObserver;

/**
 * Releases the factory and its ADM.
 */
- (void)dispose;

@end

NS_ASSUME_NONNULL_END
