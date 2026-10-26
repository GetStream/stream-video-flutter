#import <objc/runtime.h>

#import "include/stream_webrtc_flutter/FlutterRTCDesktopCapturer.h"

#if TARGET_OS_IPHONE
#import <ReplayKit/ReplayKit.h>
#import "include/stream_webrtc_flutter/Broadcast/FlutterBroadcastScreenCapturer.h"
#import "include/stream_webrtc_flutter/FlutterRPScreenRecorder.h"
#endif
#if TARGET_OS_OSX
#import "include/stream_webrtc_flutter/FlutterSCStreamCapturer.h"
#endif
#import "include/stream_webrtc_flutter/LocalVideoTrack.h"
#import "include/stream_webrtc_flutter/NativePeerConnectionFactory.h"
#import "include/stream_webrtc_flutter/VideoProcessingAdapter.h"

#if TARGET_OS_OSX
RTCDesktopMediaList* _screen = nil;
RTCDesktopMediaList* _window = nil;
NSArray<RTCDesktopSource*>* _captureSources;

// Set by the system picker path just before `getDisplayMedia` re-enters with this source id.
static NSString* const kSystemPickerSelectedSourceId = @"system-picker-selected";
static id _pendingContentFilter = nil;
#endif

@implementation FlutterWebRTCPlugin (DesktopCapturer)

