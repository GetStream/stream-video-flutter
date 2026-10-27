import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// The frame size of each video track that a renderer on screen is showing,
/// keyed by the track's id.
///
/// Sizes have rotation applied, so a portrait frame sent with a 90° rotation
/// reports as portrait. A track shown by several renderers at once keeps a
/// size as long as at least one of them is still mounted, and uses the size
/// of the one that reported first: a renderer that has just mounted reports
/// the unrotated size before its rotation arrives.
///
/// It also tells where on screen a track is drawn, from the renderers that
/// reported with their [BuildContext]. Changing a size schedules a frame,
/// since the sizes are read after each frame.
class RenderedVideoSizes {
  RenderedVideoSizes._();

  /// The registry shared by every renderer.
  static final RenderedVideoSizes instance = RenderedVideoSizes._();

  final _sizes = <String, Map<Object, ({Size size, BuildContext? context})>>{};

  /// The frame size of the track with [trackId], or null when no renderer is
  /// showing a frame of it.
  Size? sizeOf(String trackId) => _sizes[trackId]?.values.firstOrNull?.size;

  /// Where on screen the track with [trackId] is drawn, in logical pixels, or
  /// null when no renderer that reported with a context is laid out where it
  /// is shown.
  ///
  /// Of several, the largest wins: a thumbnail of the same track is too small
  /// for the picture-in-picture window to animate in from. One whose tickers
  /// are off, such as in a route below the current one, is laid out where it
  /// was but not shown, so it is passed over. Reads the layout, so it is
  /// meant for after a frame, not during one.
  Rect? screenRectOf(String trackId) {
    final renderers = _sizes[trackId]?.values;
    if (renderers == null) return null;

    Rect? largest;
    for (final (size: _, :context) in renderers) {
      if (context == null || !context.mounted) continue;
      // Read without depending on it, as this is not the context's build.
      if (!TickerMode.getNotifier(context).value) continue;

      final box = context.findRenderObject();
      if (box is! RenderBox || !box.attached || !box.hasSize) continue;

      final rect = MatrixUtils.transformRect(
        box.getTransformTo(null),
        Offset.zero & box.size,
      );
      if (largest == null || _area(rect) > _area(largest)) largest = rect;
    }
    return largest;
  }

  static double _area(Rect rect) => rect.width * rect.height;

  /// Records that [renderer] is showing frames of [size] for [trackId], drawn
  /// where [context] is laid out.
  void report(
    String trackId,
    Object renderer,
    Size size, {
    BuildContext? context,
  }) {
    final previous = sizeOf(trackId);
    _sizes.putIfAbsent(trackId, () => {})[renderer] = (
      size: size,
      context: context,
    );
    if (sizeOf(trackId) != previous) _scheduleFrame();
  }

  /// Forgets the size [renderer] reported for [trackId].
  void remove(String trackId, Object renderer) {
    final renderers = _sizes[trackId];
    if (renderers == null || !renderers.containsKey(renderer)) return;

    final previous = sizeOf(trackId);
    renderers.remove(renderer);
    if (renderers.isEmpty) _sizes.remove(trackId);
    if (sizeOf(trackId) != previous) _scheduleFrame();
  }

  /// Clears every recorded size. For tests.
  void debugReset() => _sizes.clear();

  void _scheduleFrame() => SchedulerBinding.instance.ensureVisualUpdate();
}
