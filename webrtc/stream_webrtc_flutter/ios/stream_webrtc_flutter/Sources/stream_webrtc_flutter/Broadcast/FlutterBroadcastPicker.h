#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** The system picker of the app's broadcast upload extension. */
@interface FlutterBroadcastPicker : NSObject

/**
 * Shows the picker, preselecting the extension named by the
 * `RTCScreenSharingExtension` Info.plist key. Starts no capture.
 */
+ (void)present;

@end

NS_ASSUME_NONNULL_END
