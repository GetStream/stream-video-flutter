#import <Flutter/Flutter.h>
#import <StreamWebRTC/StreamWebRTC.h>

@import Foundation;
@import AVFoundation;

@interface FlutterRTCMediaRecorder : NSObject <RTCVideoRenderer>

@property(nonatomic, strong) RTCVideoTrack* _Nullable videoTrack;
@property(nonatomic, strong) NSURL* _Nonnull output;
@property(nonatomic, strong) AVAssetWriter* _Nullable assetWriter;
@property(nonatomic, strong) AVAssetWriterInput* _Nullable writerInput;

- (instancetype _Nonnull)initWithVideoTrack:(RTCVideoTrack* _Nullable)video
                                 audioTrack:(RTCAudioTrack* _Nullable)audio
                                 outputFile:(NSURL* _Nonnull)out;

- (void)stop:(_Nonnull FlutterResult)result;

@end
