import 'package:flutter/material.dart' hide ConnectionState;

import '../../../stream_video_flutter.dart';

/// The bar along the top of a call, laid out in three slots.
///
/// The counterpart of [CallControlBar]: same `StreamToolbar` layout, same
/// height, same edge padding, so the two ends of a call screen line up. A
/// [leading] widget sits against the bar's start edge and [actions] against its
/// end; [title] is centred in the bar's full width, however lopsided the two
/// sides are.
///
/// The bar owns its chrome — the background and the top safe-area inset — and
/// nothing else. Apart from the back button and the leave-call action it falls
/// back to, every control in it is a widget the caller supplies.
///
/// {@tool snippet}
///
/// ```dart
/// CallAppBar(
///   call: call,
///   leading: StreamFlipCameraButton(call: call),
///   title: CallDurationBadge(call: call),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [CallAppBarTheme], for restyling the bar in a subtree.
///  * [CallControlBar], the bar along the bottom.
class CallAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a new instance of [CallAppBar].
  const CallAppBar({
    super.key,
    required this.call,
    this.showBackButton = true,
    this.showLeaveCallAction = true,
    this.backgroundColor,
    this.onBackPressed,
    this.onLeaveCallTap,
    this.leading,
    this.title,
    this.actions,
    this.style,
    this.primary = true,
  });

  /// Represents a call.
  final Call call;

  /// Whether to show the leading back button.
  ///
  /// Ignored when [leading] is given.
  final bool showBackButton;

  /// Whether to show the leave call action button.
  ///
  /// Ignored when [actions] is given.
  final bool showLeaveCallAction;

  /// The background color for this [CallAppBar].
  ///
  /// Wins over [CallAppBarStyle.backgroundColor], from either [style] or the
  /// ambient [CallAppBarTheme].
  final Color? backgroundColor;

  /// The action to perform when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  /// The widget anchored at the bar's start edge.
  ///
  /// Null falls back to a back button when [showBackButton] is set, and to an
  /// empty slot otherwise — which reserves no room, so the [title] stays
  /// centred in the bar's full width.
  final Widget? leading;

  /// The widget centred in the bar's full width.
  ///
  /// Null falls back to the call's status. Drawn in
  /// [CallAppBarStyle.titleTextStyle], which a style of its own overrides.
  final Widget? title;

  /// The controls anchored at the bar's end edge.
  ///
  /// Null falls back to a leave-call button when [showLeaveCallAction] is set.
  /// An empty list reserves no room, as a null [leading] does.
  final List<Widget>? actions;

  /// The visual style applied to this bar.
  ///
  /// Resolution order per field: this [style], then the ambient
  /// [CallAppBarTheme], then token-backed defaults.
  final CallAppBarStyle? style;

  /// Whether this bar is the topmost chrome of its surface.
  ///
  /// When true (the default), the bar wraps itself in a `SafeArea(bottom:
  /// false)` so it clears the system top inset. Set it to false when something
  /// above the bar has already consumed that inset, so it isn't padded twice.
  final bool primary;

  /// The style [style] resolves to against the ambient theme.
  static CallAppBarStyle? _effectiveStyle(
    BuildContext context,
    CallAppBarStyle? style,
  ) {
    final themeStyle = CallAppBarTheme.of(context).style;
    return themeStyle?.merge(style) ?? style;
  }

  /// The height the bar occupies in [context], including the top inset a
  /// [primary] bar clears.
  ///
  /// [preferredSize] reports the unthemed height, which is all it can: it has
  /// no [BuildContext] to read a themed one from. A caller that has to match a
  /// restyled bar — to inset content out from under a floating one, say — wraps
  /// it in a [PreferredSize] built from this.
  ///
  /// Pass [primary] to match the bar being measured.
  static double heightOf(
    BuildContext context, {
    CallAppBarStyle? style,
    bool primary = true,
  }) {
    final height = _CallAppBarStyleDefaults(
      context,
      _effectiveStyle(context, style),
    ).height;

    if (!primary) return height;
    return height + MediaQuery.paddingOf(context).top;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kStreamToolbarHeight);

  /// [_effectiveStyle] with the [backgroundColor] override folded in, so the
  /// constructor argument wins over both [style] and the ambient theme.
  CallAppBarStyle? _resolvedStyle(BuildContext context) {
    final effective = _effectiveStyle(context, style);
    if (backgroundColor == null) return effective;

    return (effective ?? const CallAppBarStyle()).copyWith(
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _CallAppBarStyleDefaults(context, _resolvedStyle(context));

    final leadingSlot =
        leading ??
        (showBackButton
            ? StreamToolbarButton.icon(
                icon: Icon(context.streamIcons.arrowLeft),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: onBackPressed ?? () => Navigator.maybePop(context),
              )
            : null);

    final actionSlot =
        actions ??
        <Widget>[
          if (showLeaveCallAction)
            StreamLeaveCallButton(call: call, onLeaveCallTap: onLeaveCallTap),
        ];

    // Null rather than an empty Row: the toolbar reserves space for a slot that
    // exists, so an empty trailing would push the title off centre.
    final trailingSlot = actionSlot.isEmpty
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            spacing: resolved.controlSpacing,
            children: actionSlot,
          );

    final middleSlot = DefaultTextStyle.merge(
      style: resolved.titleTextStyle,
      textAlign: TextAlign.center,
      child: title ?? Text(call.state.value.status.toStatusString()),
    );

    // The slots are centred in what the padding leaves of the bar's height
    // rather than padded down to it, so one height covers both a control's tap
    // target and its smaller visible box.
    Widget bar = SizedBox(
      height: resolved.height,
      child: StreamToolbar(
        padding: resolved.padding,
        spacing: resolved.slotSpacing,
        leading: leadingSlot,
        middle: middleSlot,
        trailing: trailingSlot,
      ),
    );

    if (primary) bar = SafeArea(bottom: false, child: bar);

    final surfaceStyle = resolved.surfaceStyle;

    // A docked bar is opaque; a floating one fades into the call below it.
    // Neither draws a line along its bottom edge, unlike the design system's
    // own app bar — a call is a surface, not a page of content.
    //
    // The outer [Semantics] keeps the slots grouped for screen readers so they
    // aren't intermixed with the call below. The inner one forces each control
    // onto its own node — without it a slot holding a raw [GestureDetector]
    // would collapse the bar into a single tappable stop.
    bar = Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: switch (surfaceStyle) {
            .floating => null,
            .regular => resolved.backgroundColor,
          },
          gradient: switch (surfaceStyle) {
            .floating => _floatingGradient(context, resolved),
            .regular => null,
          },
        ),
        child: Semantics(explicitChildNodes: true, child: bar),
      ),
    );

    // Publish the resolved surface to the slots, so a control that adapts to
    // it — [StreamToolbarButton] and friends — matches the bar it sits in.
    return StreamToolbarScope(surfaceStyle: surfaceStyle, child: bar);
  }

  LinearGradient _floatingGradient(
    BuildContext context,
    _CallAppBarStyleDefaults style,
  ) {
    // The gradient is solid through the system inset and fades down through the
    // bar below it, so the status bar stays legible while the call shows
    // through the controls.
    final safeAreaTop = primary ? MediaQuery.paddingOf(context).top : 0.0;
    final totalHeight = safeAreaTop + style.height;

    return streamFloatingFadeLinearGradient(
      color: style.floatingBackgroundColor,
      solidFraction: totalHeight > 0 ? safeAreaTop / totalHeight : 0.0,
    );
  }
}

