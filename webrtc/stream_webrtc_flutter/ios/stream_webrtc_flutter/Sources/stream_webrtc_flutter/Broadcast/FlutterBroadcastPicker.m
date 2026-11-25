#import "FlutterBroadcastPicker.h"

#import <ReplayKit/ReplayKit.h>
#import <UIKit/UIKit.h>

#import "../include/stream_webrtc_flutter/Broadcast/FlutterBroadcastScreenCapturer.h"

@implementation FlutterBroadcastPicker

+ (void)present {
  NSString* extension =
      [[[NSBundle mainBundle] infoDictionary] valueForKey:kRTCScreenSharingExtension];

  RPSystemBroadcastPickerView* picker = [[RPSystemBroadcastPickerView alloc] init];
  picker.showsMicrophoneButton = false;
  if (extension) {
    picker.preferredExtension = extension;
  } else {
    NSLog(@"Not able to find the %@ key", kRTCScreenSharingExtension);
  }
  // Opens the picker through its button's public UIControl action; the
  // private buttonPressed: selector is rejected by App Store review.
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

@end
