import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

/// The frame size of each video track that a renderer on screen is showing,
/// keyed by the track's id.
///
/// Sizes have rotation applied, so a portrait frame sent with a 90° rotation
/// reports as portrait. A track shown by several renderers at once keeps a
/// size as long as at least one of them is still mounted, and uses the size
/// of the one that reported first: a renderer that has just mounted reports
/// the unrotated size before its rotation arrives.
class RenderedVideoSizes extends ChangeNotifier {
  RenderedVideoSizes._();

  /// The registry shared by every renderer.
  static final RenderedVideoSizes instance = RenderedVideoSizes._();

  final _sizes = <String, Map<Object, Size>>{};

  /// The frame size of the track with [trackId], or null when no renderer is
  /// showing a frame of it.
  Size? sizeOf(String trackId) => _sizes[trackId]?.values.firstOrNull;

  /// Records that [renderer] is showing frames of [size] for [trackId].
  void report(String trackId, Object renderer, Size size) {
    final previous = sizeOf(trackId);
    _sizes.putIfAbsent(trackId, () => {})[renderer] = size;
    if (sizeOf(trackId) != previous) notifyListeners();
  }

  /// Forgets the size [renderer] reported for [trackId].
  void remove(String trackId, Object renderer) {
    final renderers = _sizes[trackId];
    if (renderers == null || !renderers.containsKey(renderer)) return;

    final previous = sizeOf(trackId);
    renderers.remove(renderer);
    if (renderers.isEmpty) _sizes.remove(trackId);
    if (sizeOf(trackId) != previous) notifyListeners();
  }

  /// Clears every recorded size.
  @visibleForTesting
  void reset() {
    if (_sizes.isEmpty) return;
    _sizes.clear();
    notifyListeners();
  }
}
