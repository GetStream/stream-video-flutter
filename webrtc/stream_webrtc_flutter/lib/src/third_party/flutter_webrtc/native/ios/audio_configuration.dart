import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import '../utils.dart';

enum AppleAudioIOMode { none, remoteOnly, localOnly, localAndRemote }

class AppleNativeAudioManagement {
  static AppleAudioIOMode currentMode = AppleAudioIOMode.none;

  static AppleAudioConfiguration getAppleAudioConfigurationForMode(
    AppleAudioIOMode mode, {
    bool preferSpeakerOutput = false,
  }) {
    currentMode = mode;
    if (mode == AppleAudioIOMode.remoteOnly) {
      return AppleAudioConfiguration(
        appleAudioCategory: AppleAudioCategory.playback,
        appleAudioCategoryOptions: {AppleAudioCategoryOption.mixWithOthers},
        appleAudioMode: AppleAudioMode.spokenAudio,
      );
    } else if ([
      AppleAudioIOMode.localOnly,
      AppleAudioIOMode.localAndRemote,
    ].contains(mode)) {
      return AppleAudioConfiguration(
        appleAudioCategory: AppleAudioCategory.playAndRecord,
        appleAudioCategoryOptions: {
          AppleAudioCategoryOption.allowBluetooth,
          AppleAudioCategoryOption.mixWithOthers,
        },
        appleAudioMode: preferSpeakerOutput
            ? AppleAudioMode.videoChat
            : AppleAudioMode.voiceChat,
      );
    }

    return AppleAudioConfiguration(
      appleAudioCategory: AppleAudioCategory.soloAmbient,
      appleAudioCategoryOptions: {},
      appleAudioMode: AppleAudioMode.default_,
    );
  }

  static Future<void> setAppleAudioConfiguration(
    AppleAudioConfiguration config,
  ) async {
    if (WebRTC.platformIsIOS) {
      await WebRTC.invokeMethod('setAppleAudioConfiguration', <String, dynamic>{
        'configuration': config.toMap(),
      });
    }
  }
}
