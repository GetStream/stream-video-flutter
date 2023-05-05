import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../../theme/stream_video_theme.dart';
import '../../widgets/tile_view.dart';
import '../call_participants.dart';

const _kDefaultSpacing = 16.0;

class CallParticipantsGridView extends StatelessWidget {
  const CallParticipantsGridView({
    super.key,
    required this.call,
    required this.participants,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(_kDefaultSpacing),
    this.mainAxisSpacing = _kDefaultSpacing,
    this.crossAxisSpacing = _kDefaultSpacing,
  });

  /// Represents a call.
  final Call call;

  /// The widgets to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantBuilder itemBuilder;

  /// Space between the items in the main axis.
  final double mainAxisSpacing;

  /// Space between the items in the cross axis.
  final double crossAxisSpacing;

  /// Padding around the grid.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    if (CurrentPlatform.isIos || CurrentPlatform.isAndroid) {
      return MobileCallParticipantsGrid(
        call: call,
        participants: participants,
        itemBuilder: itemBuilder,
        padding: padding,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      );
    }

    return DesktopCallParticipantsGrid(
      call: call,
      participants: participants,
      itemBuilder: itemBuilder,
      padding: padding,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
    );
  }
}

class MobileCallParticipantsGrid extends StatelessWidget {
  const MobileCallParticipantsGrid({
    super.key,
    required this.call,
    required this.participants,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(_kDefaultSpacing),
    this.mainAxisSpacing = _kDefaultSpacing,
    this.crossAxisSpacing = _kDefaultSpacing,
  });

  /// Represents a call.
  final Call call;

  /// The widgets to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantBuilder itemBuilder;

  /// Space between the items in the main axis.
  final double mainAxisSpacing;

  /// Space between the items in the cross axis.
  final double crossAxisSpacing;

  /// Padding around the grid.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final participantsCount = participants.length;

    if (participantsCount == 1) {
      return Padding(
        padding: padding,
        child: itemBuilder(context, call, participants[0]),
      );
    }

    if (participantsCount == 2) {
      return Padding(
        padding: padding,
        child: Column(
          children: [
            Expanded(child: itemBuilder(context, call, participants[0])),
            SizedBox(height: mainAxisSpacing),
            Expanded(child: itemBuilder(context, call, participants[1])),
          ],
        ),
      );
    }

