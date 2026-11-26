import 'package:flutter/foundation.dart' show listEquals;
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// The native effects attached to each local video track, and the effects
/// whose processors are registered.
///
/// Each filter attaches its effect and detaches that same attachment. An
/// effect attached more than once runs at the place it was attached last. A
/// change that leaves a track's list of effects as it was is not sent.
@internal
class VideoEffectRegistry {
  VideoEffectRegistry._();

  static final _effects = <String, List<_Attachment>>{};
  static final _registered = <String>{};
  static var _generation = 0;

  /// Changes each time the registrations are forgotten.
  static int get generation => _generation;

  /// Whether the processor of [effect] is registered.
  static bool isRegistered(String effect) => _registered.contains(effect);

  /// Records that the processor of [effect] is registered, unless the
  /// registrations were forgotten since [generation].
  static void markRegistered(String effect, {required int generation}) {
    if (generation == _generation) _registered.add(effect);
  }

  /// Forgets every registration, so each filter registers its processor
  /// again the next time it is applied.
  static void forgetRegistrations() {
    _registered.clear();
    _generation++;
  }

  /// The effects attached to [trackId], in the order they run.
  static List<String> effectsOf(String trackId) {
    final names = [
      for (final attachment in _effects[trackId] ?? const <_Attachment>[])
        attachment.effect,
    ];
    return [
      for (final (index, effect) in names.indexed)
        if (names.lastIndexOf(effect) == index) effect,
    ];
  }

  /// Attaches [effect] to [trackId], after the effects already on it, and
  /// returns the attachment that [detach] removes.
  static Future<Object> attach(String trackId, String effect) async {
    final before = effectsOf(trackId);
    final attachment = _Attachment(effect);
    (_effects[trackId] ??= []).add(attachment);
    try {
      await _sendIfChanged(trackId, before);
    } catch (_) {
      _remove(trackId, attachment);
      rethrow;
    }
    return attachment;
  }

  /// Removes [attachment], returned by [attach], from [trackId].
  static Future<void> detach(String trackId, Object attachment) async {
    final before = effectsOf(trackId);
    if (!_remove(trackId, attachment)) return;
    await _sendIfChanged(trackId, before);
  }

  static bool _remove(String trackId, Object attachment) {
    final effects = _effects[trackId];
    if (effects == null || !effects.remove(attachment)) return false;
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
    _generation = 0;
  }
}

/// One [VideoEffectRegistry.attach] of an effect, compared by identity.
class _Attachment {
  _Attachment(this.effect);

  final String effect;
}
