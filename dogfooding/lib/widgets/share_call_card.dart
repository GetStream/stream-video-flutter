import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
import '../utils/call_encryption.dart';

class ShareCallWelcomeCard extends StatefulWidget {
  const ShareCallWelcomeCard({
    required this.call,
    this.encryptionKey,
    super.key,
  });

  final Call call;

  /// The shared passphrase, put in the invite when [call] is encrypted.
  final String? encryptionKey;

  @override
  State<ShareCallWelcomeCard> createState() => _ShareCallWelcomeCardState();
}

class _ShareCallWelcomeCardState extends State<ShareCallWelcomeCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final colorScheme = StreamTheme.of(context).colorScheme;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.backgroundElevation1,
            borderRadius: BorderRadius.circular(16),
          ),
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: colorScheme.borderDefault),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: .antiAlias,
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
              color: colorScheme.textPrimary,
            ),
            childrenPadding: const EdgeInsets.all(16),
            onExpansionChanged: (value) => setState(() => _isExpanded = value),
            children: [
              _ShareCardContent(
                call: widget.call,
                encryptionKey: widget.encryptionKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShareCallParticipantsCard extends StatelessWidget {
  const ShareCallParticipantsCard({
    required this.call,
    this.encryptionKey,
    super.key,
  });
  final Call call;

  /// The shared passphrase, put in the invite when [call] is encrypted.
  final String? encryptionKey;

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
          _ShareCardContent(call: call, encryptionKey: encryptionKey),
        ],
      ),
    );
  }
}

class _ShareCardContent extends StatelessWidget {
  _ShareCardContent({required this.call, this.encryptionKey});
  final Call call;
  final String? encryptionKey;
  late final _appPreferences = locator.get<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final colorScheme = StreamTheme.of(context).colorScheme;
    final callId = call.id;

    // An encrypted call cannot be joined without the key, so an invite to one
    // has to carry it.
    final callUrl = _appPreferences.environment.getJoinUrl(
      callId: callId,
      encryptionKey: isCallEncrypted(call.state.value.settings)
          ? encryptionKey
          : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (callUrl != null) ...[
          StreamButton(
            iconLeft: const Icon(Icons.person_add_alt_1),
            onPressed: () async {
              await SharePlus.instance.share(
                ShareParams(uri: Uri.parse(callUrl)),
              );
            },
            child: const Text('Share link with others'),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          'Share this call ID with others you want in the meeting.',
          style: theme.textTheme.body,
        ),
        const SizedBox(height: 8),
        StreamButton(
          style: StreamButtonStyle.secondary,
          type: StreamButtonType.outline,
          iconLeft: const Icon(Icons.copy_all),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: callId));

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check, color: colorScheme.accentSuccess),
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
          child: Text('Call id: $callId'),
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
