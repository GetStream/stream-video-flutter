import 'dart:async';

import 'package:flutter/material.dart';
import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';
import 'livestream_status_card.dart';

class LivestreamBackstageContent extends StatefulWidget {
  const LivestreamBackstageContent({
    super.key,
    required this.call,
  });

  final Call call;

  @override
  State<LivestreamBackstageContent> createState() =>
      _LivestreamBackstageContentState();
}

class _LivestreamBackstageContentState
    extends State<LivestreamBackstageContent> {
  Timer? _timer;
  StreamSubscription<DateTime?>? _startsAtSubscription;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();

    _startTimer();

    _startsAtSubscription = widget.call
        .partialState(
          (state) => state.startsAt,
        )
        .listen(_updateTimeLeft);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _startsAtSubscription?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeLeft -= const Duration(seconds: 1);
        if (_timeLeft <= Duration.zero) {
          _timeLeft = Duration.zero;
          _timer?.cancel();
        }
      });
    });
  }

  void _updateTimeLeft(DateTime? startsAt) {
    if (startsAt != null) {
      final now = DateTime.now();
      if (startsAt.isAfter(now)) {
        setState(() {
          _timeLeft = startsAt.difference(now);
        });
      } else {
        setState(() {
          _timeLeft = Duration.zero;
        });
        _timer?.cancel();
      }
    } else {
      setState(() {
        _timeLeft = Duration.zero;
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return '00:00';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  // Selecting the count rather than the list keeps the builder off every
  // participant update that doesn't change how many there are.
  static ({int participantCount, DateTime? startsAt}) _callData(
    CallState state,
  ) => (
    // The server's count: in a large call the participant list only holds the
    // few hundred participants the client gets details for.
    participantCount: state.participantCount,
    startsAt: state.startsAt,
  );

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return PartialCallStateBuilder(
      call: widget.call,
      selector: _callData,
      builder: (context, callData) {
        final participantCount = callData.participantCount;
        final counting = callData.startsAt != null && _timeLeft > Duration.zero;

        return LivestreamStatusCard(
          title: counting
              ? translations.livestreamBackstageStartingIn
              : translations.livestreamBackstageStartingSoon,
          children: [
            if (counting)
              Text(
                _formatDuration(_timeLeft),
                style: textTheme.headingLg.copyWith(
                  color: colorScheme.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            if (participantCount > 0)
              Text(
                translations.livestreamBackstageParticipants(participantCount),
                textAlign: TextAlign.center,
                style: textTheme.bodyDefault.copyWith(
                  color: colorScheme.textSecondary,
                ),
              ),
          ],
        );
      },
    );
  }
}
