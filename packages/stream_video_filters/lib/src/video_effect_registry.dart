import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// The native effects attached to each local video track, and whether the
/// processors registered so far are still registered.
///
/// Each filter attaches and detaches only its own effect, and every change
/// sends the track's whole list.
@internal
class VideoEffectRegistry {
  VideoEffectRegistry._();

  /// Bumped when every processor is unregistered, so a filter registers its
  /// processor again the next time it is applied.
  static int generation = 0;

  static final _effects = <String, List<String>>{};

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
    generation = 0;
  }
}
