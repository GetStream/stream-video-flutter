import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../stream_video_flutter.dart';

/// Measures how much of [child] is on screen and at what size, and reports it
/// to a [ViewportVisibilityRegistry] as one viewport's view of [track].
///
/// Only ever about itself. A participant can be drawn in several places at
/// once — a tile in the grid, a picture-in-picture overlay, a livestream's
/// host strip — and what their visibility and subscription become is the
/// registry's to decide across all of them. Wrap any widget drawing a
/// participant's track in one of these and it takes part in that; draw one
/// without and the call cannot tell the track is on screen.
class ViewportVisibilityReporter extends StatefulWidget {
  /// Creates a new instance of [ViewportVisibilityReporter].
  const ViewportVisibilityReporter({
    super.key,
    required this.registry,
    required this.track,
    required this.child,
    this.isTrackPublished = false,
    this.persistWhenHidden = false,
    this.onSizeChanged,
    this.scopePrefix,
  });

  /// Told what this viewport measures, and what it stops measuring.
  final ViewportVisibilityRegistry registry;

  /// The track [child] draws.
  final ViewportTrack track;

  /// Whether [track] has been published.
  ///
  /// Nothing this viewport measures changes when a track appears — the same
  /// area was being given to a placeholder — but the size it has been holding
  /// all along has never been subscribed at, so it is reported again.
  final bool isTrackPublished;

  /// Whether this viewport wants the track subscribed even while it is hidden,
  /// as a screen share does.
  final bool persistWhenHidden;

  /// Called with the size this viewport draws the track at, in device pixels,
  /// and with [Size.zero] once it is off screen.
  final ValueSetter<Size>? onSizeChanged;

  /// Distinguishes this viewport's visibility detector from another one
  /// drawing the same track (e.g. `pipVideo` against the main view).
  final String? scopePrefix;

  /// The widget drawing the track.
  final Widget child;

  @override
  State<ViewportVisibilityReporter> createState() =>
      _ViewportVisibilityReporterState();
}

class _ViewportVisibilityReporterState
    extends State<ViewportVisibilityReporter> {
  /// This viewport's name in [ViewportVisibilityReporter.registry], which
  /// holds one measurement per viewport. Re-minted if the registry changes,
  /// since the name is only unique within the one that gave it out.
  late String _viewportId = widget.registry.nextViewportId();

  VisibilityInfo? _latest;

  /// The track last reported for, which is owed a release. Null until this
  /// viewport has measured anything.
  ViewportTrack? _reported;

  @override
  void didUpdateWidget(covariant ViewportVisibilityReporter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // An element recycled onto a different track — or onto another call's
    // registry — carries no measurement from the one it drew before. Left
    // behind, it would speak for a track this viewport no longer draws.
    final registryChanged = oldWidget.registry != widget.registry;
    final reported = _reported;
    if (reported != null && (registryChanged || reported != widget.track)) {
      _releaseAfterFrame(oldWidget.registry, _viewportId, reported);
      _reported = null;
    }

    if (registryChanged) _viewportId = widget.registry.nextViewportId();

    final latest = _latest;
    if (latest == null) return;

    // A registry that has never heard from this viewport, and a track that has
    // only now been published, both need the standing measurement said again.
    // Nothing this viewport measures changed — the same area was being given
    // to a placeholder, and a detector reports only what changes — so without
    // this neither would learn the size it has been holding all along.
    final publishedNow = !oldWidget.isTrackPublished && widget.isTrackPublished;
    if (!registryChanged && !publishedNow) return;

    // Deferred, because acting on a report writes call state, which the SDK's
    // emitter delivers synchronously: from the middle of this rebuild it would
    // ask a widget that has already been built this frame to build again, and
    // that throws. Nothing is waiting on the answer.
    final track = widget.track;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _report(_latest ?? latest);

      // A registry hearing this viewport for the first time has moved on the
      // report alone; one that has held the same answer throughout has to be
      // asked for it again.
      if (!registryChanged) widget.registry.reapply(track);
    });
  }

  @override
  void dispose() {
    final reported = _reported;
    if (reported != null) {
      _releaseAfterFrame(widget.registry, _viewportId, reported);
    }

    super.dispose();
  }

  /// Takes this viewport's measurement out of the registry at the end of the
  /// frame.
  ///
  /// Deferred for the same reason a report is, and taking what it needs by
  /// value: by the time it runs this [State] may be disposed, and the widget
  /// it would have read is gone.
  static void _releaseAfterFrame(
    ViewportVisibilityRegistry registry,
    String viewportId,
    ViewportTrack track,
  ) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      registry.release(viewportId: viewportId, track: track);
    });
  }

  void _report(VisibilityInfo info) {
    _latest = info;

    final visibility = ViewportVisibility.fromVisibleFraction(
      info.visibleFraction,
    );

    var size = Size.zero;
    if (visibility.isVisible) {
      // VisibilityDetector measures in logical, device-independent pixels, and
      // a track is subscribed in device pixels.
      final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
      size = Size(
        info.size.width * devicePixelRatio,
        info.size.height * devicePixelRatio,
      );
    }

    widget.onSizeChanged?.call(size);

    _reported = widget.track;
    widget.registry.report(
      viewportId: _viewportId,
      track: widget.track,
      measurement: ViewportMeasurement(
        visibility: visibility,
        dimension: RtcVideoDimension(
          width: size.width.toInt(),
          height: size.height.toInt(),
        ),
        persistWhenHidden: widget.persistWhenHidden,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      // Keyed by the track, so an element recycled onto a different one is
      // measured afresh rather than staying quiet at an unchanged size.
      key: Key(
        '${widget.scopePrefix ?? ''}${widget.track.userId}-'
        '${widget.track.sessionId}${widget.track.trackType}-visibility',
      ),
      onVisibilityChanged: _report,
      child: widget.child,
    );
  }
}
