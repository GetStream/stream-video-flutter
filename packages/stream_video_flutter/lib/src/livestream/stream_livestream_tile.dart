import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// The livestream's video with its toolbar: whether the stream is live, how
/// many people watch it, a speakerphone toggle and a fullscreen button.
///
/// Used by both the host and the viewers. [child] is what the tile shows,
/// typically [StreamLivestreamHosts] or a [StreamParticipantTile]; a
/// participant tile already draws the host's avatar on a bordered surface
/// while their video is off.
class StreamLivestreamTile extends StatelessWidget {
  /// Creates a [StreamLivestreamTile].
  const StreamLivestreamTile({
    super.key,
    required this.call,
    required this.child,
    this.onFullscreenTapped,
    this.showLiveIndicator = true,
    this.showSpectatorsIndicator = true,
    this.includeAnonymousParticipants = true,
    this.showSpeakerphoneToggle = true,
    this.style,
  });

  /// The livestream shown.
  final Call call;

  /// What the tile shows under the toolbar.
  final Widget child;

  /// Called when the fullscreen button is tapped.
  ///
  /// The button is left out when null.
  final VoidCallback? onFullscreenTapped;

  /// Whether the toolbar shows [StreamLiveIndicator].
  final bool showLiveIndicator;

  /// Whether the toolbar shows [StreamSpectatorsIndicator].
  final bool showSpectatorsIndicator;

  /// Whether anonymous viewers are part of the spectators count.
  final bool includeAnonymousParticipants;

  /// Whether the toolbar shows [LivestreamSpeakerphoneOption].
  final bool showSpeakerphoneToggle;

  /// Overrides the style from [StreamLivestreamTileTheme].
  final StreamLivestreamTileStyle? style;

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamLivestreamTileTheme.of(context).style;
    final resolved = _StreamLivestreamTileStyleDefaults(
      context,
      themeStyle?.merge(style) ?? style,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: resolved.toolbarPadding,
            child: Row(
              spacing: resolved.toolbarSpacing,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: resolved.leadingSpacing,
                  children: [
                    if (showLiveIndicator) StreamLiveIndicator(call: call),
                    if (showSpectatorsIndicator)
                      StreamSpectatorsIndicator(
                        call: call,
                        includeAnonymousParticipants:
                            includeAnonymousParticipants,
                      ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: resolved.trailingSpacing,
                  children: [
                    if (showSpeakerphoneToggle)
                      LivestreamSpeakerphoneOption(
                        call: call,
                        enabledSpeakerphoneIconTheme: const IconThemeData(),
                        disabledSpeakerphoneIconTheme: const IconThemeData(),
                        type: StreamButtonType.solid,
                        size: resolved.buttonSize,
                      ),
                    if (onFullscreenTapped case final onFullscreenTapped?)
                      StreamButton.icon(
                        icon: Icon(context.streamIcons.fullscreenFill),
                        style: StreamButtonStyle.secondary,
                        size: resolved.buttonSize,
                        onPressed: onFullscreenTapped,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Default style values for [StreamLivestreamTile], resolved against the
// ambient tokens.
class _StreamLivestreamTileStyleDefaults extends StreamLivestreamTileStyle {
  _StreamLivestreamTileStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final StreamLivestreamTileStyle? _style;

  late final StreamSpacing _spacing = _context.streamSpacing;

  // No bottom or end inset: each button's 48 tap target already pads its 32
  // visual by 8, which holds it 8 from the tile's bottom and end edges.
  @override
  EdgeInsetsGeometry get toolbarPadding =>
      _style?.toolbarPadding ??
      EdgeInsetsDirectional.only(start: _spacing.xs);

  @override
  double get toolbarSpacing => _style?.toolbarSpacing ?? _spacing.xxs;

  @override
  double get leadingSpacing => _style?.leadingSpacing ?? _spacing.xs;

  // The tap targets' own padding already leaves 16 between the buttons.
  @override
  double get trailingSpacing => _style?.trailingSpacing ?? 0;

  @override
  StreamButtonSize get buttonSize =>
      _style?.buttonSize ?? StreamButtonSize.small;
}
