import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../widgets/avatar_size_from_constraints.dart';
import 'indicators/connection_quality_indicator_defaults.dart';
import 'participant_label_defaults.dart';

/// Builder function used to build a video placeholder.
typedef VideoPlaceholderBuilder =
    Widget Function(
      BuildContext context,
      Call call,
      CallParticipantState participant,
    );

/// Builder function used to build a video renderer.
typedef VideoRendererBuilder =
    Widget Function(
      BuildContext context,
      Call call,
      CallParticipantState participant,
    );

/// A widget that represents a single participant in a call.
///
/// Shows the participant's video, falling back to their avatar while the camera
/// is off, over two toolbars: an overflow button and any live reaction at the
/// top, the name pill and connection quality indicator at the bottom.
///
/// The rendering can be replaced app-wide by registering a `participantTile`
/// builder with [streamVideoComponentBuilders] on a [StreamComponentFactory].
/// When no builder is registered, [DefaultStreamParticipantTile] is used.
///
/// See also:
///
///  * [StreamParticipantTileTheme], for customizing its appearance.
///  * [StreamParticipantTileAction], for the overflow menu.
class StreamParticipantTile extends StatelessWidget {
  /// Creates a new instance of [StreamParticipantTile].
  StreamParticipantTile({
    super.key,
    required Call call,
    required CallParticipantState participant,
    String? rendererScopePrefix,
    VideoFit? videoFit,
    bool? showSpeakerBorder,
    bool? showParticipantLabel,
    bool? showConnectionQualityIndicator,
    bool? showReaction,
    List<StreamParticipantTileAction>? actions,
    StreamParticipantTileActionsBuilder? actionsBuilder,
    StreamParticipantTileStyle? style,
    VideoPlaceholderBuilder? videoPlaceholderBuilder,
    VideoRendererBuilder? videoRendererBuilder,
    ValueSetter<Size>? onSizeChanged,
  }) : props = .new(
         call: call,
         participant: participant,
         rendererScopePrefix: rendererScopePrefix,
         videoFit: videoFit,
         showSpeakerBorder: showSpeakerBorder,
         showParticipantLabel: showParticipantLabel,
         showConnectionQualityIndicator: showConnectionQualityIndicator,
         showReaction: showReaction,
         actions: actions,
         actionsBuilder: actionsBuilder,
         style: style,
         videoPlaceholderBuilder: videoPlaceholderBuilder,
         videoRendererBuilder: videoRendererBuilder,
         onSizeChanged: onSizeChanged,
       );

  /// The properties that configure this participant tile.
  final StreamParticipantTileProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.videoComponentBuilder<StreamParticipantTileProps>();
    return builder?.call(context, props) ??
        DefaultStreamParticipantTile(props: props);
  }
}

/// Properties for configuring a [StreamParticipantTile].
///
/// Appearance lives in [style]; everything here is either the data the tile
/// renders or a decision about what it renders.
///
/// See also:
///
///  * [StreamParticipantTile], which uses these properties.
///  * [DefaultStreamParticipantTile], the default implementation.
@immutable
class StreamParticipantTileProps {
  /// Creates properties for a participant tile.
  const StreamParticipantTileProps({
    required this.call,
    required this.participant,
    this.rendererScopePrefix,
    this.videoFit,
    this.showSpeakerBorder,
    this.showParticipantLabel,
    this.showConnectionQualityIndicator,
    this.showReaction,
    this.actions,
    this.actionsBuilder,
    this.style,
    this.videoPlaceholderBuilder,
    this.videoRendererBuilder,
    this.onSizeChanged,
  });

  /// Represents a call.
  final Call call;

  /// The participant to display.
  final CallParticipantState participant;

  /// Optional prefix to scope renderer keys (e.g. PiP vs main view).
  final String? rendererScopePrefix;

  /// The fit of the video within the tile.
  ///
  /// Overrides [StreamParticipantTileStyle.videoFit] when set.
  final VideoFit? videoFit;