- (void)getDisplayMedia:(NSDictionary*)constraints
              factoryId:(NSString*)factoryId
                 result:(FlutterResult)result {
#if TARGET_OS_OSX
  if ([self isSystemPickerRequest:constraints]) {
    [self presentSystemPickerForDisplayMedia:constraints factoryId:factoryId result:result];
    return;
  }
#endif
  NSString* mediaStreamId = [[NSUUID UUID] UUIDString];
  NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
  if (nf == nil || nf.factory == nil) {
    result([FlutterError
        errorWithCode:@"getDisplayMedia"
              message:[NSString stringWithFormat:@"unknown factoryId %@", factoryId]
              details:nil]);
    return;
  }
  RTCMediaStream* mediaStream = [nf.factory mediaStreamWithStreamId:mediaStreamId];
  RTCVideoSource* videoSource = [nf.factory videoSourceForScreenCast:YES];
  NSString* trackUUID = [[NSUUID UUID] UUIDString];
  VideoProcessingAdapter* videoProcessingAdapter =
      [[VideoProcessingAdapter alloc] initWithRTCVideoSource:videoSource];

  // Adds the track to the stream and reports it. Runs once the capturer is delivering frames.
  void (^finishTrack)(void) = ^{
    RTCVideoTrack* videoTrack = [nf.factory videoTrackWithSource:videoSource trackId:trackUUID];
    [mediaStream addVideoTrack:videoTrack];

    LocalVideoTrack* localVideoTrack = [[LocalVideoTrack alloc] initWithTrack:videoTrack
                                                              videoProcessing:videoProcessingAdapter];

    [self.localTracks setObject:localVideoTrack forKey:trackUUID];

    if (nf.factoryId != nil) {
      self.trackFactoryId[trackUUID] = nf.factoryId;
    }

    NSMutableArray* audioTracks = [NSMutableArray array];
    NSMutableArray* videoTracks = [NSMutableArray array];

    for (RTCVideoTrack* track in mediaStream.videoTracks) {
      [videoTracks addObject:@{
        @"id" : track.trackId,
        @"kind" : track.kind,
        @"label" : track.trackId,
        @"enabled" : @(track.isEnabled),
        @"remote" : @(YES),
        @"readyState" : @"live"
      }];
    }

    self.localStreams[mediaStreamId] = mediaStream;
    result(
        @{@"streamId" : mediaStreamId, @"audioTracks" : audioTracks, @"videoTracks" : videoTracks});
  };

#if TARGET_OS_IPHONE
  BOOL useBroadcastExtension = false;
  BOOL presentBroadcastPicker = false;

  id videoConstraints = constraints[@"video"];
  if ([videoConstraints isKindOfClass:[NSDictionary class]]) {
    // constraints.video.deviceId
    useBroadcastExtension = [((NSDictionary*)videoConstraints)[@"deviceId"] hasPrefix:@"broadcast"];
    presentBroadcastPicker = useBroadcastExtension &&
                             ![((NSDictionary*)videoConstraints)[@"deviceId"] hasSuffix:@"-manual"];
  }

  id screenCapturer;

  if (useBroadcastExtension) {
    screenCapturer =
        [[FlutterBroadcastScreenCapturer alloc] initWithDelegate:videoProcessingAdapter];
  } else {
    screenCapturer =
        [[FlutterRPScreenRecorder alloc] initWithDelegate:[videoProcessingAdapter source]];
  }

  [screenCapturer startCapture];
  NSLog(@"start %@ capture", useBroadcastExtension ? @"broadcast" : @"replykit");

  self.videoCapturerStopHandlers[trackUUID] = ^(CompletionHandler handler) {
    NSLog(@"stop %@ capture, trackID %@", useBroadcastExtension ? @"broadcast" : @"replykit",
          trackUUID);
    [screenCapturer stopCaptureWithCompletionHandler:handler];
  };

  if (presentBroadcastPicker) {
    NSString* extension =
        [[[NSBundle mainBundle] infoDictionary] valueForKey:kRTCScreenSharingExtension];

    RPSystemBroadcastPickerView* picker = [[RPSystemBroadcastPickerView alloc] init];
    picker.showsMicrophoneButton = false;
    if (extension) {
      picker.preferredExtension = extension;
    } else {
      NSLog(@"Not able to find the %@ key", kRTCScreenSharingExtension);
    }
    // Trigger the picker's internal button via public UIControl APIs only.
    // Calling the private buttonPressed: selector gets apps rejected under
    // App Store Guideline 2.5.1 (non-public API).
    UIButton* pickerButton = nil;
    for (UIView* subview in picker.subviews) {
      if ([subview isKindOfClass:[UIButton class]]) {
        pickerButton = (UIButton*)subview;
        break;
      }
    }
    if (pickerButton != nil) {
      [pickerButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
      NSLog(@"RPSystemBroadcastPickerView button not found, broadcast picker was not presented");
    }
  }
#endif

#if TARGET_OS_OSX
  /* example for constraints:
      {
          'audio': false,
          'video": {
              'deviceId':  {'exact': sourceId},
              'mandatory': {
                  'frameRate': 30.0
              },
          }
      }
  */
  NSString* sourceId = nil;
  BOOL useDefaultScreen = NO;
  NSInteger fps = 30;
  id videoConstraints = constraints[@"video"];
  if ([videoConstraints isKindOfClass:[NSNumber class]] && [videoConstraints boolValue] == YES) {
    useDefaultScreen = YES;
  } else if ([videoConstraints isKindOfClass:[NSDictionary class]]) {
    NSDictionary* deviceId = videoConstraints[@"deviceId"];
    if (deviceId != nil && [deviceId isKindOfClass:[NSDictionary class]]) {
      if (deviceId[@"exact"] != nil) {
        sourceId = deviceId[@"exact"];
        if (sourceId == nil) {
          result(@{@"error" : @"No deviceId.exact found"});
          return;
        }
      }
    } else {
      // fall back to default screen if no deviceId is specified
      useDefaultScreen = YES;
    }
    id mandatory = videoConstraints[@"mandatory"];
    if (mandatory != nil && [mandatory isKindOfClass:[NSDictionary class]]) {
      id frameRate = mandatory[@"frameRate"];
      if (frameRate != nil && [frameRate isKindOfClass:[NSNumber class]]) {
        fps = [frameRate integerValue];
      }
    }
  }
  RTCDesktopCapturer* desktopCapturer;
  RTCDesktopSource* source = nil;

  if ([sourceId isEqualToString:kSystemPickerSelectedSourceId]) {
    if (@available(macOS 14.0, *)) {
      SCContentFilter* filter = _pendingContentFilter;
      _pendingContentFilter = nil;
      if (filter == nil) {
        result(@{@"error" : @"No content selected in the system picker"});
        return;
      }
      FlutterSCStreamCapturer* streamCapturer =
          [[FlutterSCStreamCapturer alloc] initWithDelegate:videoProcessingAdapter filter:filter];
      // Same event Android sends when its screen share is ended from the system UI.
      streamCapturer.onStopped = ^{
        [self postEventWithName:@"screenSharingStopped" data:@{@"trackId" : trackUUID}];
      };
      self.videoCapturerStopHandlers[trackUUID] = ^(CompletionHandler handler) {
        NSLog(@"stop desktop capture: system picker, trackID %@", trackUUID);
        [streamCapturer stopCaptureWithCompletionHandler:handler];
      };
      NSLog(@"start desktop capture: system picker, fps: %ld", (long)fps);
      [streamCapturer startCaptureWithFPS:fps
                        completionHandler:^(NSError* error) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                            if (error != nil) {
                              [self.videoCapturerStopHandlers removeObjectForKey:trackUUID];
                              result([FlutterError errorWithCode:@"getDisplayMedia"
                                                         message:error.localizedDescription
                                                         details:nil]);
                              return;
                            }
                            finishTrack();
                          });
                        }];
      return;
    }
    result(@{@"error" : @"The system picker requires macOS 14"});
    return;
  }
  if (useDefaultScreen) {
    desktopCapturer = [[RTCDesktopCapturer alloc] initWithDefaultScreen:self
                                                        captureDelegate:videoProcessingAdapter];
  } else {
    source = [self getSourceById:sourceId];
    if (source == nil) {
      result(@{@"error" : [NSString stringWithFormat:@"No source found for id: %@", sourceId]});
      return;
    }
    desktopCapturer = [[RTCDesktopCapturer alloc] initWithSource:source
                                                        delegate:self
                                                 captureDelegate:videoProcessingAdapter];
  }
  [desktopCapturer startCaptureWithFPS:fps];
  NSLog(@"start desktop capture: sourceId: %@, type: %@, fps: %lu", sourceId,
        source.sourceType == RTCDesktopSourceTypeScreen ? @"screen" : @"window", fps);

  self.videoCapturerStopHandlers[trackUUID] = ^(CompletionHandler handler) {
    NSLog(@"stop desktop capture: sourceId: %@, type: %@, trackID %@", sourceId,
          source.sourceType == RTCDesktopSourceTypeScreen ? @"screen" : @"window", trackUUID);
    [desktopCapturer stopCapture];
    handler();
  };
