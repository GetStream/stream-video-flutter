import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../theme/app_palette.dart';

class CallDurationTitle extends StatefulWidget {
  const CallDurationTitle({super.key, required this.call});

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PartialCallStateBuilder(
            call: widget.call,
            selector: (state) => state.isE2eeEnabled,
            builder: (context, isEncrypted) => isEncrypted
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Tooltip(
                      message: 'This call is end-to-end encrypted',
                      child: Icon(
                        Icons.shield_rounded,
                        size: 16,
                        color: videoTheme.colorTheme.accentInfo,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          _Duration(call: widget.call),
        ],
      ),
    );
  }
}

class _Duration extends StatelessWidget {
  const _Duration({required this.call});

  final Call call;

  @override
  Widget build(BuildContext context) {
    final videoTheme = StreamVideoTheme.of(context);

    return StreamBuilder<Duration>(
      stream: call.callDurationStream,
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
      },
    );
  }
}
