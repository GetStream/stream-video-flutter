import '../logger/impl/tagged_logger.dart';
import '../models/viewport_measurement.dart';
import '../models/viewport_visibility.dart';
import '../webrtc/model/rtc_video_dimension.dart';

/// Called when what every viewport adds up to for a track has moved, and with
/// every track a new session has to be told about again.
typedef OnViewportAggregate = void Function(ViewportAggregate aggregate);

/// Holds what each viewport measures for the tracks it draws, and derives the
/// one answer the call has to act on per track.
///
/// A participant can be drawn by several viewports at once — a tile in the
/// grid, a picture-in-picture overlay, a livestream's host strip — while the
/// call has a single visibility and a single subscription per track. Left to
/// report on their own, whichever viewport spoke last would decide both, so a
/// participant on screen in the grid could be recorded as hidden and have
/// their track unsubscribed by an overlay that is not showing them, and a
/// small overlay could pull a full-screen tile's subscription down to its own
/// size.
///
/// Each viewport reports only about itself, through [report], and the registry
/// answers for the track: visible while any viewport has it on screen, sized
/// for the largest viewport that does.
class ViewportVisibilityRegistry {
  ViewportVisibilityRegistry({required this.onAggregate});

  late final _logger = taggedLogger(tag: 'SV:ViewportVisibility');

  /// Told the new answer whenever one of them moves.
  final OnViewportAggregate onAggregate;

  int _viewportSeq = 0;

  /// A name no other viewport reporting here has.
  ///
  /// Two viewports drawing the same track must not share one, or they are back
  /// to overwriting each other. Nothing outside this process reads it.
  String nextViewportId() => '${_viewportSeq++}';

  /// Per track, what each viewport drawing it last measured.
  final _measurements = <ViewportTrack, Map<String, ViewportMeasurement>>{};

  /// What was last handed to [onAggregate], so an unchanged answer is not
  /// reported again.
  final _reported = <ViewportTrack, ViewportAggregate>{};

  /// Records what the viewport known as [viewportId] measures for [track].
  void report({
    required String viewportId,
    required ViewportTrack track,
    required ViewportMeasurement measurement,
  }) {
    final measurements = _measurements.putIfAbsent(track, () => {});
    if (measurements[viewportId] == measurement) return;

    measurements[viewportId] = measurement;
    _emit(track);
  }

  /// Drops what [viewportId] measured for [track]: it has stopped drawing it.
  ///
  /// A track no viewport draws any more is hidden and sized for nobody, which
  /// is reported once before it is forgotten.
  void release({required String viewportId, required ViewportTrack track}) {
    final measurements = _measurements[track];
    if (measurements == null) return;
    if (measurements.remove(viewportId) == null) return;

    if (measurements.isNotEmpty) return _emit(track);

    _measurements.remove(track);
    _emit(track);
    _reported.remove(track);
  }

  /// Reports [track]'s answer again even though it has not moved.
  ///
  /// For what happens outside a viewport and leaves its measurement standing:
  /// a track that has only now been published has to be subscribed at a size
  /// the viewports drawing it have been holding all along.
  void reapply(ViewportTrack track) {
    if (!_measurements.containsKey(track)) return;

    _reported.remove(track);
    _emit(track);
  }

  /// Reports every track again, for a session that has not been told any of it.
  ///
  /// A viewport reports what changes about itself, so nothing here would be
  /// said a second time on its own: without this, a track that was visible
  /// across a reconnect would stay unknown to the new session until the
  /// viewport drawing it happened to move.
  void reapplyAll() {
    _logger.d(() => '[reapplyAll] tracks: ${_measurements.length}');

    _reported.clear();
    _measurements.keys.toList().forEach(_emit);
  }

  /// Forgets everything, without reporting it.
  void clear() {
    _measurements.clear();
    _reported.clear();
  }

  void _emit(ViewportTrack track) {
    final aggregate = _aggregate(track, _measurements[track]?.values);
    if (_reported[track] == aggregate) return;

    _logger.v(() => '[emit] aggregate: $aggregate');

    _reported[track] = aggregate;
    onAggregate(aggregate);
  }

  static ViewportAggregate _aggregate(
    ViewportTrack track,
    Iterable<ViewportMeasurement>? measurements,
  ) {
    final onScreen =
        measurements?.where(
          (measurement) => measurement.visibility.isVisible,
        ) ??
        const <ViewportMeasurement>[];

    // The largest viewport showing the track is the one the subscription has
    // to serve; anything smaller can scale down, nothing can scale up.
    var dimension = const RtcVideoDimension.zero();
    for (final measurement in onScreen) {
      if (measurement.dimension.area > dimension.area) {
        dimension = measurement.dimension;
      }
    }

    return ViewportAggregate(
      track: track,
      visibility: onScreen.isEmpty
          ? ViewportVisibility.hidden
          : ViewportVisibility.visible,
      dimension: dimension,
      persistWhenHidden:
          measurements?.any((measurement) => measurement.persistWhenHidden) ??
          false,
    );
  }
}
