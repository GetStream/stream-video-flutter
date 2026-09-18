import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// The size the design system draws an inline icon at.
const _indicatorSize = 20.0;

/// The pill in the middle of the call app bar: how long the call has been
/// running, preceded by whatever is worth flagging about it.
class CallDurationTitle extends StatelessWidget {
  const CallDurationTitle({super.key, required this.call});

  final Call call;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.backgroundSurface,
        borderRadius: BorderRadius.all(context.streamRadius.xxxl),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.xs,
          // The design splits the pill's 6 into 4 on the pill and 2 on the row
          // inside it, which only matters to a design tool; 6 here is the same
          // 32-tall pill around a 20 icon.
          vertical: spacing.xxs + spacing.xxxs,
        ),
        // One selector rather than one builder per indicator, and wrapped
        // around the whole row rather than around the icons: a row that has
        // nothing to show has to leave no child behind, or a pill holding only
        // the duration is still charged the gap in front of it.
        //
        // A record compares by value, so the stream stays distinct.
        child: PartialCallStateBuilder(
          call: call,
          selector: (state) => (
            encrypted: state.isE2eeEnabled,
            recording: state.isRecording,
            presenting: state.callParticipants.any(
              (it) => it.isScreenShareEnabled,
            ),
          ),
          builder: (context, status) => Row(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing.xs,
            children: [
              ?_indicators(context, status),
              _Duration(call: call),
            ],
          ),
        ),
      ),
    );
  }

  /// What is going on in the call, as icons: whether it is encrypted, being
  /// recorded, and being presented to. Null when it is none of those.
  Widget? _indicators(
    BuildContext context,
    ({bool encrypted, bool recording, bool presenting}) status,
  ) {
    if (!status.encrypted && !status.recording && !status.presenting) {
      return null;
    }

    final colorScheme = context.streamColorScheme;
    final icons = context.streamIcons;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: context.streamSpacing.xxxs,
      children: [
        if (status.encrypted)
          _Indicator(
            icon: icons.verifiedFill,
            color: colorScheme.accentSuccess,
            tooltip: 'This call is end-to-end encrypted',
          ),
        if (status.recording)
          _Indicator(
            icon: icons.recordingFill,
            color: colorScheme.accentError,
            tooltip: 'This call is being recorded',
          ),
        if (status.presenting)
          _Indicator(
            icon: context.streamPresentIcon,
            color: colorScheme.accentPrimary,
            tooltip: 'Someone is sharing their screen',
          ),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.icon,
    required this.color,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Icon(icon, size: _indicatorSize, color: color),
    );
  }
}

class _Duration extends StatelessWidget {
  const _Duration({required this.call});

  final Call call;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return StreamBuilder<Duration>(
      stream: call.callDurationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        final seconds = _twoDigits(duration.inSeconds.remainder(60));
        final minutes = _twoDigits(duration.inMinutes.remainder(60));
        final hours = duration.inHours;
        final leading = hours > 0 ? '$hours:$minutes' : minutes;

        // One weight throughout — the design separates the elapsed units from
        // the running one by colour, not by boldness.
        return Text.rich(
          TextSpan(
            text: leading,
            children: [
              TextSpan(
                text: ':$seconds',
                style: TextStyle(color: colorScheme.textPrimary),
              ),
            ],
          ),
          style: context.streamTextTheme.bodyEmphasis.copyWith(
            color: colorScheme.textTertiary,
          ),
          semanticsLabel: _spokenDuration(duration),
        );
      },
    );
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');

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