#endif

  finishTrack();
}

- (void)getDesktopSources:(NSDictionary*)argsMap result:(FlutterResult)result {
#if TARGET_OS_OSX
  NSLog(@"getDesktopSources");

  NSArray* types = [argsMap objectForKey:@"types"];
  if (types == nil) {
    result([FlutterError errorWithCode:@"ERROR" message:@"types is required" details:nil]);
    return;
  }

  if (![self buildDesktopSourcesListWithTypes:types forceReload:YES result:result]) {
    NSLog(@"getDesktopSources failed.");
    return;
  }

  NSMutableArray* sources = [NSMutableArray array];
  NSEnumerator* enumerator = [_captureSources objectEnumerator];
  RTCDesktopSource* object;
  while ((object = enumerator.nextObject) != nil) {
    /*NSData *data = nil;
    if([object thumbnail]) {
        data = [[NSData alloc] init];
        NSImage *resizedImg = [self resizeImage:[object thumbnail] forSize:NSMakeSize(320, 180)];
        data = [resizedImg TIFFRepresentation];
    }*/
    [sources addObject:@{
      @"id" : object.sourceId,
      @"name" : object.name,
      @"thumbnailSize" : @{@"width" : @0, @"height" : @0},
      @"type" : object.sourceType == RTCDesktopSourceTypeScreen ? @"screen" : @"window",
      //@"thumbnail": data,
    }];
  }
  result(@{@"sources" : sources});
#else
  result([FlutterError errorWithCode:@"ERROR" message:@"Not supported on iOS" details:nil]);
#endif
}

- (void)getDesktopSourceThumbnail:(NSDictionary*)argsMap result:(FlutterResult)result {
#if TARGET_OS_OSX
  NSLog(@"getDesktopSourceThumbnail");
  NSString* sourceId = argsMap[@"sourceId"];
  RTCDesktopSource* object = [self getSourceById:sourceId];
  if (object == nil) {
    result(@{@"error" : @"No source found"});
    return;
  }
  NSImage* image = [object UpdateThumbnail];
  if (image != nil) {
    NSImage* resizedImg = [self resizeImage:image forSize:NSMakeSize(320, 180)];
    NSData* data = [resizedImg TIFFRepresentation];
    result(data);
  } else {
    result(@{@"error" : @"No thumbnail found"});
  }

#else
  result([FlutterError errorWithCode:@"ERROR" message:@"Not supported on iOS" details:nil]);
#endif
}

