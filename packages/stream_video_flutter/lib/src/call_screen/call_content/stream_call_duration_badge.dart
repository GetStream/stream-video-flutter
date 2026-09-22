import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';
import '../../l10n/localizations/stream_video_flutter_localizations.dart';

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
/// The timestamp emphasises what the clock has reached: from the first non-zero
/// digit on, extended back over the unit that digit sits in. So `04:28` is
/// emphasised throughout, `00:00` not at all, and `00:08` emphasises the `8`
/// alone — the seconds keep their leading zero unemphasised, or the badge would
/// flicker as they roll past `09` every minute.
///
/// {@tool snippet}
///
/// ```dart
/// CallAppBar(call: call, title: StreamCallDurationBadge(call: call))
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamCallDurationBadgeTheme], for restyling the badge in a subtree.
class StreamCallDurationBadge extends StatelessWidget {
  /// Creates a duration badge.
  const StreamCallDurationBadge({
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
  /// [StreamCallDurationBadgeTheme], then token-backed defaults.
  final StreamCallDurationBadgeStyle? style;

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamCallDurationBadgeTheme.of(context).style;
    final resolved = _StreamCallDurationBadgeStyleDefaults(
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
          // A row with no indicators leaves no child behind, so a badge
          // holding only the time is not charged the gap in front of it.
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
    _StreamCallDurationBadgeStyleDefaults style,
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
  final _StreamCallDurationBadgeStyleDefaults style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: call.callDurationStream,
      builder: (context, snapshot) {
        // A device clock behind the server's `startedAt` makes the difference
        // negative, which has no reading as elapsed time.
        final elapsed = snapshot.data ?? Duration.zero;
        final duration = elapsed.isNegative ? Duration.zero : elapsed;

        // One weight throughout — the design separates the leading zeros from
        // the time that has elapsed by colour, not by boldness.
        return Text.rich(
          TextSpan(children: _spans(_format(duration), style.elapsedTextColor)),
          style: style.textStyle,
          semanticsLabel: _spokenDuration(context.translations, duration),
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
  static String _spokenDuration(
    StreamVideoFlutterLocalizations translations,
    Duration duration,
  ) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    // Each unit is dropped once it reads zero, except the seconds, so a call
    // that has just started still has something to announce.
    final parts = [
      if (hours > 0) translations.callDurationHours(hours),
      if (minutes > 0) translations.callDurationMinutes(minutes),
      translations.callDurationSeconds(seconds),
    ];

    return translations.callDurationSpoken(parts.join(' '));
  }
}

// Default style values for [StreamCallDurationBadge], resolved against the ambient
// tokens. Every getter is non-null, so the widget never spells a fallback out
// twice.
class _StreamCallDurationBadgeStyleDefaults
    extends StreamCallDurationBadgeStyle {
  _StreamCallDurationBadgeStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final StreamCallDurationBadgeStyle? _style;

  late final StreamSpacing _spacing = _context.streamSpacing;
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ??
      EdgeInsets.symmetric(
        horizontal: _spacing.xs,
        // 6 around a 20 icon is the design's 32 tall pill.
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
