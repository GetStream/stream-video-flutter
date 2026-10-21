#ifdef __cplusplus
#import "StreamWebRTC/RTCAudioSource.h"
#include "media_stream_interface.h"

@interface RTCAudioSource ()

/**
 * The AudioSourceInterface object passed to this RTCAudioSource during
 * construction.
 */
@property(nonatomic, readonly) rtc::scoped_refptr<webrtc::AudioSourceInterface> nativeAudioSource;

@end
#endif