- (void)updateDesktopSources:(NSDictionary*)argsMap result:(FlutterResult)result {
#if TARGET_OS_OSX
  NSLog(@"updateDesktopSources");
  NSArray* types = [argsMap objectForKey:@"types"];
  if (types == nil) {
    result([FlutterError errorWithCode:@"ERROR" message:@"types is required" details:nil]);
    return;
  }
  if (![self buildDesktopSourcesListWithTypes:types forceReload:NO result:result]) {
    NSLog(@"updateDesktopSources failed.");
    return;
  }
  result(@{@"result" : @YES});
#else
  result([FlutterError errorWithCode:@"ERROR" message:@"Not supported on iOS" details:nil]);
#endif
}

#if TARGET_OS_OSX
- (BOOL)isSystemPickerRequest:(NSDictionary*)constraints {
  id video = constraints[@"video"];
  if (![video isKindOfClass:[NSDictionary class]]) return NO;
  id deviceId = ((NSDictionary*)video)[@"deviceId"];
  if (![deviceId isKindOfClass:[NSDictionary class]]) return NO;
  return [((NSDictionary*)deviceId)[@"exact"] isEqual:kFlutterSystemPickerSourceId];
}

/// Shows the system picker, then re-enters `getDisplayMedia` with the chosen content.
- (void)presentSystemPickerForDisplayMedia:(NSDictionary*)constraints
                                 factoryId:(NSString*)factoryId
                                    result:(FlutterResult)result {
  NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
  if (nf == nil || nf.factory == nil) {
    result([FlutterError
        errorWithCode:@"getDisplayMedia"
              message:[NSString stringWithFormat:@"unknown factoryId %@", factoryId]
              details:nil]);
    return;
  }
  if (@available(macOS 14.0, *)) {
    [FlutterContentSharingPicker
        presentWithCompletion:^(SCContentFilter* filter, NSError* error) {
          if (filter == nil) {
            result([FlutterError
                errorWithCode:error != nil ? @"getDisplayMedia" : @"cancelled"
                      message:error.localizedDescription ?: @"The system picker was cancelled"
                      details:nil]);
            return;
          }
          _pendingContentFilter = filter;
          NSMutableDictionary* video = [constraints[@"video"] mutableCopy];
          video[@"deviceId"] = @{@"exact" : kSystemPickerSelectedSourceId};
          NSMutableDictionary* updated = [constraints mutableCopy];
          updated[@"video"] = video;
          [self getDisplayMedia:updated factoryId:factoryId result:result];
        }];
  } else {
    result([FlutterError errorWithCode:@"getDisplayMedia"
                               message:@"The system picker requires macOS 14"
                               details:nil]);
  }
}

- (NSImage*)resizeImage:(NSImage*)sourceImage forSize:(CGSize)targetSize {
  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

  if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;

    // scale to fit the longer
    scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
    scaledWidth = ceil(width * scaleFactor);
    scaledHeight = ceil(height * scaleFactor);

    // center the image
    if (widthFactor > heightFactor) {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    } else if (widthFactor < heightFactor) {
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
  }

  NSImage* newImage = [[NSImage alloc] initWithSize:NSMakeSize(scaledWidth, scaledHeight)];
  CGRect thumbnailRect = {thumbnailPoint, {scaledWidth, scaledHeight}};
  NSRect imageRect = NSMakeRect(0.0, 0.0, width, height);

  [newImage lockFocus];
  [sourceImage drawInRect:thumbnailRect
                 fromRect:imageRect
                operation:NSCompositingOperationCopy
                 fraction:1.0];
  [newImage unlockFocus];

  return newImage;
}

- (RTCDesktopSource*)getSourceById:(NSString*)sourceId {
  NSEnumerator* enumerator = [_captureSources objectEnumerator];
  RTCDesktopSource* object;
  while ((object = enumerator.nextObject) != nil) {
    if ([sourceId isEqualToString:object.sourceId]) {
      return object;
    }
  }
  return nil;
}

