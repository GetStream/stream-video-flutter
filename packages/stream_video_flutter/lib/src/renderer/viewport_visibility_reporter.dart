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

  /// Whether [track] is published.
  ///
  /// When this turns true, the measurement this viewport has been holding is
  /// reported again, so the track is subscribed at the size already on screen.
  final bool isTrackPublished;

  /// Whether this viewport wants the track subscribed even while it is hidden,
  /// as a screen share does.
  final bool persistWhenHidden;

  /// Called with the size this viewport draws the track at, in device pixels,
  /// and with [Size.zero] once it is off screen.
  ///
  /// Not called once this viewport is disposed, so the last size a listener
  /// was given stays whatever it was.
  final ValueSetter<Size>? onSizeChanged;

  /// Labels this viewport's visibility detector, for reading a widget tree
  /// (e.g. `pipVideo` against the main view).
  ///
  /// Each reporter keys its own detector, so this does not have to be unique
  /// and nothing depends on it.
  final String? scopePrefix;

  /// The widget drawing the track.
  final Widget child;

  @override
  State<ViewportVisibilityReporter> createState() =>
      _ViewportVisibilityReporterState();
}

class _ViewportVisibilityReporterState
    extends State<ViewportVisibilityReporter> {
  static int _detectorSeq = 0;

  /// This viewport's place in [ViewportVisibilityReporter.registry]. Replaced
  /// if the registry changes, since a handle belongs to the one that gave it
  /// out.
  late ViewportHandle _handle = widget.registry.attach();

  /// This reporter's own detector key.
  ///
  /// [VisibilityDetector] keys a process-wide map of what it last saw, so two
  /// sharing a key drop each other's reports — which two viewports drawing one
  /// track otherwise would. Held for this reporter's lifetime: a viewport
  /// pointed at a different track is the same viewport, measuring the same
  /// area, and says so itself rather than through a new detector.
  late final Key _detectorKey = Key(
    '${widget.scopePrefix ?? ''}viewport-${_detectorSeq++}-visibility',
  );

  VisibilityInfo? _latest;

  @override
  void didUpdateWidget(covariant ViewportVisibilityReporter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A handle belongs to the registry that gave it out, so a reporter moved
    // to another call retires the old one rather than leaving a track recorded
    // as on screen in a call it has left.
    final registryChanged = oldWidget.registry != widget.registry;
    if (registryChanged) {
      _disposeAfterFrame(_handle);
      _handle = widget.registry.attach();
    }

    final latest = _latest;
    if (latest == null) return;

    // Nothing this viewport measures has changed — the same area was being
    // given to a placeholder, or to another participant — and a detector
    // reports only what changes. So a registry that has never heard from this
    // viewport, a track it has only now been pointed at, and a track only now
    // published all need the standing measurement said again. Reporting for a
    // new track releases the one before it, which the handle does itself.
    final trackChanged = oldWidget.track != widget.track;
    final publishedNow = !oldWidget.isTrackPublished && widget.isTrackPublished;
    if (!registryChanged && !trackChanged && !publishedNow) return;

    // Deferred, because acting on a report writes call state, which the SDK's
    // emitter delivers synchronously: from the middle of this rebuild it would
    // ask a widget that has already been built this frame to build again, and
    // that throws. Nothing is waiting on the answer.
    final track = widget.track;
    final standing = !registryChanged && !trackChanged;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _report(_latest ?? latest);

      // A registry or a track it has not heard of has moved on the report
      // alone; one that has held the same answer throughout has to be asked
      // for it again.
      if (standing) widget.registry.reapply(track);
    });
  }

  @override
  void dispose() {
    _disposeAfterFrame(_handle);

    super.dispose();
  }

  /// Retires [handle] at the end of the frame, releasing whatever it measured.
  ///
  /// Deferred for the same reason a report is, and taking the handle by value:
  /// by the time it runs this [State] may be disposed, and the widget it would
  /// have read is gone.
  static void _disposeAfterFrame(ViewportHandle handle) {
    SchedulerBinding.instance.addPostFrameCallback((_) => handle.dispose());
  }

  void _report(VisibilityInfo info) {
    // A detector delivers one last, hidden report after it is gone. Taken, it
    // would put this viewport back into a registry that has already released
    // it, with nothing left alive to release it a second time.
    if (!mounted) return;

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

    _handle.report(
      widget.track,
      ViewportMeasurement(
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
      key: _detectorKey,
      onVisibilityChanged: _report,
      child: widget.child,
    );
  }
}
