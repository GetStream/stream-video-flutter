#import "include/stream_webrtc_flutter/FlutterRTCVideoRenderer.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CGImage.h>
#import <StreamWebRTC/RTCYUVHelper.h>
#import <StreamWebRTC/RTCYUVPlanarBuffer.h>
#import <StreamWebRTC/StreamWebRTC.h>

#import <objc/runtime.h>

#import <os/lock.h>
#import "include/stream_webrtc_flutter/FlutterWebRTCPlugin.h"

@implementation FlutterRTCVideoRenderer {
  CGSize _frameSize;
  CGSize _renderSize;
  CVPixelBufferRef _pixelBufferRef;
  RTCVideoRotation _rotation;
  FlutterEventChannel* _eventChannel;
  bool _isFirstFrameRendered;
  bool _frameAvailable;
  os_unfair_lock _lock;
  id<RTCI420Buffer> _rotatedBuffer;  // reused across frames for rotation
  CVPixelBufferRef _nv12Buffers[2];  // double-buffered NV12 crop output (ping-pong)
  CVPixelBufferRef _currentBuffer;   // buffer handed to Flutter this frame
  uint8_t* _cropTempBuffer;          // reused scratch for cropAndScaleTo
  size_t _cropTempSize;
}

@synthesize textureId = _textureId;
@synthesize registry = _registry;
@synthesize eventSink = _eventSink;
@synthesize videoTrack = _videoTrack;

- (instancetype)initWithTextureRegistry:(id<FlutterTextureRegistry>)registry
                              messenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _lock = OS_UNFAIR_LOCK_INIT;
    _isFirstFrameRendered = false;
    _frameAvailable = false;
    _frameSize = CGSizeZero;
    _renderSize = CGSizeZero;
    _rotation = -1;
    _registry = registry;
    _pixelBufferRef = nil;
    _eventSink = nil;
    _rotation = -1;
    _textureId = [registry registerTexture:self];
    /*Create Event Channel.*/
    _eventChannel = [FlutterEventChannel
        eventChannelWithName:[NSString stringWithFormat:@"FlutterWebRTC/Texture%lld", _textureId]
             binaryMessenger:messenger];
    [_eventChannel setStreamHandler:self];
  }
  return self;
}

- (CVPixelBufferRef)copyPixelBuffer {
  CVPixelBufferRef buffer = nil;
  os_unfair_lock_lock(&_lock);
  if (_currentBuffer != nil && _frameAvailable) {
    buffer = CVBufferRetain(_currentBuffer);
    _frameAvailable = false;
  }
  os_unfair_lock_unlock(&_lock);
  return buffer;
}

// (re)create the two reused NV12 output buffers used by the crop path. They are
// double-buffered (ping-pong) so the next crop never overwrites the buffer still
// being read by Flutter. The pixel format is taken from the source frame so
// video-range and full-range NV12 both keep their correct color range.
- (void)ensureNV12BuffersWithWidth:(int)width height:(int)height pixelFormat:(OSType)pixelFormat {
  NSDictionary* attrs = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
  for (int i = 0; i < 2; i++) {
    if (_nv12Buffers[i] != nil && CVPixelBufferGetWidth(_nv12Buffers[i]) == (size_t)width &&
        CVPixelBufferGetHeight(_nv12Buffers[i]) == (size_t)height &&
        CVPixelBufferGetPixelFormatType(_nv12Buffers[i]) == pixelFormat) {
      continue;
    }
    if (_nv12Buffers[i] != nil) {
      CVBufferRelease(_nv12Buffers[i]);
      _nv12Buffers[i] = nil;
    }
    CVPixelBufferCreate(kCFAllocatorDefault, width, height, pixelFormat,
                        (__bridge CFDictionaryRef)attrs, &_nv12Buffers[i]);
  }
}

