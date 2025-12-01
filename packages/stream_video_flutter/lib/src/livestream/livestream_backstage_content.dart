import 'dart:async';

import 'package:flutter/material.dart';
import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final liveTheme = theme.livestreamTheme;
    final translations = context.translations;

    return PartialCallStateBuilder(
      call: widget.call,
      selector: (state) =>
          (callParticipants: state.callParticipants, startsAt: state.startsAt),
      builder: (context, callData) {
        final participants = callData.callParticipants;
        final startsAt = callData.startsAt;

        return Scaffold(
          backgroundColor: theme.colorTheme.livestreamBackground,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  startsAt == null || _timeLeft <= Duration.zero
                      ? translations.livestreamBackstageStartingSoon
                      : translations.livestreamBackstageStartingIn,
                  style: liveTheme.backstageTextStyle,
                ),
                if (startsAt != null && _timeLeft > Duration.zero) ...[
                  const SizedBox(height: 12),
                  Text(
                    _formatDuration(_timeLeft),
                    style: liveTheme.backstageCounterTextStyle,
                  ),
                ],
                if (participants.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    translations.livestreamBackstageParticipants(
                      participants.length,
                    ),
                    style: liveTheme.backstageParticipantsTextStyle,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
