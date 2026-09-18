import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// How long a call has been running, with whatever is worth flagging about it
/// leading the time.
///
/// Built for the centre slot of a [CallAppBar], and sized to it: the pill is
/// 32 tall and hugs its content, so it grows and shrinks as indicators come and
/// go.
///
/// Three independent indicators can show at once, in a fixed order —
/// encryption, then recording, then screen share — so the row stays put as a
/// call's state changes rather than reordering itself. With all three off the
/// badge is the time alone, which is the resting state for a call with nothing
/// to report.
///
/// The timestamp dims what the clock has not reached yet: it darkens from the
/// first non-zero digit on, extended back over the unit that digit sits in. So
/// `04:28` is dark throughout, `00:00` is light throughout, and `00:08` darkens
/// the `8` alone — the seconds keep their leading zero light, or the badge
/// would flicker as they roll past `09` every minute.
///
/// {@tool snippet}
///
/// ```dart
/// CallAppBar(call: call, title: CallDurationBadge(call: call))
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [CallDurationBadgeTheme], for restyling the badge in a subtree.
class CallDurationBadge extends StatelessWidget {
  /// Creates a duration badge.
  const CallDurationBadge({
    super.key,
    required this.call,
    this.showEncryption = true,
    this.showRecording = true,
    this.showScreenShare = true,
    this.style,
  });

  /// The call whose elapsed time is shown.
  final Call call;

  /// Whether an end-to-end encrypted call is marked as one.
  final bool showEncryption;

  /// Whether a call being recorded is marked as one.
  final bool showRecording;

  /// Whether a call somebody is presenting to is marked as one.
  final bool showScreenShare;

  /// The visual style applied to this badge.
  ///
  /// Resolution order per field: this [style], then the ambient
  /// [CallDurationBadgeTheme], then token-backed defaults.
  final CallDurationBadgeStyle? style;

