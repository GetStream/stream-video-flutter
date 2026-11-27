import 'dart:math' as math;
import 'dart:ui' show DisplayFeatureState;

import 'package:flutter/widgets.dart';

/// How a half-open foldable is held, from the way its fold runs.
enum StreamFoldPosture {
  /// The fold runs top to bottom and splits the window into a leading and a
  /// trailing half.
  book,

  /// The fold runs across and splits the window into a top and a bottom half.
  tabletop;

  /// The axis the two halves are laid out along: horizontal for [book],
  /// vertical for [tabletop].
  Axis get axis => switch (this) {
    book => Axis.horizontal,
    tabletop => Axis.vertical,
  };
}

/// A fold or hinge that splits the window in two.
///
/// Counts what [DisplayFeatureSubScreen] avoids: a feature with an area, or a
/// fold that is half open. A flat fold has no area and is ignored, and so is a
/// cutout, which never runs the full length of the window.
@immutable
class StreamDisplayFold {
  /// Creates a fold at [bounds], in window coordinates.
  const StreamDisplayFold({required this.bounds, required this.posture});

  /// The fold in window coordinates, as the platform reports it.
  ///
  /// Zero wide for a fold in a flexible screen, wider for a hinge between two
  /// screens.
  final Rect bounds;

  /// Whether the fold runs top to bottom or across.
  final StreamFoldPosture posture;

  /// The axis the two halves are laid out along.
  Axis get axis => posture.axis;

  /// The fold's reported width across [axis].
  double get extent => switch (axis) {
    Axis.horizontal => bounds.width,
    Axis.vertical => bounds.height,
  };

  /// The fold's start and end along [axis], in window coordinates.
  (double, double) get span => switch (axis) {
    Axis.horizontal => (bounds.left, bounds.right),
    Axis.vertical => (bounds.top, bounds.bottom),
  };

  /// The fold that splits the window of [context], or null when there is
  /// none.
  ///
  /// When [posture] is given, only a fold in that posture is returned.
  static StreamDisplayFold? maybeOf(
    BuildContext context, {
    StreamFoldPosture? posture,
  }) {
    final size = MediaQuery.sizeOf(context);

    for (final feature in MediaQuery.displayFeaturesOf(context)) {
      final bounds = feature.bounds;
      final avoided =
          bounds.shortestSide > 0 ||
          feature.state == DisplayFeatureState.postureHalfOpened;
      if (!avoided) continue;

      final book =
          bounds.top <= 0 &&
          bounds.bottom >= size.height &&
          bounds.left > 0 &&
          bounds.right < size.width;
      final tabletop =
          bounds.left <= 0 &&
          bounds.right >= size.width &&
          bounds.top > 0 &&
          bounds.bottom < size.height;

      final found = book
          ? StreamFoldPosture.book
          : tabletop
          ? StreamFoldPosture.tabletop
          : null;
      if (found == null || (posture != null && posture != found)) continue;

      return StreamDisplayFold(bounds: bounds, posture: found);
    }

    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamDisplayFold &&
          other.bounds == bounds &&
          other.posture == posture;

  @override
  int get hashCode => Object.hash(bounds, posture);

  @override
  String toString() => 'StreamDisplayFold(${posture.name}, $bounds)';
}

/// A [StreamDisplayFold] measured against a box: where it crosses the box, in
/// the box's own coordinates.
@immutable
class StreamLocalFold {
  /// Creates a fold crossing a box of [size] from [start] to [end] along the
  /// posture's axis.
  const StreamLocalFold({
    required this.fold,
    required this.size,
    required this.start,
    required this.end,
  });

  /// The fold in window coordinates.
  final StreamDisplayFold fold;

  /// The size of the box the fold was measured against.
  final Size size;

  /// Where the fold starts along [axis], from the box's left or top edge.
  final double start;

  /// Where the fold ends along [axis], from the box's left or top edge.
  final double end;

  /// The axis the two sides of the box are laid out along.
  Axis get axis => fold.axis;

  /// Whether the fold runs top to bottom or across.
  StreamFoldPosture get posture => fold.posture;

  /// The fold's reported width.
  double get extent => end - start;

  /// The box's length along [axis].
  double get length => switch (axis) {
    Axis.horizontal => size.width,
    Axis.vertical => size.height,
  };

  /// The middle of the fold along [axis].
  double get center => (start + end) / 2;

  /// The room the two sides keep clear around the fold: its reported width,
  /// or [gap] when that is wider, centred on the fold.
  ///
  /// Returns where the first side ends and the second starts, from the box's
  /// left or top edge.
  (double, double) clearance(double gap) {
    final half = math.max(extent, gap) / 2;
    return (center - half, center + half);
  }

