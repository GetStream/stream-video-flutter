import 'dart:io';

import 'package:meta/meta.dart';

/// The iOS port types of external audio devices.
const _iosExternalPorts = {
  'bluetootha2dp',
  'bluetoothle',
  'bluetoothhfp',
  'caraudio',
  'headphones',
};

/// The Android device types of external audio devices.
const _androidExternalTypes = {'bluetooth', 'wired-headset'};

/// Whether the audio device in the group [groupId] is external, such as a
/// headset or a car, on the native platform the app runs on.
@internal
bool isExternalAudioDevice(String? groupId) => isExternalAudioDeviceFor(
  groupId,
  isIOS: Platform.isIOS,
  isAndroid: Platform.isAndroid,
);

/// Whether the audio device in the group [groupId] is external on the
/// platform described by the flags. The group is the port type on iOS and
/// the device type on Android.
@visibleForTesting
bool isExternalAudioDeviceFor(
  String? groupId, {
  required bool isIOS,
  required bool isAndroid,
}) {
  if (groupId == null) return false;
  final group = groupId.toLowerCase();
  if (isIOS) return _iosExternalPorts.any(group.contains);
  if (isAndroid) return _androidExternalTypes.any(group.contains);
  return group.contains('bluetooth');
}
