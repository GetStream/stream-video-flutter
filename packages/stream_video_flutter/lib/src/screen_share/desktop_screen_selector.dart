import 'package:flutter/material.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import '../../stream_video_flutter.dart';
import 'screen_selector_state_notifier.dart';
import 'screen_share_thumbnail_widget.dart';

typedef DesktopScreenSelectorBuilder = Future<DesktopCapturerSource?> Function(
  BuildContext context,
);

Future<DesktopCapturerSource?> showDefaultScreenSelectionDialog(
  BuildContext context,
) {
  final streamVideoTheme = StreamVideoTheme.of(context);
  final screenSelectorState = ScreenSelectorStateNotifier();

  return showDialog<DesktopCapturerSource>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Choose what to share'),
      backgroundColor: streamVideoTheme.colorTheme.overlay,
      content: TabbedScreenSelectWidget(
        screenSelectorState: screenSelectorState,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop<DesktopCapturerSource>(context, null);
            screenSelectorState.dispose();
          },
        ),
        TextButton(
          child: const Text('Share'),
          onPressed: () {
            Navigator.pop<DesktopCapturerSource>(
                context, screenSelectorState.value.selectedSource);
            screenSelectorState.dispose();
          },
        ),
      ],
    ),
  );
}

class TabbedScreenSelectWidget extends StatelessWidget {
  const TabbedScreenSelectWidget({
    required ScreenSelectorStateNotifier screenSelectorState,
    super.key,
  }) : _screenSelectorState = screenSelectorState;
  final ScreenSelectorStateNotifier _screenSelectorState;
  Map<String, DesktopCapturerSource> get _sources =>
      _screenSelectorState.value.sources;
  DesktopCapturerSource? get _selectedSource =>
      _screenSelectorState.value.selectedSource;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 640,
      height: 560,
      child: ValueListenableBuilder(
        valueListenable: _screenSelectorState,
        builder: (context, state, _) {
          final streamVideoTheme = StreamVideoTheme.of(context);
          final textTheme = streamVideoTheme.textTheme;

          return DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                TabBar(
                  onTap: (value) => _screenSelectorState.setSourceType(
                    [if (value == 0) SourceType.Screen else SourceType.Window],
                  ),
                  tabs: ['Entire Screen', 'Window']
                      .map(
                        (e) => Tab(child: Text(e, style: textTheme.tabBar)),
                      )
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ThumbnailGrid(
                        sources: _sources.values
                            .where(
                              (element) => element.type == SourceType.Screen,
                            )
                            .toList(),
                        selectedSource: _selectedSource,
                        onSelectSource: _screenSelectorState.setSelectedSource,
                      ),
                      ThumbnailGrid(
                        crossAxisCount: 3,
                        sources: _sources.values
                            .where(
                              (element) => element.type == SourceType.Window,
                            )
                            .toList(),
                        selectedSource: _selectedSource,
                        onSelectSource: _screenSelectorState.setSelectedSource,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ThumbnailGrid extends StatelessWidget {
  const ThumbnailGrid({
    required this.sources,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 8,
    required this.selectedSource,
    required this.onSelectSource,
    super.key,
  });

  final List<DesktopCapturerSource> sources;
  final DesktopCapturerSource? selectedSource;
  final OnThumbnailTapped onSelectSource;
  final double crossAxisSpacing;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: crossAxisSpacing,
      crossAxisCount: crossAxisCount,
      children: sources
          .map(
            (e) => ScreenShareThumbnailWidget(
              onTap: onSelectSource,
              source: e,
              selected: selectedSource?.id == e.id,
            ),
          )
          .toList(),
    );
  }
}
