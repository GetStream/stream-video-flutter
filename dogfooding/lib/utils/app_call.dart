// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import '../di/injector.dart';
import 'consts.dart';

/// Makes the [Call] for [callId] with the preferences every call in this app
/// uses.
///
/// [callType] defaults to [kCallType]. [publishOptions] overrides the codecs
/// and bitrate the call publishes and subscribes with.
Call makeAppCall(
  String callId, {
  StreamCallType? callType,
  ClientPublishOptions? publishOptions,
}) {
  return locator.get<StreamVideo>().makeCall(
    callType: callType ?? kCallType,
    id: callId,
    preferences: DefaultCallPreferences(
      closedCaptionsVisibleCaptions: 3,
      closedCaptionsVisibilityDurationMs: 5000,
      clientPublishOptions: publishOptions,
    ),
  );
}
