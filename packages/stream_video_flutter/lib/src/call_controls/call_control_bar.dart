import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Which controls a [CallControlBar] shows, in three slots.
///
/// [leading] sits against the bar's start edge and [trailing] against its end;
/// [center] is centred in the bar's full width, however lopsided the two sides
/// are. A slot whose list is empty is not drawn and reserves no room, so a bar
/// with only a [center] has that centre across the whole width.
///
/// The bar draws no controls of its own — every one of them is a widget given
/// here, typically a [CallControlButton] or a [CallFeatureButton].
///
/// {@tool snippet}
///
/// ```dart
/// CallControlBarLayout(
///   leading: [ToggleLayoutOption(onLayoutModeChanged: setLayout)],
///   center: [
///     ToggleMicrophoneOption(call: call),
///     ToggleCameraOption(call: call),
///     LeaveCallOption(call: call),
///   ],
///   trailing: [StreamParticipantsControl(participants: participants)],
/// )
/// ```
/// {@end-tool}
@immutable
class CallControlBarLayout {
  /// Creates a layout showing exactly the slots given.
  ///
  /// The slots are the lists passed, not copies, which is what keeps this
  /// `const`: pass `const` lists for a wholly immutable result.
  const CallControlBarLayout({
    this.leading = const [],
    this.center = const [],
    this.trailing = const [],
  });

  /// The controls anchored at the bar's start edge.
  final List<Widget> leading;

  /// The controls centred in the bar's full width.
  ///
  /// Centred in the bar rather than in the gap between the two sides, so a
  /// long [leading] and an empty [trailing] leave this row where it was. The
  /// room it is given is what is left after reserving the wider side's width
  /// on *both* sides of it, which is the price of that: at
  /// [StreamScreenSize.small] a populated side halves the centre twice over,
  /// so prefer either [leading] and [trailing] or [center] there, not both.
  final List<Widget> center;

  /// The controls anchored at the bar's end edge.
  final List<Widget> trailing;
}

/// The row of controls along the bottom of a call, laid out for the width it
/// is given.
///
/// Takes one [CallControlBarLayout] per [StreamScreenSize] and draws the one
/// the window calls for, falling back to the next smaller layout that was
/// supplied — so a bar given only [small] and [large] draws [small] on a
/// medium window. [small] is required because it is the fallback everything
/// else lands on.
///
/// The bar owns its chrome: the background, the hairline separating it from
/// the call above, and the bottom safe-area inset. It owns no controls; the
/// layouts supply all of them.
///
/// {@tool snippet}
///
/// A bar that splits its controls in two on a phone and centres them on a
/// desktop:
///
/// ```dart
/// CallControlBar(
///   CallControlBarLayout(
///     leading: [ToggleMicrophoneOption(call: call), ToggleCameraOption(call: call)],
///     trailing: [StreamParticipantsControl(participants: participants)],
///   ),
///   large: CallControlBarLayout(
///     leading: [ToggleLayoutOption(onLayoutModeChanged: setLayout)],
///     center: [
///       ToggleMicrophoneOption(call: call),
///       ToggleCameraOption(call: call),
///       LeaveCallOption(call: call),
///     ],
///     trailing: [StreamParticipantsControl(participants: participants)],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [CallControlBarLayout], which describes one size's slots.
///  * [CallControlBarTheme], for restyling the bar in a subtree.
class CallControlBar extends StatelessWidget {
  /// Creates a control bar.
  const CallControlBar(
    this.small, {
    super.key,
    this.medium,
    this.large,
    this.style,
    this.primary = true,
  });

  /// The layout drawn at [StreamScreenSize.small], and the fallback for both
  /// larger sizes.
  final CallControlBarLayout small;

  /// The layout drawn at [StreamScreenSize.medium].
  ///
  /// Null falls back to [small]. Leave it null when a tablet should look like
  /// a phone, which is what the design asks for.
  final CallControlBarLayout? medium;

  /// The layout drawn at [StreamScreenSize.large].
  ///
  /// Null falls back to [medium], and then to [small].
  final CallControlBarLayout? large;

  /// The visual style applied to this bar.
  ///
  /// Resolution order per field: this [style], then the ambient
  /// [CallControlBarTheme], then token-backed defaults.
  final CallControlBarStyle? style;

  /// Whether this bar is the bottommost chrome of its surface.
  ///
  /// When true (the default), the bar wraps itself in a `SafeArea(top: false)`
  /// so it clears the system bottom inset. Set it to false when something
  /// below the bar has already consumed that inset, so it isn't padded twice.
  final bool primary;

  /// The layout this bar draws at [screenSize].
  ///
  /// A size with no layout of its own falls back to the next smaller one that
  /// has one, down to [small].
  CallControlBarLayout layoutFor(StreamScreenSize screenSize) =>
      switch (screenSize) {
        .small => small,
        .medium => medium ?? small,
        .large => large ?? medium ?? small,
      };

