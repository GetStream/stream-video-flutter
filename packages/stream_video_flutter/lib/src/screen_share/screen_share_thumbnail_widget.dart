import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'screen_share_logger.dart';
import 'screen_share_selector_defaults.dart';

/// Called with the source a thumbnail stands for.
typedef OnThumbnailTapped = void Function(DesktopCapturerSource);

/// One screen or window in a [StreamScreenShareSelector]: a still of the
/// source over its name, outlined in the accent color while it is picked.
///
/// Mirrors the `Web / Screen Share Thumbnail` component from the design.
///
/// The still is the bitmap the platform captured when the source was loaded,
/// which is what [ScreenShareSourceController] holds. It is not a live preview
/// and does not update on its own.
class StreamScreenShareThumbnail extends StatelessWidget {
  /// Creates a screen share thumbnail.
  const StreamScreenShareThumbnail({
    super.key,
    required this.source,
    required this.selected,
    required this.onTap,
    this.style,
  });

  /// The screen or window this stands for.
  final DesktopCapturerSource source;

  /// Whether this is the source the user picked.
  final bool selected;

  /// Called with [source] when the thumbnail is tapped.
  final OnThumbnailTapped onTap;

  /// Overrides for the thumbnail's styling.
  ///
  /// Merged over the ambient [StreamScreenShareSelectorTheme].
  final StreamScreenShareSelectorStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = resolveScreenShareSelectorStyle(context, this.style);
    final thumbnail = source.thumbnail;

    return Semantics(
      selected: selected,
      button: true,
      label: source.name,
      child: InkWell(
        onTap: () {
          screenShareLogger.d(() => 'Selected source id => ${source.id}');
          onTap(source);
        },
        borderRadius: style.tileBorderRadius,
        child: Container(
          padding: style.tilePadding,
          // A foreground border paints inside the tile, so the extra pixel a
          // selected tile's border carries does not resize it.
          foregroundDecoration: BoxDecoration(
            borderRadius: style.tileBorderRadius,
            border: Border.all(
              color: selected ? style.selectedBorderColor : style.borderColor,
              width: selected ? style.selectedBorderWidth : style.borderWidth,
            ),
          ),
          child: Column(
            spacing: style.tileSpacing,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: style.imageBorderRadius,
                  child: ColoredBox(
                    color: style.placeholderColor,
                    child: thumbnail == null
                        ? const SizedBox.expand()
                        : SizedBox.expand(
                            child: Image.memory(
                              thumbnail,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ),
                          ),
                  ),
                ),
              ),
              Text(
                source.name,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: style.labelTextStyle.copyWith(
                  color: selected ? style.selectedLabelColor : style.labelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
