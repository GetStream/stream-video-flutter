#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Forwards the broadcast upload extension's start and stop notifications to
 * Dart as the `screenSharingStarted` and `screenSharingStopped` events.
 *
 * The extension posts them as Darwin notifications; the names are shared with
 * `stream_video_screen_sharing`.
 */
@interface FlutterBroadcastObserver : NSObject

/** Starts observing, once per process. Later calls do nothing. */
+ (void)startObserving;

@end

NS_ASSUME_NONNULL_END