- (BOOL)buildDesktopSourcesListWithTypes:(NSArray*)types
                             forceReload:(BOOL)forceReload
                                  result:(FlutterResult)result {
  BOOL captureWindow = NO;
  BOOL captureScreen = NO;
  _captureSources = [NSMutableArray array];

  NSEnumerator* typesEnumerator = [types objectEnumerator];
  NSString* type;
  while ((type = typesEnumerator.nextObject) != nil) {
    if ([type isEqualToString:@"screen"]) {
      captureScreen = YES;
    } else if ([type isEqualToString:@"window"]) {
      captureWindow = YES;
    } else {
      result([FlutterError errorWithCode:@"ERROR" message:@"Invalid type" details:nil]);
      return NO;
    }
  }

  if (!captureWindow && !captureScreen) {
    result([FlutterError errorWithCode:@"ERROR"
                               message:@"At least one type is required"
                               details:nil]);
    return NO;
  }

  if (captureWindow) {
    if (!_window)
      _window = [[RTCDesktopMediaList alloc] initWithType:RTCDesktopSourceTypeWindow delegate:self];
    [_window UpdateSourceList:forceReload updateAllThumbnails:YES];
    NSArray<RTCDesktopSource*>* sources = [_window getSources];
    _captureSources = [_captureSources arrayByAddingObjectsFromArray:sources];
  }
  if (captureScreen) {
    if (!_screen)
      _screen = [[RTCDesktopMediaList alloc] initWithType:RTCDesktopSourceTypeScreen delegate:self];
    [_screen UpdateSourceList:forceReload updateAllThumbnails:YES];
    NSArray<RTCDesktopSource*>* sources = [_screen getSources];
    _captureSources = [_captureSources arrayByAddingObjectsFromArray:sources];
  }
  NSLog(@"captureSources: %lu", [_captureSources count]);
  return YES;
}

#pragma mark - RTCDesktopMediaListDelegate delegate

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)didDesktopSourceAdded:(RTC_OBJC_TYPE(RTCDesktopSource) *)source {
  // NSLog(@"didDesktopSourceAdded: %@, id %@", source.name, source.sourceId);
  if (self.eventSink) {
    NSImage* image = [source UpdateThumbnail];
    NSData* data = [[NSData alloc] init];
    if (image != nil) {
      NSImage* resizedImg = [self resizeImage:image forSize:NSMakeSize(320, 180)];
      data = [resizedImg TIFFRepresentation];
    }
    postEvent(self.eventSink, @{
      @"event" : @"desktopSourceAdded",
      @"id" : source.sourceId,
      @"name" : source.name,
      @"thumbnailSize" : @{@"width" : @0, @"height" : @0},
      @"type" : source.sourceType == RTCDesktopSourceTypeScreen ? @"screen" : @"window",
      @"thumbnail" : data
    });
  }
}

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)didDesktopSourceRemoved:(RTC_OBJC_TYPE(RTCDesktopSource) *)source {
  // NSLog(@"didDesktopSourceRemoved: %@, id %@", source.name, source.sourceId);
  if (self.eventSink) {
    postEvent(self.eventSink, @{
      @"event" : @"desktopSourceRemoved",
      @"id" : source.sourceId,
    });
  }
}

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)didDesktopSourceNameChanged:(RTC_OBJC_TYPE(RTCDesktopSource) *)source {
  // NSLog(@"didDesktopSourceNameChanged: %@, id %@", source.name, source.sourceId);
  if (self.eventSink) {
    postEvent(self.eventSink, @{
      @"event" : @"desktopSourceNameChanged",
      @"id" : source.sourceId,
      @"name" : source.name,
    });
  }
}

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)didDesktopSourceThumbnailChanged:(RTC_OBJC_TYPE(RTCDesktopSource) *)source {
  // NSLog(@"didDesktopSourceThumbnailChanged: %@, id %@", source.name, source.sourceId);
  if (self.eventSink) {
    NSImage* resizedImg = [self resizeImage:[source thumbnail] forSize:NSMakeSize(320, 180)];
    NSData* data = [resizedImg TIFFRepresentation];
    postEvent(self.eventSink, @{
      @"event" : @"desktopSourceThumbnailChanged",
      @"id" : source.sourceId,
      @"thumbnail" : data
    });
  }
}

#pragma mark - RTCDesktopCapturerDelegate delegate

- (void)didSourceCaptureStart:(RTCDesktopCapturer*)capturer {
  NSLog(@"didSourceCaptureStart");
}

- (void)didSourceCapturePaused:(RTCDesktopCapturer*)capturer {
  NSLog(@"didSourceCapturePaused");
}

- (void)didSourceCaptureStop:(RTCDesktopCapturer*)capturer {
  NSLog(@"didSourceCaptureStop");
}

- (void)didSourceCaptureError:(RTCDesktopCapturer*)capturer {
  NSLog(@"didSourceCaptureError");
}

#endif

@end
