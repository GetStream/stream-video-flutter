import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Defines the alignment of the participants bar.
enum ParticipantsBarAlignment { top, bottom, left, right }

/// Arranges a call around one participant: they hold the stage, and everybody
/// else runs in a bar along the edge opposite them.
///
/// The bar takes the edge it is aligned to and the stage fills everything
/// else, at every size. The one thing that holds it back is
/// [StreamCallParticipantsSpotlightStyle.maxSpotlightAspectRatio]: a view wider
/// than that leaves room to either side of the stage rather than stretching it.
///
/// The bar's tiles have a size of their own rather than a share of the view,
/// scaled down only where they would otherwise take more than a third of it.
/// They are centred while they fit, and once they do not the bar runs to the
/// edge of the view and scrolls.
class CallParticipantsSpotlightView extends StatelessWidget {
  const CallParticipantsSpotlightView({
    super.key,
    required this.call,
    required this.spotlight,
    CallParticipantBuilder? spotlightBuilder,
    required this.participants,
    required this.participantBuilder,
    this.padding,
    this.spacing,
    this.barAlignment = ParticipantsBarAlignment.bottom,
  }) : spotlightBuilder = spotlightBuilder ?? participantBuilder;

  /// Represents a call.
  final Call call;

  /// The participant to be spotlighted.
  final CallParticipantState spotlight;

  /// Builder function used to build the spotlight.
  ///
  /// If not provided, the [participantBuilder] will be used.
  final CallParticipantBuilder spotlightBuilder;

  /// The list of other participants to display.
  final Iterable<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantBuilder participantBuilder;

  /// Padding around the spotlight and participants bar.
  ///
  /// Overrides [StreamCallParticipantsSpotlightStyle.padding].
  final EdgeInsetsGeometry? padding;

  /// The gap between the spotlight and the bar, and between the bar's tiles.
  ///
  /// Overrides [StreamCallParticipantsSpotlightStyle.spacing].
  final double? spacing;

  /// The alignment of the participants bar.
  final ParticipantsBarAlignment barAlignment;

  /// The most of the view the bar may take.
  ///
  /// Its tiles have a size of their own rather than a share of the view, so a
  /// window short enough would otherwise leave the stage nothing. Past this
  /// the tiles scale down with the view instead.
  static const _maxBarFraction = 1 / 3;