  @override
  Widget build(BuildContext context) {
    final themeStyle = CallDurationBadgeTheme.of(context).style;
    final resolved = _CallDurationBadgeStyleDefaults(
      context,
      themeStyle?.merge(style) ?? style,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolved.backgroundColor,
        borderRadius: resolved.borderRadius,
      ),
      child: Padding(
        padding: resolved.padding,
        // Held to a fixed height rather than left to the tallest child, so a
        // badge showing nothing but the time is as tall as one carrying
        // indicators — the timestamp's own box is shorter than an icon.
        child: SizedBox(
          height: resolved.contentHeight,
          // One selector rather than one builder per indicator, and wrapped
          // around the whole row rather than around the icons: a row with
          // nothing to show has to leave no child behind, or a badge holding
          // only the time is still charged the gap in front of it.
          //
          // A record compares by value, so the stream stays distinct.
          child: PartialCallStateBuilder(
            call: call,
            selector: (state) => (
              encrypted: showEncryption && state.isE2eeEnabled,
              recording: showRecording && state.isRecording,
              presenting:
                  showScreenShare &&
                  state.callParticipants.any((it) => it.isScreenShareEnabled),
            ),
            builder: (context, status) => Row(
              mainAxisSize: MainAxisSize.min,
              spacing: resolved.spacing,
              children: [
                ?_indicators(context, resolved, status),
                _Duration(call: call, style: resolved),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The indicators [status] calls for, or null when it calls for none.
  Widget? _indicators(
    BuildContext context,
    _CallDurationBadgeStyleDefaults style,
    ({bool encrypted, bool recording, bool presenting}) status,
  ) {
    if (!status.encrypted && !status.recording && !status.presenting) {
      return null;
    }

    final icons = context.streamIcons;
    final translations = context.translations;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: style.indicatorSpacing,
      children: [
        if (status.encrypted)
          _Indicator(
            icon: icons.verifiedFill,
            color: style.encryptedColor,
            size: style.indicatorSize,
            tooltip: translations.callEncryptedTooltip,
          ),
        if (status.recording)
          _Indicator(
            icon: icons.recordingFill,
            color: style.recordingColor,
            size: style.indicatorSize,
            tooltip: translations.callRecordingTooltip,
          ),
        if (status.presenting)
          _Indicator(
            icon: context.streamPresentIcon,
            color: style.screenShareColor,
            size: style.indicatorSize,
            tooltip: translations.callScreenSharingTooltip,
          ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.icon,
    required this.color,
    required this.size,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final double size;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Icon(icon, size: size, color: color),
    );
  }
}

class _Duration extends StatelessWidget {
  const _Duration({required this.call, required this.style});

  final Call call;
  final _CallDurationBadgeStyleDefaults style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: call.callDurationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;

        // One weight throughout — the design separates the leading zeros from
        // the time that has elapsed by colour, not by boldness.
        return Text.rich(
          TextSpan(children: _spans(_format(duration), style.elapsedTextColor)),
          style: style.textStyle,
          semanticsLabel: _spokenDuration(duration),
        );
      },
    );
  }

  /// [duration] as `MM:SS`, or `H:MM:SS` once it passes an hour.
  static String _format(Duration duration) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    if (duration.inHours == 0) return '$minutes:$seconds';

    return '${duration.inHours}:$minutes:$seconds';
  }

  /// [timestamp] split in two, [elapsed] from the point the clock has reached.
  static List<TextSpan> _spans(String timestamp, Color elapsed) {
    final from = _elapsedFrom(timestamp);
    if (from == null) return [TextSpan(text: timestamp)];

    final style = TextStyle(color: elapsed);
    if (from == 0) return [TextSpan(text: timestamp, style: style)];

    return [
      // Null leaves the run in the ambient colour rather than restating it.
      TextSpan(text: timestamp.substring(0, from)),
      TextSpan(text: timestamp.substring(from), style: style),
    ];
  }

  /// Where [timestamp] starts reading as time that has elapsed, or null when
  /// none of it has.
  ///
  /// The first non-zero digit, extended back over the unit it sits in: a unit
  /// the clock has reached is emphasised whole, so `04:28` is emphasised
  /// throughout rather than from its `4`, and the colon goes with it.
  ///
  /// The last unit is the exception. Its leading zero is left alone, because
  /// the seconds run through `01` to `09` once a minute and emphasising that
  /// zero would have the badge flicker every minute — which is why `00:08`
  /// emphasises the `8` alone.
  static int? _elapsedFrom(String timestamp) {
    final significant = timestamp.indexOf(RegExp('[1-9]'));
    if (significant < 0) return null;

    final isLastUnit = !timestamp.substring(significant).contains(':');
    if (isLastUnit) return significant;

    return timestamp.lastIndexOf(':', significant) + 1;
  }

  // Screen readers read '05:03' out as digits, which says nothing about a call
  // that has been running five minutes.
  static String _spokenDuration(Duration duration) {
    final parts = [
      if (duration.inHours > 0) '${duration.inHours} hours',
      if (duration.inMinutes > 0) '${duration.inMinutes.remainder(60)} minutes',
      '${duration.inSeconds.remainder(60)} seconds',
    ];

    return 'Call duration ${parts.join(' ')}';
  }
}

// Default style values for [CallDurationBadge], resolved against the ambient
// tokens. Every getter is non-null, so the widget never spells a fallback out
// twice.
class _CallDurationBadgeStyleDefaults extends CallDurationBadgeStyle {
  _CallDurationBadgeStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final CallDurationBadgeStyle? _style;

  late final StreamSpacing _spacing = _context.streamSpacing;
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ??
      EdgeInsets.symmetric(
        horizontal: _spacing.xs,
        // The design splits the 6 into 4 on the pill and 2 on the row inside
        // it, which only matters to a design tool; 6 here is the same 32 tall
        // pill around a 20 icon.
        vertical: _spacing.xxs + _spacing.xxxs,
      );

  @override
  double get contentHeight => _style?.contentHeight ?? indicatorSize;

  @override
  double get spacing => _style?.spacing ?? _spacing.xs;

  @override
  double get indicatorSpacing => _style?.indicatorSpacing ?? _spacing.xxxs;

  @override
  double get indicatorSize => _style?.indicatorSize ?? 20;

  @override
  Color get backgroundColor =>
      _style?.backgroundColor ?? _colorScheme.backgroundSurface;

  @override
  BorderRadiusGeometry get borderRadius =>
      _style?.borderRadius ?? BorderRadius.all(_context.streamRadius.xxxl);

  // `height: 1` so the digits centre against the indicators rather than sitting
  // in the 20pt line box `bodyEmphasis` carries, and tabular figures so the
  // pill holds still as the seconds tick — a proportional `1` is narrower than
  // a `9`.
  @override
  TextStyle get textStyle =>
      _style?.textStyle ??
      _context.streamTextTheme.bodyEmphasis.copyWith(
        color: _colorScheme.textTertiary,
        height: 1,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  @override
  Color get elapsedTextColor =>
      _style?.elapsedTextColor ?? _colorScheme.textPrimary;

  @override
  Color get encryptedColor =>
      _style?.encryptedColor ?? _colorScheme.accentSuccess;

  @override
  Color get recordingColor =>
      _style?.recordingColor ?? _colorScheme.accentError;

  @override
  Color get screenShareColor =>
      _style?.screenShareColor ?? _colorScheme.accentPrimary;
}
