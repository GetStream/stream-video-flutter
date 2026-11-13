import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';
import 'stream_call_badge_style_defaults.dart';

/// The call's latency in milliseconds, behind a dot coloured by how good it
/// is, as a 32 tall pill.
///
/// Built for a [CallAppBar], next to a [StreamCallDurationBadge] and a
/// [StreamCallParticipantsBadge]. The reading is the round-trip time of the
/// connection this client publishes on — a call-level figure, not a
/// per-participant one.
///
/// A reading up to [fairFrom] is great, one below [poorFrom] is fair, and
/// anything higher is poor. Before the first measurement the badge shows `--`
/// behind a neutral dot.
///
/// {@tool snippet}
///
/// ```dart
/// StreamCallLatencyBadge(call: call)
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamCallLatencyBadgeTheme], for restyling the badge in a subtree.
class StreamCallLatencyBadge extends StatelessWidget {
  /// Creates a latency badge.
  const StreamCallLatencyBadge({
    super.key,
    required this.call,
    this.fairFrom = 100,
    this.poorFrom = 400,
    this.style,
  }) : assert(fairFrom <= poorFrom, 'fairFrom must not exceed poorFrom');

  /// The call whose latency is shown.
  final Call call;

  /// The latency, in milliseconds, above which a reading is no longer great.
  final int fairFrom;

  /// The latency, in milliseconds, from which a reading is poor.
  final int poorFrom;

  /// The visual style applied to this badge.
  ///
  /// Resolution order per field: this [style], then the ambient
  /// [StreamCallLatencyBadgeTheme], then token-backed defaults.
  final StreamCallLatencyBadgeStyle? style;

  // Each session has its own stats reporter, created once the session is up,
  // so the badge resubscribes when a session connects — after joining, a
  // reconnect or a migration.
  static ({String sessionId, bool connected}) _session(CallState state) =>
      (sessionId: state.sessionId, connected: state.status.isConnected);

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamCallLatencyBadgeTheme.of(context).style;
    final resolved = _StreamCallLatencyBadgeStyleDefaults(
      context,
      themeStyle?.merge(style) ?? style,
    );

    return PartialCallStateBuilder(
      call: call,
      selector: _session,
      builder: (context, _) {
        final reporter = call.statsReporter;

        // Keyed by the reporter: a StreamBuilder reads `initialData` only when
        // it is created, so a new session's reading would otherwise be lost.
        return StreamBuilder<CallMetrics?>(
          key: ObjectKey(reporter),
          stream: reporter?.stream,
          initialData: reporter?.currentMetrics,
          builder: (context, snapshot) => _buildBadge(
            context,
            resolved,
            snapshot.data?.publisher?.latency,
          ),
        );
      },
    );
  }

  Widget _buildBadge(
    BuildContext context,
    _StreamCallLatencyBadgeStyleDefaults style,
    int? latency,
  ) {
    final translations = context.translations;
    final dotColor = switch (latency) {
      null => style.unknownColor,
      final value when value <= fairFrom => style.greatColor,
      final value when value < poorFrom => style.fairColor,
      _ => style.poorColor,
    };

    return Semantics(
      label: latency == null
          ? translations.callLatencyUnknownSpoken
          : translations.callLatencySpoken(latency),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: style.borderRadius,
        ),
        child: Padding(
          padding: style.padding,
          child: SizedBox(
            height: style.contentHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: style.spacing,
              children: [
                SizedBox.square(
                  dimension: style.dotSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: latency?.toString() ?? '--'),
                      TextSpan(
                        text: ' ms',
                        style: TextStyle(color: style.unitTextColor),
                      ),
                    ],
                  ),
                  style: style.textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Default style values for [StreamCallLatencyBadge], resolved against the
// ambient tokens. Every getter is non-null, so the widget never spells a
// fallback out twice.
class _StreamCallLatencyBadgeStyleDefaults extends StreamCallLatencyBadgeStyle {
  _StreamCallLatencyBadgeStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final StreamCallLatencyBadgeStyle? _style;

  late final _badge = StreamCallBadgeStyleDefaults(_context);
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  @override
  EdgeInsetsGeometry get padding => _style?.padding ?? _badge.padding;

  @override
  double get contentHeight => _style?.contentHeight ?? _badge.contentHeight;

  // The dot keeps the same gap on every platform, unless the shared theme
  // sets one.
  @override
  double get spacing =>
      _style?.spacing ?? _badge.themeSpacing ?? _context.streamSpacing.xs;

  @override
  double get dotSize => _style?.dotSize ?? 8;

  @override
  Color get backgroundColor =>
      _style?.backgroundColor ?? _badge.backgroundColor;

  @override
  BorderRadiusGeometry get borderRadius =>
      _style?.borderRadius ?? _badge.borderRadius;

  @override
  TextStyle get textStyle => _badge.resolveTextStyle(
    color: _colorScheme.textPrimary,
    override: _style?.textStyle,
  );

  @override
  Color get unitTextColor => _style?.unitTextColor ?? _colorScheme.textTertiary;

  @override
  Color get greatColor => _style?.greatColor ?? _colorScheme.accentSuccess;

  @override
  Color get fairColor => _style?.fairColor ?? _colorScheme.accentWarning;

  @override
  Color get poorColor => _style?.poorColor ?? _colorScheme.accentError;

  @override
  Color get unknownColor => _style?.unknownColor ?? _colorScheme.textTertiary;
}