  @override
  Widget build(BuildContext context) {
    final style = _StreamCallParticipantsSpotlightStyleDefaults(
      context,
      StreamCallParticipantsSpotlightTheme.of(context).style,
    );

    final padding = (this.padding ?? style.padding).resolve(
      Directionality.maybeOf(context),
    );
    final spacing = this.spacing ?? style.spacing;
    final isHorizontal = barAlignment.toAxis() == Axis.horizontal;

    // The bar runs to the edge of the view along the axis it scrolls on, and
    // carries the padding of that axis inside its list instead: a tile leaving
    // the view should slide off the edge rather than stop short of it. Only
    // the other axis insets the bar from outside.
    final outer = isHorizontal
        ? EdgeInsets.only(top: padding.top, bottom: padding.bottom)
        : EdgeInsets.only(left: padding.left, right: padding.right);
    final stagePadding = isHorizontal
        ? EdgeInsets.only(left: padding.left, right: padding.right)
        : EdgeInsets.only(top: padding.top, bottom: padding.bottom);

    return Padding(
      padding: outer,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stage = Expanded(
            child: Padding(
              padding: stagePadding,
              child: _buildSpotlight(context, style.maxSpotlightAspectRatio),
            ),
          );

          if (participants.isEmpty) {
            // A flex of one, so the stage is measured the same way whether or
            // not anybody is in the bar.
            return isHorizontal
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [stage],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [stage],
                  );
          }

          final tileSize = _resolveBarTileSize(
            style.barTileSize,
            constraints,
            isHorizontal: isHorizontal,
          );

          final children = <Widget>[
            stage,
            SizedBox.square(dimension: spacing),
            _buildParticipantsBar(
              context,
              tileSize: tileSize,
              spacing: spacing,
              padding: padding,
              constraints: constraints,
              isHorizontal: isHorizontal,
            ),
          ];

          final ordered = barAlignment.barComesFirst
              ? children.reversed.toList()
              : children;

          return isHorizontal
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: ordered,
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: ordered,
                );
        },
      ),
    );
  }

  Widget _buildSpotlight(BuildContext context, double maxAspectRatio) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        // Fills the room the bar leaves, except that it never gets wider than
        // the ratio allows — a view wider than that keeps the stage centred in
        // it rather than stretching it.
        final width = math.min(constraints.maxWidth, height * maxAspectRatio);

        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: spotlightBuilder.call(context, call, spotlight),
          ),
        );
      },
    );
  }

  Widget _buildParticipantsBar(
    BuildContext context, {
    required Size tileSize,
    required double spacing,
    required EdgeInsets padding,
    required BoxConstraints constraints,
    required bool isHorizontal,
  }) {
    final tileExtent = isHorizontal ? tileSize.width : tileSize.height;
    final viewport = isHorizontal
        ? constraints.maxWidth
        : constraints.maxHeight;

    final tiles = participants.toList(growable: false);
    final content = tiles.length * tileExtent + (tiles.length - 1) * spacing;

    // Centred on the whole view while the tiles fit. Once they do not, the
    // list falls back to the padding and the rest runs off both edges.
    final slack = viewport.isFinite ? (viewport - content) / 2 : 0.0;
    final (start, end) = isHorizontal
        ? (padding.left, padding.right)
        : (padding.top, padding.bottom);

    return SizedBox(
      width: isHorizontal ? constraints.maxWidth : tileSize.width,
      height: isHorizontal ? tileSize.height : constraints.maxHeight,
      child: ListView.separated(
        padding: isHorizontal
            ? EdgeInsets.only(
                left: math.max(start, slack),
                right: math.max(end, slack),
              )
            : EdgeInsets.only(
                top: math.max(start, slack),
                bottom: math.max(end, slack),
              ),
        itemCount: tiles.length,
        scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
        separatorBuilder: (context, index) =>
            SizedBox.square(dimension: spacing),
        itemBuilder: (context, index) {
          final participant = tiles[index];
          return SizedBox.fromSize(
            size: tileSize,
            child: participantBuilder.call(context, call, participant),
          );
        },
      ),
    );
  }

  /// [tileSize], scaled down where it would leave the stage too little room.
  Size _resolveBarTileSize(
    Size tileSize,
    BoxConstraints constraints, {
    required bool isHorizontal,
  }) {
    final available = isHorizontal
        ? constraints.maxHeight
        : constraints.maxWidth;
    final extent = isHorizontal ? tileSize.height : tileSize.width;
    assert(
      extent > 0,
      'A bar tile of zero or less hides every participant in the bar.',
    );
    if (!available.isFinite || extent <= 0) return tileSize;

    final maxExtent = available * _maxBarFraction;
    if (extent <= maxExtent) return tileSize;

    return tileSize * (maxExtent / extent);
  }
}

extension on ParticipantsBarAlignment {
  Axis toAxis() {
    switch (this) {
      case ParticipantsBarAlignment.top:
      case ParticipantsBarAlignment.bottom:
        return Axis.horizontal;
      case ParticipantsBarAlignment.left:
      case ParticipantsBarAlignment.right:
        return Axis.vertical;
    }
  }

  /// Whether the bar is drawn before the spotlight along the layout's axis.
  bool get barComesFirst =>
      this == ParticipantsBarAlignment.top ||
      this == ParticipantsBarAlignment.left;
}

/// Default style values for [CallParticipantsSpotlightView].
class _StreamCallParticipantsSpotlightStyleDefaults
    extends StreamCallParticipantsSpotlightStyle {
  _StreamCallParticipantsSpotlightStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final StreamCallParticipantsSpotlightStyle? _style;

  late final _spacing = _context.streamSpacing;

  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ?? EdgeInsets.symmetric(horizontal: _spacing.xs);

  @override
  double get spacing => _style?.spacing ?? _spacing.xs;

  @override
  double get maxSpotlightAspectRatio =>
      _style?.maxSpotlightAspectRatio ?? 16 / 9;

  @override
  Size get barTileSize => _style?.barTileSize ?? const Size(222, 125);
}
