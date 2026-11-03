import 'dart:async';

import 'package:flutter/services.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'stream_video_filters.dart';

const _tag = 'SVF:BackgroundFilters';

enum BlurIntensity {
  light('BackgroundBlurLight'),
  medium('BackgroundBlurMedium'),
  heavy('BackgroundBlurHeavy');

  const BlurIntensity(this.name);
  final String name;
}

class StreamVideoEffectsManager {
  StreamVideoEffectsManager(this.call) {
    if (call.state.value.preferences.videoModerationConfig.applyBlur) {
      // ignore: invalid_use_of_internal_member
      call.setModerationBlurEffectHandlers(
        onApply: applyFullFrameBlurFilter,
        onClear: disableAllFilters,
      );
    }
  }

  static bool isBlurRegistered = false;
  static bool isFullFrameBlurRegistered = false;
  static Map<String, bool> isImageRegistered = <String, bool>{};
  static Map<String, bool> isCustomEffectRegistered = <String, bool>{};

  // Registering, attaching, detaching and unregistering built-in effects, and
  // the flags above that mirror the registry, run one at a time across all
  // managers. Otherwise an unregister could run between the register and the
  // attach of an apply that is in flight: the attach would then install a name
  // that no longer exists (sending the camera image unfiltered while
  // appliedVideoEffects reports the effect), or, in the other order, attach a
  // processor right after it was detached for release.
  static Future<void> _registryQueue = Future.value();

  static Future<void> _runSerially(Future<void> Function() action) {
    final result = _registryQueue.then((_) => action());
    _registryQueue = result.catchError((Object _) {});
    return result;
  }

  final Call call;

  /// List of previously applied video effects using this manager.
  List<String>? get appliedVideoEffects => _appliedVideoEffects;

  final _logger = taggedLogger(tag: _tag);
  List<String>? _appliedVideoEffects;
  StreamSubscription<bool?>? _localVideoTrackSubscription;
  bool _disposed = false;

  /// Checks if the background effect is supported on the current device.
  Future<bool> isSupported() async {
    try {
      return await StreamVideoFilters().isBackgroundEffectSupported() ?? false;
    } on MissingPluginException catch (_) {
      return false;
    }
  }

  /// Applies a background blur filter to the local participant video stream.
  /// The [blurIntensity] parameter specifies the intensity of the blur effect.
  Future<void> applyBackgroundBlurFilter(
    BlurIntensity blurIntensity, {
    RtcLocalTrack? track,
  }) {
    return _applyBuiltInEffects(
      [blurIntensity.name],
      register: _registerBlurEffectIfNeeded,
      track: track,
    );
  }

  /// Applies a full-frame blur filter to the local participant video stream.
  Future<void> applyFullFrameBlurFilter({
    RtcLocalTrack? track,
  }) {
    return _applyBuiltInEffects(
      ['FullFrameBlur'],
      register: _registerFullFrameBlurEffectIfNeeded,
      track: track,
    );
  }

  /// Applies a background image filter to the local participant video stream.
  /// The [imageUrl] parameter specifies the path to the image asset file or an URL to the image.
  ///
  /// The image is loaded asynchronously. While it is loading, and if it cannot
  /// be loaded, the background is blurred instead so the camera image is never
  /// sent unfiltered. A failed load is logged natively and does not make this
  /// call fail.
  Future<void> applyBackgroundImageFilter(
    String imageUrl, {
    RtcLocalTrack? track,
  }) {
    return _applyBuiltInEffects(
      ['VirtualBackground-$imageUrl'],
      register: () => _registerImageEffectIfNeeded(imageUrl),
      track: track,
    );
  }

