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
  }) : assert(
         actions == null || actionsBuilder == null,
         'Pass actions or actionsBuilder, not both: a builder describes the '
         'same menu and would be the one used.',
       ),
       props = .new(
         call: call,
         participant: participant,
         rendererScopePrefix: rendererScopePrefix,
         videoFit: videoFit,
         showSpeakerBorder: showSpeakerBorder,
         showParticipantLabel: showParticipantLabel,
         showConnectionQualityIndicator: showConnectionQualityIndicator,
         showReaction: showReaction,
         // A fixed list is a builder that ignores its participant. Collapsing
         // it here leaves the props with one way to say this, so a decorator
         // can substitute the menu with copyWith instead of finding its list
         // outranked by a builder it cannot clear.
         actionsBuilder:
             actionsBuilder ?? (actions == null ? null : (_, _) => actions),
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

    // Measured here rather than inside the default tile, so a component
    // registered on the factory is handed the same size and chrome the default
    // would have drawn with instead of having to measure again.
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = StreamParticipantTileTheme.of(context);
        final size = constraints.biggest;
        final chrome =
            (theme.chromePolicy ?? StreamParticipantTileChromePolicy.bySize)
                .resolve(
                  StreamParticipantTileChromeDetails(
                    size: size,
                    participant: props.participant,
                  ),
                );

        final measured = props.copyWith(size: size, chrome: chrome);
        return builder?.call(context, measured) ??
            DefaultStreamParticipantTile(props: measured);
      },
    );
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
    this.actionsBuilder,
    this.style,
    this.videoPlaceholderBuilder,
    this.videoRendererBuilder,
    this.onSizeChanged,
    this.size,
    this.chrome,
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

  /// Builds the actions offered in the tile's overflow menu.
  ///
  /// Called during build, so the menu can reflect the participant's current
  /// state. The overflow button is hidden entirely while this is null or
  /// returns an empty list, which it does by default: the SDK ships no actions
  /// of its own.
  ///
  /// A fixed list passed as `StreamParticipantTile(actions: …)` arrives here as
  /// a builder that ignores its participant.
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

  /// The size the tile was laid out at.
  ///
  /// Filled in by [StreamParticipantTile] once it has been measured, so a
  /// component registered on the factory can lay out against it. Null in props
  /// constructed directly.
  final Size? size;

  /// How much chrome the tile draws at [size].
  ///
  /// Resolved by [StreamParticipantTileThemeData.chromePolicy] and filled in
  /// alongside [size]. Null in props constructed directly, in which case the
  /// default tile resolves it itself.
  final StreamParticipantTileChrome? chrome;

  /// Creates a copy of these properties but with the given fields replaced
  ///
  /// Passing null leaves a field alone rather than clearing it, so a decorator
  /// substituting the menu passes its own builder:
  /// `copyWith(actionsBuilder: (_, _) => mine)`.
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
    StreamParticipantTileActionsBuilder? actionsBuilder,
    StreamParticipantTileStyle? style,
    VideoPlaceholderBuilder? videoPlaceholderBuilder,
    VideoRendererBuilder? videoRendererBuilder,
    ValueSetter<Size>? onSizeChanged,
    Size? size,
    StreamParticipantTileChrome? chrome,
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
      actionsBuilder: actionsBuilder ?? this.actionsBuilder,
      style: style ?? this.style,
      videoPlaceholderBuilder:
          videoPlaceholderBuilder ?? this.videoPlaceholderBuilder,
      videoRendererBuilder: videoRendererBuilder ?? this.videoRendererBuilder,
      onSizeChanged: onSizeChanged ?? this.onSizeChanged,
      size: size ?? this.size,
      chrome: chrome ?? this.chrome,
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
    // Normally the size arrives on the props, measured by
    // [StreamParticipantTile]. Props built by hand carry none, so measure here
    // instead of drawing against a size nothing has checked.
    final size = props.size;
    if (size == null) {
      return LayoutBuilder(
        builder: (context, constraints) => _build(context, constraints.biggest),
      );
    }

    return _build(context, size);
  }

  Widget _build(BuildContext context, Size size) {
    final theme = StreamParticipantTileTheme.of(context);
    final participant = props.participant;
    final chrome =
        props.chrome ??
        (theme.chromePolicy ?? StreamParticipantTileChromePolicy.bySize)
            .resolve(
              StreamParticipantTileChromeDetails(
                size: size,
                participant: participant,
              ),
            );

    final resolved = theme.styleResolver?.call(
      StreamParticipantTileStyleDetails(
        size: size,
        chrome: chrome,
        participant: participant,
      ),
    );
    final themeStyle = theme.style?.merge(resolved) ?? resolved;
    final style = themeStyle?.merge(props.style) ?? props.style;
    final defaults = _StreamParticipantTileStyleDefaults(context, chrome);

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
        child: _TileContent(
          props: props,
          style: style,
          defaults: defaults,
          size: size,
          chrome: chrome,
        ),
      ),
    );
  }
}

