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
///   leading: [StreamLayoutButton(onLayoutModeChanged: setLayout)],
///   center: [
///     StreamMicrophoneButton(call: call),
///     StreamCameraButton(call: call),
///     StreamLeaveCallButton(call: call),
///   ],
///   trailing: [StreamParticipantsButton(call: call)],
/// )
/// ```
/// {@end-tool}
@immutable
class CallControlBarLayout {
  /// Creates a layout showing exactly the slots given.
  ///
  /// The lists are held as given, not copied. A layout with every slot empty
  /// draws an empty bar; omit the bar instead, or leave the size null and let
  /// it fall back to a smaller one.
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
/// The bar owns its chrome: the background and the bottom safe-area inset. It
/// owns no controls; the layouts supply all of them.
///
/// {@tool snippet}
///
/// A bar that splits its controls in two on a phone and centres them on a
/// desktop:
///
/// ```dart
/// CallControlBar(
///   small: CallControlBarLayout(
///     leading: [StreamMicrophoneButton(call: call), StreamCameraButton(call: call)],
///     trailing: [StreamParticipantsButton(call: call)],
///   ),
///   large: CallControlBarLayout(
///     leading: [StreamLayoutButton(onLayoutModeChanged: setLayout)],
///     center: [
///       StreamMicrophoneButton(call: call),
///       StreamCameraButton(call: call),
///       StreamLeaveCallButton(call: call),
///     ],
///     trailing: [StreamParticipantsButton(call: call)],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// The bar is configured rather than replaced: it takes no props and looks up
/// no component builder, so an app that wants different controls supplies
/// different layouts, and one that wants a different look restyles it through
/// [CallControlBarTheme]. Register builders on the controls inside it.
///
/// See also:
///
///  * [CallControlBarLayout], which describes one size's slots.
///  * [CallControlBarTheme], for restyling the bar in a subtree.
class CallControlBar extends StatelessWidget {
  /// Creates a control bar.
  const CallControlBar({
    required this.small,
    this.medium,
    this.large,
    this.style,
    this.primary = true,
    super.key,
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

  /// The style [style] resolves to against the ambient theme.
  static CallControlBarStyle? _effectiveStyle(
    BuildContext context,
    CallControlBarStyle? style,
  ) {
    final themeStyle = CallControlBarTheme.of(context).style;
    return themeStyle?.merge(style) ?? style;
  }

  /// The height the bar occupies in [context], including the bottom inset a
  /// [primary] bar clears.
  ///
  /// [CallControlBar] is not a [PreferredSizeWidget]: the height is a themed
  /// value, which `preferredSize` cannot read for want of a [BuildContext]. A
  /// caller that needs one — to inset content out from under a floating bar,
  /// say — wraps the bar in a [PreferredSize] built from this.
  ///
  /// Pass [primary] to match the bar being measured.
  static double heightOf(
    BuildContext context, {
    CallControlBarStyle? style,
    bool primary = true,
  }) {
    final height = _CallControlBarStyleDefaults(
      context,
      _effectiveStyle(context, style),
    ).height;

    if (!primary) return height;
    return height + MediaQuery.paddingOf(context).bottom;
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _CallControlBarStyleDefaults(
      context,
      _effectiveStyle(context, style),
    );

    final layout = layoutFor(context.streamScreenSize);
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
      height: resolved.height,
      child: StreamToolbar(
        padding: resolved.padding,
        spacing: resolved.slotSpacing,
        leading: slot(layout.leading),
        middle: slot(layout.center),
        trailing: slot(layout.trailing),
      ),
    );

    if (primary) bar = SafeArea(top: false, child: bar);

    final surfaceStyle = resolved.surfaceStyle;

    // A docked bar is opaque; a floating one fades into the call behind it.
    // Neither draws a line along its top edge.
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
    final totalHeight = safeAreaBottom + style.height;

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
  double get height => _style?.height ?? kStreamToolbarHeight;

  // `sm` rather than `md`, so the visible inset lands on the design's 16: a
  // control is 40 visible inside a 48 tap target, which contributes the other
  // 4 on every edge.
  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ?? EdgeInsets.symmetric(horizontal: _spacing.sm);

  @override
  double get slotSpacing => _style?.slotSpacing ?? _spacing.md;

  @override
  double get controlSpacing => _style?.controlSpacing ?? _spacing.none;

  @override
  StreamSurfaceStyle get surfaceStyle =>
      _style?.surfaceStyle ?? _context.streamSurfaceStyle;

  // `backgroundApp`, matching `CallAppBar` and the call content's scaffold:
  // the bar is chrome on the call surface, not an elevation above it.
  @override
  Color get backgroundColor =>
      _style?.backgroundColor ?? _colorScheme.backgroundApp;

  @override
  Color get floatingBackgroundColor =>
      _style?.floatingBackgroundColor ?? _colorScheme.backgroundApp;
}
