import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';
import 'participant_fold_layout.dart';
import 'participants_navigation_button.dart';

/// Arranges every participant in a grid, a page at a time.
///
/// The arrangement follows the shape of the space the grid is given rather than
/// the width of the window: for each column count it could use, the grid works
/// out how large the video would render, and takes the best. A square count
/// stays square while the box is no wider than 2:1, so four people go two by
/// two on a phone and four in a row on a short wide window. A box more than
/// 1.5 times taller than wide scores its tiles as squares, so five people on
/// an upright phone go two by two by one rather than stacking.
///
/// See [solveParticipantGrid] for the rule, and
/// [StreamCallParticipantsGridThemeData.columnResolver] to override it.
///
/// On a half-open foldable the grid keeps its tiles off the fold: it centres
/// itself on the fold and shares each page between the two sides, as
/// [solveParticipantFoldSplit] decides. A participant alone in the call takes
/// the start side, with [foldPlaceholderBuilder] on the other. See
/// [StreamCallParticipantsGridThemeData.foldStyle] to tune it.
class CallParticipantsGridView extends StatefulWidget {
  const CallParticipantsGridView({
    super.key,
    required this.call,
    required this.participants,
    required this.itemBuilder,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.foldPlaceholderBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The widgets to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantBuilder itemBuilder;

  /// Space between the items in the main axis.
  ///
  /// Overrides [StreamCallParticipantsGridThemeData.mainAxisSpacing].
  final double? mainAxisSpacing;

  /// Space between the items in the cross axis.
  ///
  /// Overrides [StreamCallParticipantsGridThemeData.crossAxisSpacing].
  final double? crossAxisSpacing;

  /// Padding around the grid.
  ///
  /// Overrides [StreamCallParticipantsGridThemeData.padding].
  final EdgeInsetsGeometry? padding;

  /// Builds what fills the empty side of a fold while one participant is in
  /// the grid.
  ///
  /// Defaults to [StreamWaitingForParticipants].
  final WidgetBuilder? foldPlaceholderBuilder;

  @override
  State<CallParticipantsGridView> createState() =>
      _CallParticipantsGridViewState();
}

class _CallParticipantsGridViewState extends State<CallParticipantsGridView> {
  final _pageController = PageController();
  final _currentPage = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int page) => _pageController.animateToPage(
    page,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    final metrics = _GridMetrics.of(context, widget);
    final pages = widget.participants.slices(metrics.pageSize).toList();
    if (pages.isEmpty) return const SizedBox.shrink();

    // People leaving can take the page the grid is on with them. The physics
    // are fixed, so a stranded page would have no way back. Corrected after
    // the frame rather than during it, since this runs inside build.
    final lastPage = pages.length - 1;
    if (_currentPage.value > lastPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _currentPage.value = lastPage;
        if (_pageController.hasClients) _pageController.jumpToPage(lastPage);
      });
    }

    final isAlone = widget.participants.length == 1;