    if (participantsCount == 3) {
      return Padding(
        padding: padding,
        child: Column(
          children: [
            Expanded(child: itemBuilder(context, call, participants[0])),
            SizedBox(height: mainAxisSpacing),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: itemBuilder(context, call, participants[1])),
                  SizedBox(width: crossAxisSpacing),
                  Expanded(child: itemBuilder(context, call, participants[2])),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (participantsCount == 4) {
      return Padding(
        padding: padding,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: itemBuilder(context, call, participants[0])),
                  SizedBox(width: crossAxisSpacing),
                  Expanded(child: itemBuilder(context, call, participants[1])),
                ],
              ),
            ),
            SizedBox(height: mainAxisSpacing),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: itemBuilder(context, call, participants[2])),
                  SizedBox(width: crossAxisSpacing),
                  Expanded(child: itemBuilder(context, call, participants[3])),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (participantsCount == 5) {
      return Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(child: itemBuilder(context, call, participants[0])),
                  SizedBox(height: mainAxisSpacing),
                  Expanded(child: itemBuilder(context, call, participants[1])),
                ],
              ),
            ),
            SizedBox(width: crossAxisSpacing),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: itemBuilder(context, call, participants[2])),
                  SizedBox(height: mainAxisSpacing),
                  Expanded(child: itemBuilder(context, call, participants[3])),
                  SizedBox(height: mainAxisSpacing),
                  Expanded(child: itemBuilder(context, call, participants[4])),
                ],
              ),
            ),
          ],
        ),
      );
    }

    const pageSize = 6;
    final pages = participants.slices(pageSize);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        var mainAxisCount = 3;
        var crossAxisCount = 2;

        // If the width is greater than the height, we need to swap the
        // main and cross axis.
        if (maxWidth > maxHeight) {
          final temp = mainAxisCount;
          mainAxisCount = crossAxisCount;
          crossAxisCount = temp;
        }

        return PageView.builder(
          itemCount: pages.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final page = pages.elementAt(index);

            return TileView(
              padding: padding,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisCount: mainAxisCount,
              crossAxisCount: crossAxisCount,
              crossAxisAlignment: WrapAlignment.start,
              mainAxisAlignment: WrapAlignment.start,
              children: page.map(
                (participant) {
                  return itemBuilder(context, call, participant);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class DesktopCallParticipantsGrid extends StatefulWidget {
  const DesktopCallParticipantsGrid({
    super.key,
    required this.call,
    required this.participants,
    required this.itemBuilder,
    this.pageSize = 16,
    this.padding = const EdgeInsets.all(_kDefaultSpacing),
    this.mainAxisSpacing = _kDefaultSpacing,
    this.crossAxisSpacing = _kDefaultSpacing,
  }) : assert(pageSize <= 49, 'We currently support a maximum of 49 items');

  /// Represents a call.
  final Call call;

  /// The widgets to display.
  final List<CallParticipantState> participants;

  /// Builder function used to build a participant item.
  final CallParticipantBuilder itemBuilder;

  /// Number of participants to display in a single page.
  final int pageSize;

  /// Space between the items in the main axis.
  final double mainAxisSpacing;

  /// Space between the items in the cross axis.
  final double crossAxisSpacing;

  /// Padding around the grid.
  final EdgeInsetsGeometry padding;

  @override
  State<DesktopCallParticipantsGrid> createState() =>
      _DesktopCallParticipantsGridState();
}

class _DesktopCallParticipantsGridState
    extends State<DesktopCallParticipantsGrid> {
  late final _pageController = PageController();
  late final _currentPage = ValueNotifier<int>(0);
  late var _pages = widget.participants.slices(widget.pageSize);

  @override
  void didUpdateWidget(covariant DesktopCallParticipantsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.participants != widget.participants ||
        oldWidget.pageSize != widget.pageSize) {
      _pages = widget.participants.slices(widget.pageSize);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentPage,
      builder: (context, currentPage, child) {
        return Stack(
          children: [
            child!,
            if (_pages.length > 1)
              Padding(
                padding: widget.padding,
                child: Center(
                  child: Row(
                    children: [
                      AnimatedScale(
                        scale: currentPage > 0 ? 1 : 0,
                        duration: kThemeAnimationDuration,
                        child: PageNavigationButton(
                          icon: const Icon(Icons.chevron_left_rounded),
                          onPressed: () async {
                            final previousPage = currentPage - 1;
                            await _pageController.animateToPage(
                              previousPage,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );

                            // We need to set the value after the animation
                            _currentPage.value = previousPage;
                          },
                        ),
                      ),
                      const Spacer(),
                      AnimatedScale(
                        scale: currentPage < _pages.length - 1 ? 1 : 0,
                        duration: kThemeAnimationDuration,
                        child: PageNavigationButton(
                          icon: const Icon(Icons.chevron_right_rounded),
                          onPressed: () async {
                            final nextPage = currentPage + 1;
                            await _pageController.animateToPage(
                              nextPage,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );

                            // We need to set the value after the animation
                            _currentPage.value = nextPage;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          return PageView.builder(
            itemCount: _pages.length,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final page = _pages.elementAt(index);

              final participantsCount = page.length;
              final pageSize = math.min(widget.pageSize, participantsCount);
              var crossAxisCount = math.sqrt(pageSize - 1).floor() + 1;
              var mainAxisCount = (pageSize / crossAxisCount).ceil();

              // If the height is greater than the width, we need to swap the
              // main and cross axis.
              if (maxHeight > maxWidth) {
                final temp = mainAxisCount;
                mainAxisCount = crossAxisCount;
                crossAxisCount = temp;
              }

              return TileView(
                key: ValueKey(index),
                padding: widget.padding,
                mainAxisSpacing: widget.mainAxisSpacing,
                crossAxisSpacing: widget.crossAxisSpacing,
                mainAxisCount: mainAxisCount,
                crossAxisCount: crossAxisCount,
                children: page.map(
                  (participant) {
                    return widget.itemBuilder(
                      context,
                      widget.call,
                      participant,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
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