  /// The height the bar renders at in [context], safe area excluded.
  ///
  /// [CallControlBar] is not a [PreferredSizeWidget]: its height depends on
  /// the window, which `preferredSize` cannot read. A caller that needs one —
  /// to inset content out from under a floating bar, say — wraps the bar in a
  /// [PreferredSize] built from this.
  static double heightOf(BuildContext context, {CallControlBarStyle? style}) {
    final resolved = _CallControlBarStyleDefaults(
      context,
      CallControlBarTheme.of(context).style?.merge(style) ?? style,
    );

    return context.streamScreenSize.isLarge
        ? resolved.expandedHeight
        : resolved.compactHeight;
  }

  /// The surface style this bar renders with in [context].
  ///
  /// Precedence: the per-instance [style], then the ambient
  /// [CallControlBarTheme] style, then the ambient [StreamSurfaceStyle].
  ///
  /// Matches what the bar resolves for itself, so a screen dropping one into a
  /// call can lay the content above it out to match.
  static StreamSurfaceStyle resolveSurfaceStyle(
    BuildContext context, {
    CallControlBarStyle? style,
  }) {
    final themeStyle = CallControlBarTheme.of(context).style;
    final effective = themeStyle?.merge(style) ?? style;
    return effective?.surfaceStyle ?? context.streamSurfaceStyle;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = context.streamScreenSize;
    final isLarge = screenSize.isLarge;

    final resolved = _CallControlBarStyleDefaults(
      context,
      CallControlBarTheme.of(context).style?.merge(style) ?? style,
    );

    final layout = layoutFor(screenSize);
    final controlSpacing = resolved.controlSpacing;

    Widget? slot(List<Widget> controls) {
      // Null rather than an empty Row: the toolbar reserves space for a slot
      // that exists, so an empty leading would push the centre off centre.
      if (controls.isEmpty) return null;
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: controlSpacing,
        children: controls,
      );
    }

    // The slots are centred in what the padding leaves of the bar's height
    // rather than padded down to it, so one height covers both a control's tap
    // target and its smaller visible box.
    Widget bar = SizedBox(
      height: isLarge ? resolved.expandedHeight : resolved.compactHeight,
      child: StreamToolbar(
        padding: isLarge ? resolved.expandedPadding : resolved.compactPadding,
        spacing: resolved.slotSpacing,
        leading: slot(layout.leading),
        middle: slot(layout.center),
        trailing: slot(layout.trailing),
      ),
    );

    if (primary) bar = SafeArea(top: false, child: bar);

    final surfaceStyle = resolved.surfaceStyle;

    // A docked bar is opaque; a floating one fades into the call behind it.
    //
    // Neither draws a line along its top edge. Core's bars treat a
    // `borderSubtle` hairline as part of their identity, because they separate
    // one page of content from another — a call has nothing to separate the
    // controls from, and the design draws none.
    //
    // The outer [Semantics] keeps the slots grouped for screen readers so they
    // aren't intermixed with the call above. The inner one forces each control
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
    _CallControlBarStyleDefaults style,
  ) {
    // The gradient is solid through the system inset and fades up through the
    // bar above it, so the home indicator stays legible while the call shows
    // through the controls.
    final safeAreaBottom = primary ? MediaQuery.paddingOf(context).bottom : 0.0;
    final height = context.streamScreenSize.isLarge
        ? style.expandedHeight
        : style.compactHeight;
    final totalHeight = safeAreaBottom + height;

    return streamFloatingFadeLinearGradient(
      color: style.floatingBackgroundColor,
      solidFraction: totalHeight > 0 ? safeAreaBottom / totalHeight : 0.0,
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }
}

// Default style values for [CallControlBar], resolved against the ambient
// tokens. Every getter is non-null, so the widget never spells a fallback out
// twice.
class _CallControlBarStyleDefaults extends CallControlBarStyle {
  _CallControlBarStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final CallControlBarStyle? _style;

  late final StreamSpacing _spacing = _context.streamSpacing;
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  @override
  double get compactHeight => _style?.compactHeight ?? 64;

  @override
  double get expandedHeight => _style?.expandedHeight ?? kStreamToolbarHeight;

  @override
  EdgeInsetsGeometry get compactPadding =>
      _style?.compactPadding ?? EdgeInsets.symmetric(horizontal: _spacing.xs);

  @override
  EdgeInsetsGeometry get expandedPadding =>
      _style?.expandedPadding ?? EdgeInsets.symmetric(horizontal: _spacing.md);

  @override
  double get slotSpacing => _style?.slotSpacing ?? _spacing.md;

  @override
  double get controlSpacing => _style?.controlSpacing ?? _spacing.none;

  @override
  StreamSurfaceStyle get surfaceStyle =>
      _style?.surfaceStyle ?? _context.streamSurfaceStyle;

  // `backgroundApp` rather than core's `backgroundElevation1`, which is what
  // its own bars use: the bar is chrome on the call surface, and `CallAppBar`
  // and the call content's scaffold are both `backgroundApp`. Lifting only the
  // bottom bar left the two ends of the same screen a shade apart in dark
  // mode, where the elevations differ — in light they are all white, which is
  // why the design frames agree either way.
  @override
  Color get backgroundColor =>
      _style?.backgroundColor ?? _colorScheme.backgroundApp;

  @override
  Color get floatingBackgroundColor =>
      _style?.floatingBackgroundColor ?? _colorScheme.backgroundApp;
}