  /// Applies a custom effect to the local participant video stream.
  /// The [effectName] parameter specifies the name of the custom effect.
  /// The [registerEffectProcessorCallback] parameter is is a required callback to register the custom effect processor.
  /// For details on how to implement the custom effect check the documentation.
  ///
  /// The callback runs inside this manager's effect queue, so it must not call
  /// back into any apply, disable or unregister method of a
  /// [StreamVideoEffectsManager]: that call would wait for the queue, which is
  /// waiting for the callback.
  Future<void> applyCustomEffect(
    String effectName, {
    required Future<void> Function() registerEffectProcessorCallback,
  }) {
    return _runSerially(() async {
      if (!(await isSupported())) {
        return;
      }

      if (!isCustomEffectRegistered.containsKey(effectName)) {
        await registerEffectProcessorCallback();
        isCustomEffectRegistered[effectName] = true;
      }

      await _applyVideoEffects([effectName]);
    });
  }

  /// Applies a list of video effects to the local participant video stream.
  /// The [names] parameter specifies the list of effect names.
  /// Make sure to register the effect processors before applying the effects.
  Future<void> applyVideoEffects(
    List<String> names, {
    RtcLocalTrack? track,
  }) {
    return _runSerially(() async {
      if (!(await isSupported())) {
        return;
      }
      await _applyVideoEffects(names, track: track);
    });
  }

  /// Registers a built-in effect and attaches it as one unit of the registry
  /// queue, so no unregister can slip in between the two.
  ///
  /// Every public apply, disable and unregister method takes its place in the
  /// queue synchronously, before any await, so calls run in the order they
  /// were made even when they are not awaited.
  Future<void> _applyBuiltInEffects(
    List<String> names, {
    required Future<void> Function() register,
    RtcLocalTrack? track,
  }) {
    return _runSerially(() async {
      if (!(await isSupported())) {
        return;
      }
      await register();
      await _applyVideoEffects(names, track: track, register: register);
    });
  }

