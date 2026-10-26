#import "include/stream_webrtc_flutter/FlutterSCStreamCapturer.h"

NSString* const kFlutterSystemPickerSourceId = @"system-picker";

@interface FlutterSCStreamCapturer () <SCStreamOutput, SCStreamDelegate>
@end

@implementation FlutterSCStreamCapturer {
  SCContentFilter* _filter;
  SCStream* _stream;
  dispatch_queue_t _queue;
}

- (instancetype)initWithDelegate:(id<RTCVideoCapturerDelegate>)delegate
                          filter:(SCContentFilter*)filter {
  self = [super initWithDelegate:delegate];
  if (self) {
    _filter = filter;
    _queue = dispatch_queue_create("io.getstream.webrtc.sc-stream-capturer", DISPATCH_QUEUE_SERIAL);
  }
  return self;
}

- (void)startCaptureWithFPS:(NSInteger)fps
         completionHandler:(void (^)(NSError* _Nullable error))completionHandler {
  SCStreamConfiguration* configuration = [[SCStreamConfiguration alloc] init];
  CGFloat scale = _filter.pointPixelScale > 0 ? _filter.pointPixelScale : 1.0;
  // 4:2:0 needs even dimensions.
  configuration.width = (size_t)MAX(2, ceil(_filter.contentRect.size.width * scale / 2) * 2);
  configuration.height = (size_t)MAX(2, ceil(_filter.contentRect.size.height * scale / 2) * 2);
  configuration.pixelFormat = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
  configuration.minimumFrameInterval = CMTimeMake(1, (int32_t)MAX(1, fps));
  configuration.showsCursor = YES;

  _stream = [[SCStream alloc] initWithFilter:_filter configuration:configuration delegate:self];

  NSError* error = nil;
  if (![_stream addStreamOutput:self type:SCStreamOutputTypeScreen sampleHandlerQueue:_queue error:&error]) {
    NSLog(@"FlutterSCStreamCapturer: addStreamOutput failed: %@", error);
    _stream = nil;
    completionHandler(error);
    return;
  }
  [_stream startCaptureWithCompletionHandler:^(NSError* _Nullable startError) {
    if (startError != nil) {
      NSLog(@"FlutterSCStreamCapturer: startCapture failed: %@", startError);
      self->_stream = nil;
    }
    completionHandler(startError);
  }];
}

- (void)stopCaptureWithCompletionHandler:(void (^)(void))completionHandler {
  SCStream* stream = _stream;
  _stream = nil;
  if (stream == nil) {
    if (completionHandler != nil) completionHandler();
    return;
  }
  [stream stopCaptureWithCompletionHandler:^(NSError* _Nullable error) {
    if (error != nil) {
      NSLog(@"FlutterSCStreamCapturer: stopCapture failed: %@", error);
    }
    if (completionHandler != nil) completionHandler();
  }];
}

#pragma mark - SCStreamOutput

- (void)stream:(SCStream*)stream
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
                   ofType:(SCStreamOutputType)type {
  if (type != SCStreamOutputTypeScreen || !CMSampleBufferIsValid(sampleBuffer) ||
      !CMSampleBufferDataIsReady(sampleBuffer)) {
    return;
  }

  // Idle and blank frames carry no pixel buffer.
  NSArray* attachments = (__bridge NSArray*)CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, NO);
  NSDictionary* info = attachments.firstObject;
  NSNumber* status = info[SCStreamFrameInfoStatus];
  if (status != nil && status.integerValue != SCFrameStatusComplete) {
    return;
  }

  CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  if (pixelBuffer == nil) {
    return;
  }

  RTCCVPixelBuffer* rtcPixelBuffer = [[RTCCVPixelBuffer alloc] initWithPixelBuffer:pixelBuffer];
  int64_t timeStampNs =
      (int64_t)(CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * NSEC_PER_SEC);
  RTCVideoFrame* videoFrame = [[RTCVideoFrame alloc] initWithBuffer:rtcPixelBuffer
                                                           rotation:RTCVideoRotation_0
                                                        timeStampNs:timeStampNs];
  [self.delegate capturer:self didCaptureVideoFrame:videoFrame];
}

#pragma mark - SCStreamDelegate

- (void)stream:(SCStream*)stream didStopWithError:(NSError*)error {
  NSLog(@"FlutterSCStreamCapturer: stream stopped: %@", error);
  // The stream retains this capturer as its output; release it so the two do not keep each other alive.
  if (_stream != stream) {
    return;
  }
  _stream = nil;
  if (self.onStopped != nil) {
    self.onStopped();
  }
}

@end

#pragma mark - Picker

@interface FlutterContentSharingPicker () <SCContentSharingPickerObserver>
@property(nonatomic, copy) void (^completion)(SCContentFilter*, NSError*);
@end

@implementation FlutterContentSharingPicker

// The picker keeps a weak reference to its observers, so the one in flight is held here.
static id _current;

+ (void)presentWithCompletion:(void (^)(SCContentFilter*, NSError*))completion {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (_current != nil) {
      completion(nil, [NSError errorWithDomain:@"FlutterContentSharingPicker"
                                          code:1
                                      userInfo:@{NSLocalizedDescriptionKey : @"Picker already shown"}]);
      return;
    }
    FlutterContentSharingPicker* observer = [[FlutterContentSharingPicker alloc] init];
    observer.completion = completion;
    _current = observer;

    SCContentSharingPicker* picker = SCContentSharingPicker.sharedPicker;
    SCContentSharingPickerConfiguration* configuration = [[SCContentSharingPickerConfiguration alloc] init];
    configuration.allowedPickerModes =
        SCContentSharingPickerModeSingleWindow | SCContentSharingPickerModeSingleDisplay;
    picker.defaultConfiguration = configuration;
    picker.maximumStreamCount = @1;
    [picker addObserver:observer];
    picker.active = YES;
    [picker present];
  });
}

- (void)finishWithFilter:(SCContentFilter*)filter error:(NSError*)error {
  SCContentSharingPicker* picker = SCContentSharingPicker.sharedPicker;
  picker.active = NO;
  [picker removeObserver:self];
  void (^completion)(SCContentFilter*, NSError*) = self.completion;
  self.completion = nil;
  _current = nil;
  if (completion != nil) completion(filter, error);
}

- (void)contentSharingPicker:(SCContentSharingPicker*)picker
          didUpdateWithFilter:(SCContentFilter*)filter
                    forStream:(SCStream*)stream {
  [self finishWithFilter:filter error:nil];
}

- (void)contentSharingPicker:(SCContentSharingPicker*)picker didCancelForStream:(SCStream*)stream {
  [self finishWithFilter:nil error:nil];
}

- (void)contentSharingPickerStartDidFailWithError:(NSError*)error {
  [self finishWithFilter:nil error:error];
}

@end