  /// Whether to outline the tile while the participant is speaking.
  ///
  /// Overrides [StreamParticipantTileStyle.showSpeakerBorder] when set.
  final bool? showSpeakerBorder;

  /// Whether to show the name pill.
  ///
  /// Overrides [StreamParticipantTileStyle.showParticipantLabel] when set.
  final bool? showParticipantLabel;

  /// Whether to show the connection quality indicator.
  ///
  /// Overrides [StreamParticipantTileStyle.showConnectionQualityIndicator]
  /// when set.
  final bool? showConnectionQualityIndicator;

  /// Whether to show the participant's live reaction.
  ///
  /// Overrides [StreamParticipantTileStyle.showReaction] when set.
  final bool? showReaction;

  /// The actions offered in the tile's overflow menu.
  ///
  /// The overflow button is hidden entirely while this resolves to an empty
  /// list, which it does by default: the SDK ships no actions of its own.
  /// Ignored when [actionsBuilder] is set.
  final List<StreamParticipantTileAction>? actions;

  /// Builds the actions offered in the tile's overflow menu.
  ///
  /// Takes precedence over [actions], and is called during build, so the menu
  /// can reflect the participant's current state.
  final StreamParticipantTileActionsBuilder? actionsBuilder;

  /// Overrides for this tile's appearance.
  ///
  /// Merged over the ambient [StreamParticipantTileTheme].
  final StreamParticipantTileStyle? style;

  /// Builder function used to build a video placeholder.
  ///
  /// Takes precedence over a `participantPlaceholder` builder registered on the
  /// [StreamComponentFactory]: a call site that asked for something specific
  /// outranks an app-wide default.
  final VideoPlaceholderBuilder? videoPlaceholderBuilder;

  /// Builder function used to build a video renderer.
  ///
  /// Takes precedence over a `participantVideo` builder registered on the
  /// [StreamComponentFactory].
  final VideoRendererBuilder? videoRendererBuilder;

  /// Callback that is called when the size of the participant widget changes.
  final ValueSetter<Size>? onSizeChanged;

  /// Creates a copy of these properties but with the given fields replaced
  /// with the new values.
  StreamParticipantTileProps copyWith({
    Call? call,
    CallParticipantState? participant,
    String? rendererScopePrefix,
    VideoFit? videoFit,
    bool? showSpeakerBorder,
    bool? showParticipantLabel,
    bool? showConnectionQualityIndicator,
    bool? showReaction,
    List<StreamParticipantTileAction>? actions,
    StreamParticipantTileActionsBuilder? actionsBuilder,
    StreamParticipantTileStyle? style,
    VideoPlaceholderBuilder? videoPlaceholderBuilder,
    VideoRendererBuilder? videoRendererBuilder,
    ValueSetter<Size>? onSizeChanged,
  }) {
    return StreamParticipantTileProps(
      call: call ?? this.call,
      participant: participant ?? this.participant,
      rendererScopePrefix: rendererScopePrefix ?? this.rendererScopePrefix,
      videoFit: videoFit ?? this.videoFit,
      showSpeakerBorder: showSpeakerBorder ?? this.showSpeakerBorder,
      showParticipantLabel: showParticipantLabel ?? this.showParticipantLabel,
      showConnectionQualityIndicator:
          showConnectionQualityIndicator ?? this.showConnectionQualityIndicator,
      showReaction: showReaction ?? this.showReaction,
      actions: actions ?? this.actions,
      actionsBuilder: actionsBuilder ?? this.actionsBuilder,
      style: style ?? this.style,
      videoPlaceholderBuilder:
          videoPlaceholderBuilder ?? this.videoPlaceholderBuilder,
      videoRendererBuilder: videoRendererBuilder ?? this.videoRendererBuilder,
      onSizeChanged: onSizeChanged ?? this.onSizeChanged,
    );
  }
}