  /// Attaches [names] to the local video track and re-attaches them whenever
  /// the camera is turned back on (the track is re-created then). Runs inside
  /// the registry queue. [register] re-registers a built-in effect before a
  /// re-attach, in case the registry was cleared meanwhile.
  Future<void> _applyVideoEffects(
    List<String> names, {
    RtcLocalTrack? track,
    Future<void> Function()? register,
  }) async {
    if (_disposed) {
      return;
    }
    _appliedVideoEffects = names;

    await _localVideoTrackSubscription?.cancel();
    _localVideoTrackSubscription = call
        .partialState((s) => s.localParticipant?.isVideoEnabled)
        // The stream replays the current value on subscribe. That is the
        // track being attached to right below, not a camera-on: re-applying
        // on it would build a second processor chain on Android.
        .skip(1)
        .where((enabled) => enabled ?? false)
        .listen((_) {
          unawaited(
            _runSerially(() async {
              // Replaced or removed while this was queued: nothing to re-apply.
              if (_disposed || !identical(_appliedVideoEffects, names)) {
                return;
              }
              await register?.call();
              final trackId = await _getTrackId();
              if (trackId != null) {
                await rtc.setVideoEffects(trackId, names: names);
              }
            }).catchError((Object e, StackTrace stk) {
              _logger.w(
                () => 'Could not re-apply video effects $names: $e\n$stk',
              );
            }),
          );
        });

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
  Future<void> ensureBlurEffectRegistered() {
    return _runSerially(_registerBlurEffectIfNeeded);
  }

  /// Ensures that the full-frame blur effect processor is registered.
  Future<void> ensureFullFrameBlurEffectRegistered() {
    return _runSerially(_registerFullFrameBlurEffectIfNeeded);
  }

  /// Ensures that the image effect processor is registered.
  Future<void> ensureImageEffectRegistered(String imageUrl) {
    return _runSerially(() => _registerImageEffectIfNeeded(imageUrl));
  }

  // The three below must run inside the registry queue.

  Future<void> _registerBlurEffectIfNeeded() async {
    if (!isBlurRegistered) {
      await StreamVideoFilters().registerBlurEffectProcessors();
      isBlurRegistered = true;
    }
  }

  Future<void> _registerFullFrameBlurEffectIfNeeded() async {
    if (!isFullFrameBlurRegistered) {
      await StreamVideoFilters().registerFullFrameBlurEffectProcessor();
      isFullFrameBlurRegistered = true;
    }
  }

  Future<void> _registerImageEffectIfNeeded(String imageUrl) async {
    if (!isImageRegistered.containsKey(imageUrl)) {
      await StreamVideoFilters().registerImageEffectProcessors(
        backgroundImageUrl: imageUrl,
      );
      isImageRegistered[imageUrl] = true;
    }
  }

  /// Disables all video filters applied to the local participant video stream.
  Future<void> disableAllFilters({
    RtcLocalTrack? track,
  }) {
    // Queued so it cannot run between the register and the attach of an apply
    // in flight, which would leave that effect attached.
    final queued = _runSerially(() async {
      if (!(await isSupported())) {
        return;
      }

      // An apply queued before this one has set its effects meanwhile.
      await _clearAppliedEffects();

      final trackId = track != null
          ? track.mediaTrack.id
          : await _getTrackId();
      if (trackId == null) {
        return;
      }

      await rtc.setVideoEffects(
        trackId,
        names: [],
      );
    });

    // Also right away, so appliedVideoEffects reports the change at once.
    unawaited(_clearAppliedEffects());
    return queued;
  }

  /// Forgets the applied effects and stops re-applying them on camera-on.
  /// Called right away so [appliedVideoEffects] reports the change at once,
  /// and again inside the registry queue to undo an apply that was queued
  /// before the disable or unregister and has completed meanwhile.
  Future<void> _clearAppliedEffects() async {
    _appliedVideoEffects = [];
    await _localVideoTrackSubscription?.cancel();
    _localVideoTrackSubscription = null;
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

  /// Unregisters every built-in effect processor (blur, full-frame blur and
  /// image backgrounds) registered natively by this plugin so it can be
  /// deallocated, and resets the registration bookkeeping so the processors
  /// are registered again on the next apply.
  ///
  /// Custom effects registered through [applyCustomEffect] stay registered,
  /// but are detached from the track like any other effect.
  ///
  /// Call this once filters are no longer needed, before leaving the call: any
  /// effect still attached to the local video track is detached first so the
  /// processors can actually be released, and once the track is torn down that
  /// native effect chain can no longer be reached.
  ///
  /// The registry is shared by every [StreamVideoEffectsManager] in the
  /// process, so this detaches the effects of all of them. Another manager
  /// keeps reporting its [appliedVideoEffects] and re-registers and re-attaches
  /// them the next time the camera is turned on.
  Future<void> unregisterAllFilters() {
    // Queued behind any apply already in flight, so this never runs between
    // its register and its attach; its flag is reset here too, and an apply
    // started meanwhile registers again after the removal.
    final queued = _runSerially(() async {
      if (!(await isSupported())) {
        return;
      }

      // An apply queued before this one has set its effects meanwhile.
      await _clearAppliedEffects();

      // Detach before removing from the registry: the native effect chain
      // holds strong references to the processors, so without this they would
      // keep running (and stay alive) while appliedVideoEffects reports
      // nothing.
      try {
        final trackId = await _getTrackId();
        if (trackId != null) {
          await rtc.setVideoEffects(trackId, names: []);
        }
      } catch (e, stk) {
        // Best effort: right after leave() the track's factory is already
        // gone and the detach fails. The registry is still cleaned up below.
        _logger.w(
          () => 'Could not detach video effects before unregistering: $e\n$stk',
        );
      }

      isBlurRegistered = false;
      isFullFrameBlurRegistered = false;
      isImageRegistered.clear();

      await StreamVideoFilters().unregisterAllFilters();
    });

    // Also right away, so appliedVideoEffects reports the change at once.
    unawaited(_clearAppliedEffects());
    return queued;
  }

  /// Stops re-applying effects on camera-on. An apply still queued or in
  /// flight no longer attaches anything either. The effects currently attached
  /// to the track stay attached; use [disableAllFilters] or
  /// [unregisterAllFilters] first to remove them.
  Future<void> dispose() async {
    _disposed = true;
    await _clearAppliedEffects();
  }
}
