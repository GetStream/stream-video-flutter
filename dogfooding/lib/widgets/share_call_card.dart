import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:flutter_dogfooding/widgets/stream_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class ShareCallCard extends StatelessWidget {
  const ShareCallCard({
    required this.callId,
    super.key,
  });

  final String callId;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColorPalette.buttonSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        StreamButton.active(
          icon: const Icon(
            Icons.person_add_alt_1,
            color: Colors.white,
          ),
          label: 'Share link with others',
          onPressed: () async {
            await Share.share(callId);
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Or share this call ID with others you want in the meeting.',
          style: theme.textTheme.body.copyWith(
            color: theme.colorTheme.textLowEmphasis,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Call ID: ', style: theme.textTheme.title3),
            Text(
              callId,
              style: theme.textTheme.title3.copyWith(
                color: AppColorPalette.appGreen,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: callId));

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check,
                              color: AppColorPalette.appGreen),
                          const SizedBox(width: 8),
                          Text('Call ID copied to clipboard',
                              style: theme.textTheme.body.copyWith(
                                color: theme.colorTheme.textHighEmphasis,
                              )),
                        ],
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.copy_all),
            )
          ],
        )
      ]),
    );
  }
}