- (void)dispose {
  os_unfair_lock_lock(&_lock);
  [_registry unregisterTexture:_textureId];
  _textureId = -1;
  if (_pixelBufferRef) {
    CVBufferRelease(_pixelBufferRef);
    _pixelBufferRef = nil;
  }
  if (_currentBuffer) {
    CVBufferRelease(_currentBuffer);
    _currentBuffer = nil;
  }
  for (int i = 0; i < 2; i++) {
    if (_nv12Buffers[i]) {
      CVBufferRelease(_nv12Buffers[i]);
      _nv12Buffers[i] = nil;
    }
  }
  if (_cropTempBuffer) {
    free(_cropTempBuffer);
    _cropTempBuffer = NULL;
    _cropTempSize = 0;
  }
  _rotatedBuffer = nil;  // release the reused rotation buffer
  _frameAvailable = false;
  os_unfair_lock_unlock(&_lock);
}

- (void)setVideoTrack:(RTCVideoTrack*)videoTrack {
  RTCVideoTrack* oldValue = self.videoTrack;
  if (oldValue != videoTrack) {
    os_unfair_lock_lock(&_lock);
    _videoTrack = videoTrack;
    os_unfair_lock_unlock(&_lock);
    _isFirstFrameRendered = false;
    if (oldValue) {
      [oldValue removeRenderer:self];
    }
    _frameSize = CGSizeZero;
    _renderSize = CGSizeZero;
    _rotation = -1;
    if (videoTrack) {
      [videoTrack addRenderer:self];
    }
  }
}

- (id<RTCI420Buffer>)correctRotation:(const id<RTCI420Buffer>)src
                        withRotation:(RTCVideoRotation)rotation {
  // an unrotated frame needs no rotation
  if (rotation == RTCVideoRotation_0) {
    return src;
  }

  int rotated_width = src.width;
  int rotated_height = src.height;

  if (rotation == RTCVideoRotation_90 || rotation == RTCVideoRotation_270) {
    int temp = rotated_width;
    rotated_width = rotated_height;
    rotated_height = temp;
  }

  // reuse one rotation buffer across frames; (re)allocate only when the
  // rotated dimensions change, instead of allocating on every frame.
  if (_rotatedBuffer == nil || _rotatedBuffer.width != rotated_width ||
      _rotatedBuffer.height != rotated_height) {
    _rotatedBuffer = [[RTCI420Buffer alloc] initWithWidth:rotated_width height:rotated_height];
  }
  id<RTCI420Buffer> buffer = _rotatedBuffer;

  [RTCYUVHelper I420Rotate:src.dataY
                srcStrideY:src.strideY
                      srcU:src.dataU
                srcStrideU:src.strideU
                      srcV:src.dataV
                srcStrideV:src.strideV
                      dstY:(uint8_t*)buffer.dataY
                dstStrideY:buffer.strideY
                      dstU:(uint8_t*)buffer.dataU
                dstStrideU:buffer.strideU
                      dstV:(uint8_t*)buffer.dataV
                dstStrideV:buffer.strideV
                     width:src.width
                    height:src.height
                      mode:rotation];

  return buffer;
}