// Default style values for [CallAppBar], resolved against the ambient tokens.
// Every getter is non-null, so the widget never spells a fallback out twice.
class _CallAppBarStyleDefaults extends CallAppBarStyle {
  _CallAppBarStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final CallAppBarStyle? _style;

  late final StreamSpacing _spacing = _context.streamSpacing;
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  @override
  double get height => _style?.height ?? kStreamToolbarHeight;

  // `sm` rather than `md`, so the visible inset lands on the design's 16: a
  // control is 40 visible inside a 48 tap target, which contributes the other 4
  // on every edge. The vertical 12 changes nothing at the default height — 72
  // less 24 is the 48 the tap target already wants — and keeps a shortened bar
  // from cropping its controls.
  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ?? EdgeInsets.all(_spacing.sm);

  @override
  double get slotSpacing => _style?.slotSpacing ?? _spacing.md;

  @override
  double get controlSpacing => _style?.controlSpacing ?? _spacing.none;

  @override
  StreamSurfaceStyle get surfaceStyle =>
      _style?.surfaceStyle ?? _context.streamSurfaceStyle;

  // `backgroundApp`, matching [CallControlBar] and the call content's scaffold:
  // the bar is chrome on the call surface, not an elevation above it.
  @override
  Color get backgroundColor =>
      _style?.backgroundColor ?? _colorScheme.backgroundApp;

  @override
  Color get floatingBackgroundColor =>
      _style?.floatingBackgroundColor ?? _colorScheme.backgroundApp;

  @override
  TextStyle get titleTextStyle =>
      _style?.titleTextStyle ??
      _context.streamTextTheme.headingSm.copyWith(
        color: _colorScheme.textPrimary,
      );
}
