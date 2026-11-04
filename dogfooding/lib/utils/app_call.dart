// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import '../di/injector.dart';
import 'consts.dart';

/// Makes the [Call] for [callId] with the preferences every call in this app
/// uses.
Call makeAppCall(String callId) {
  return locator.get<StreamVideo>().makeCall(
    callType: kCallType,
    id: callId,
    preferences: DefaultCallPreferences(
      closedCaptionsVisibleCaptions: 3,
      closedCaptionsVisibilityDurationMs: 5000,
      // clientPublishOptions: ClientPublishOptions(
      // preferredCodec: PreferredCodec.h264,
      // fmtpLine: 'a=fmtp:96max-fr=60;max-fs=12288', <-- VP8
      // fmtpLine: 'level-idx=5;profile=0;tier=0', <-- AV1
      // ),
    ),
  );
}
