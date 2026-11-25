import '../third_party/flutter_webrtc/native/utils.dart';

/// Shows the system picker of the app's broadcast upload extension. iOS only.
///
/// Starts no capture. Once the broadcast has started, `getDisplayMedia` with
/// `broadcast-manual` as the `deviceId` captures it without showing the picker
/// again.
///
/// Throws an [UnsupportedError] on other platforms.
Future<void> presentiOSBroadcastPicker() async {
  if (!WebRTC.platformIsIOS) {
    throw UnsupportedError(
      'presentiOSBroadcastPicker is only supported on iOS',
    );
  }
  await WebRTC.invokeMethod<void, void>('presentBroadcastPicker');
}
