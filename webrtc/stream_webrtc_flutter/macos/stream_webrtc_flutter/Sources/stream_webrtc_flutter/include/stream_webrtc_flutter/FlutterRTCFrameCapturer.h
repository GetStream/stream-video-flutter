#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#else
#import <FlutterMacOS/FlutterMacOS.h>
#endif
#import <StreamWebRTC/StreamWebRTC.h>

@interface FlutterRTCFrameCapturer : NSObject <RTCVideoRenderer>

- (instancetype)initWithTrack:(RTCVideoTrack*)track
                       toPath:(NSString*)path
                       result:(FlutterResult)result;

+ (CVPixelBufferRef)convertToCVPixelBuffer:(RTCVideoFrame*)frame;

@end