- (void)copyI420ToCVPixelBuffer:(CVPixelBufferRef)outputPixelBuffer
                      withFrame:(RTCVideoFrame*)frame {
  id<RTCI420Buffer> srcI420 = [frame.buffer toI420];
  id<RTCI420Buffer> i420Buffer = [self correctRotation:srcI420 withRotation:frame.rotation];
  CVPixelBufferLockBaseAddress(outputPixelBuffer, 0);

  const OSType pixelFormat = CVPixelBufferGetPixelFormatType(outputPixelBuffer);
  if (pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange ||
      pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
    // NV12
    uint8_t* dstY = CVPixelBufferGetBaseAddressOfPlane(outputPixelBuffer, 0);
    const size_t dstYStride = CVPixelBufferGetBytesPerRowOfPlane(outputPixelBuffer, 0);
    uint8_t* dstUV = CVPixelBufferGetBaseAddressOfPlane(outputPixelBuffer, 1);
    const size_t dstUVStride = CVPixelBufferGetBytesPerRowOfPlane(outputPixelBuffer, 1);

    [RTCYUVHelper I420ToNV12:i420Buffer.dataY
                  srcStrideY:i420Buffer.strideY
                        srcU:i420Buffer.dataU
                  srcStrideU:i420Buffer.strideU
                        srcV:i420Buffer.dataV
                  srcStrideV:i420Buffer.strideV
                        dstY:dstY
                  dstStrideY:(int)dstYStride
                       dstUV:dstUV
                 dstStrideUV:(int)dstUVStride
                       width:i420Buffer.width
                      height:i420Buffer.height];

  } else {
    uint8_t* dst = CVPixelBufferGetBaseAddress(outputPixelBuffer);
    const size_t bytesPerRow = CVPixelBufferGetBytesPerRow(outputPixelBuffer);

    if (pixelFormat == kCVPixelFormatType_32BGRA) {
      // Corresponds to libyuv::FOURCC_ARGB

      [RTCYUVHelper I420ToARGB:i420Buffer.dataY
                    srcStrideY:i420Buffer.strideY
                          srcU:i420Buffer.dataU
                    srcStrideU:i420Buffer.strideU
                          srcV:i420Buffer.dataV
                    srcStrideV:i420Buffer.strideV
                       dstARGB:dst
                 dstStrideARGB:(int)bytesPerRow
                         width:i420Buffer.width
                        height:i420Buffer.height];

    } else if (pixelFormat == kCVPixelFormatType_32ARGB) {
      // Corresponds to libyuv::FOURCC_BGRA
      [RTCYUVHelper I420ToBGRA:i420Buffer.dataY
                    srcStrideY:i420Buffer.strideY
                          srcU:i420Buffer.dataU
                    srcStrideU:i420Buffer.strideU
                          srcV:i420Buffer.dataV
                    srcStrideV:i420Buffer.strideV
                       dstBGRA:dst
                 dstStrideBGRA:(int)bytesPerRow
                         width:i420Buffer.width
                        height:i420Buffer.height];
    }
  }

  CVPixelBufferUnlockBaseAddress(outputPixelBuffer, 0);
}