/// The default implementation of [StreamParticipantTile].
class DefaultStreamParticipantTile extends StatelessWidget {
  /// Creates a new instance of [DefaultStreamParticipantTile].
  const DefaultStreamParticipantTile({super.key, required this.props});

  /// The properties that configure this participant tile.
  final StreamParticipantTileProps props;

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamParticipantTileTheme.of(context).style;
    final style = themeStyle?.merge(props.style) ?? props.style;
    final defaults = _StreamParticipantTileStyleDefaults(context);

    final participant = props.participant;
    final borderRadius = style?.borderRadius ?? defaults.borderRadius;
    final hasVideo = participant.isVideoEnabled;
    final isSpeaking = participant.isSpeaking;
    final showSpeakerBorder =
        props.showSpeakerBorder ??
        style?.showSpeakerBorder ??
        defaults.showSpeakerBorder;

    // A tile showing video needs no outline — the video defines its own edge.
    final border = switch ((isSpeaking && showSpeakerBorder, hasVideo)) {
      (true, _) => style?.speakingBorder ?? defaults.speakingBorder,
      (false, false) => style?.border ?? defaults.border,
      (false, true) => null,
    };

    return ClipRRect(
      // A rounded decoration alone cannot clip the video: on Android the
      // renderer can be a platform view, which only a real clip contains.
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: style?.backgroundColor ?? defaults.backgroundColor,
          borderRadius: borderRadius,
        ),
        // In the foreground so the outline paints over the video rather than
        // insetting it, and so toggling it repaints without a relayout.
        foregroundDecoration: BoxDecoration(
          borderRadius: borderRadius,
          border: border,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => _TileContent(
            props: props,
            style: style,
            defaults: defaults,
            constraints: constraints,
          ),
        ),
      ),
    );
  }
}

// How much of the tile's chrome fits at its current size.
//
// The same tile is a full-width desktop cell, a thumbnail in a spotlight strip
// and a 140px floating self-view, so what it can show is a function of the
// space it was given rather than of the platform.
//
// This ladder covers the bottom toolbar, whose widths come from the chrome's
// own arithmetic — the toolbar's 12px inset on both sides, a 12px gap before
// the indicator, and the narrowest the pill can be drawn at:
//
//   indicator only         12 + 32 + 12                      =  56
//   pill (icons only)      12 + (12 + 24 + 4) + 12 + 32 + 12 = 108
//   pill with a short name 108 + a readable 44px of text     = 152
//
// It is a floor rather than the whole story: a muted participant's pill carries
// icons the widths above do not account for, and the top toolbar is anchored to
// the opposite edge, so both are measured against what they actually draw. See
// [_TileContent.build] and [_BottomToolbar.build].
enum _TileDensity {
  /// Everything.
  full,

  /// No name — the icons still read at this size, a truncated name does not.
  compact,

  /// The connection quality indicator alone.
  minimal,

  /// No chrome at all.
  bare;

  static const _fullWidth = 152.0;
  static const _compactWidth = 108.0;
  static const _minimalWidth = 56.0;
  static const _fullHeight = 128.0;
  static const _compactHeight = 72.0;
  static const _minimalHeight = 56.0;

  static _TileDensity resolve(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;

    if (width >= _fullWidth && height >= _fullHeight) return full;
    if (width >= _compactWidth && height >= _compactHeight) return compact;
    if (width >= _minimalWidth && height >= _minimalHeight) return minimal;
    return bare;
  }

  bool get showsName => this == full;

  bool get showsLabel => this == full || this == compact;

  bool get showsConnectionQuality => this != bare;

  // Both live in the top toolbar. The ladder decides whether a tile is big
  // enough to carry any of it; whether it actually fits is measured.
  bool get carriesTopToolbar => this == full || this == compact;
}

class _TileContent extends StatelessWidget {
  const _TileContent({
    required this.props,
    required this.style,
    required this.defaults,
    required this.constraints,
  });

  final StreamParticipantTileProps props;
  final StreamParticipantTileStyle? style;
  final _StreamParticipantTileStyleDefaults defaults;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final participant = props.participant;
    final density = _TileDensity.resolve(constraints);

