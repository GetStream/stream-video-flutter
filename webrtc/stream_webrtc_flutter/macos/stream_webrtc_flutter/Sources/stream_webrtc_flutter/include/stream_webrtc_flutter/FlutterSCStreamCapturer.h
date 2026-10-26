#import <Foundation/Foundation.h>
#import <ScreenCaptureKit/ScreenCaptureKit.h>
#import <StreamWebRTC/StreamWebRTC.h>

/// Value of `deviceId.exact` that asks `getDisplayMedia` to show the system content sharing picker.
extern NSString* _Nonnull const kFlutterSystemPickerSourceId;

/// Captures the content of an `SCContentFilter` with ScreenCaptureKit and feeds the frames to a
/// `RTCVideoCapturerDelegate`.
API_AVAILABLE(macos(14.0))
@interface FlutterSCStreamCapturer : RTCVideoCapturer

- (nonnull instancetype)initWithDelegate:(nonnull id<RTCVideoCapturerDelegate>)delegate
                                  filter:(nonnull SCContentFilter*)filter;

/// Starts capturing. Calls [completionHandler] once with nil when frames are flowing, or with the
/// error when capture could not start.
/// Called when the system ends the capture, such as when the user stops sharing from the menu bar.
/// Not called for [stopCaptureWithCompletionHandler:].
@property(nonatomic, copy, nullable) void (^onStopped)(void);

- (void)startCaptureWithFPS:(NSInteger)fps
          completionHandler:(nonnull void (^)(NSError* _Nullable error))completionHandler;

- (void)stopCaptureWithCompletionHandler:(nullable void (^)(void))completionHandler;

@end

/// Shows the system content sharing picker (`SCContentSharingPicker`) and reports the choice.
API_AVAILABLE(macos(14.0))
@interface FlutterContentSharingPicker : NSObject

/// Presents the picker. Calls [completion] once with the chosen filter, or with nil when the user
/// cancels or the picker fails to start.
+ (void)presentWithCompletion:(nonnull void (^)(SCContentFilter* _Nullable filter,
                                                NSError* _Nullable error))completion;

@end
