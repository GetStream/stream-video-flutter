import 'dart:async';

import 'package:flutter/services.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../stream_video_flutter_platform_interface.dart';

const _tag = 'SVF:BackgroundFilters';

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
  static Map<String, bool> isCustomEffectRegistered = <String, bool>{};

  final Call call;

  /// List of previously applied video effects using this manager.
  List<String>? get appliedVideoEffects => _appliedVideoEffects;

  final _logger = taggedLogger(tag: _tag);
  List<String>? _appliedVideoEffects;
  StreamSubscription<bool?>? _localVideoTrackSubscription;

  /// Checks if the background effect is supported on the current device.
  Future<bool> isSupported() async {
    try {
      return await StreamVideoFlutterPlatform.instance
              .isBackgroundEffectSupported() ??
          false;
    } on MissingPluginException catch (_) {
      return false;
    }
  }

  /// Applies a background blur filter to the local participant video stream.
  /// The [blurIntensity] parameter specifies the intensity of the blur effect.
  Future<void> applyBackgroundBlurFilter(
    BlurIntensity blurIntensity, {
    RtcLocalTrack? track,
  }) async {
    if (!(await isSupported())) {
      return;
    }

    await ensureBlurEffectRegistered();
    await applyVideoEffects([blurIntensity.name], track: track);
  }

  /// Applies a background image filter to the local participant video stream.
  /// The [imageUrl] parameter specifies the path to the image asset file or an URL to the image.
  Future<void> applyBackgroundImageFilter(
    String imageUrl, {
    RtcLocalTrack? track,
  }) async {
    if (!(await isSupported())) {
      return;
    }

    await ensureImageEffectRegistered(imageUrl);
    await applyVideoEffects(['VirtualBackground-$imageUrl'], track: track);
  }

  /// Applies a custom effect to the local participant video stream.
  /// The [effectName] parameter specifies the name of the custom effect.
  /// The [registerEffectProcessorCallback] parameter is is a required callback to register the custom effect processor.
  /// For details on how to implement the custom effect check the documentation.
  Future<void> applyCustomEffect(
    String effectName, {
    required Future<void> Function() registerEffectProcessorCallback,
  }) async {
    if (!(await isSupported())) {
      return;
    }

    if (!isCustomEffectRegistered.containsKey(effectName)) {
      await registerEffectProcessorCallback();
      isCustomEffectRegistered[effectName] = true;
    }

    await applyVideoEffects([effectName]);
  }

  /// Applies a list of video effects to the local participant video stream.
  /// The [names] parameter specifies the list of effect names.
  /// Make sure to register the effect processors before applying the effects.
  Future<void> applyVideoEffects(
    List<String> names, {
    RtcLocalTrack? track,
  }) async {
    _appliedVideoEffects = names;

    await _localVideoTrackSubscription?.cancel();
    _localVideoTrackSubscription =
        call.partialState((s) => s.localParticipant?.isVideoEnabled).listen(
      (enabled) async {
        final trackId = await _getTrackId();
        if (trackId != null) {
          await rtc.setVideoEffects(
            trackId,
            names: names,
          );
        }
      },
    );

    final trackId = track != null ? track.mediaTrack.id : await _getTrackId();
    if (trackId == null) {
      _logger.w(
        () =>
            'Could not apply video effects, could not find video track for localParticipant. Effects will be applied when the track is available.',
      );
      return;
    }

    await rtc.setVideoEffects(
      trackId,
      names: names,
    );
  }

  /// Ensures that the blur effect processor is registered.
  Future<void> ensureBlurEffectRegistered() async {
    if (!isBlurRegistered) {
      await StreamVideoFlutterPlatform.instance.registerBlurEffectProcessors();
      isBlurRegistered = true;
    }
  }

  /// Ensures that the image effect processor is registered.
  Future<void> ensureImageEffectRegistered(String imageUrl) async {
    if (!isImageRegistered.containsKey(imageUrl)) {
      await StreamVideoFlutterPlatform.instance.registerImageEffectProcessors(
        backgroundImageUrl: imageUrl,
      );
      isImageRegistered[imageUrl] = true;
    }
  }

  /// Disables all video filters applied to the local participant video stream.
  Future<void> disableAllFilters({
    RtcLocalTrack? track,
  }) async {
    if (!(await isSupported())) {
      return;
    }

    _appliedVideoEffects = [];
    await _localVideoTrackSubscription?.cancel();

    final trackId = track != null ? track.mediaTrack.id : await _getTrackId();
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
      _logger.d(
        () =>
            'Could not apply background image filter, trackPrefix is null for localParticipant',
      );
      return null;
    }

    final track = call.getTrack(trackPrefix, SfuTrackType.video);
    final trackId = track?.mediaTrack.id;

    if (trackId == null) {
      _logger.d(
        () =>
            'Could not apply background image filter, could not find video track for localParticipant',
      );
      return null;
    }

    return trackId;
  }

  Future<void> dispose() async {
    await _localVideoTrackSubscription?.cancel();
    _localVideoTrackSubscription = null;
  }
}
