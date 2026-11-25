import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../stream_video_filters.dart';

/// A [rtc.VideoFilter] that runs a frame processor registered natively under
/// [effectName], on the captured track itself.
///
/// Applying it registers the processor, unless this filter already did since
/// the last [StreamVideoFilters.unregisterAllFilters], and attaches it to the
/// track. Stopping it detaches the processor again.
abstract class NativeVideoFilter extends rtc.VideoFilter {
  NativeVideoFilter();

  /// The name the processor is registered under.
  String get effectName;

  /// Registers the processor natively.
  Future<void> register();

  int? _registeredIn;

  @override
  Future<rtc.MediaStreamFilterResult> apply(rtc.MediaStream input) async {
    if (!rtc.webRtcCapabilities.supportsVideoEffects) {
      throw UnsupportedError(
        'Video effects are not supported on this platform',
      );
    }

    final track = input.getVideoTracks().firstOrNull;
    final trackId = track?.id;
    if (trackId == null) return rtc.MediaStreamFilterResult(input);

    final registry = StreamVideoFilters.registryGeneration;
    if (_registeredIn != registry) {
      await register();
      _registeredIn = registry;
    }

    await rtc.setVideoEffects(trackId, names: [effectName]);

    return rtc.MediaStreamFilterResult(
      input,
      stop: () => rtc.setVideoEffects(trackId, names: const []),
    );
  }

  @override
  String toString() => '$runtimeType($effectName)';
}
