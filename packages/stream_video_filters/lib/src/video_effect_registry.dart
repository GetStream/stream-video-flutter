import 'package:flutter/foundation.dart' show listEquals;
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// The native effects attached to each local video track, and the effects
/// whose processors are registered.
///
/// Each filter attaches and detaches only its own effect. A change that
/// leaves a track's list of effects as it was is not sent.
@internal
class VideoEffectRegistry {
  VideoEffectRegistry._();

  static final _effects = <String, List<String>>{};
  static final _registered = <String>{};

  /// Whether the processor of [effect] is registered.
  static bool isRegistered(String effect) => _registered.contains(effect);

  /// Records that the processor of [effect] is registered.
  static void markRegistered(String effect) => _registered.add(effect);

  /// Forgets every registration, so each filter registers its processor
  /// again the next time it is applied.
  static void forgetRegistrations() => _registered.clear();

  /// The effects attached to [trackId], in the order they run.
  static List<String> effectsOf(String trackId) =>
      {...?_effects[trackId]}.toList();

  /// Attaches [effect] to [trackId], after the effects already on it.
  static Future<void> attach(String trackId, String effect) async {
    final before = effectsOf(trackId);
    (_effects[trackId] ??= []).add(effect);
    try {
      await _sendIfChanged(trackId, before);
    } catch (_) {
      _remove(trackId, effect);
      rethrow;
    }
  }

  /// Detaches one [effect] attached by [attach] from [trackId].
  static Future<void> detach(String trackId, String effect) async {
    final before = effectsOf(trackId);
    if (!_remove(trackId, effect)) return;
    await _sendIfChanged(trackId, before);
  }

  /// Removes the last [effect] attached to [trackId], so the effects attached
  /// before it keep their place.
  static bool _remove(String trackId, String effect) {
    final effects = _effects[trackId];
    final index = effects?.lastIndexOf(effect) ?? -1;
    if (index < 0) return false;
    effects!.removeAt(index);
    if (effects.isEmpty) _effects.remove(trackId);
    return true;
  }

  static Future<void> _sendIfChanged(String trackId, List<String> before) {
    final effects = effectsOf(trackId);
    if (listEquals(effects, before)) {
      return Future.value();
    }
    return rtc.setVideoEffects(trackId, names: effects);
  }

  /// Forgets every attached effect and registration.
  @visibleForTesting
  static void reset() {
    _effects.clear();
    _registered.clear();
  }
}
