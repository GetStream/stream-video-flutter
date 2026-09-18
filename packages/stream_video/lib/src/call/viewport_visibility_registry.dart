import 'dart:async';

import '../logger/impl/tagged_logger.dart';
import '../models/viewport_measurement.dart';
import '../models/viewport_visibility.dart';
import '../webrtc/model/rtc_video_dimension.dart';

/// Called with a track's aggregate whenever it changes, and again for every
/// track on [ViewportVisibilityRegistry.reapplyAll].
///
/// Called synchronously, from inside the [ViewportVisibilityRegistry.report],
/// [ViewportVisibilityRegistry.release] or [ViewportVisibilityRegistry.reapply]
/// that moved it, so it must not call back into the registry.
///
/// Answers whether the aggregate was acted on. An answer of `false` is
/// forgotten rather than remembered as said, so the next report drives it
/// again.
typedef OnViewportAggregate =
    Future<bool> Function(ViewportAggregate aggregate);

/// Holds what each viewport measures for the tracks it draws, and derives the
/// one answer the call has to act on per track.
///
/// A participant can be drawn by several viewports at once — a tile in the
/// grid, a picture-in-picture overlay, a livestream's host strip — while the
/// call has a single visibility and a single subscription per track. Each
/// viewport reports only about itself, under a name from [nextViewportId], and
/// the registry answers for the track: visible while any viewport has it on
/// screen, sized for the largest viewport that does, and never
/// [ViewportVisibility.unknown].
///
/// A viewport that stops drawing a track must [release] it; nothing here
/// expires on its own.
class ViewportVisibilityRegistry {
  ViewportVisibilityRegistry({required this.onAggregate});

  late final _logger = taggedLogger(tag: 'SV:ViewportVisibility');

  /// Told the new answer whenever one of them moves.
  final OnViewportAggregate onAggregate;

  int _viewportSeq = 0;

  /// A name no other viewport reporting to this registry has.
  ///
  /// Reporting again under the same name replaces that viewport's measurement
  /// for the track, so two viewports drawing one track must not share a name.
  /// A viewport releases each track it reported separately.
  String nextViewportId() => '${_viewportSeq++}';

  /// Per track, what each viewport drawing it last measured.
  final _measurements = <ViewportTrack, Map<String, ViewportMeasurement>>{};

  /// What was last handed to [onAggregate] and acted on, so an unchanged
  /// answer is not reported again.
  final _reported = <ViewportTrack, ViewportAggregate>{};

  /// Records what the viewport known as [viewportId] measures for [track].
  void report({
    required String viewportId,
    required ViewportTrack track,
    required ViewportMeasurement measurement,
  }) {
    final measurements = _measurements.putIfAbsent(track, () => {});
    if (measurements[viewportId] == measurement) return;

    _logger.v(() => '[report] $viewportId on $track: $measurement');

    measurements[viewportId] = measurement;
    _emit(track);
  }

  /// Drops what [viewportId] measured for [track]: it has stopped drawing it.
  ///
  /// A track no viewport draws any more is hidden and sized for nobody,
  /// reported once if that is a change, then forgotten.
  void release({required String viewportId, required ViewportTrack track}) {
    final measurements = _measurements[track];
    if (measurements == null) return;

    if (measurements.remove(viewportId) == null) {
      _logger.w(() => '[release] $viewportId measured nothing for $track');
      return;
    }

    _logger.v(() => '[release] $viewportId on $track');

    if (measurements.isNotEmpty) return _emit(track);

    _measurements.remove(track);
    _emit(track);
    _reported.remove(track);
  }

  /// Reports [track]'s answer again even though it has not moved.
  ///
  /// For what happens outside a viewport and leaves its measurement standing:
  /// a track that has only now been published has to be subscribed at a size
  /// the viewports drawing it have been holding all along. Does nothing for a
  /// track no viewport is measuring.
  void reapply(ViewportTrack track) {
    if (!_measurements.containsKey(track)) return;

    _reported.remove(track);
    _emit(track);
  }

  /// Reports every track again, for a session that has not been told any of it.
  ///
  /// A viewport reports what changes about itself, so nothing here would be
  /// said a second time on its own.
  void reapplyAll() {
    _logger.d(() => '[reapplyAll] tracks: ${_measurements.length}');

    _reported.clear();
    _measurements.keys.toList().forEach(_emit);
  }

  /// Forgets everything, without reporting it.
  ///
  /// [reapplyAll] then has nothing to say until each viewport reports again.
  void clear() {
    _measurements.clear();
    _reported.clear();
  }

  void _emit(ViewportTrack track) {
    final aggregate = _aggregate(track, _measurements[track]?.values);
    if (_reported[track] == aggregate) return;

    _logger.v(() => '[emit] aggregate: $aggregate');

    // Recorded before it is acted on, so an emit for the same answer while
    // this one is in flight does not repeat it, and dropped again if it turns
    // out not to have landed.
    _reported[track] = aggregate;
    unawaited(
      onAggregate(aggregate).then((applied) {
        if (applied) return;

        _logger.w(() => '[emit] not applied, forgetting: $aggregate');
        if (_reported[track] == aggregate) _reported.remove(track);
      }),
    );
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
