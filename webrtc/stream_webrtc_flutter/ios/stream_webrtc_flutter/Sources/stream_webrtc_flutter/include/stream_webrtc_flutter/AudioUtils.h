#import <StreamWebRTC/StreamWebRTC.h>

@interface AudioUtils : NSObject
+ (void)ensureAudioSessionWithRecording:(BOOL)recording;
// needed for wired headphones to use headphone mic
+ (BOOL)selectAudioInput:(AVAudioSessionPort)type;
+ (void)setSpeakerphoneOn:(BOOL)enable;
+ (void)setSpeakerphoneOnButPreferBluetooth;
+ (void)deactiveRtcAudioSession;
// Returns NO and sets error when the session rejects the category or mode.
+ (BOOL)setAppleAudioConfiguration:(NSDictionary*)configuration error:(NSError**)error;
@end
