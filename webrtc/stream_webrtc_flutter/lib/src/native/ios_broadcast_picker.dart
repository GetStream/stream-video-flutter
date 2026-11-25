import 'package:flutter/services.dart' show PlatformException;

import '../third_party/flutter_webrtc/native/utils.dart';

/// Shows the system picker of the app's broadcast upload extension. iOS only.
///
/// Starts no capture. Once the broadcast has started, `getDisplayMedia` with
/// `broadcast-manual` as the `deviceId` captures it without showing the picker
/// again.
///
/// Throws a [PlatformException] when the `RTCScreenSharingExtension`
/// Info.plist key is missing or the picker cannot be opened, and an
/// [UnsupportedError] on other platforms.
Future<void> presentiOSBroadcastPicker() async {
  if (!WebRTC.platformIsIOS) {
    throw UnsupportedError(
      'presentiOSBroadcastPicker is only supported on iOS',
    );
  }
  await WebRTC.invokeMethod<void, void>('presentBroadcastPicker');
}

/// Asks the app's broadcast upload extension to finish its broadcast with an
/// error. iOS only.
///
/// The extension reports the stop as `onScreenSharingStopped` when it has
/// finished. Throws an [UnsupportedError] on other platforms.
Future<void> stopiOSBroadcast() async {
  if (!WebRTC.platformIsIOS) {
    throw UnsupportedError('stopiOSBroadcast is only supported on iOS');
  }
  await WebRTC.invokeMethod<void, void>('stopBroadcast');
}
