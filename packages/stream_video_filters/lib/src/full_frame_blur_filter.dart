import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../stream_video_filters.dart';
import 'video_effect_registry.dart';

/// Blurs the whole camera frame, natively, before it is sent.
///
/// Pass it to `VideoModerationConfig.blur` to blur the camera while the call
/// is moderated. Stopping it detaches only the blur it attached.
final class FullFrameBlurFilter extends rtc.VideoFilter {
  const FullFrameBlurFilter();

  static const _name = 'FullFrameBlur';

  @override
  Future<rtc.MediaStreamFilterResult> apply(
    rtc.MediaStreamFilterInput input,
  ) async {
    final stream = input.stream;
    final track = stream.getVideoTracks().firstOrNull;
    if (track == null) return rtc.MediaStreamFilterResult(stream);

    final trackId = track.id!;
    await StreamVideoFilters().registerFullFrameBlurEffectProcessor();
    await VideoEffectRegistry.attach(trackId, _name);

    return rtc.MediaStreamFilterResult(
      stream,
      stop: (_) => VideoEffectRegistry.detach(trackId, _name),
    );
  }

  @override
  bool operator ==(Object other) => other is FullFrameBlurFilter;

  @override
  int get hashCode => (FullFrameBlurFilter).hashCode;
}