  /// A gutter of [gap] centred on the middle of the fold, ignoring its
  /// reported width.
  ///
  /// For surfaces with room inside their own edges, such as video tiles, which
  /// may run into a hinge. Interactive content keeps to [clearance] instead.
  ///
  /// Returns where the first side ends and the second starts, from the box's
  /// left or top edge.
  (double, double) gutter(double gap) => (center - gap / 2, center + gap / 2);

  /// The fold measured against this box less [padding], or null when it no
  /// longer crosses what is left.
  StreamLocalFold? inset(EdgeInsets padding) {
    final inner = padding.deflateSize(size);
    final offset = switch (axis) {
      Axis.horizontal => padding.left,
      Axis.vertical => padding.top,
    };
    final innerLength = switch (axis) {
      Axis.horizontal => inner.width,
      Axis.vertical => inner.height,
    };
    final innerStart = start - offset;
    final innerEnd = end - offset;
    if (innerStart <= 0 || innerEnd >= innerLength) return null;

    return StreamLocalFold(
      fold: fold,
      size: inner,
      start: innerStart,
      end: innerEnd,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamLocalFold &&
          other.fold == fold &&
          other.size == size &&
          other.start == start &&
          other.end == end;

  @override
  int get hashCode => Object.hash(fold, size, start, end);

  @override
  String toString() =>
      'StreamLocalFold(${posture.name}, $start..$end of $length)';
}

/// Builds its child with the fold of the window as it crosses this box.
typedef StreamFoldWidgetBuilder =
    Widget Function(
      BuildContext context,
      StreamFoldMeasurement measurement,
    );

/// What a [StreamFoldBuilder] knows about the fold.
@immutable
class StreamFoldMeasurement {
  /// Creates a measurement.
  const StreamFoldMeasurement({
    required this.window,
    required this.local,
    this.pending = false,
  });

  /// The fold of the window, or null when it has none.
  final StreamDisplayFold? window;

  /// The fold where it crosses the box, or null when it does not cross it or
  /// has not been measured yet.
  ///
  /// A fold on the box's edge, or outside it, does not cross it.
  final StreamLocalFold? local;

  /// Whether the box still has to be measured before [local] can be trusted:
  /// the window has a fold, and this is the first frame.
  final bool pending;
}

/// Measures where the fold of the window crosses this box and builds [builder]
/// with it.
///
/// The fold is in window coordinates, so after each frame this measures where
/// the box sits in the window and builds again when it has moved. Between
/// measurements the fold is worked out from the last position and the box's
/// current size, so a box that only changes size, such as one a side panel
/// shrinks, follows it in the same frame. Until the first measurement
/// [StreamFoldMeasurement.pending] is true.
class StreamFoldBuilder extends StatefulWidget {
  /// Creates a widget that builds with the fold crossing it.
  const StreamFoldBuilder({
    super.key,
    required this.builder,
    this.posture,
    this.enabled = true,
  });

  /// Builds the child with the fold as measured.
  final StreamFoldWidgetBuilder builder;

  /// When given, only a fold in this posture is measured.
  final StreamFoldPosture? posture;

  /// False builds as if the window had no fold.
  final bool enabled;

  @override
  State<StreamFoldBuilder> createState() => _StreamFoldBuilderState();
}

class _StreamFoldBuilderState extends State<StreamFoldBuilder> {
  /// Where the box sat in the window at the last measurement.
  Offset? _origin;

  /// The transitions of the route this box is on. A route sliding in or out
  /// moves the box without laying it out again, so each one ending is a cue
  /// to measure.
  final _transitions = <Animation<double>>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _unlistenTransitions();
    final route = ModalRoute.of(context);
    for (final animation in [?route?.animation, ?route?.secondaryAnimation]) {
      animation.addStatusListener(_onTransitionStatus);
      _transitions.add(animation);
    }
  }

  @override
  void dispose() {
    _unlistenTransitions();
    super.dispose();
  }

  void _unlistenTransitions() {
    for (final animation in _transitions) {
      animation.removeStatusListener(_onTransitionStatus);
    }
    _transitions.clear();
  }

  void _onTransitionStatus(AnimationStatus status) {
    if (status.isAnimating) return;
    WidgetsBinding.instance.addPostFrameCallback(_measure);
  }

  /// The box's size at the last measurement, for an axis it is not
  /// constrained on.
  Size? _measuredSize;

  void _measure(Duration _) {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.attached) return;
    // While the route slides, the box is somewhere it will not stay. The
    // last measurement holds until the transition ends, when it is taken
    // again.
    if (_origin != null && _transitions.any((t) => t.isAnimating)) return;

    final origin = box.localToGlobal(Offset.zero);
    if (origin != _origin || box.size != _measuredSize) {
      setState(() {
        _origin = origin;
        _measuredSize = box.size;
      });
    }
  }

