import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// How many people are in a call, as a 32 tall pill.
///
/// Built for a [CallAppBar], next to a [StreamCallDurationBadge] and a
/// [StreamCallLatencyBadge]. Shows a count only, so its width stays stable as
/// people join and leave.
///
/// The count is the larger of the call's reported participant count and the
/// participants this client has in its state.
///
/// {@tool snippet}
///
/// ```dart
/// StreamCallParticipantsBadge(call: call)
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamCallParticipantsBadgeTheme], for restyling the badge in a subtree.
class StreamCallParticipantsBadge extends StatelessWidget {
  /// Creates a participants badge.
  const StreamCallParticipantsBadge({
    super.key,
    required this.call,
    this.style,
  });

  /// The call whose participants are counted.
  final Call call;

  /// The visual style applied to this badge.
  ///
  /// Resolution order per field: this [style], then the ambient
  /// [StreamCallParticipantsBadgeTheme], then token-backed defaults.
  final StreamCallParticipantsBadgeStyle? style;

  static int _count(CallState state) =>
      math.max(state.participantCount, state.callParticipants.length);

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamCallParticipantsBadgeTheme.of(context).style;
    final resolved = _StreamCallParticipantsBadgeStyleDefaults(
      context,
      themeStyle?.merge(style) ?? style,
    );

    return PartialCallStateBuilder(
      call: call,
      selector: _count,
      builder: (context, count) => Semantics(
        label: context.translations.callParticipantsSpoken(count),
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: resolved.backgroundColor,
            borderRadius: resolved.borderRadius,
          ),
          child: Padding(
            padding: resolved.padding,
            child: SizedBox(
              height: resolved.contentHeight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: resolved.spacing,
                children: [
                  Icon(
                    context.streamIcons.usersFill,
                    size: resolved.iconSize,
                    color: resolved.iconColor,
                  ),
                  Text('$count', style: resolved.textStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Default style values for [StreamCallParticipantsBadge], resolved against the
// ambient tokens. Every getter is non-null, so the widget never spells a
// fallback out twice.
class _StreamCallParticipantsBadgeStyleDefaults
    extends StreamCallParticipantsBadgeStyle {
  _StreamCallParticipantsBadgeStyleDefaults(this._context, this._style);

  final BuildContext _context;
  final StreamCallParticipantsBadgeStyle? _style;

  late final StreamSpacing _spacing = _context.streamSpacing;
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;

  @override
  EdgeInsetsGeometry get padding =>
      _style?.padding ??
      EdgeInsets.symmetric(
        horizontal: _spacing.xs,
        vertical: _spacing.xxs + _spacing.xxxs,
      );

  @override
  double get contentHeight => _style?.contentHeight ?? 20;

  @override
  double get spacing =>
      _style?.spacing ?? (isDesktopOrWeb ? _spacing.xxs : _spacing.xs);

  @override
  double get iconSize => _style?.iconSize ?? (isDesktopOrWeb ? 16 : 20);

  @override
  Color get iconColor => _style?.iconColor ?? _colorScheme.textPrimary;

  @override
  Color get backgroundColor =>
      _style?.backgroundColor ?? _colorScheme.backgroundSurface;

  @override
  BorderRadiusGeometry get borderRadius =>
      _style?.borderRadius ?? BorderRadius.all(_context.streamRadius.xxxl);

  @override
  TextStyle get textStyle {
    final textTheme = _context.streamTextTheme;
    final base = isDesktopOrWeb
        ? textTheme.captionEmphasis
        : textTheme.bodyEmphasis;

    return base
        .copyWith(
          color: _colorScheme.textPrimary,
          height: 1,
          fontFeatures: const [FontFeature.tabularFigures()],
        )
        .merge(_style?.textStyle);
  }
}
