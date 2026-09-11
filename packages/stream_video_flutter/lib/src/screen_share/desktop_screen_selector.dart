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
/// different shape, build one out of [StreamScreenShareSelector] or
/// [StreamScreenShareThumbnail] and pass it to
/// [StreamScreenShareButton.desktopScreenSelectorBuilder].
Future<DesktopCapturerSource?> showDefaultScreenSelectionDialog(
  BuildContext context,
) {
  return showStreamModalDialog<DesktopCapturerSource>(
    context: context,
    builder: (context) => const _ScreenSelectionDialog(),
  );
}

class _ScreenSelectionDialog extends StatefulWidget {
  const _ScreenSelectionDialog();

  @override
  State<_ScreenSelectionDialog> createState() => _ScreenSelectionDialogState();
}

class _ScreenSelectionDialogState extends State<_ScreenSelectionDialog> {
  late final _controller = ScreenShareSourceController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;

    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, state, _) => StreamModalDialog(
        title: Text(translations.desktopScreenShareChooseDialogTitle),
        headerActions: [
          StreamButton.icon(
            icon: Icon(context.streamIcons.refresh),
            style: StreamButtonStyle.secondary,
            type: StreamButtonType.ghost,
            tooltip: translations.desktopScreenShareRefresh,
            onPressed: state.isLoading ? null : _controller.refresh,
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
        child: StreamScreenShareSelector(controller: _controller),
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
          selected: state.selectedSourceId == source.id,
          onTap: onSelectSource,
          style: this.style,
        );
      },
    );
  }
}
