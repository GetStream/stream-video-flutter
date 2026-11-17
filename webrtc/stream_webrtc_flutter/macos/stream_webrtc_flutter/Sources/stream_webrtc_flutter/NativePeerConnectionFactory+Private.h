#import "include/stream_webrtc_flutter/NativePeerConnectionFactory.h"

NS_ASSUME_NONNULL_BEGIN

/** Factory state only this plugin reads and writes. */
@interface NativePeerConnectionFactory ()

/**
 * Whether voice processing was on when the audio engine was switched to
 * manual rendering while unavailable; it is put back on leaving that mode.
 * Read and written on admQueue only.
 */
@property(nonatomic, assign) BOOL voiceProcessingBeforeManualRendering;

@end

NS_ASSUME_NONNULL_END
