import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../stream_video_filters.dart';
import 'video_effect_registry.dart';

/// A [rtc.VideoFilter] that runs a frame processor registered natively under
/// [effectName], on the captured track itself.
///
/// Applying it registers the processor, unless a filter with the same
/// [effectName] already did since the last
/// [StreamVideoFilters.unregisterAllFilters], and attaches it to the
/// track next to the processors other filters attached. Stopping it detaches
/// only its own processor.
///
/// A subclass is itself declared `base`, `final` or `sealed`.
abstract base class NativeVideoFilter extends rtc.VideoFilter {
  NativeVideoFilter();

  /// The name the processor is registered under.
  String get effectName;

  /// Registers the processor natively.
  @protected
  Future<void> register();

  @override
  Future<rtc.MediaStreamFilterResult> apply(
    rtc.MediaStreamFilterInput input,
  ) async {
    if (!rtc.webRtcCapabilities.supportsVideoEffects) {
      throw UnsupportedError(
        'Video effects are not supported on this platform',
      );
    }

    final stream = input.stream;
    final trackId = stream.getVideoTracks().firstOrNull?.id;
    if (trackId == null) return rtc.MediaStreamFilterResult(stream);

    if (!VideoEffectRegistry.isRegistered(effectName)) {
      final generation = VideoEffectRegistry.generation;
      await register();
      VideoEffectRegistry.markRegistered(effectName, generation: generation);
    }

    await VideoEffectRegistry.attach(trackId, effectName);

    return rtc.MediaStreamFilterResult(
      stream,
      stop: (_) => VideoEffectRegistry.detach(trackId, effectName),
    );
  }

  @override
  String toString() => '$runtimeType($effectName)';
}
