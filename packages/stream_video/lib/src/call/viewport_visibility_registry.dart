import 'dart:async';

import '../logger/impl/tagged_logger.dart';
import '../models/viewport_measurement.dart';
import '../models/viewport_visibility.dart';
import '../webrtc/model/rtc_video_dimension.dart';

/// Called with a track's aggregate whenever it changes, synchronously from
/// the call that moved it, so it must not call back into the registry.
///
/// Answers whether it was acted on; a `false` is forgotten, so the next report
/// drives it again.
typedef OnViewportAggregate =
    Future<bool> Function(ViewportAggregate aggregate);

/// One viewport's place in a [ViewportVisibilityRegistry].
///
/// Speaks only for the viewport holding it: it cannot overwrite another's
/// measurement, and takes out only what it put in. [dispose] it when the
/// viewport stops drawing; nothing expires on its own.
final class ViewportHandle {
  ViewportHandle._(this._registry);

  final ViewportVisibilityRegistry _registry;

  /// The track this handle owes a release for. Null while measuring nothing.
  ViewportTrack? _track;

  bool _disposed = false;

  /// Whether this handle reports nothing further.
  bool get isDisposed => _disposed;

  /// Records what this viewport measures for [track], releasing the track it
  /// reported for before, if that was a different one.
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

  /// Takes this viewport's measurement out of the registry. Does nothing if it
  /// is measuring none, so calling it twice is safe.
  void release() {
    final track = _track;
    if (track == null) return;

    _track = null;
    _registry._release(this, track);
  }

  /// Releases whatever this viewport was measuring. A report after this is
  /// refused.
  void dispose() {
    release();
    _disposed = true;
  }
}

/// Derives the one answer a call acts on per track from what every viewport
/// drawing it measures.
///
/// A participant can be drawn by several viewports at once — a grid tile, a
/// picture-in-picture overlay, a livestream's host strip — while the call has
/// one visibility and one subscription per track. Each viewport [attach]es for
/// a [ViewportHandle] and reports only about itself; the track comes out
/// visible while any viewport has it on screen, sized for the largest that
/// does, and never [ViewportVisibility.unknown].
///
/// A track the last viewport lets go of is held for [releaseGrace] before it
/// is reported hidden, so a participant moving from one viewport to another
/// does not lose their subscription in between.
class ViewportVisibilityRegistry {
  ViewportVisibilityRegistry({
    required this.onAggregate,
    Duration? releaseGrace,
  }) : releaseGrace = releaseGrace ?? defaultReleaseGrace;

  /// The [releaseGrace] a registry built without one uses — every call's,
  /// since a call builds its own registry.
  ///
  /// Set alongside `VisibilityDetectorController.updateInterval`, which is
  /// what the grace has to outlast: raised, this is raised with it, and taken
  /// out, this is taken out too.
  static Duration defaultReleaseGrace = const Duration(milliseconds: 600);

  late final _logger = taggedLogger(tag: 'SV:ViewportVisibility');

  /// Told the new answer whenever one of them moves.
  final OnViewportAggregate onAggregate;

  /// How long a track the last viewport let go of is held before it is
  /// reported hidden.
  ///
  /// A participant moving between layouts — out of the spotlight and into the
  /// bar below it — is a new widget in a new place, so the viewport measuring
  /// them is torn down and another built. In between, nothing measures the
  /// track. Reported hidden right then it is unsubscribed and resubscribed a
  /// moment later, and the tile shows a placeholder until the picture comes
  /// back.
  ///
  /// So the answer waits for the viewport taking over. Long enough for one to
  /// measure and report: on Flutter that is a `VisibilityDetector`, whose
  /// first report is up to `VisibilityDetectorController.updateInterval`
  /// (500ms by default) after it is built. A track nothing picks up is
  /// reported hidden once this elapses.
  ///
  /// [Duration.zero] reports it straight away.
  final Duration releaseGrace;

  /// Per track, what each viewport drawing it last measured.
  final _measurements =
      <ViewportTrack, Map<ViewportHandle, ViewportMeasurement>>{};

  /// Per track, the [releaseGrace] running for it. Only ever for a track no
  /// longer in [_measurements]: a track measured again cancels its own.
  final _pendingReleases = <ViewportTrack, Timer>{};

  /// What [onAggregate] last acted on, so an unchanged answer is not repeated.
  final _reported = <ViewportTrack, ViewportAggregate>{};

  /// A place for one viewport to report from, held for as long as it draws.
  // Registers a new viewport rather than converting the registry.
  // ignore: use_to_and_as_if_applicable
  ViewportHandle attach() => ViewportHandle._(this);

  void _report(
    ViewportHandle handle,
    ViewportTrack track,
    ViewportMeasurement measurement,
  ) {
    // A viewport measuring it again is the handover the grace was held for.
    _pendingReleases.remove(track)?.cancel();

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

    if (releaseGrace <= Duration.zero) return _reportGone(track);

    _logger.v(() => '[release] holding $track for $releaseGrace');
    _pendingReleases[track] = Timer(releaseGrace, () => _reportGone(track));
  }

  /// Reports [track] hidden, the grace having passed with no viewport taking
  /// it up.
  void _reportGone(ViewportTrack track) {
    _pendingReleases.remove(track);
    _emit(track);
    _reported.remove(track);
  }

  /// Reports [track]'s answer again though it has not moved, for a track only
  /// now published under viewports that have been holding a size all along.
  /// Does nothing for a track no viewport is measuring.
  void reapply(ViewportTrack track) {
    if (!_measurements.containsKey(track)) return;

    _reported.remove(track);
    _emit(track);
  }

  /// Reports every track again, for a session that has not been told any of
  /// it. Viewports report what changes about them, so nothing would be said a
  /// second time on its own.
  void reapplyAll() {
    _logger.d(() => '[reapplyAll] tracks: ${_measurements.length}');

    _reported.clear();
    _measurements.keys.toList().forEach(_emit);
  }

  /// Forgets everything, without reporting it. [reapplyAll] then has nothing
  /// to say until each viewport reports again.
  void clear() {
    for (final timer in _pendingReleases.values) {
      timer.cancel();
    }
    _pendingReleases.clear();
    _measurements.clear();
    _reported.clear();
  }

  void _emit(ViewportTrack track) {
    final aggregate = _aggregate(track, _measurements[track]?.values);
    if (_reported[track] == aggregate) return;

    _logger.v(() => '[emit] aggregate: $aggregate');

    // Recorded before it is acted on, so an emit in flight is not repeated,
    // and dropped again if it turns out not to have landed.
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
