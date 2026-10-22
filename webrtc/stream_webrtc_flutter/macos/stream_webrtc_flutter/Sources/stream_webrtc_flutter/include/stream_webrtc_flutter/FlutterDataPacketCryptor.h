#if TARGET_OS_IPHONE
#import <Flutter/Flutter.h>
#else
#import <FlutterMacOS/FlutterMacOS.h>
#endif
#import <StreamWebRTC/StreamWebRTC.h>

#import "FlutterWebRTCPlugin.h"

@interface FlutterWebRTCPlugin (DataPacketCryptor)

- (void)handleDataPacketCryptorMethodCall:(nonnull FlutterMethodCall*)call
                                   result:(nonnull FlutterResult)result;

@end
