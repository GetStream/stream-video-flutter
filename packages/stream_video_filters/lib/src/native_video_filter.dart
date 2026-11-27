import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../stream_video_filters.dart';
import 'video_effect_registry.dart';
import 'web/browser_effect.dart';
import 'web/browser_filters.dart';

/// A [rtc.VideoFilter] that runs a frame processor registered natively under
/// [effectName], on the captured track itself.
///
/// Applying it registers the processor, unless a filter with the same
/// [effectName] already did since the last
/// [StreamVideoFilters.unregisterAllFilters], and attaches it to the
/// track next to the processors other filters attached. Stopping it detaches
/// only its own processor.
///
/// On web, the filters of this package that have a browser counterpart run
/// it instead, see [StreamVideoFilters.webOptions]; the others are not
/// supported there.
///
/// A subclass is itself declared `base`, `final` or `sealed`.
abstract base class NativeVideoFilter extends rtc.VideoFilter {
  NativeVideoFilter();

  /// The name the processor is registered under.
  String get effectName;

  /// Registers the processor natively.
  ///
  /// Throws when the processor cannot run on this device.
  ///
  /// The filters' registering, attaching and detaching wait for it, so it
  /// has to complete, and must not call
  /// [StreamVideoFilters.unregisterAllFilters], which waits for it too.
  @protected
  Future<void> register();

  /// The names whose processors [register] registers: [effectName], and any
  /// others it registers along with it.
  @protected
  Iterable<String> get registeredEffectNames => [effectName];

  /// The effect this filter runs on web, or null where it has none.
  @internal
  BrowserEffect? get browserEffect => null;

  @override
  Future<rtc.MediaStreamFilterResult> apply(
    rtc.MediaStreamFilterInput input,
  ) async {
    if (kIsWeb) {
      final effect = browserEffect;
      if (effect == null) {
        throw UnsupportedError('$this is not supported on web');
      }
      return applyBrowserEffect(input, effect, StreamVideoFilters.webOptions);
    }

    if (!rtc.webRtcCapabilities.supportsVideoEffects) {
      throw UnsupportedError(
        'Video effects are not supported on this platform',
      );
    }

    final stream = input.stream;
    final trackId = stream.getVideoTracks().firstOrNull?.id;
    if (trackId == null) return rtc.MediaStreamFilterResult(stream);

    final attachment = await VideoEffectRegistry.run(() async {
      if (!VideoEffectRegistry.isRegistered(effectName)) {
        await register();
        VideoEffectRegistry.markRegistered(registeredEffectNames);
      }
      return VideoEffectRegistry.attach(trackId, effectName);
    });

    return rtc.MediaStreamFilterResult(
      stream,
      stop: (_) => VideoEffectRegistry.run(
        () => VideoEffectRegistry.detach(trackId, attachment),
      ),
    );
  }

  @override
  String toString() => '$runtimeType($effectName)';
}
