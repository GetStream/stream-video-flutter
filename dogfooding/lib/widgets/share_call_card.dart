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
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;
    final borderRadius = BorderRadius.all(context.streamRadius.lg);

    // The design puts the card's edges on the participant label's. The label
    // sits spacing.xs inside the tile, and the tile sits the grid's own
    // padding inside the call, so the card clears both.
    final gridPadding =
        StreamCallParticipantsGridTheme.of(context).padding?.resolve(
          Directionality.maybeOf(context),
        ) ??
        EdgeInsets.all(spacing.xs);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: gridPadding + EdgeInsets.all(spacing.xs),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // Below the small breakpoint the card spans the whole width
            // between those insets; a wider window holds it at 360.
            maxWidth: context.streamScreenSize.isSmall ? double.infinity : 360,
          ),
          child: Material(
            // Elevation rather than a painted shadow, so the card lifts off the
            // call the same way every other raised Stream surface does.
            elevation: context.streamElevation.level3,
            color: colorScheme.backgroundElevation1,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            clipBehavior: Clip.antiAlias,
            child: DecoratedBox(
              // Painted in front, so the tile's own surface does not cover it.
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(color: colorScheme.borderDefault),
              ),
              child: ExpansionTile(
                title: Text(
                  'Your Meeting is Live!',
                  style: context.streamTextTheme.headingSm.copyWith(
                    color: colorScheme.textPrimary,
                  ),
                ),
                // A shape, even an empty one, replaces the tile's default
                // dividers. BorderSide.none also contributes no padding, which
                // a transparent side would: its width still counts.
                shape: const Border(),
                collapsedShape: const Border(),
                trailing: Icon(
                  _isExpanded
                      ? context.streamIcons.chevronUp
                      : context.streamIcons.chevronDown,
                  size: spacing.lg,
                  color: colorScheme.textPrimary,
                ),
                // minTileHeight sizes the row inside tilePadding, so the
                // 16 above and below the title comes from centring it in 52.
                tilePadding: EdgeInsets.symmetric(horizontal: spacing.md),
                minTileHeight: 52,
                childrenPadding: EdgeInsets.fromLTRB(
                  spacing.md,
                  0,
                  spacing.md,
                  spacing.md,
                ),
                // The content sizes itself to the card, not to its widest row.
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                onExpansionChanged: (value) =>
                    setState(() => _isExpanded = value),
                children: [
                  _ShareCardContent(
                    call: widget.call,
                    encryptionKey: widget.encryptionKey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The share content laid out for the participants panel: no accordion, a
/// heading above it instead.
///
/// No call sites today, kept for the panel to show again.
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (callUrl != null) ...[
          StreamButton(
            iconLeft: Icon(context.streamIcons.userAddFill),
            // The default padded tap target grows each 40px pill to 48 and so
            // doubles the gap the design puts between the two; a full-width
            // button keeps a large tap area without it.
            themeStyle: const StreamButtonThemeStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () async {
              await SharePlus.instance.share(
                ShareParams(uri: Uri.parse(callUrl)),
              );
            },
            child: const Text('Add Others'),
          ),
          SizedBox(height: spacing.xs),
        ],
        StreamButton(
          style: StreamButtonStyle.secondary,
          type: StreamButtonType.outline,
          iconLeft: Icon(context.streamIcons.copyFill),
          themeStyle: const StreamButtonThemeStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: callId));

            if (context.mounted) {
              StreamSnackbarMessenger.of(context).show(
                StreamSnackbar(
                  message: const Text('Call ID copied to clipboard'),
                  variant: StreamSnackbarVariant.success,
                ),
              );
            }
          },
          child: const Text('Copy Call ID'),
        ),
        if (callUrl != null) ...[
          SizedBox(height: spacing.md),
          Container(
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(context.streamRadius.lg),
              color: colorScheme.backgroundSurface,
            ),
            padding: EdgeInsets.all(spacing.md),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(context.streamRadius.xl),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: QrImageView(data: callUrl),
              ),
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(
            'Scan the QR code to join from another device.',
            textAlign: TextAlign.center,
            style: context.streamTextTheme.metadataDefault.copyWith(
              color: colorScheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
