import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/stream_video.dart';

import '../../stream_video_flutter_platform_interface.dart';

const _tag = 'SVF:BackgrounFilters';

enum BlurIntensity {
  light('BackgroundBlurLight'),
  medium('BackgroundBlurMedium'),
  heavy('BackgroundBlurHeavy');

  const BlurIntensity(this.name);
  final String name;
}

class StreamVideoEffectsManager {
  StreamVideoEffectsManager(this.call);

  static bool isBlurRegistered = false;
  static Map<String, bool> isImageRegistered = <String, bool>{};

  final Call call;
  final _logger = taggedLogger(tag: _tag);

  Future<bool> isSupported() async {
    return await StreamVideoFlutterPlatform.instance
            .isBackgroundEffectSupported() ??
        false;
  }

  Future<void> applyBackgroundBlurFilter(BlurIntensity blurIntensity) async {
    if (!(await isSupported())) {
      return;
    }

    if (!isBlurRegistered) {
      await StreamVideoFlutterPlatform.instance.registerBlurEffectProcessors();
      isBlurRegistered = true;
    }

    final trackId = await _getTrackId();
    if (trackId == null) {
      return;
    }

    await rtc.setVideoEffects(
      trackId,
      names: [
        blurIntensity.name,
      ],
    );
  }

  Future<void> applyBackgroundImageFilter(String imageUrl) async {
    if (!(await isSupported())) {
      return;
    }

    if (!isImageRegistered.containsKey(imageUrl)) {
      await StreamVideoFlutterPlatform.instance.registerImageEffectProcessors(
        backgroundImageUrl: imageUrl,
      );
      isImageRegistered[imageUrl] = true;
    }

    final trackId = await _getTrackId();
    if (trackId == null) {
      return;
    }

    final effectName = 'VirtualBackground-$imageUrl';

    await rtc.setVideoEffects(
      trackId,
      names: [
        effectName,
      ],
    );
  }

  Future<void> disableAllFilters() async {
    if (!(await isSupported())) {
      return;
    }

    final trackId = await _getTrackId();
    if (trackId == null) {
      return;
    }

    await rtc.setVideoEffects(
      trackId,
      names: [],
    );
  }

  Future<String?> _getTrackId() async {
    final trackPrefix = call.state.value.localParticipant?.trackIdPrefix;
    if (trackPrefix == null) {
      _logger.e(
        () =>
            'Could not apply background image filter, trackPrefix is null for localParticipant',
      );
      return null;
    }

    final track = call.getTrack(trackPrefix, SfuTrackType.video);
    final trackId = track?.mediaTrack.id;

    if (trackId == null) {
      _logger.e(
        () =>
            'Could not apply background image filter, could not find video track for localParticipant',
      );
      return null;
    }

    return trackId;
  }
}
