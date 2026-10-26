
#import <StreamWebRTC/RTCVideoCapturer.h>
#import <StreamWebRTC/RTCVideoFrame.h>

@protocol VideoFrameProcessorDelegate
- (RTCVideoFrame*)capturer:(RTCVideoCapturer*)capturer didCaptureVideoFrame:(RTCVideoFrame*)frame;
@end