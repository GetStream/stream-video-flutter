import 'dart:async';

import '../logger/impl/tagged_logger.dart';
import '../models/viewport_measurement.dart';
import '../models/viewport_visibility.dart';
import '../webrtc/model/rtc_video_dimension.dart';

/// Called with a track's aggregate whenever it changes, and again for every
/// track on [ViewportVisibilityRegistry.reapplyAll].
///
/// Called synchronously, from inside the [ViewportHandle.report],
/// [ViewportHandle.release] or [ViewportVisibilityRegistry.reapply] that moved
/// it, so it must not call back into the registry.
///
/// Answers whether the aggregate was acted on. An answer of `false` is
/// forgotten rather than remembered as said, so the next report drives it
/// again.
typedef OnViewportAggregate =
    Future<bool> Function(ViewportAggregate aggregate);

/// One viewport's place in a [ViewportVisibilityRegistry], from
/// [ViewportVisibilityRegistry.attach].
///
/// A handle speaks only for the viewport that holds it: what it reports cannot
/// overwrite another viewport's measurement, and it can take out only what it
/// put in. Holding one is the whole of a viewport's part in the registry, so a
/// viewport that stops drawing must [dispose] of its handle — nothing here
/// expires on its own.
final class ViewportHandle {
  ViewportHandle._(this._registry);

  final ViewportVisibilityRegistry _registry;

  /// The track this handle last reported for, and so the one it owes a
  /// release. Null while it is measuring nothing.
  ViewportTrack? _track;

  bool _disposed = false;

  /// Whether this handle has been disposed of and reports nothing further.
  bool get isDisposed => _disposed;

  /// Records what this viewport measures for [track].
  ///
  /// Reporting for a different track releases the one before it, so a viewport
  /// pointed at somebody new stops speaking for whoever it drew last.
  void report(ViewportTrack track, ViewportMeasurement measurement) {
    if (_disposed) {
      _registry._logger.w(() => '[report] handle is disposed: $track');
      return;
    }

    final previous = _track;
    if (previous != null && previous != track) {
      _registry._release(this, previous);
    }

    _track = track;
    _registry._report(this, track, measurement);
  }

  /// Takes this viewport's measurement out of the registry: it has stopped
  /// drawing the track.
  ///
  /// Does nothing if it is measuring none, so calling it twice is safe.
  void release() {
    final track = _track;
    if (track == null) return;

    _track = null;
    _registry._release(this, track);
  }

  /// Releases whatever this viewport was measuring and retires the handle.
  ///
  /// A report after this is refused rather than silently reviving a viewport
  /// that is gone.
  void dispose() {
    release();
    _disposed = true;
  }
}

/// Holds what each viewport measures for the tracks it draws, and derives the
/// one answer the call has to act on per track.
///
/// A participant can be drawn by several viewports at once — a tile in the
/// grid, a picture-in-picture overlay, a livestream's host strip — while the
/// call has a single visibility and a single subscription per track. Each
/// viewport [attach]es for a [ViewportHandle] of its own and reports only
/// about itself, and the registry answers for the track: visible while any
/// viewport has it on screen, sized for the largest viewport that does, and
/// never [ViewportVisibility.unknown].
class ViewportVisibilityRegistry {
  ViewportVisibilityRegistry({required this.onAggregate});

  late final _logger = taggedLogger(tag: 'SV:ViewportVisibility');

  /// Told the new answer whenever one of them moves.
  final OnViewportAggregate onAggregate;

  /// Per track, what each viewport drawing it last measured.
  final _measurements =
      <ViewportTrack, Map<ViewportHandle, ViewportMeasurement>>{};

  /// What was last handed to [onAggregate] and acted on, so an unchanged
  /// answer is not reported again.
  final _reported = <ViewportTrack, ViewportAggregate>{};

  /// A place for one viewport to report from.
  ///
  /// The viewport holds the handle for as long as it draws anything, and
  /// disposes of it when it stops.
  // Registers a new viewport rather than converting the registry.
  // ignore: use_to_and_as_if_applicable
  ViewportHandle attach() => ViewportHandle._(this);

  void _report(
    ViewportHandle handle,
    ViewportTrack track,
    ViewportMeasurement measurement,
  ) {
    final measurements = _measurements.putIfAbsent(track, () => {});
    if (measurements[handle] == measurement) return;

    _logger.v(() => '[report] $track: $measurement');

    measurements[handle] = measurement;
    _emit(track);
  }

  void _release(ViewportHandle handle, ViewportTrack track) {
    final measurements = _measurements[track];
    if (measurements == null) return;
    if (measurements.remove(handle) == null) return;

    _logger.v(() => '[release] $track');

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