  /// [fold] against a box of [size] at [origin], or null when it does not
  /// cross the box.
  static StreamLocalFold? _localFold(
    StreamDisplayFold fold,
    Offset origin,
    Size size,
  ) {
    final (foldStart, foldEnd) = fold.span;
    final (offset, length) = switch (fold.axis) {
      Axis.horizontal => (origin.dx, size.width),
      Axis.vertical => (origin.dy, size.height),
    };
    final start = foldStart - offset;
    final end = foldEnd - offset;
    if (start <= 0 || end >= length) return null;

    return StreamLocalFold(fold: fold, size: size, start: start, end: end);
  }

  @override
  Widget build(BuildContext context) {
    final fold = widget.enabled
        ? StreamDisplayFold.maybeOf(context, posture: widget.posture)
        : null;

    if (fold == null) {
      _origin = null;
      _measuredSize = null;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // A layout builder whether or not there is a fold, so the child keeps
        // its state when one appears.
        if (fold == null) {
          return widget.builder(
            context,
            const StreamFoldMeasurement(window: null, local: null),
          );
        }

        // Every layout, so a move or a resize is picked up after the frame.
        WidgetsBinding.instance.addPostFrameCallback(_measure);

        final origin = _origin;
        final measured = _measuredSize;
        StreamLocalFold? local;
        if (origin != null && measured != null) {
          final size = Size(
            constraints.hasBoundedWidth ? constraints.maxWidth : measured.width,
            constraints.hasBoundedHeight
                ? constraints.maxHeight
                : measured.height,
          );
          local = _localFold(fold, origin, size);
        }

        return widget.builder(
          context,
          StreamFoldMeasurement(
            window: fold,
            local: local,
            pending: origin == null,
          ),
        );
      },
    );
  }
}

/// Lays [start] and [end] out on either side of the window's fold, kept clear
/// of it by its reported width or [gap], whichever is wider, centred on it.
///
/// Splits a row at a book fold, or a column at a tabletop fold, as [posture]
/// says. Until the first measurement, and when the fold is not inside the box,
/// the two share the length evenly with [gap] between them.
class SplitAtFold extends StatelessWidget {
  /// Creates a box split at the fold of the window.
  const SplitAtFold({
    super.key,
    required this.gap,
    required this.start,
    required this.end,
    this.posture = StreamFoldPosture.book,
  });

  /// The least room between the two sides.
  final double gap;

  /// The side before the fold: leading in the book posture, top in tabletop.
  final Widget start;

  /// The side after the fold: trailing in the book posture, bottom in
  /// tabletop.
  final Widget end;

  /// Which fold to split at.
  final StreamFoldPosture posture;

  @override
  Widget build(BuildContext context) {
    final axis = posture.axis;
    final rtl =
        axis == Axis.horizontal &&
        Directionality.of(context) == TextDirection.rtl;
    final first = rtl ? end : start;
    final second = rtl ? start : end;

    return StreamFoldBuilder(
      posture: posture,
      // One tree whether or not the fold has been measured, so the children
      // keep their state when it is.
      builder: (context, measurement) => LayoutBuilder(
        builder: (context, constraints) {
          final length = switch (axis) {
            Axis.horizontal => constraints.maxWidth,
            Axis.vertical => constraints.maxHeight,
          };
          // With no length to split, such as in a scroll view, the two are
          // stacked with the gap between them.
          if (!length.isFinite) {
            return Flex(
              direction: axis,
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.ltr,
              children: [first, _extent(axis, gap, null), second],
            );
          }
          final (firstLength, between) = _firstAndBetween(
            length,
            gap,
            measurement.local,
          );

          return Flex(
            direction: axis,
            textDirection: TextDirection.ltr,
            children: [
              _extent(axis, firstLength, first),
              _extent(axis, between, null),
              Expanded(child: second),
            ],
          );
        },
      ),
    );
  }

  /// How long the first side is, and the room between the two, splitting
  /// [length] at [fold]; split evenly when there is no fold inside it.
  static (double, double) _firstAndBetween(
    double length,
    double gap,
    StreamLocalFold? fold,
  ) {
    final even = math.max(0, (length - gap) / 2).toDouble();
    final (firstEnd, secondStart) = fold?.clearance(gap) ?? (even, even + gap);
    if (firstEnd <= 0 || secondStart >= length) return (even, gap);
    return (firstEnd, secondStart - firstEnd);
  }

  static Widget _extent(Axis axis, double length, Widget? child) =>
      switch (axis) {
        Axis.horizontal => SizedBox(width: length, child: child),
        Axis.vertical => SizedBox(height: length, child: child),
      };
}

/// The anchor point that puts a modal with no source of its own in the
/// trailing half of a folded window: the top-right corner, or the top-left in
/// a right-to-left locale.
///
/// Without one, a route falls back to the leading half.
Offset trailingTopAnchorOf(BuildContext context) =>
    switch (Directionality.of(context)) {
      TextDirection.ltr => const Offset(double.maxFinite, 0),
      TextDirection.rtl => Offset.zero,
    };
