import 'package:flutter/foundation.dart' show listEquals;
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// The native effects attached to each local video track, and the effects
/// whose processors are registered.
///
/// Each filter attaches its effect and detaches that same attachment. An
/// effect attached more than once runs at the place it was attached last. A
/// change that leaves a track's list of effects as it was is not sent.
///
/// Registering, attaching, detaching and unregistering run one at a time,
/// through [run], so an unregister never lands between a registration and
/// the attach that relies on it.
@internal
class VideoEffectRegistry {
  VideoEffectRegistry._();

  static final _effects = <String, List<_Attachment>>{};
  static final _registered = <String>{};
  static Future<void> _queue = Future.value();

  /// Runs [action] once every action run before it has completed.
  static Future<T> run<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  /// Whether the processor of [effect] is registered.
  static bool isRegistered(String effect) => _registered.contains(effect);

  /// Records that the processors of [effects] are registered.
  static void markRegistered(Iterable<String> effects) {
    _registered.addAll(effects);
  }

  /// Forgets every registration, so each filter registers its processor
  /// again the next time it is applied.
  static void forgetRegistrations() => _registered.clear();

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
    _queue = Future.value();
  }
}

/// One [VideoEffectRegistry.attach] of an effect, compared by identity.
class _Attachment {
  _Attachment(this.effect);

  final String effect;
}
