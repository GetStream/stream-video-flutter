import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// The livestream's video with its toolbar: whether the stream is live, how
/// many people watch it and a fullscreen button, plus a speakerphone toggle
/// when one is asked for.
///
/// Used by both the host and the viewers. [StreamLivestreamTileProps.child]
/// is what the tile shows, typically [StreamLivestreamHosts] or a
/// [StreamParticipantTile]; a participant tile already draws the host's
/// avatar on a bordered surface while their video is off.
///
/// The rendering can be replaced app-wide by registering a `livestreamTile`
/// builder with [streamVideoComponentBuilders] on a [StreamComponentFactory].
/// When no builder is registered, [DefaultStreamLivestreamTile] is used.
///
/// See also:
///
///  * [StreamLivestreamTileTheme], for customizing its appearance.
class StreamLivestreamTile extends StatelessWidget {
  /// Creates a [StreamLivestreamTile].
  StreamLivestreamTile({
    super.key,
    required Call call,
    required Widget child,
    VoidCallback? onFullscreenTapped,
    bool isFullscreen = false,
    bool? showLiveIndicator,
    bool? showSpectatorsIndicator,
    bool includeAnonymousParticipants = true,
    bool? showSpeakerphoneToggle,
    StreamLivestreamTileStyle? style,
  }) : props = .new(
         call: call,
         child: child,
         onFullscreenTapped: onFullscreenTapped,
         isFullscreen: isFullscreen,
         showLiveIndicator: showLiveIndicator,
         showSpectatorsIndicator: showSpectatorsIndicator,
         includeAnonymousParticipants: includeAnonymousParticipants,
         showSpeakerphoneToggle: showSpeakerphoneToggle,
         style: style,
       );

  /// The properties that configure this tile.
  final StreamLivestreamTileProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.videoComponentBuilder<StreamLivestreamTileProps>();
    return builder?.call(context, props) ??
        DefaultStreamLivestreamTile(props: props);
  }
}

/// Properties for configuring a [StreamLivestreamTile].
///
/// See also:
///
///  * [StreamLivestreamTile], which uses these properties.
///  * [DefaultStreamLivestreamTile], the default implementation.
@immutable
class StreamLivestreamTileProps {
  /// Creates properties for a livestream tile.
  const StreamLivestreamTileProps({
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

  /// Whether the tile fills the screen, which makes the fullscreen button
  /// show the exit glyph and tooltip.
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
  /// false.
  final bool? showSpeakerphoneToggle;

  /// Overrides for this tile's appearance.
  ///
  /// Merged over the ambient [StreamLivestreamTileTheme].
  final StreamLivestreamTileStyle? style;

  /// Creates a copy of these properties with the given fields replaced.
  StreamLivestreamTileProps copyWith({
    Call? call,
    Widget? child,
    VoidCallback? onFullscreenTapped,
    bool? isFullscreen,
    bool? showLiveIndicator,
    bool? showSpectatorsIndicator,
    bool? includeAnonymousParticipants,
    bool? showSpeakerphoneToggle,
    StreamLivestreamTileStyle? style,
  }) {
    return StreamLivestreamTileProps(
      call: call ?? this.call,
      child: child ?? this.child,
      onFullscreenTapped: onFullscreenTapped ?? this.onFullscreenTapped,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      showLiveIndicator: showLiveIndicator ?? this.showLiveIndicator,
      showSpectatorsIndicator:
          showSpectatorsIndicator ?? this.showSpectatorsIndicator,
      includeAnonymousParticipants:
          includeAnonymousParticipants ?? this.includeAnonymousParticipants,
      showSpeakerphoneToggle:
          showSpeakerphoneToggle ?? this.showSpeakerphoneToggle,
      style: style ?? this.style,
    );
  }
}

/// The default implementation of [StreamLivestreamTile].
class DefaultStreamLivestreamTile extends StatelessWidget {
  /// Creates the default livestream tile.
  const DefaultStreamLivestreamTile({super.key, required this.props});

  /// The properties that configure this tile.
  final StreamLivestreamTileProps props;

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamLivestreamTileTheme.of(context).style;
    final resolved = _StreamLivestreamTileStyleDefaults(
      context,
      themeStyle?.merge(props.style) ?? props.style,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        props.child,
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
      if (props.showLiveIndicator ?? resolved.showLiveIndicator)
        Flexible(child: StreamLiveIndicator(call: props.call)),
      if (props.showSpectatorsIndicator ?? resolved.showSpectatorsIndicator)
        Flexible(
          child: StreamSpectatorsIndicator(
            call: props.call,
            includeAnonymousParticipants: props.includeAnonymousParticipants,
          ),
        ),
    ];

    final trailing = [
      if (props.showSpeakerphoneToggle ?? resolved.showSpeakerphoneToggle)
        LivestreamSpeakerphoneOption(
          call: props.call,
          enabledSpeakerphoneIconTheme: const IconThemeData(),
          disabledSpeakerphoneIconTheme: const IconThemeData(),
          type: StreamButtonType.solid,
          size: resolved.buttonSize,
        ),
      if (props.onFullscreenTapped case final onFullscreenTapped?)
        StreamButton.icon(
          icon: Icon(
            props.isFullscreen
                ? context.streamIcons.fullscreenExit
                : context.streamIcons.fullscreen,
          ),
          tooltip: props.isFullscreen
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
  bool get showSpeakerphoneToggle => _style?.showSpeakerphoneToggle ?? false;
}
