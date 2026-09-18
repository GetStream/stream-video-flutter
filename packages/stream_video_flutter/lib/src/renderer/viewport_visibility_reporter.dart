import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../stream_video_flutter.dart';

/// Measures how much of [child] is on screen and at what size, and reports it
/// to a [ViewportVisibilityRegistry] as one viewport's view of [track].
///
/// Only ever about itself; what the participant's visibility and subscription
/// become is the registry's to decide across every viewport drawing them. Wrap
/// a widget drawing a participant's track in one of these and it takes part in
/// that; draw one without and the call cannot tell the track is on screen.
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

  /// Whether [track] is published. When it turns true this viewport's standing
  /// measurement is reported again, so the new track is subscribed at the size
  /// already on screen.
  final bool isTrackPublished;

  /// Whether this viewport wants the track subscribed even while it is hidden,
  /// as a screen share does.
  final bool persistWhenHidden;

  /// Called with the size this viewport draws the track at, in device pixels,
  /// and with [Size.zero] once it is off screen. Not called on dispose.
  final ValueSetter<Size>? onSizeChanged;

  /// Labels this viewport's visibility detector, for reading a widget tree
  /// (e.g. `pipVideo` against the main view). Each reporter keys its own
  /// detector, so nothing depends on this.
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

  /// This viewport's place in the registry, replaced if the registry changes:
  /// a handle belongs to the one that gave it out.
  late ViewportHandle _handle = widget.registry.attach();

  /// This reporter's own detector key.
  ///
  /// [VisibilityDetector] keys a process-wide map, so two sharing a key drop
  /// each other's reports — which two viewports drawing one track otherwise
  /// would. Held for this reporter's lifetime: pointed at a different track it
  /// is still the same viewport, and reports for it itself.
  late final Key _detectorKey = Key(
    '${widget.scopePrefix ?? ''}viewport-${_detectorSeq++}-visibility',
  );

  VisibilityInfo? _latest;

  @override
  void didUpdateWidget(covariant ViewportVisibilityReporter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A handle belongs to the registry that gave it out, so one moved to
    // another call retires it rather than leaving a track recorded as on
    // screen in a call it has left.
    final registryChanged = oldWidget.registry != widget.registry;
    if (registryChanged) {
      _disposeAfterFrame(_handle);
      _handle = widget.registry.attach();
    }

    final latest = _latest;
    if (latest == null) return;

    // A detector reports only what changes, and nothing here measures
    // differently — the same area was being given to a placeholder, or to
    // another participant. So a new registry, a new track, and a track only
    // now published each need the standing measurement said again.
    final trackChanged = oldWidget.track != widget.track;
    final publishedNow = !oldWidget.isTrackPublished && widget.isTrackPublished;
    if (!registryChanged && !trackChanged && !publishedNow) return;

    // Deferred: acting on a report writes call state, which the SDK's emitter
    // delivers synchronously, and from this rebuild that would ask a widget
    // already built this frame to build again, which throws.
    final track = widget.track;
    final standing = !registryChanged && !trackChanged;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _report(_latest ?? latest);

      // A registry or track it has not heard of moves on the report alone;
      // one holding the same answer throughout has to be asked again.
      if (standing) widget.registry.reapply(track);
    });
  }

  @override
  void dispose() {
    _disposeAfterFrame(_handle);

    super.dispose();
  }

  /// Retires [handle] at the end of the frame, deferred for the same reason a
  /// report is. Takes the handle by value: by then this [State] may be gone.
  static void _disposeAfterFrame(ViewportHandle handle) {
    SchedulerBinding.instance.addPostFrameCallback((_) => handle.dispose());
  }

  void _report(VisibilityInfo info) {
    // A detector delivers one last, hidden report after it is gone. Taken, it
    // would put this viewport back with nothing left alive to release it.
    if (!mounted) return;

    _latest = info;

    final visibility = ViewportVisibility.fromVisibleFraction(
      info.visibleFraction,
    );

    var size = Size.zero;
    if (visibility.isVisible) {
      // VisibilityDetector measures in logical pixels; a track is subscribed
      // in device pixels.
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
