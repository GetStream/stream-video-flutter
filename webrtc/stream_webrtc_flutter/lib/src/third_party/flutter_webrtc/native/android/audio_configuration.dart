import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import '../utils.dart';

class AndroidNativeAudioManagement {
  static Future<void> setAndroidAudioConfiguration(
    AndroidAudioConfiguration config,
  ) async {
    if (WebRTC.platformIsAndroid) {
      await WebRTC.invokeMethod(
        'setAndroidAudioConfiguration',
        <String, dynamic>{'configuration': config.toMap()},
      );
    }
  }
}
