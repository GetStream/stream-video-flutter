#import "include/stream_webrtc_flutter/FlutterRTCVideoPlatformView.h"

@implementation FlutterRTCVideoPlatformView {
  // The shared-Metal renderer, frames are handed straight to it (RTCVideoRenderer).
  RTCVideoRenderingView* _renderingView;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    // Mirror the Swift SDK's VideoRenderer configuration
    _renderingView = [[RTCVideoRenderingView alloc] initWithFrame:self.bounds];
    _renderingView.renderingBackend = RTCVideoRenderingBackendSharedMetal;
    _renderingView.maxInFlightFrames = 2;
    _renderingView.videoContentMode = UIViewContentModeScaleAspectFill;
    _renderingView.enabled = YES;
    _renderingView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_renderingView];
    self.opaque = NO;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _renderingView.frame = self.bounds;
}

- (void)setSize:(CGSize)size {
  [_renderingView setSize:size];
}

- (void)renderFrame:(nullable RTC_OBJC_TYPE(RTCVideoFrame) *)frame {
  // Hand the frame straight to the shared-Metal renderer
  [_renderingView renderFrame:frame];
}

@end
