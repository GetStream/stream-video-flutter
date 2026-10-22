#import <Foundation/Foundation.h>
#import "FlutterWebRTCPlugin.h"

@interface RTCMediaStreamTrack (Flutter)
@property(nonatomic, strong, nonnull) id settings;
@end

@interface FlutterWebRTCPlugin (RTCMediaStream)

- (RTCVideoTrack* _Nullable)cloneTrack:(nonnull NSString*)trackId;

- (void)getUserMedia:(nonnull NSDictionary*)constraints
           factoryId:(nullable NSString*)factoryId
              result:(nonnull FlutterResult)result;

- (void)createLocalMediaStream:(nullable NSString*)factoryId
                        result:(nonnull FlutterResult)result;

- (void)getSources:(nonnull FlutterResult)result;

#if TARGET_OS_IPHONE
/**
 * The audio inputs and outputs `getSources` reports, as source maps. Reads
 * `availableInputs`, an IPC to the audio server, so call it on
 * `deviceEnumerationQueue`, not on main.
 */
- (nonnull NSArray<NSDictionary*>*)audioSessionSources;
#endif

- (void)mediaStreamTrackCaptureFrame:(nonnull RTCMediaStreamTrack*)track
                              toPath:(nonnull NSString*)path
                              result:(nonnull FlutterResult)result;

- (void)selectAudioInput:(nonnull NSString*)deviceId result:(nullable FlutterResult)result;

- (void)selectAudioOutput:(nonnull NSString*)deviceId result:(nullable FlutterResult)result;

- (void)triggeriOSAudioRouteSelectionUI:(nonnull FlutterResult)result;
@end
