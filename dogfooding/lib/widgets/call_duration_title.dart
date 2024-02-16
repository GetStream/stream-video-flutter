import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:flutter_dogfooding/utils/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallDurationTitle extends StatefulWidget {
  const CallDurationTitle({
    super.key,
    required this.call,
  });

  final Call call;

  @override
  State<CallDurationTitle> createState() => _CallDurationTitleState();
}

class _CallDurationTitleState extends State<CallDurationTitle> {
  late DateTime _startedAt;
  Duration _duration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    widget.call.get().then((value) {
      _startedAt = value.foldOrNull(
              success: (callData) =>
                  callData.data.metadata.session.startedAt ?? DateTime.now()) ??
          DateTime.now();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _duration = DateTime.now().difference(_startedAt);
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoTheme = StreamVideoTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            shieldCheck,
            width: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${_duration.inMinutes.toString().padLeft(2, '0')}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
            style: videoTheme.textTheme.title3.apply(
              color: AppColorPalette.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