    final actions =
        props.actionsBuilder?.call(context, participant) ??
        props.actions ??
        const <StreamParticipantTileAction>[];

    final showLabel =
        (props.showParticipantLabel ??
            style?.showParticipantLabel ??
            defaults.showParticipantLabel) &&
        density.showsLabel;
    final showIndicator =
        (props.showConnectionQualityIndicator ??
            style?.showConnectionQualityIndicator ??
            defaults.showConnectionQualityIndicator) &&
        density.showsConnectionQuality;
    final reaction = participant.reaction;

    // The top toolbar hangs off the opposite edge from the bottom one, so the
    // ladder's widths say nothing about whether it fits. Measure it: the button
    // reserves a tap target, the reaction is drawn at its own size inset from
    // the tile edge, and both have to clear whatever the bottom toolbar takes
    // rather than land on top of it.
    final topPadding = (style?.topToolbarPadding ?? defaults.topToolbarPadding)
        .resolve(Directionality.maybeOf(context));
    final reactionSpan =
        (style?.reactionSize ?? defaults.reactionSize) +
        2 * _reactionPadding(context, style: style, defaults: defaults);
    final clearance =
        topPadding.vertical +
        _bottomChromeHeight(
          context,
          style: style,
          defaults: defaults,
          showLabel: showLabel,
          showIndicator: showIndicator,
        );

    final showMore =
        actions.isNotEmpty &&
        (style?.showMoreButton ?? defaults.showMoreButton) &&
        density.carriesTopToolbar &&
        constraints.maxWidth >= topPadding.horizontal + _kTapTarget &&
        constraints.maxHeight >= clearance + _kTapTarget;

    final showReaction =
        reaction != null &&
        (props.showReaction ?? style?.showReaction ?? defaults.showReaction) &&
        density.carriesTopToolbar &&
        constraints.maxWidth >=
            topPadding.horizontal +
                (showMore ? _kTapTarget : 0) +
                reactionSpan &&
        constraints.maxHeight >=
            clearance + math.max(showMore ? _kTapTarget : 0, reactionSpan);

    return Stack(
      fit: StackFit.expand,
      children: [
        // No RepaintBoundary between here and the label pill: the pill's
        // backdrop filter samples this subtree, and a boundary would hand it an
        // empty backdrop and silently drop the blur.
        _buildVideo(context),
        if (showMore || showReaction)
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: RepaintBoundary(
              child: _TopToolbar(
                actions: showMore ? actions : const [],
                reaction: showReaction ? reaction : null,
                style: style,
                defaults: defaults,
              ),
            ),
          ),
        if (showLabel || showIndicator)
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: _BottomToolbar(
              participant: participant,
              showLabel: showLabel,
              showName: density.showsName,
              showIndicator: showIndicator,
              style: style,
              defaults: defaults,
            ),
          ),
      ],
    );
  }

  Widget _buildVideo(BuildContext context) {
    final call = props.call;
    final participant = props.participant;
    final rendererScopePrefix = props.rendererScopePrefix;

    final rendererBuilder = props.videoRendererBuilder;
    if (rendererBuilder != null) {
      return rendererBuilder(context, call, participant);
    }

    final placeholderBuilder = props.videoPlaceholderBuilder;

    return StreamParticipantVideo(
      call: call,
      participant: participant,
      rendererScopePrefix: rendererScopePrefix,
      onSizeChanged: props.onSizeChanged,
      videoFit: props.videoFit ?? style?.videoFit ?? defaults.videoFit,
      placeholderBuilder: (context) {
        if (placeholderBuilder != null) {
          return placeholderBuilder(context, call, participant);
        }
        return StreamParticipantPlaceholder(
          call: call,
          participant: participant,
          // No default of its own: the placeholder merges an incoming
          // style over the defaults it owns, so restating them here would
          // only be a second copy to keep in step.
          style: style?.placeholderStyle,
        );
      },
    );
  }
}

