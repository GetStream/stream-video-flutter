import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../stream_video_flutter.dart';

/// Names each reporter for the call's viewport registry. Nothing outside this
/// process reads it; it only has to tell two live reporters apart.
int _viewportSeq = 0;

/// Measures how much of [child] is on screen and at what size, and reports it
/// to [Call.viewportVisibility] as one viewport's view of [track].
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
    required this.call,
    required this.track,
    required this.child,
    this.isTrackPublished = false,
    this.persistWhenHidden = false,
    this.onSizeChanged,
    this.scopePrefix,
  });

  /// The call whose registry is told what this viewport measures.
  final Call call;

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
  /// This viewport's name in the registry, which holds one measurement per
  /// viewport. Two of them drawing the same track must not share it, or they
  /// are back to overwriting each other.
  final String _viewportId = '${_viewportSeq++}';

  VisibilityInfo? _latest;

  /// The track last reported for, which is owed a release. Null until this
  /// viewport has measured anything.
  ViewportTrack? _reported;

  @override
  void didUpdateWidget(covariant ViewportVisibilityReporter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // An element recycled onto a different track carries no measurement from
    // the one it drew before.
    final reported = _reported;
    if (reported != null && reported != widget.track) {
      _releaseAfterFrame(widget.call, _viewportId, reported);
      _reported = null;
    }

    final latest = _latest;
    if (latest == null) return;

    if (!oldWidget.isTrackPublished && widget.isTrackPublished) {
      // Deferred, because acting on a report writes call state, which the
      // SDK's emitter delivers synchronously: from the middle of this rebuild
      // it would ask a widget that has already been built this frame to build
      // again, and that throws. Nothing is waiting on the answer.
      final track = widget.track;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _report(_latest ?? latest);
        widget.call.viewportVisibility.reapply(track);
      });
    }
  }

  @override
  void dispose() {
    final reported = _reported;
    if (reported != null) {
      _releaseAfterFrame(widget.call, _viewportId, reported);
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
    Call call,
    String viewportId,
    ViewportTrack track,
  ) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      call.viewportVisibility.release(viewportId: viewportId, track: track);
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
    widget.call.viewportVisibility.report(
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
