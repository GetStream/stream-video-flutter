#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>
#import <StreamWebRTC/StreamWebRTC.h>

@interface FlutterRTCAudioSink : NSObject

@property(nonatomic, copy) void (^bufferCallback)(CMSampleBufferRef);
@property(nonatomic) CMAudioFormatDescriptionRef format;

- (instancetype)initWithAudioTrack:(RTCAudioTrack*)audio;

- (void)close;

@end