#pragma mark - RTCVideoRenderer methods
- (void)renderFrame:(RTCVideoFrame*)frame {
  os_unfair_lock_lock(&_lock);
  if (_videoTrack == nil) {
    os_unfair_lock_unlock(&_lock);
    return;
  }
  if (!_frameAvailable) {
    CVPixelBufferRef output = NULL;  // becomes the buffer handed to Flutter

    // hardware-decoded, upright frames are already NV12 in an IOSurface.
    // Hand that to Flutter with no color conversion — zero-copy when the buffer
    // already matches the frame's adapted size, otherwise a single crop-and-scale
    // copy into a reused NV12 buffer.
    if (frame.rotation == RTCVideoRotation_0 &&
        [frame.buffer isKindOfClass:[RTCCVPixelBuffer class]]) {
      RTCCVPixelBuffer* cvBuffer = (RTCCVPixelBuffer*)frame.buffer;
      CVPixelBufferRef src = cvBuffer.pixelBuffer;
      const OSType fmt = CVPixelBufferGetPixelFormatType(src);
      if (fmt == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange ||
          fmt == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
        // frame.width/height are the adapted dimensions — what we report to Dart via
        // didTextureChangeVideoSize, and what the I420 fallback path below produces.
        // Target them here too so every path emits a texture of the same size.
        // requiresCropping only compares the crop rect against the backing buffer, so
        // a frame that needs pure downscaling also has to be checked explicitly.
        if (![cvBuffer requiresCropping] &&
            ![cvBuffer requiresScalingToWidth:frame.width height:frame.height] &&
            CVPixelBufferGetIOSurface(src) != NULL) {
          output = src;  // true zero-copy
        } else {
          [self ensureNV12BuffersWithWidth:frame.width height:frame.height pixelFormat:fmt];
          int tmpSize = [cvBuffer bufferSizeForCroppingAndScalingToWidth:frame.width
                                                                  height:frame.height];
          BOOL tempBufferReady = YES;
          if (tmpSize > 0 && (_cropTempBuffer == NULL || _cropTempSize < (size_t)tmpSize)) {
            free(_cropTempBuffer);
            _cropTempBuffer = malloc((size_t)tmpSize);
            // Only claim the size on success: NV12Scale reads through this pointer
            // whenever the frame actually needs scaling.
            _cropTempSize = (_cropTempBuffer != NULL) ? (size_t)tmpSize : 0;
            tempBufferReady = (_cropTempBuffer != NULL);
          }
          // Pick the buffer not currently published to Flutter, so the crop never
          // overwrites the frame the compositor may still be reading.
          CVPixelBufferRef dst =
              (_nv12Buffers[0] != _currentBuffer) ? _nv12Buffers[0] : _nv12Buffers[1];
          if (tempBufferReady && dst != nil &&
              [cvBuffer cropAndScaleTo:dst withTempBuffer:_cropTempBuffer]) {
            output = dst;
          }
        }
      }
    }

    if (output == NULL && _pixelBufferRef != nil) {
      // Fallback: software-decoded (I420) or rotated frames → BGRA convert path
      [self copyI420ToCVPixelBuffer:_pixelBufferRef withFrame:frame];
      output = _pixelBufferRef;
    }

    if (output != NULL) {
      CVBufferRetain(output);
      if (_currentBuffer != nil) {
        CVBufferRelease(_currentBuffer);
      }
      _currentBuffer = output;
      if (_textureId != -1) {
        [_registry textureFrameAvailable:_textureId];
      }
      _frameAvailable = true;
    }
  }
  os_unfair_lock_unlock(&_lock);

  __weak FlutterRTCVideoRenderer* weakSelf = self;
  if (_renderSize.width != frame.width || _renderSize.height != frame.height) {
    dispatch_async(dispatch_get_main_queue(), ^{
      FlutterRTCVideoRenderer* strongSelf = weakSelf;
      if (strongSelf.eventSink) {
        strongSelf.eventSink(@{
          @"event" : @"didTextureChangeVideoSize",
          @"id" : @(strongSelf.textureId),
          @"width" : @(frame.width),
          @"height" : @(frame.height),
        });
      }
    });
    _renderSize = CGSizeMake(frame.width, frame.height);
  }

  if (frame.rotation != _rotation) {
    dispatch_async(dispatch_get_main_queue(), ^{
      FlutterRTCVideoRenderer* strongSelf = weakSelf;
      if (strongSelf.eventSink) {
        strongSelf.eventSink(@{
          @"event" : @"didTextureChangeRotation",
          @"id" : @(strongSelf.textureId),
          @"rotation" : @(frame.rotation),
        });
      }
    });

    _rotation = frame.rotation;
  }

  // Notify the Flutter new pixelBufferRef to be ready.
  dispatch_async(dispatch_get_main_queue(), ^{
    FlutterRTCVideoRenderer* strongSelf = weakSelf;
    if (!strongSelf->_isFirstFrameRendered) {
      if (strongSelf.eventSink) {
        strongSelf.eventSink(@{@"event" : @"didFirstFrameRendered"});
        strongSelf->_isFirstFrameRendered = true;
      }
    }
  });
}

/**
 * Sets the size of the video frame to render.
 *
 * @param size The size of the video frame to render.
 */
- (void)setSize:(CGSize)size {
  os_unfair_lock_lock(&_lock);
  if (size.width != _frameSize.width || size.height != _frameSize.height) {
    if (_pixelBufferRef) {
      CVBufferRelease(_pixelBufferRef);
    }
    NSDictionary* pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
    CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32BGRA,
                        (__bridge CFDictionaryRef)(pixelAttributes), &_pixelBufferRef);
    _frameAvailable = false;
    _frameSize = size;
  }
  os_unfair_lock_unlock(&_lock);
}

#pragma mark - FlutterStreamHandler methods

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  _eventSink = nil;
  return nil;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)sink {
  _eventSink = sink;
  return nil;
}
@end

@implementation FlutterWebRTCPlugin (FlutterVideoRendererManager)

- (FlutterRTCVideoRenderer*)createWithTextureRegistry:(id<FlutterTextureRegistry>)registry
                                            messenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  return [[FlutterRTCVideoRenderer alloc] initWithTextureRegistry:registry messenger:messenger];
}

- (void)rendererSetSrcObject:(FlutterRTCVideoRenderer*)renderer stream:(RTCVideoTrack*)videoTrack {
  renderer.videoTrack = videoTrack;
}
@end