    return ValueListenableBuilder<int>(
      valueListenable: _currentPage,
      builder: (context, currentPage, child) => _PageNavigation(
        padding: metrics.padding,
        screenSize: metrics.screenSize,
        currentPage: currentPage.clamp(0, lastPage),
        lastPage: lastPage,
        onGoToPage: _goToPage,
        child: child!,
      ),
      child: StreamFoldBuilder(
        enabled: metrics.theme.foldStyle?.avoidFold ?? true,
        builder: (context, fold) => LayoutBuilder(
          builder: (context, constraints) => PageView.builder(
            itemCount: pages.length,
            controller: _pageController,
            // A page at a time rather than the platform's own physics, so a
            // drag, a wheel or a trackpad settles on a page boundary.
            physics: const PageScrollPhysics(),
            onPageChanged: (page) => _currentPage.value = page,
            itemBuilder: (context, index) {
              // Nothing until the fold has been measured, so each tile
              // appears once, at its final size.
              if (fold.pending) return const SizedBox.shrink();

              return _FoldPage(
                call: widget.call,
                participants: pages[index],
                itemBuilder: widget.itemBuilder,
                metrics: metrics,
                size: constraints.biggest,
                fold: fold.local,
                isAlone: isAlone,
                placeholderBuilder: widget.foldPlaceholderBuilder,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// The grid's measurements and rules: the widget's overrides, then the theme,
/// then the defaults.
class _GridMetrics {
  const _GridMetrics({
    required this.theme,
    required this.padding,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.maxTileAspectRatio,
    required this.screenSize,
    required this.pageSize,
    required this.minTileSize,
  });

  factory _GridMetrics.of(
    BuildContext context,
    CallParticipantsGridView widget,
  ) {
    final theme = StreamCallParticipantsGridTheme.of(context);
    final spacing = context.streamSpacing;
    final screenSize = context.streamScreenSize;

    return _GridMetrics(
      theme: theme,
      padding: (widget.padding ?? theme.padding ?? EdgeInsets.all(spacing.xs))
          .resolve(Directionality.maybeOf(context)),
      mainAxisSpacing:
          widget.mainAxisSpacing ?? theme.mainAxisSpacing ?? spacing.xs,
      crossAxisSpacing:
          widget.crossAxisSpacing ?? theme.crossAxisSpacing ?? spacing.xs,
      maxTileAspectRatio: theme.maxTileAspectRatio ?? 16 / 9,
      screenSize: screenSize,
      pageSize: switch (screenSize) {
        StreamScreenSize.small => theme.compactPageSize ?? 6,
        _ => theme.pageSize ?? 12,
      },
      // The smallest a tile next to a fold may be: the fold style's, or the
      // spotlight's bar tile.
      minTileSize:
          theme.foldStyle?.minTileSize ??
          StreamCallParticipantsSpotlightTheme.of(context).style?.barTileSize ??
          const Size(222, 125),
    );
  }

  final StreamCallParticipantsGridThemeData theme;
  final EdgeInsets padding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double maxTileAspectRatio;
  final StreamScreenSize screenSize;
  final int pageSize;
  final Size minTileSize;

  /// The gutter kept clear down the middle of a fold along [axis].
  double foldGap(Axis? axis) =>
      theme.foldStyle?.foldGap ??
      switch (axis) {
        Axis.vertical => mainAxisSpacing,
        _ => crossAxisSpacing,
      };

  StreamParticipantGridDetails details(
    Size box,
    int count, [
    StreamParticipantFoldDetails? fold,
  ]) => StreamParticipantGridDetails(
    box: box,
    count: count,
    mainAxisSpacing: mainAxisSpacing,
    crossAxisSpacing: crossAxisSpacing,
    maxTileAspectRatio: maxTileAspectRatio,
    screenSize: screenSize,
    fold: fold,
  );

  /// The arrangement for [details]: the theme's column count, or the solver's.
  StreamParticipantGridArrangement arrange(
    StreamParticipantGridDetails details,
  ) {
    final columns = theme.columnResolver?.call(details);
    return columns == null
        ? solveParticipantGrid(details)
        : arrangeParticipantGrid(details, columns);
  }

  /// How many of [count] participants go on the start side of [split].
  int startCount(FoldRegionsSplit split, int count) {
    final details = StreamParticipantFoldSplitDetails(
      count: count,
      startSize: split.start.size,
      endSize: split.end.size,
      posture: split.fold.posture,
      foldBounds: split.foldBounds,
      reportedExtent: split.fold.extent,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      maxTileAspectRatio: maxTileAspectRatio,
      minTileSize: minTileSize,
      maxExtraTilesOnSmallerSide: theme.maxExtraTilesOnSmallerSide ?? 2,
      screenSize: screenSize,
    );
    final resolved =
        theme.foldSplitResolver?.call(details) ??
        solveParticipantFoldSplit(details);
    return resolved.clamp(0, count);
  }
}

/// Pads the grid and, with more than one page, adds the back and forward
/// buttons.
///
/// A small window has no room to spare, so its buttons sit over the grid, a
/// gap inside its padding. Larger ones set the grid in between them instead,
/// each button a gap out from the grid and the padding in from the edge.
class _PageNavigation extends StatelessWidget {
  const _PageNavigation({
    required this.padding,
    required this.screenSize,
    required this.currentPage,
    required this.lastPage,
    required this.onGoToPage,
    required this.child,
  });

  final EdgeInsets padding;
  final StreamScreenSize screenSize;
  final int currentPage;
  final int lastPage;
  final ValueChanged<int> onGoToPage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (lastPage == 0) return Padding(padding: padding, child: child);

    final gap = context.streamSpacing.xs;
    // Insets are to the button's visual, less the tap inset.
    final tapInset = participantsNavigationButtonTapInset;

    final back = _button(context, isBack: true, visible: currentPage > 0);
    final forward = _button(
      context,
      isBack: false,
      visible: currentPage < lastPage,
    );

    if (screenSize == StreamScreenSize.small) {
      return Stack(
        children: [
          Padding(padding: padding, child: child),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                left: math.max(0, padding.left + gap - tapInset),
                right: math.max(0, padding.right + gap - tapInset),
              ),
              child: Center(
                child: Row(children: [back, const Spacer(), forward]),
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: math.max(0, padding.left - tapInset),
        right: math.max(0, padding.right - tapInset),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: math.max(0, gap - tapInset),
        children: [
          Center(widthFactor: 1, child: back),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: padding.top,
                bottom: padding.bottom,
              ),
              child: child,
            ),
          ),
          Center(widthFactor: 1, child: forward),
        ],
      ),
    );
  }

  /// A hidden button keeps its place, so the grid is the same size on every
  /// page.
  Widget _button(
    BuildContext context, {
    required bool isBack,
    required bool visible,
  }) {
    final icons = context.streamIcons;
    final translations = context.translations;

    // The chevrons mirror themselves under RTL.
    return ParticipantsNavigationButton(
      icon: isBack ? icons.chevronLeft : icons.chevronRight,
      tooltip: isBack
          ? translations.participantsPrevious
          : translations.participantsNext,
      visible: visible,
      onPressed: () => onGoToPage(isBack ? currentPage - 1 : currentPage + 1),
    );
  }
}

/// One page of the grid, kept off [fold]: in one region when there is no fold
/// to split across, shared between its two sides when there is.
class _FoldPage extends StatelessWidget {
  const _FoldPage({
    required this.call,
    required this.participants,
    required this.itemBuilder,
    required this.metrics,
    required this.size,
    required this.fold,
    required this.isAlone,
    required this.placeholderBuilder,
  });

  final Call call;
  final List<CallParticipantState> participants;
  final CallParticipantBuilder itemBuilder;
  final _GridMetrics metrics;
  final Size size;
  final StreamLocalFold? fold;
  final bool isAlone;
  final WidgetBuilder? placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    final regions = resolveFoldRegions(
      size: size,
      fold: fold,
      gap: metrics.foldGap(fold?.axis),
      minTileSize: metrics.minTileSize,
      centerOnFold: metrics.theme.foldStyle?.centerOnFold ?? true,
      textDirection: Directionality.of(context),
    );

    switch (regions) {
      case FoldRegionsSingle(:final rect):
        final grid = _GridPage(
          call: call,
          participants: participants,
          itemBuilder: itemBuilder,
          arrangement: metrics.arrange(
            metrics.details(rect.size, participants.length),
          ),
          mainAxisSpacing: metrics.mainAxisSpacing,
          crossAxisSpacing: metrics.crossAxisSpacing,
        );
        if (rect.size == size) return grid;
        return Stack(
          children: [Positioned.fromRect(rect: rect, child: grid)],
        );

      case final FoldRegionsSplit split:
        final startCount = metrics.startCount(split, participants.length);
        final start = participants.sublist(0, startCount);
        final end = participants.sublist(startCount);

        return Stack(
          children: [
            Positioned.fromRect(
              rect: split.start,
              child: _side(split, StreamFoldSide.start, start, end.length),
            ),
            Positioned.fromRect(
              rect: split.end,
              child: _side(split, StreamFoldSide.end, end, start.length),
            ),
          ],
        );
    }
  }

  Widget _side(
    FoldRegionsSplit split,
    StreamFoldSide side,
    List<CallParticipantState> participants,
    int otherCount,
  ) => _FoldSide(
    call: call,
    participants: participants,
    itemBuilder: itemBuilder,
    metrics: metrics,
    size: (side == StreamFoldSide.start ? split.start : split.end).size,
    foldDetails: split.details(side, otherCount),
    showPlaceholder: isAlone,
    placeholderBuilder: placeholderBuilder,
  );
}

/// One side of a fold: its share of the page, or, for somebody alone in the
/// call, a placeholder rather than half the screen left blank.
class _FoldSide extends StatelessWidget {
  const _FoldSide({
    required this.call,
    required this.participants,
    required this.itemBuilder,
    required this.metrics,
    required this.size,
    required this.foldDetails,
    required this.showPlaceholder,
    required this.placeholderBuilder,
  });

  final Call call;
  final List<CallParticipantState> participants;
  final CallParticipantBuilder itemBuilder;
  final _GridMetrics metrics;
  final Size size;
  final StreamParticipantFoldDetails foldDetails;
  final bool showPlaceholder;
  final WidgetBuilder? placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    if (participants.isNotEmpty) {
      return _GridPage(
        call: call,
        participants: participants,
        itemBuilder: itemBuilder,
        arrangement: metrics.arrange(
          metrics.details(size, participants.length, foldDetails),
        ),
        mainAxisSpacing: metrics.mainAxisSpacing,
        crossAxisSpacing: metrics.crossAxisSpacing,
      );
    }

    if (!showPlaceholder) return const SizedBox.shrink();

    // Shaped like the tile it stands in for.
    final tile = solveParticipantGrid(metrics.details(size, 1)).tileSize;
    return Center(
      child: SizedBox.fromSize(
        size: tile,
        child:
            placeholderBuilder?.call(context) ??
            const StreamWaitingForParticipants(),
      ),
    );
  }
}

/// One page of tiles, laid out to [arrangement].
///
/// Rows are packed and the block is centred on both axes, so a short last row
/// sits under the middle of the one above it.
class _GridPage extends StatelessWidget {
  const _GridPage({
    required this.call,
    required this.participants,
    required this.itemBuilder,
    required this.arrangement,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  });

  final Call call;
  final List<CallParticipantState> participants;
  final CallParticipantBuilder itemBuilder;
  final StreamParticipantGridArrangement arrangement;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  @override
  Widget build(BuildContext context) {
    final rows = participants.slices(arrangement.columns).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: mainAxisSpacing,
      children: [
        for (final row in rows)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: crossAxisSpacing,
            children: [
              for (final participant in row)
                SizedBox.fromSize(
                  key: ValueKey(participant.uniqueParticipantKey),
                  size: arrangement.tileSize,
                  child: itemBuilder(context, call, participant),
                ),
            ],
          ),
      ],
    );
  }
}
