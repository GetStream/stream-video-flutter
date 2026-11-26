#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSErrorDomain const FlutterBroadcastPickerErrorDomain;

typedef NS_ERROR_ENUM(FlutterBroadcastPickerErrorDomain, FlutterBroadcastPickerError){
    /** The `RTCScreenSharingExtension` Info.plist key is missing. */
    FlutterBroadcastPickerErrorMissingExtensionKey = 1,
    /** The picker view has no button to open it with. */
    FlutterBroadcastPickerErrorMissingButton = 2,
};

/** The system picker of the app's broadcast upload extension. */
@interface FlutterBroadcastPicker : NSObject

/**
 * Shows the picker, preselecting the extension named by the
 * `RTCScreenSharingExtension` Info.plist key. Starts no capture.
 *
 * Returns NO and sets `error` when the key is missing or the picker cannot be
 * opened.
 */
+ (BOOL)presentWithError:(NSError* _Nullable* _Nullable)error;

@end

NS_ASSUME_NONNULL_END
