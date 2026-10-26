#import "include/stream_webrtc_flutter/StreamMacAudioDevices.h"

#import <CoreAudio/CoreAudio.h>

@implementation StreamMacAudioDevices

#pragma mark - Public

+ (NSArray<NSDictionary<NSString*, NSString*>*>*)inputDevices {
  return [self enumerateDevicesAsInput:YES];
}

+ (NSArray<NSDictionary<NSString*, NSString*>*>*)outputDevices {
  return [self enumerateDevicesAsInput:NO];
}

+ (BOOL)deviceIdExists:(NSString*)deviceId asInput:(BOOL)input {
  if (deviceId.length == 0)
    return NO;
  NSArray<NSDictionary*>* list = input ? [self inputDevices] : [self outputDevices];
  for (NSDictionary* d in list) {
    if ([deviceId isEqualToString:d[@"deviceId"]])
      return YES;
  }
  return NO;
}

#pragma mark - Internal

/// Enumerates all live AudioObjectIDs and returns those that have at least one
/// input (or output) channel — i.e. those that can be selected as a recording
/// or playback device respectively.
+ (NSArray<NSDictionary<NSString*, NSString*>*>*)enumerateDevicesAsInput:(BOOL)input {
  NSMutableArray<NSDictionary<NSString*, NSString*>*>* result = [NSMutableArray array];

  AudioObjectPropertyAddress devicesAddr = {
      .mSelector = kAudioHardwarePropertyDevices,
      .mScope = kAudioObjectPropertyScopeGlobal,
      .mElement = kAudioObjectPropertyElementMain,
  };
  UInt32 size = 0;
  OSStatus status =
      AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &devicesAddr, 0, NULL, &size);
  if (status != noErr || size == 0)
    return result;

  const NSUInteger count = size / sizeof(AudioObjectID);
  AudioObjectID* ids = (AudioObjectID*)malloc(size);
  if (ids == NULL)
    return result;
  status = AudioObjectGetPropertyData(kAudioObjectSystemObject, &devicesAddr, 0, NULL, &size, ids);
  if (status != noErr) {
    free(ids);
    return result;
  }

  const AudioObjectPropertyScope scope =
      input ? kAudioDevicePropertyScopeInput : kAudioDevicePropertyScopeOutput;

  for (NSUInteger i = 0; i < count; i++) {
    const AudioObjectID dev = ids[i];
    if (![self device:dev hasChannelsForScope:scope])
      continue;

    NSString* uid = [self stringPropertyOf:dev selector:kAudioDevicePropertyDeviceUID];
    NSString* name = [self stringPropertyOf:dev selector:kAudioObjectPropertyName];
    if (uid.length == 0)
      continue;
    if (name.length == 0)
      name = uid;

    [result addObject:@{
      @"deviceId" : uid,
      @"label" : name,
    }];
  }

  free(ids);
  return result;
}

/// Returns YES if the device exposes at least one channel for the given
/// scope (input or output).
+ (BOOL)device:(AudioObjectID)dev hasChannelsForScope:(AudioObjectPropertyScope)scope {
  AudioObjectPropertyAddress addr = {
      .mSelector = kAudioDevicePropertyStreamConfiguration,
      .mScope = scope,
      .mElement = kAudioObjectPropertyElementMain,
  };
  UInt32 size = 0;
  OSStatus status = AudioObjectGetPropertyDataSize(dev, &addr, 0, NULL, &size);
  if (status != noErr || size == 0)
    return NO;

  AudioBufferList* list = (AudioBufferList*)malloc(size);
  if (list == NULL)
    return NO;
  status = AudioObjectGetPropertyData(dev, &addr, 0, NULL, &size, list);
  BOOL hasChannels = NO;
  if (status == noErr) {
    for (UInt32 i = 0; i < list->mNumberBuffers; i++) {
      if (list->mBuffers[i].mNumberChannels > 0) {
        hasChannels = YES;
        break;
      }
    }
  }
  free(list);
  return hasChannels;
}

/// Reads a CFString-typed Core Audio property and bridges it to NSString.
+ (NSString*)stringPropertyOf:(AudioObjectID)dev selector:(AudioObjectPropertySelector)sel {
  AudioObjectPropertyAddress addr = {
      .mSelector = sel,
      .mScope = kAudioObjectPropertyScopeGlobal,
      .mElement = kAudioObjectPropertyElementMain,
  };
  CFStringRef value = NULL;
  UInt32 size = sizeof(value);
  OSStatus status = AudioObjectGetPropertyData(dev, &addr, 0, NULL, &size, &value);
  if (status != noErr || value == NULL)
    return @"";
  NSString* result = (__bridge_transfer NSString*)value;
  return result ?: @"";
}

@end