class _TileContent extends StatelessWidget {
  const _TileContent({
    required this.props,
    required this.style,
    required this.defaults,
    required this.size,
    required this.chrome,
  });

  final StreamParticipantTileProps props;
  final StreamParticipantTileStyle? style;
  final _StreamParticipantTileStyleDefaults defaults;
  final Size size;
  final StreamParticipantTileChrome chrome;

  @override
  Widget build(BuildContext context) {
    final participant = props.participant;
    final density = chrome;

    final actions =
        props.actionsBuilder?.call(context, participant) ??
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
        size.width >= topPadding.horizontal + _kTapTarget &&
        size.height >= clearance + _kTapTarget;

    final showReaction =
        reaction != null &&
        (props.showReaction ?? style?.showReaction ?? defaults.showReaction) &&
        density.carriesTopToolbar &&
        size.width >=
            topPadding.horizontal +
                (showMore ? _kTapTarget : 0) +
                reactionSpan &&
        size.height >=
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
                sessionId: participant.sessionId,
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
              showIndicator: showIndicator,
              chrome: chrome,
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
    required this.sessionId,
    required this.actions,
    required this.reaction,
    required this.style,
    required this.defaults,
  });

  final String sessionId;
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
          // Expanded on the button's side rather than a Spacer beside a
          // Flexible reaction: two flex children would split the free space
          // between them and cap the reaction at half the row, which at phone
          // tile widths draws it at a fraction of the size the tile measured it
          // at. This hands the reaction everything the button leaves.
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: actions.isNotEmpty
                  ? _MoreMenuButton(
                      sessionId: sessionId,
                      actions: actions,
                      style: style,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          if (reaction != null)
            Padding(
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

// The geometry that puts the pill and the indicator in the tile's bottom
// corners: each rounded where it meets the middle of the tile and where it
// shares the tile's corner, square along the tile's edges.
({
  StreamParticipantLabelStyle label,
  StreamConnectionQualityIndicatorStyle indicator,
})
_anchoredChrome(
  BuildContext context, {
  required BorderRadius tileBorderRadius,
}) {
  final inner = context.streamRadius.lg;
  final isRtl = Directionality.of(context) == TextDirection.rtl;
  final start = isRtl
      ? tileBorderRadius.bottomRight
      : tileBorderRadius.bottomLeft;
  final end = isRtl
      ? tileBorderRadius.bottomLeft
      : tileBorderRadius.bottomRight;

  return (
    label: StreamParticipantLabelStyle(
      borderRadius: BorderRadiusDirectional.only(
        topEnd: inner,
        bottomStart: start,
      ),
    ),
    indicator: StreamConnectionQualityIndicatorStyle(
      // Only the shape changes, so it comes off the decoration the indicator
      // would have drawn — resolved the way the indicator resolves it — rather
      // than being described again here, which would drop an app's own fill.
      decoration:
          (StreamConnectionQualityIndicatorTheme.of(
                    context,
                  ).style?.decoration ??
                  StreamConnectionQualityIndicatorStyleDefaults(
                    context,
                  ).decoration)
              .copyWith(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: inner,
                  bottomEnd: end,
                ),
              ),
    ),
  );
}

class _BottomToolbar extends StatelessWidget {
  const _BottomToolbar({
    required this.participant,
    required this.showLabel,
    required this.showIndicator,
    required this.chrome,
    required this.style,
    required this.defaults,
  });

  final CallParticipantState participant;
  final bool showLabel;
  final bool showIndicator;
  final StreamParticipantTileChrome chrome;
  final StreamParticipantTileStyle? style;
  final _StreamParticipantTileStyleDefaults defaults;

  /// The radius the tile is drawn with, which the chrome's outer corners follow.
  BorderRadius get tileBorderRadius =>
      style?.borderRadius ?? defaults.borderRadius;

  @override
  Widget build(BuildContext context) {
    // The pill gives things up before it disappears. What the chrome level
    // allows comes first; then the participant's state icons, which the level's
    // widths measure against a pill carrying fewer of them than a muted
    // camera-off participant hands it; then the name. Only a pill with nothing
    // left to say is dropped. Resolved here rather than passed straight down,
    // so the chrome's own defaults reach the pill and an explicit style still
    // overrides them.
    const extrasOff = StreamParticipantLabelStyle(
      showAudioIndicator: false,
      showVideoOffIcon: false,
    );
    final explicit = style?.labelStyle;

    // Anchored in a corner of the tile, so each piece is rounded on the corner
    // it shares with the tile and on the one facing the middle, and square
    // where it meets the tile's edges. The tile's own radius is what the outer
    // corner follows: a square tile — the picture-in-picture window — gives a
    // square corner, and a rounded one gives its own arc rather than a clipped
    // approximation of it.
    final anchored = chrome.isFull
        ? null
        : _anchoredChrome(context, tileBorderRadius: tileBorderRadius);

    // Resolved the way the label's style is, so the corner the chrome anchors
    // the indicator in reaches it and an explicit style still overrides it.
    final indicatorStyle =
        anchored?.indicator.merge(style?.connectionQualityIndicatorStyle) ??
        style?.connectionQualityIndicatorStyle;

    final geometry = anchored?.label;
    final candidates = [
      (
        style: defaults.labelStyle.merge(geometry).merge(explicit),
        showName: true,
      ),
      (style: extrasOff.merge(geometry).merge(explicit), showName: true),
      (style: extrasOff.merge(geometry).merge(explicit), showName: false),
    ];

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
                      // The chrome level sizes the toolbar against the tile.
                      // What actually reaches the pill is whatever is left
                      // after the indicator, which a replaced indicator can
                      // shrink further, so the candidates are measured against
                      // that rather than against the tile.
                      builder: (context, constraints) {
                        for (final candidate in candidates) {
                          final showsName = participantLabelDrawsName(
                            showName: candidate.showName,
                            name: participant.name,
                          );

                          // Neither a name nor an icon left: there is no pill
                          // to draw, so fall through to none at all rather
                          // than leaving an empty one in the tree.
                          if (!showsName &&
                              !participantLabelDrawsIcons(
                                isAudioEnabled: participant.isAudioEnabled,
                                isVideoEnabled: participant.isVideoEnabled,
                                isVideoPaused: participant.isTrackPaused(
                                  SfuTrackType.video,
                                ),
                                style: candidate.style,
                              )) {
                            continue;
                          }

                          final minWidth = participantLabelMinWidth(
                            context,
                            showMicrophoneOff: !participant.isAudioEnabled,
                            showVideoOff: !participant.isVideoEnabled,
                            showVideoPaused: participant.isTrackPaused(
                              SfuTrackType.video,
                            ),
                            showName: showsName,
                            style: candidate.style,
                          );

                          if (constraints.maxWidth < minWidth) continue;

                          return StreamParticipantLabel.fromParticipant(
                            participant: participant,
                            showName: candidate.showName,
                            style: candidate.style,
                          );
                        }

                        return const SizedBox.shrink();
                      },
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
                style: indicatorStyle,
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
  const _MoreMenuButton({
    required this.sessionId,
    required this.actions,
    required this.style,
  });

  /// The participant the open menu would act on.
  final String sessionId;

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
    // The target changing is the case the recycling comment above is about,
    // and the one the action list cannot report: the same three entries —
    // "Pin", "Mute", "Remove" — compare equal for every participant, so a
    // recycled element would leave the menu open over somebody else.
    if (oldWidget.sessionId != widget.sessionId) {
      _controller.close();
      return;
    }

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
        // Destructive entries go below the rest, whatever order the caller
        // listed them in, so "Remove" never lands between two ordinary items.
        // A stable partition, so the relative order within each group is the
        // caller's.
        for (final action in [
          ...widget.actions.where((it) => !it.isDestructive),
          ...widget.actions.where((it) => it.isDestructive),
        ])
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
// across: a size taken from the tightest constraint, and the initials fill and
// text colour. The rest — per-corner radii, the selection ring — has no
// counterpart and is dropped.
//
// Kept in step with `StreamCallParticipantThemeData.toParticipantTileThemeData`,
// which translates the same legacy property on the theme path.
StreamParticipantPlaceholderStyle? _placeholderStyleOf(
  StreamUserAvatarThemeData? theme,
) {
  if (theme == null) return null;

  return StreamParticipantPlaceholderStyle(
    avatarTheme: StreamAvatarThemeData(
      size: avatarSizeFromConstraints(theme.constraints),
      // The initials chip is coloured as one piece, so its fill and text
      // travel together. Without a fill the avatar picks a colour per user
      // instead, and the text colour goes with it.
      backgroundColor: theme.initialsBackground,
      foregroundColor: theme.initialsBackground == null
          ? null
          : theme.initialsTextStyle.color,
    ),
  );
}

// Default style values for [StreamParticipantTile].
class _StreamParticipantTileStyleDefaults extends StreamParticipantTileStyle {
  _StreamParticipantTileStyleDefaults(this._context, this._chrome);

  final BuildContext _context;
  final StreamParticipantTileChrome _chrome;

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

  // The pill reports the participant's device state only where there is room
  // for it beside the name. See [StreamParticipantTileChrome.showsLabelExtras].
  @override
  StreamParticipantLabelStyle get labelStyle => StreamParticipantLabelStyle(
    showAudioIndicator: _chrome.showsLabelExtras,
    showVideoOffIcon: _chrome.showsLabelExtras,
  );

  // Flush into the tile's corners below [StreamParticipantTileChrome.full]: the
  // inset costs more video than it buys at that size, and the 16px it gives
  // back go to the name. Which corners the chrome rounds is [_BottomToolbar]'s
  // business — they follow the tile's own.
  @override
  EdgeInsetsGeometry get toolbarPadding =>
      _chrome.isFull ? EdgeInsets.all(_spacing.xs) : EdgeInsets.zero;

  @override
  double get toolbarSpacing => _spacing.xxs;

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
                  videoPausedColor: _pausedVideoIndicatorColor,
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
