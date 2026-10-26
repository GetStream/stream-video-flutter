#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#else
#import <FlutterMacOS/FlutterMacOS.h>
#endif
#import <StreamWebRTC/StreamWebRTC.h>

#import "FlutterWebRTCPlugin.h"

NS_ASSUME_NONNULL_BEGIN

/// Dart-visible EncryptionManager: wraps native manager and its event channel
/// (`FlutterWebRTC/e2ee/<managerId>`), created via `encryptionManagerCreate` and stored by
/// `managerId`.
@interface FlutterRTCEncryptionManagerHandle
    : NSObject <FlutterStreamHandler, RTCEncryptionManagerDelegate>

@property(nonatomic, strong, readonly) RTCEncryptionManager* manager;
@property(nonatomic, strong, readonly) FlutterEventChannel* eventChannel;

- (instancetype)initWithManager:(RTCEncryptionManager*)manager
                   eventChannel:(FlutterEventChannel*)eventChannel NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Detaches the event channel. Platform thread only, and before
 * `releaseNative` so no event races the teardown.
 */
- (void)detach;

/** Releases the native manager. Blocks on its frame-crypto worker. */
- (void)releaseNative;

@end

/**
 * Common Stream implementation for AES-GCM end-to-end encryption,
 * used across all Stream SDKs (JS, iOS, Android, Flutter).
 * This is independent of per-call factories: the manager owns keys,
 * not media.
 */
@interface FlutterWebRTCPlugin (EncryptionManager)

/**
 * Handles every `encryptionManager*` method.
 *
 * @return `YES` when `call` belonged to this bridge and `result` was already
 *     invoked, `NO` when the caller should keep dispatching.
 */
- (BOOL)handleEncryptionManagerMethodCall:(nonnull FlutterMethodCall*)call
                                   result:(nonnull FlutterResult)result;

/** Releases every manager, e.g. when the plugin detaches from the engine. */
- (void)disposeAllEncryptionManagers;

@end

NS_ASSUME_NONNULL_END
