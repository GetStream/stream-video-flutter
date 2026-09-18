import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Arranges every participant in a grid, a page at a time.
///
/// The arrangement follows the shape of the space the grid is given rather than
/// the width of the window: for each column count it could use, the grid works
/// out how large the video would render, and takes the best. A window far wider
/// than it is tall puts its participants in a row; a phone stacks the same
/// people down the screen.
///
/// See [solveParticipantGrid] for the rule, and
/// [StreamCallParticipantsGridThemeData.columnResolver] to override it.
class CallParticipantsGridView extends StatefulWidget {
  const CallParticipantsGridView({
    super.key,
    required this.call,
    required this.participants,
    required this.itemBuilder,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
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
  final EdgeInsets? padding;

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

  Future<void> _goToPage(int page) async {
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // The notifier drives the chevrons, which should not swap over until the
    // page they belong to has arrived.
    _currentPage.value = page;
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallParticipantsGridTheme.of(context);
    final spacing = context.streamSpacing;
    final screenSize = context.streamScreenSize;

    final padding =
        widget.padding ??
        theme.padding?.resolve(Directionality.maybeOf(context)) ??
        EdgeInsets.all(spacing.xs);
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

    return Padding(
      padding: padding,
      child: ValueListenableBuilder<int>(
        valueListenable: _currentPage,
        builder: (context, value, child) {
          if (pages.length <= 1) return child!;

          final currentPage = value.clamp(0, lastPage);

          return Stack(
            children: [
              child!,
              Center(
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: currentPage > 0 ? 1 : 0,
                      duration: kThemeAnimationDuration,
                      child: PageNavigationButton(
                        icon: Icon(context.streamIcons.chevronLeft),
                        onPressed: () => _goToPage(currentPage - 1),
                      ),
                    ),
                    const Spacer(),
                    AnimatedScale(
                      scale: currentPage < lastPage ? 1 : 0,
                      duration: kThemeAnimationDuration,
                      child: PageNavigationButton(
                        icon: Icon(context.streamIcons.chevronRight),
                        onPressed: () => _goToPage(currentPage + 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return PageView.builder(
              itemCount: pages.length,
              controller: _pageController,
              // Swiping is how the grid was paged on a phone before the
              // chevrons arrived, and Flutter's default drag devices leave a
              // mouse out, so this is touch only.
              physics: const PageScrollPhysics(),
              onPageChanged: (page) => _currentPage.value = page,
              itemBuilder: (context, index) {
                final page = pages[index];

                final details = StreamParticipantGridDetails(
                  box: constraints.biggest,
                  count: page.length,
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing,
                  maxTileAspectRatio: maxTileAspectRatio,
                  screenSize: screenSize,
                );

                final columns = theme.columnResolver?.call(details);
                final arrangement = columns == null
                    ? solveParticipantGrid(details)
                    : arrangeParticipantGrid(details, columns);

                return _GridPage(
                  call: widget.call,
                  participants: page,
                  itemBuilder: widget.itemBuilder,
                  arrangement: arrangement,
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing,
                );
              },
            );
          },
        ),
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
  final ParticipantGridArrangement arrangement;
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

class PageNavigationButton extends StatelessWidget {
  const PageNavigationButton({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconSize,
    this.onPressed,
  });

  final Widget icon;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final colorTheme = streamVideoTheme.colorTheme;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(48, 48),
        padding: EdgeInsets.zero,
        backgroundColor: colorTheme.barsBg,
      ),
      child: IconTheme.merge(
        data: IconThemeData(
          size: iconSize,
          color: iconColor ?? colorTheme.textHighEmphasis,
        ),
        child: icon,
      ),
    );
  }
}
