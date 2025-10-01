import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
import '../theme/app_palette.dart';
import 'stream_button.dart';

class ShareCallWelcomeCard extends StatefulWidget {
  const ShareCallWelcomeCard({required this.callId, super.key});

  final String callId;

  @override
  State<ShareCallWelcomeCard> createState() => _ShareCallWelcomeCardState();
}

class _ShareCallWelcomeCardState extends State<ShareCallWelcomeCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColorPalette.buttonSecondary,
            borderRadius: BorderRadius.circular(16),
          ),
          constraints: const BoxConstraints(maxWidth: 600),
          child: ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Your meeting is live!',
                style: theme.textTheme.title3,
              ),
            ),
            shape: const Border(
              top: BorderSide(color: Colors.transparent),
              bottom: BorderSide(color: Colors.transparent),
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_more : Icons.expand_less,
              color: Colors.white,
            ),
            childrenPadding: const EdgeInsets.all(16),
            onExpansionChanged: (value) => setState(() => _isExpanded = value),
            children: [_ShareCardContent(callId: widget.callId)],
          ),
        ),
      ),
    );
  }
}

class ShareCallParticipantsCard extends StatelessWidget {
  const ShareCallParticipantsCard({required this.callId, super.key});
  final String callId;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Share the link', style: theme.textTheme.title1),
          const SizedBox(height: 16),
          _ShareCardContent(callId: callId),
        ],
      ),
    );
  }
}

class _ShareCardContent extends StatelessWidget {
  _ShareCardContent({required this.callId});
  final String callId;
  late final _appPreferences = locator.get<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final callUrl = _appPreferences.environment.getJoinUrl(callId: callId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (callUrl != null) ...[
          StreamButton.active(
            icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
            label: 'Share link with others',
            onPressed: () async {
              await SharePlus.instance.share(
                ShareParams(uri: Uri.parse(callUrl)),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        Text(
          'Share this call ID with others you want in the meeting.',
          style: theme.textTheme.body,
        ),
        const SizedBox(height: 8),
        StreamButton.tertiary(
          icon: const Icon(Icons.copy_all, color: Colors.white),
          label: 'Call id: $callId',
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: callId));

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check, color: AppColorPalette.appGreen),
                      const SizedBox(width: 8),
                      Text(
                        'Call ID copied to clipboard',
                        style: theme.textTheme.body.copyWith(
                          color: theme.colorTheme.textHighEmphasis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        if (callUrl != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'Or scan the QR code to join from another device',
              style: theme.textTheme.body,
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              constraints: const BoxConstraints(maxHeight: 150),
              child: AspectRatio(
                aspectRatio: 1,
                child: QrImageView(
                  data: callUrl,
                  size: 200,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