class _TopToolbar extends StatelessWidget {
  const _TopToolbar({
    required this.actions,
    required this.reaction,
    required this.style,
    required this.defaults,
  });

  final List<StreamParticipantTileAction> actions;
  final CallReaction? reaction;
  final StreamParticipantTileStyle? style;
  final _StreamParticipantTileStyleDefaults defaults;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: style?.topToolbarPadding ?? defaults.topToolbarPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (actions.isNotEmpty)
            _MoreMenuButton(actions: actions, style: style),
          const Spacer(),
          if (reaction != null)
            // Loose, so a glyph that measures wider than the size it was drawn
            // at clips instead of overflowing the row. Emoji advance widths are
            // a property of the platform's font, which the tile cannot know
            // when it decides whether the reaction fits.
            Flexible(
              child: Padding(
                // Measured from the tile edge, so the toolbar's own inset comes
                // off the designed distance.
                padding: EdgeInsets.all(
                  _reactionPadding(context, style: style, defaults: defaults),
                ),
                child: _ReactionIndicator(
                  reaction: reaction!,
                  size: style?.reactionSize ?? defaults.reactionSize,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// The tap target the overflow button reserves around itself.
const _kTapTarget = kMinInteractiveDimension;

// The reaction's own inset, less whatever the toolbar already insets it by.
double _reactionPadding(
  BuildContext context, {
  required StreamParticipantTileStyle? style,
  required _StreamParticipantTileStyleDefaults defaults,
}) {
  final inset = style?.reactionInset ?? defaults.reactionInset;
  final toolbarInset = (style?.topToolbarPadding ?? defaults.topToolbarPadding)
      .resolve(Directionality.maybeOf(context))
      .top;
  return math.max(0, inset - toolbarInset);
}

// How much room the bottom toolbar takes, so the top one can keep clear of it.
//
// Both of its parts are resolved from their own styles rather than assumed:
// either can be themed to a different size, and a tile that guessed would put
// the overflow button back on top of the name pill.
double _bottomChromeHeight(
  BuildContext context, {
  required StreamParticipantTileStyle? style,
  required _StreamParticipantTileStyleDefaults defaults,
  required bool showLabel,
  required bool showIndicator,
}) {
  if (!showLabel && !showIndicator) return 0;

  var content = 0.0;
  if (showLabel) {
    content = math.max(
      content,
      participantLabelHeight(context, style: style?.labelStyle),
    );
  }
  if (showIndicator) {
    content = math.max(
      content,
      connectionQualityIndicatorSize(
        context,
        style: style?.connectionQualityIndicatorStyle,
      ),
    );
  }

  final padding = (style?.toolbarPadding ?? defaults.toolbarPadding).resolve(
    Directionality.maybeOf(context),
  );
  return padding.vertical + content;
}

class _ReactionIndicator extends StatelessWidget {
  const _ReactionIndicator({required this.reaction, required this.size});

  final CallReaction reaction;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = StreamVideoTheme.of(context).callControlsTheme.callReactions
        .firstWhereOrNull((it) => it.emojiCode == reaction.emojiCode)
        ?.icon;

    if (icon == null) return const SizedBox.shrink();

    return Text(icon, style: TextStyle(fontSize: size));
  }
}

class _BottomToolbar extends StatelessWidget {
  const _BottomToolbar({
    required this.participant,
    required this.showLabel,
    required this.showName,
    required this.showIndicator,
    required this.style,
    required this.defaults,
  });

  final CallParticipantState participant;
  final bool showLabel;
  final bool showName;
  final bool showIndicator;
  final StreamParticipantTileStyle? style;
  final _StreamParticipantTileStyleDefaults defaults;

  @override
  Widget build(BuildContext context) {
    // What the pill needs to draw everything this participant gives it. A muted
    // camera-off participant carries two icons the density ladder's widths know
    // nothing about, and the pill lays its icons out at their full size rather
    // than shrinking them.
    final minLabelWidth = participantLabelMinWidth(
      context,
      showName: showName,
      showMicrophoneOff: !participant.isAudioEnabled,
      showVideoOff: !participant.isVideoEnabled,
      style: style?.labelStyle,
    );

    return Padding(
      padding: style?.toolbarPadding ?? defaults.toolbarPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Expanded, not Flexible plus a Spacer: two flex children would split
          // the free space between them and cap the pill at half the row. This
          // hands the label region exactly what is left after the indicator and
          // the gap, which is what keeps a long name from reaching the
          // indicator at any tile size.
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: showLabel
                  ? LayoutBuilder(
                      // The tile-level density check sizes the chrome against
                      // the tile. What actually reaches the pill is whatever is
                      // left after the indicator, which a replaced indicator can
                      // shrink further. Below the pill's own fixed width there
                      // is nothing left to truncate, so drop it rather than
                      // overflow.
                      builder: (context, constraints) =>
                          constraints.maxWidth < minLabelWidth
                          ? const SizedBox.shrink()
                          : StreamParticipantLabel.fromParticipant(
                              participant: participant,
                              showName: showName,
                              style: style?.labelStyle,
                            ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          if (showIndicator) ...[
            // Only between the two of them. With no pill beside it the gap
            // separates the indicator from nothing, and the tile's narrowest
            // band has no room to spare for it.
            if (showLabel)
              SizedBox(width: style?.toolbarSpacing ?? defaults.toolbarSpacing),
            RepaintBoundary(
              child: StreamConnectionQualityIndicator(
                connectionQuality: participant.connectionQuality,
                style: style?.connectionQualityIndicatorStyle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// The overflow button and the menu it anchors.
//
// Stateful because the menu has to be closed from outside a tap: a menu left
// open while its tile scrolls away floats free of the tile it belongs to, and
// one left open while tiles are recycled would act on the wrong participant.
class _MoreMenuButton extends StatefulWidget {
  const _MoreMenuButton({required this.actions, required this.style});

  final List<StreamParticipantTileAction> actions;
  final StreamParticipantTileStyle? style;

  @override
  State<_MoreMenuButton> createState() => _MoreMenuButtonState();
}

class _MoreMenuButtonState extends State<_MoreMenuButton> {
  final _controller = MenuController();
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position == _scrollPosition) return;
    _scrollPosition?.isScrollingNotifier.removeListener(_closeOnScroll);
    _scrollPosition = position
      ?..isScrollingNotifier.addListener(_closeOnScroll);
  }

  @override
  void didUpdateWidget(_MoreMenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // By value: an actionsBuilder returns a fresh list every build, so
    // comparing identity would close the menu on the next rebuild of the call —
    // which, with participant state streaming in, is immediately.
    if (!listEquals(oldWidget.actions, widget.actions)) _controller.close();
  }

  @override
  void dispose() {
    _scrollPosition?.isScrollingNotifier.removeListener(_closeOnScroll);
    super.dispose();
  }

  void _closeOnScroll() {
    if (_scrollPosition?.isScrollingNotifier.value ?? false) {
      _controller.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamContextMenuAnchor(
      controller: _controller,
      alignmentOffset: Offset(0, context.streamSpacing.xxs),
      menuChildren: [
        for (final action in widget.actions)
          StreamContextMenuAction<void>(
            enabled: action.enabled,
            isDestructive: action.isDestructive,
            leading: Icon(action.icon),
            // The menu sizes itself to its widest item, so a long label has to
            // truncate rather than stretch the panel.
            label: Text(
              action.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              // A MenuAnchor panel is an overlay rather than a route, so
              // selecting an item does not dismiss it on its own.
              _controller.close();
              action.onPressed();
            },
          ),
      ],
      builder: (context, controller, child) => StreamTapTargetPadding(
        minSize: const Size.square(kMinInteractiveDimension),
        alignment: AlignmentDirectional.topStart,
        child: StreamButton.icon(
          style: .secondary,
          size: .small,
          themeStyle: widget.style?.moreButtonStyle,
          icon: Icon(context.streamIcons.moreHorizontal),
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
        ),
      ),
    );
  }
}

// Maps the deprecated avatar theme onto the placeholder's style.
//
// Only the properties the design-system avatar has an equivalent for carry
// across: a size taken from the tightest constraint, and the initials text
// style. The rest — per-corner radii, the selection ring — has no counterpart
// and is dropped.
StreamParticipantPlaceholderStyle? _placeholderStyleOf(
  StreamUserAvatarThemeData? theme,
) {
  if (theme == null) return null;

  return StreamParticipantPlaceholderStyle(
    avatarTheme: StreamAvatarThemeData(
      size: avatarSizeFromConstraints(theme.constraints),
    ),
  );
}

// Default style values for [StreamParticipantTile].
class _StreamParticipantTileStyleDefaults extends StreamParticipantTileStyle {
  _StreamParticipantTileStyleDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;
  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;

  @override
  VideoFit get videoFit => defaultVideoFit;

  @override
  Color get backgroundColor => _colorScheme.backgroundSurfaceSubtle;

  @override
  BorderRadius get borderRadius => BorderRadius.all(_radius.xxl);

  @override
  BoxBorder get border => Border.all(color: _colorScheme.borderDefault);

  @override
  BoxBorder get speakingBorder =>
      Border.all(color: _colorScheme.accentPrimary, width: 2);

  @override
  bool get showSpeakerBorder => true;

  @override
  bool get showParticipantLabel => true;

  @override
  bool get showConnectionQualityIndicator => true;

  @override
  bool get showMoreButton => true;

  @override
  bool get showReaction => true;

  @override
  EdgeInsetsGeometry get toolbarPadding => EdgeInsets.all(_spacing.sm);

  @override
  double get toolbarSpacing => _spacing.sm;

  @override
  EdgeInsetsGeometry get topToolbarPadding => EdgeInsets.all(_spacing.xxs);

  @override
  double get reactionSize => 48;

  @override
  double get reactionInset => _spacing.sm;
}

/// A widget that represents a single participant in a call.
///
/// Kept as a thin wrapper around [DefaultStreamParticipantTile] so existing
/// code keeps working; it takes the same parameters as before.
@Deprecated(
  'Use StreamParticipantTile instead. '
  'Will be removed in the next major version.',
)
class StreamCallParticipant extends StatelessWidget {
  /// Creates a new instance of [StreamCallParticipant].
  @Deprecated(
    'Use StreamParticipantTile instead. '
    'Will be removed in the next major version.',
  )
  StreamCallParticipant({
    super.key,
    required Call call,
    required CallParticipantState participant,
    String? rendererScopePrefix,
    VideoFit? videoFit,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    StreamUserAvatarThemeData? userAvatarTheme,
    bool? showSpeakerBorder,
    double? speakerBorderThickness,
    Color? speakerBorderColor,
    bool? showParticipantLabel,
    TextStyle? participantLabelTextStyle,
    @Deprecated(
      'The participant label is laid out in the tile toolbar and no longer '
      'takes an alignment. This parameter has no effect.',
    )
    AlignmentGeometry? participantLabelAlignment,
    Color? audioLevelIndicatorColor,
    @Deprecated(
      'Only a muted microphone draws an icon now, so there is nothing for this '
      'to color. This parameter has no effect.',
    )
    Color? enabledMicrophoneColor,
    Color? disabledMicrophoneColor,
    Color? pausedVideoIndicatorColor,
    bool? showConnectionQualityIndicator,
    Color? connectionLevelActiveColor,
    Color? connectionLevelInactiveColor,
    @Deprecated(
      'The connection quality indicator is laid out in the tile toolbar and no '
      'longer takes an alignment. This parameter has no effect.',
    )
    AlignmentGeometry? connectionLevelAlignment,
    VideoPlaceholderBuilder? videoPlaceholderBuilder,
    VideoRendererBuilder? videoRendererBuilder,
    ValueSetter<Size>? onSizeChanged,
  }) : props = .new(
         call: call,
         participant: participant,
         rendererScopePrefix: rendererScopePrefix,
         videoFit: videoFit,
         showSpeakerBorder: showSpeakerBorder,
         showParticipantLabel: showParticipantLabel,
         showConnectionQualityIndicator: showConnectionQualityIndicator,
         videoPlaceholderBuilder: videoPlaceholderBuilder,
         videoRendererBuilder: videoRendererBuilder,
         onSizeChanged: onSizeChanged,
       ),
       _backgroundColor = backgroundColor,
       _borderRadius = borderRadius,
       _userAvatarTheme = userAvatarTheme,
       _speakerBorderThickness = speakerBorderThickness,
       _speakerBorderColor = speakerBorderColor,
       _participantLabelTextStyle = participantLabelTextStyle,
       _audioLevelIndicatorColor = audioLevelIndicatorColor,
       _disabledMicrophoneColor = disabledMicrophoneColor,
       _pausedVideoIndicatorColor = pausedVideoIndicatorColor,
       _connectionLevelActiveColor = connectionLevelActiveColor,
       _connectionLevelInactiveColor = connectionLevelInactiveColor;

  /// The properties that configure this participant tile.
  final StreamParticipantTileProps props;

  final Color? _backgroundColor;
  final BorderRadius? _borderRadius;
  final StreamUserAvatarThemeData? _userAvatarTheme;
  final double? _speakerBorderThickness;
  final Color? _speakerBorderColor;
  final TextStyle? _participantLabelTextStyle;
  final Color? _audioLevelIndicatorColor;
  final Color? _disabledMicrophoneColor;
  final Color? _pausedVideoIndicatorColor;
  final Color? _connectionLevelActiveColor;
  final Color? _connectionLevelInactiveColor;

  @override
  Widget build(BuildContext context) {
    // Built here rather than in the initializer list: a thickness given without
    // a color (or the reverse) still needs the other half of the border, and
    // that half comes from the theme.
    final speakingBorder =
        (_speakerBorderColor != null || _speakerBorderThickness != null)
        ? Border.all(
            color:
                _speakerBorderColor ?? context.streamColorScheme.accentPrimary,
            width: _speakerBorderThickness ?? 2,
          )
        : null;

    return DefaultStreamParticipantTile(
      props: props.copyWith(
        style: StreamParticipantTileStyle(
          backgroundColor: _backgroundColor,
          borderRadius: _borderRadius,
          speakingBorder: speakingBorder,
          placeholderStyle: _placeholderStyleOf(_userAvatarTheme),
          // Only built when this widget was actually given something to say.
          // The generated merge would leave an all-null style alone anyway, so
          // this is about keeping the props readable rather than correctness.
          labelStyle:
              (_participantLabelTextStyle != null ||
                  _audioLevelIndicatorColor != null ||
                  _disabledMicrophoneColor != null ||
                  _pausedVideoIndicatorColor != null)
              ? StreamParticipantLabelStyle(
                  nameTextStyle: _participantLabelTextStyle,
                  speakingColor: _audioLevelIndicatorColor,
                  microphoneOffColor: _disabledMicrophoneColor,
                  videoOffIconColor: _pausedVideoIndicatorColor,
                )
              : null,
          connectionQualityIndicatorStyle:
              (_connectionLevelActiveColor != null ||
                  _connectionLevelInactiveColor != null)
              ? StreamConnectionQualityIndicatorStyle(
                  // The indicator now colors each level apart. A single legacy
                  // color spreads across all three, so an override still lands.
                  poorColor: _connectionLevelActiveColor,
                  fairColor: _connectionLevelActiveColor,
                  greatColor: _connectionLevelActiveColor,
                  inactiveColor: _connectionLevelInactiveColor,
                )
              : null,
        ),
      ),
    );
  }
}
