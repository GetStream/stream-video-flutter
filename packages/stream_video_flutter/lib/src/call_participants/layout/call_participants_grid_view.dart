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
    final theme = StreamCallParticipantsGridTheme.of(context);
    final spacing = context.streamSpacing;
    final screenSize = context.streamScreenSize;

    final padding =
        (widget.padding ?? theme.padding ?? EdgeInsets.all(spacing.xs)).resolve(
          Directionality.maybeOf(context),
        );
    final mainAxisSpacing =
        widget.mainAxisSpacing ?? theme.mainAxisSpacing ?? spacing.xs;
    final crossAxisSpacing =
        widget.crossAxisSpacing ?? theme.crossAxisSpacing ?? spacing.xs;
    final maxTileAspectRatio = theme.maxTileAspectRatio ?? 16 / 9;

    final pageSize = switch (screenSize) {
      StreamScreenSize.small => theme.compactPageSize ?? 6,
      _ => theme.pageSize ?? 12,
    };

    final pages = widget.participants.slices(pageSize).toList();
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

    return ValueListenableBuilder<int>(
      valueListenable: _currentPage,
      builder: (context, value, child) {
        final content = child!;
        final grid = Padding(padding: padding, child: content);
        if (pages.length <= 1) return grid;

        final currentPage = value.clamp(0, lastPage);
        final icons = context.streamIcons;
        final translations = context.translations;
        final isRtl = Directionality.of(context) == TextDirection.rtl;

        // A hidden button keeps its place, so the grid is the same size on
        // every page.
        Widget button({required bool isBack, required bool visible}) {
          final pointsLeft = isBack != isRtl;

          return ParticipantsNavigationButton(
            icon: pointsLeft ? icons.chevronLeft : icons.chevronRight,
            tooltip: isBack
                ? translations.participantsPrevious
                : translations.participantsNext,
            visible: visible,
            onPressed: () =>
                _goToPage(isBack ? currentPage - 1 : currentPage + 1),
          );
        }

        final back = button(isBack: true, visible: currentPage > 0);
        final forward = button(
          isBack: false,
          visible: currentPage < lastPage,
        );

        // Insets are to the button's visual, less the tap inset.
        final tapInset = participantsNavigationButtonTapInset;

        // A small window has no room to spare, so its buttons sit over the
        // grid, a gap inside its padding. Larger ones set the grid in between
        // them instead, each button a gap out from the grid and the padding
        // in from the edge.
        if (screenSize == StreamScreenSize.small) {
          return Stack(
            children: [
              grid,
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: math.max(0, padding.left + spacing.xs - tapInset),
                    right: math.max(0, padding.right + spacing.xs - tapInset),
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
            spacing: math.max(0, spacing.xs - tapInset),
            children: [
              Center(widthFactor: 1, child: back),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: padding.top,
                    bottom: padding.bottom,
                  ),
                  child: content,
                ),
              ),
              Center(widthFactor: 1, child: forward),
            ],
          ),
        );
      },
      child: StreamFoldBuilder(
        enabled: theme.foldStyle?.avoidFold ?? true,
        builder: (context, fold) => LayoutBuilder(
          builder: (context, constraints) {
            return PageView.builder(
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

                final page = pages[index];
                final regions = resolveFoldRegions(
                  size: constraints.biggest,
                  fold: fold.local,
                  gap:
                      theme.foldStyle?.foldGap ??
                      switch (fold.local?.axis) {
                        Axis.vertical => mainAxisSpacing,
                        _ => crossAxisSpacing,
                      },
                  minTileSize: _minTileSize(context, theme),
                  centerOnFold: theme.foldStyle?.centerOnFold ?? true,
                  textDirection: Directionality.of(context),
                );

                StreamParticipantGridArrangement arrange(
                  StreamParticipantGridDetails details,
                ) {
                  final columns = theme.columnResolver?.call(details);
                  return columns == null
                      ? solveParticipantGrid(details)
                      : arrangeParticipantGrid(details, columns);
                }

                Widget side(
                  List<CallParticipantState> participants,
                  StreamParticipantGridDetails details,
                ) => _GridPage(
                  call: widget.call,
                  participants: participants,
                  itemBuilder: widget.itemBuilder,
                  arrangement: arrange(details),
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing,
                );

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

                switch (regions) {
                  case FoldRegionsSingle(:final rect):
                    final grid = side(page, details(rect.size, page.length));
                    if (rect.size == constraints.biggest) return grid;
                    return Stack(
                      children: [Positioned.fromRect(rect: rect, child: grid)],
                    );

                  case final FoldRegionsSplit split:
                    final splitDetails = StreamParticipantFoldSplitDetails(
                      count: page.length,
                      startSize: split.start.size,
                      endSize: split.end.size,
                      posture: split.fold.posture,
                      foldBounds: split.foldBounds,
                      reportedExtent: split.fold.extent,
                      mainAxisSpacing: mainAxisSpacing,
                      crossAxisSpacing: crossAxisSpacing,
                      maxTileAspectRatio: maxTileAspectRatio,
                      minTileSize: _minTileSize(context, theme),
                      maxExtraTilesOnSmallerSide:
                          theme.maxExtraTilesOnSmallerSide ?? 2,
                      screenSize: screenSize,
                    );
                    final startCount =
                        (theme.foldSplitResolver?.call(splitDetails) ??
                                solveParticipantFoldSplit(splitDetails))
                            .clamp(0, page.length);
                    final start = page.sublist(0, startCount);
                    final end = page.sublist(startCount);

                    Widget sideOrPlaceholder(
                      StreamFoldSide which,
                      List<CallParticipantState> participants,
                      int otherCount,
                    ) {
                      final rect = which == StreamFoldSide.start
                          ? split.start
                          : split.end;
                      if (participants.isNotEmpty) {
                        return side(
                          participants,
                          details(
                            rect.size,
                            participants.length,
                            split.details(which, otherCount),
                          ),
                        );
                      }
                      // Somebody alone in the call gets a placeholder on the
                      // other side, rather than half the screen left blank.
                      if (widget.participants.length != 1) {
                        return const SizedBox.shrink();
                      }
                      // Shaped like the tile it stands in for.
                      final tile = solveParticipantGrid(
                        details(rect.size, 1),
                      ).tileSize;
                      return Center(
                        child: SizedBox.fromSize(
                          size: tile,
                          child:
                              widget.foldPlaceholderBuilder?.call(context) ??
                              const StreamWaitingForParticipants(),
                        ),
                      );
                    }

                    return Stack(
                      children: [
                        Positioned.fromRect(
                          rect: split.start,
                          child: sideOrPlaceholder(
                            StreamFoldSide.start,
                            start,
                            end.length,
                          ),
                        ),
                        Positioned.fromRect(
                          rect: split.end,
                          child: sideOrPlaceholder(
                            StreamFoldSide.end,
                            end,
                            start.length,
                          ),
                        ),
                      ],
                    );
                }
              },
            );
          },
        ),
      ),
    );
  }

  /// The smallest a tile next to a fold may be: the fold style's, or the
  /// spotlight's bar tile.
  static Size _minTileSize(
    BuildContext context,
    StreamCallParticipantsGridThemeData theme,
  ) =>
      theme.foldStyle?.minTileSize ??
      StreamCallParticipantsSpotlightTheme.of(context).style?.barTileSize ??
      const Size(222, 125);
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
