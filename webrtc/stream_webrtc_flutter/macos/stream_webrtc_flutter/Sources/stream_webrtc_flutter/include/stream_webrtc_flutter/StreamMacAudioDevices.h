#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Core Audio HAL helpers used to enumerate macOS input / output devices and
 * change the system-default device
 */
@interface StreamMacAudioDevices : NSObject

/// Returns all currently-attached input devices (mics, line-ins, virtual).
+ (NSArray<NSDictionary<NSString*, NSString*>*>*)inputDevices;

/// Returns all currently-attached output devices (speakers, headphones, virtual).
+ (NSArray<NSDictionary<NSString*, NSString*>*>*)outputDevices;

/// Looks up the deviceId-strings as returned by [inputDevices] /
/// [outputDevices] and returns YES if a matching device exists.
+ (BOOL)deviceIdExists:(NSString*)deviceId asInput:(BOOL)input;

@end

NS_ASSUME_NONNULL_END
