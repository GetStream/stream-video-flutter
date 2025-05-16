import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
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
  @override
  Widget build(BuildContext context) {
    final videoTheme = StreamVideoTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: videoTheme.callControlsTheme.optionBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: StreamBuilder<Duration>(
          stream: widget.call.callDurationStream,
          builder: (context, snapshot) {
            final duration = snapshot.data ?? Duration.zero;

            return RichText(
              text: TextSpan(
                text: duration.inMinutes.toString().padLeft(2, '0'),
                style: videoTheme.textTheme.bodyBold.copyWith(
                  color: AppColorPalette.secondaryText,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        ':${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColorPalette.primaryText,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
