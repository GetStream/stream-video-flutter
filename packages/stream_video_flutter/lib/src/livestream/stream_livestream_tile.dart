import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

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
    this.isFullscreen = false,
    this.showLiveIndicator,
    this.showSpectatorsIndicator,
    this.includeAnonymousParticipants = true,
    this.showSpeakerphoneToggle,
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

  /// Whether the tile fills the screen, which turns the fullscreen button
  /// into an exit-fullscreen button.
  final bool isFullscreen;

  /// Whether the toolbar shows [StreamLiveIndicator].
  ///
  /// Falls back to [StreamLivestreamTileStyle.showLiveIndicator], then true.
  final bool? showLiveIndicator;

  /// Whether the toolbar shows [StreamSpectatorsIndicator].
  ///
  /// Falls back to [StreamLivestreamTileStyle.showSpectatorsIndicator], then
  /// true.
  final bool? showSpectatorsIndicator;

  /// Whether anonymous viewers are part of the spectators count.
  final bool includeAnonymousParticipants;

  /// Whether the toolbar shows [LivestreamSpeakerphoneOption].
  ///
  /// Falls back to [StreamLivestreamTileStyle.showSpeakerphoneToggle], then
  /// true.
  final bool? showSpeakerphoneToggle;

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
        PositionedDirectional(
          start: 0,
          end: 0,
          bottom: 0,
          child: _toolbar(context, resolved),
        ),
      ],
    );
  }

  Widget _toolbar(
    BuildContext context,
    _StreamLivestreamTileStyleDefaults resolved,
  ) {
    final translations = context.translations;

    final leading = [
      if (showLiveIndicator ?? resolved.showLiveIndicator)
        Flexible(child: StreamLiveIndicator(call: call)),
      if (showSpectatorsIndicator ?? resolved.showSpectatorsIndicator)
        Flexible(
          child: StreamSpectatorsIndicator(
            call: call,
            includeAnonymousParticipants: includeAnonymousParticipants,
          ),
        ),
    ];

    final trailing = [
      if (showSpeakerphoneToggle ?? resolved.showSpeakerphoneToggle)
        LivestreamSpeakerphoneOption(
          call: call,
          enabledSpeakerphoneIconTheme: const IconThemeData(),
          disabledSpeakerphoneIconTheme: const IconThemeData(),
          type: StreamButtonType.solid,
          size: resolved.buttonSize,
        ),
      if (onFullscreenTapped case final onFullscreenTapped?)
        StreamButton.icon(
          // Core has no exit-fullscreen glyph; see CLAUDE.md.
          icon: Icon(
            isFullscreen
                ? Icons.fullscreen_exit
                : context.streamIcons.fullscreen,
          ),
          tooltip: isFullscreen
              ? translations.livestreamExitFullscreen
              : translations.livestreamEnterFullscreen,
          style: StreamButtonStyle.secondary,
          size: resolved.buttonSize,
          onPressed: onFullscreenTapped,
        ),
    ];

    return Padding(
      padding: resolved.toolbarPadding,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: resolved.toolbarMinHeight),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: resolved.leadingSpacing,
                  children: leading,
                ),
              ),
            ),
            if (trailing.isNotEmpty) ...[
              SizedBox(width: resolved.toolbarSpacing),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: resolved.trailingSpacing,
                children: trailing,
              ),
            ],
          ],
        ),
      ),
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

  // The toolbar is at least one tap target tall, so the pills sit 8 from
  // the bottom edge like the buttons, with or without a button beside them.
  double get toolbarMinHeight => kMinInteractiveDimension;

  // No bottom or end inset: each button's 48 tap target already pads its 32
  // visual by 8, which holds it 8 from the tile's bottom and end edges.
  @override
  EdgeInsetsGeometry get toolbarPadding =>
      _style?.toolbarPadding ?? EdgeInsetsDirectional.only(start: _spacing.xs);

  @override
  double get toolbarSpacing => _style?.toolbarSpacing ?? _spacing.xxs;

  // Matches the 16 the tap targets leave between the trailing buttons.
  @override
  double get leadingSpacing => _style?.leadingSpacing ?? _spacing.md;

  // The tap targets' own padding already leaves 16 between the buttons.
  @override
  double get trailingSpacing => _style?.trailingSpacing ?? 0;

  @override
  StreamButtonSize get buttonSize =>
      _style?.buttonSize ?? StreamButtonSize.small;

  @override
  bool get showLiveIndicator => _style?.showLiveIndicator ?? true;

  @override
  bool get showSpectatorsIndicator => _style?.showSpectatorsIndicator ?? true;

  @override
  bool get showSpeakerphoneToggle => _style?.showSpeakerphoneToggle ?? true;
}
