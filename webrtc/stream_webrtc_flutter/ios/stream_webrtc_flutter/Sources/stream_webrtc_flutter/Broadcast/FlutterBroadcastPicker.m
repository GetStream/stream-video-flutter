#import "FlutterBroadcastPicker.h"

#import <ReplayKit/ReplayKit.h>
#import <UIKit/UIKit.h>

#import "../include/stream_webrtc_flutter/Broadcast/FlutterBroadcastScreenCapturer.h"

NSErrorDomain const FlutterBroadcastPickerErrorDomain = @"FlutterBroadcastPicker";

@implementation FlutterBroadcastPicker

+ (BOOL)presentWithError:(NSError**)error {
  NSString* extension =
      [[[NSBundle mainBundle] infoDictionary] valueForKey:kRTCScreenSharingExtension];
  if (extension == nil) {
    if (error != NULL) {
      *error = [NSError
          errorWithDomain:FlutterBroadcastPickerErrorDomain
                     code:FlutterBroadcastPickerErrorMissingExtensionKey
                 userInfo:@{
                   NSLocalizedDescriptionKey : [NSString
                       stringWithFormat:@"The %@ Info.plist key is missing",
                                        kRTCScreenSharingExtension]
                 }];
    }
    return NO;
  }

  RPSystemBroadcastPickerView* picker = [[RPSystemBroadcastPickerView alloc] init];
  picker.showsMicrophoneButton = false;
  picker.preferredExtension = extension;
  // Opens the picker through its button's public UIControl action; the
  // private buttonPressed: selector is rejected by App Store review.
  UIButton* pickerButton = nil;
  for (UIView* subview in picker.subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {
      pickerButton = (UIButton*)subview;
      break;
    }
  }
  if (pickerButton == nil) {
    if (error != NULL) {
      *error = [NSError
          errorWithDomain:FlutterBroadcastPickerErrorDomain
                     code:FlutterBroadcastPickerErrorMissingButton
                 userInfo:@{
                   NSLocalizedDescriptionKey : @"The RPSystemBroadcastPickerView button was not found"
                 }];
    }
    return NO;
  }

  [pickerButton sendActionsForControlEvents:UIControlEventTouchUpInside];
  return YES;
}

@end
