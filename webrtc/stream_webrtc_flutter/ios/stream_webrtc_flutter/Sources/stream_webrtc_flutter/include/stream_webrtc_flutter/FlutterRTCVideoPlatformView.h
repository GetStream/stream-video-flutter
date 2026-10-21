#import <Flutter/Flutter.h>
#import <StreamWebRTC/StreamWebRTC.h>

@interface FlutterRTCVideoPlatformView : UIView

- (void)renderFrame:(nullable RTC_OBJC_TYPE(RTCVideoFrame) *)frame;

- (instancetype _Nonnull)initWithFrame:(CGRect)frame;

- (void)setSize:(CGSize)size;

@end
