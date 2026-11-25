import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../stream_video_filters.dart';

/// Blurs the whole camera frame, natively, before it is sent.
///
/// Pass it to `VideoModerationConfig.blur` to blur the camera while the call
/// is moderated.
class FullFrameBlurFilter extends rtc.VideoFilter {
  const FullFrameBlurFilter();

  static const _name = 'FullFrameBlur';

  @override
  Future<rtc.MediaStreamFilterResult> apply(rtc.MediaStream input) async {
    final track = input.getVideoTracks().firstOrNull;
    if (track == null) return rtc.MediaStreamFilterResult(input);

    await StreamVideoFilters().registerFullFrameBlurEffectProcessor();
    await rtc.setVideoEffects(track.id!, names: [_name]);

    return rtc.MediaStreamFilterResult(
      input,
      stop: () => rtc.setVideoEffects(track.id!, names: []),
    );
  }

  @override
  bool operator ==(Object other) => other is FullFrameBlurFilter;

  @override
  int get hashCode => (FullFrameBlurFilter).hashCode;
}
