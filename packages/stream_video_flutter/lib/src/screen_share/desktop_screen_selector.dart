import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';
import 'screen_share_selector_defaults.dart';

/// Picks the screen or window to share, on a platform that offers no chooser
/// of its own.
typedef DesktopScreenSelectorBuilder =
    Future<DesktopCapturerSource?> Function(
      BuildContext context,
    );

/// Shows the default screen selection dialog: the screens and windows on
/// offer, in two tabs, over a blurred scrim.
///
/// Resolves to the picked source, or null when the dialog was cancelled or
/// dismissed.
///
/// Style it through [StreamScreenShareSelectorTheme]. For a picker of a
/// different shape, build one out of [StreamScreenShareDialog],
/// [StreamScreenShareSelector] or [StreamScreenShareThumbnail] and pass it to
/// [StreamScreenShareButton.desktopScreenSelectorBuilder].
Future<DesktopCapturerSource?> showDefaultScreenSelectionDialog(
  BuildContext context,
) {
  return showStreamModalDialog<DesktopCapturerSource>(
    context: context,
    builder: (context) => const StreamScreenShareDialog(),
  );
}

/// The default screen share picker, as a widget: a [StreamModalDialog] around
/// a [StreamScreenShareSelector], with a refresh action in the header and
/// Cancel and Share in the footer.
///
/// Pops the [Navigator] with the picked source, or with nothing when
/// cancelled. [showDefaultScreenSelectionDialog] shows it over a scrim; use
/// this directly to present it some other way.
class StreamScreenShareDialog extends StatefulWidget {
  /// Creates a screen share dialog.
  const StreamScreenShareDialog({super.key, this.controller});

  /// Holds the sources on offer and the one that is picked.
  ///
  /// Null builds one — and disposes it — for the life of the dialog, which is
  /// what [showDefaultScreenSelectionDialog] does. A controller passed here
  /// belongs to the caller, who disposes it.
  final ScreenShareSourceController? controller;

  @override
  State<StreamScreenShareDialog> createState() =>
      _StreamScreenShareDialogState();
}

class _StreamScreenShareDialogState extends State<StreamScreenShareDialog> {
  ScreenShareSourceController? _ownedController;

  ScreenShareSourceController get _controller =>
      widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    // Built here rather than lazily on first build: a controller starts
    // reading the platform as soon as it exists, which is not something to do
    // as a side effect of building.
    if (widget.controller == null) {
      _ownedController = ScreenShareSourceController();
    }
  }

  @override
  void didUpdateWidget(StreamScreenShareDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) return;

    if (widget.controller == null) {
      _ownedController ??= ScreenShareSourceController();
    } else {
      // A controller arriving where the dialog had been making its own leaves
      // the owned one with nothing to drive.
      _ownedController?.dispose();
      _ownedController = null;
    }
  }

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final controller = _controller;

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, _) => StreamModalDialog(
        title: Text(translations.desktopScreenShareChooseDialogTitle),
        headerActions: [
          StreamButton.icon(
            icon: Icon(context.streamIcons.refresh),
            style: StreamButtonStyle.secondary,
            type: StreamButtonType.ghost,
            tooltip: translations.desktopScreenShareRefresh,
            onPressed: state.isLoading ? null : controller.refresh,
          ),
        ],
        actions: [
          StreamButton(
            style: StreamButtonStyle.secondary,
            type: StreamButtonType.ghost,
            onPressed: () => Navigator.pop<DesktopCapturerSource>(context),
            child: Text(translations.desktopScreenShareChooseDialogCancel),
          ),
          StreamButton(
            onPressed: switch (state.selectedSource) {
              final source? => () => Navigator.pop<DesktopCapturerSource>(
                context,
                source,
              ),
              null => null,
            },
            child: Text(translations.desktopScreenShareChooseDialogShare),
          ),
        ],
        child: StreamScreenShareSelector(controller: controller),
      ),
    );
  }
}

/// The body of the screen share picker: a tab per source type over a grid of
/// [StreamScreenShareThumbnail]s.
///
/// Reports a pick to the [controller], which the caller reads to find out what
/// to share. The caller owns the controller and disposes it.
///
/// {@tool snippet}
///
/// ```dart
/// StreamScreenShareSelector(controller: _controller)
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [showDefaultScreenSelectionDialog], which shows this in a dialog.
///  * [StreamScreenShareSelectorTheme], for restyling it over a subtree.
class StreamScreenShareSelector extends StatelessWidget {
  /// Creates a screen share selector.
  const StreamScreenShareSelector({
    super.key,
    required this.controller,
    this.style,
  });

  /// Holds the sources on offer and the one that is picked.
  final ScreenShareSourceController controller;

  /// Overrides for the selector's styling.
  ///
  /// Merged over the ambient [StreamScreenShareSelectorTheme].
  final StreamScreenShareSelectorStyle? style;

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;

    const types = [SourceType.Screen, SourceType.Window];
    final labels = [
      translations.desktopScreenShareEntireScreen,
      translations.desktopScreenShareWindow,
    ];

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, _) => Column(
        children: [
          StreamTabBar(
            selectedIndex: types.indexOf(state.sourceType),
            onSelected: (index) => controller.setSourceType(types[index]),
            tabs: [
              for (final label in labels) StreamTabBarItem(label: label),
            ],
          ),
          Expanded(
            child: _SourceGrid(
              state: state,
              style: style,
              onSelectSource: controller.setSelectedSource,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceGrid extends StatelessWidget {
  const _SourceGrid({
    required this.state,
    required this.style,
    required this.onSelectSource,
  });

  final ScreenShareSourceState state;
  final StreamScreenShareSelectorStyle? style;
  final OnThumbnailTapped onSelectSource;

  @override
  Widget build(BuildContext context) {
    final style = resolveScreenShareSelectorStyle(context, this.style);
    final sources = state.visibleSources;

    if (sources.isEmpty) {
      // A first load has nothing to show yet; a refresh keeps the grid it has.
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }

      return Padding(
        padding: style.padding,
        child: Center(
          child: Text(
            context.translations.desktopScreenShareNoSources,
            textAlign: TextAlign.center,
            style: context.streamTextTheme.bodyDefault.copyWith(
              color: context.streamColorScheme.textSecondary,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: style.padding,
      itemCount: sources.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: style.crossAxisCount,
        crossAxisSpacing: style.spacing,
        mainAxisSpacing: style.spacing,
        mainAxisExtent: style.tileHeight,
      ),
      itemBuilder: (context, index) {
        final source = sources[index];
        return StreamScreenShareThumbnail(
          key: ValueKey(source.id),
          source: source,
          thumbnail: state.thumbnailFor(source),
          selected: state.selectedSourceId == source.id,
          onTap: onSelectSource,
          style: this.style,
        );
      },
    );
  }
}
