import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// The native effects attached to each local video track.
///
/// Each filter attaches and detaches only its own effect, and every change
/// sends the track's whole list.
@internal
class VideoEffectRegistry {
  VideoEffectRegistry._();

  static final _effects = <String, List<String>>{};

  // The effects StreamVideoEffectsManager set on each track.
  static final _managed = <String, List<String>>{};

  /// The effects attached to [trackId], in the order they run.
  static List<String> effectsOf(String trackId) =>
      {...?_effects[trackId]}.toList();

  /// Attaches [effect] to [trackId], after the effects already on it.
  static Future<void> attach(String trackId, String effect) async {
    (_effects[trackId] ??= []).add(effect);
    try {
      await _send(trackId);
    } catch (_) {
      _remove(trackId, effect);
      rethrow;
    }
  }

  /// Sets the effects StreamVideoEffectsManager runs on [trackId] to [names],
  /// in place of the ones it set before. They run before the effects filters
  /// attached, which stay attached. Keeps the effects as they were when the
  /// change cannot be sent.
  static Future<void> setManaged(String trackId, List<String> names) async {
    final before = [...?_effects[trackId]];
    final effects = [...before];
    _managed[trackId]?.forEach(effects.remove);
    effects.insertAll(0, names);
    _store(trackId, effects);
    try {
      await _send(trackId);
    } catch (_) {
      _store(trackId, before);
      rethrow;
    }
    if (names.isEmpty) {
      _managed.remove(trackId);
    } else {
      _managed[trackId] = [...names];
    }
  }

  static void _store(String trackId, List<String> effects) {
    if (effects.isEmpty) {
      _effects.remove(trackId);
    } else {
      _effects[trackId] = effects;
    }
  }

  /// Detaches one [effect] attached by [attach] from [trackId].
  static Future<void> detach(String trackId, String effect) async {
    if (!_remove(trackId, effect)) return;
    await _send(trackId);
  }

  static bool _remove(String trackId, String effect) {
    final effects = _effects[trackId];
    if (effects == null || !effects.remove(effect)) return false;
    if (effects.isEmpty) _effects.remove(trackId);
    return true;
  }

  static Future<void> _send(String trackId) {
    return rtc.setVideoEffects(trackId, names: effectsOf(trackId));
  }

  /// Forgets every attached effect.
  @visibleForTesting
  static void reset() {
    _effects.clear();
    _managed.clear();
  }
}
