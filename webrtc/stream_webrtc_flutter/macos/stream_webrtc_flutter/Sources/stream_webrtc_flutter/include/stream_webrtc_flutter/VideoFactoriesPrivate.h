#import <Foundation/Foundation.h>
#import <StreamWebRTC/StreamWebRTC.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoEncoderFactory : RTCDefaultVideoEncoderFactory
@end

@interface VideoDecoderFactory : RTCDefaultVideoDecoderFactory
@end

@interface VideoEncoderFactorySimulcast : RTCVideoEncoderFactorySimulcast
@end

NS_ASSUME_NONNULL_END
