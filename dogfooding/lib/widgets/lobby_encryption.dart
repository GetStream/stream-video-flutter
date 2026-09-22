// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import '../utils/call_encryption.dart';

/// Lobby footer that turns on end-to-end encryption and manages the shared
/// key.
///
/// Encryption is fixed when a call is created, so what this offers depends
/// entirely on whether [call] exists yet:
/// - not created → a live switch, since the mode is still ours to pick and the
///   call is created with it once the user joins;
/// - created and encrypted → a read-only banner, plus the key field, which is
///   all that is left to collect;
/// - created and plain → the switch, greyed out.
///
/// On a platform that cannot encrypt at all — see [supported] — none of that
/// applies and the card only reports where it stands.
class LobbyEncryption extends StatelessWidget {
  const LobbyEncryption({
    super.key,
    required this.call,
    required this.callExists,
    required this.supported,
    required this.encryptionEnabled,
    required this.encryptionKey,
    required this.busy,
    required this.onEncryptionToggled,
    required this.onEncryptionKeyChanged,
    required this.onGenerateKey,
    required this.keyController,
  });

  final Call call;

  /// Whether [call] has already been created on the backend.
  final bool callExists;

  /// Whether this platform can encrypt and decrypt at all.
  ///
  /// False on web, Windows and Linux. There is then nothing to switch and no
  /// key worth collecting, so the card drops both.
  final bool supported;

  /// The mode the switch is asking for, meaningful only before creation.
  final bool encryptionEnabled;

  /// The shared passphrase, empty when encryption is off.
  final String encryptionKey;

  /// Whether the call is being created; the switch is inert meanwhile.
  final bool busy;

  final ValueChanged<bool> onEncryptionToggled;
  final ValueChanged<String> onEncryptionKeyChanged;
  final VoidCallback onGenerateKey;
  final TextEditingController keyController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;
    final isSmall = context.streamScreenSize.isSmall;

    return PartialCallStateBuilder(
      call: call,
      selector: (state) => (
        settings: state.settings,
        createdByUser: state.createdByUser,
      ),
      builder: (context, state) {
        if (callExists && state.createdByUser.id.isEmpty) {
          return const SizedBox.shrink();
        }

        final isOn = callExists
            ? isCallEncrypted(state.settings)
            : encryptionEnabled;

        // An encrypted call this platform cannot decrypt: the key field would
        // collect something nothing here can use, and the join is refused
        // anyway, so all that is left is to say so.
        final blocked = isOn && !supported;
        final needsKey =
            supported && callExists && isOn && encryptionKey.isEmpty;

        return SizedBox(
          // The same width as the join button below it, so the two line up.
          width: isSmall ? double.infinity : 400,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(radius.lg),
              color: colorScheme.backgroundSurfaceCard,
              border: Border.all(
                color: switch ((isOn, supported)) {
                  (true, false) => colorScheme.borderWarning,
                  (true, true) => colorScheme.accentPrimary,
                  (false, _) => colorScheme.borderSubtle,
                },
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spacing.md,
                children: [
                  if (!supported)
                    _Header(
                      title: 'End-to-end encryption',
                      subtitle: blocked
                          ? 'This call is encrypted and cannot be joined on '
                                'this platform'
                          : 'Not supported on this platform',
                      isOn: isOn,
                      warning: blocked,
                      // Nothing to switch: the platform decides, not the user.
                      trailing: blocked
                          ? null
                          : StreamSwitch(value: false, onChanged: null),
                    )
                  else if (callExists && isOn)
                    const _Header(
                      title: 'End-to-end encryption',
                      isOn: true,
                    )
                  else
                    _Header(
                      title: 'End-to-end encryption',
                      subtitle: switch ((callExists, isOn)) {
                        (true, _) => 'This call was created without encryption',
                        (false, true) => 'Only people with the key can join',
                        (false, false) => 'Encrypt this call with a shared key',
                      },
                      isOn: isOn,
                      trailing: StreamSwitch(
                        value: isOn,
                        onChanged: callExists || busy
                            ? null
                            : onEncryptionToggled,
                      ),
                    ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    alignment: Alignment.topCenter,
                    child: !isOn || !supported
                        ? const SizedBox(width: double.infinity)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: spacing.sm,
                            children: [
                              StreamTextInput(
                                controller: keyController,
                                onChanged: onEncryptionKeyChanged,
                                hintText: 'Shared room key',
                                // A key is matched verbatim, so iOS
                                // auto-capitalizing the first letter turns a
                                // valid key into one that will not decrypt.
                                textCapitalization: .none,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!callExists)
                                      Tooltip(
                                        message: 'Generate a new key',
                                        child: StreamButton.icon(
                                          style: .secondary,
                                          type: .ghost,
                                          icon: Icon(
                                            context.streamIcons.refresh,
                                          ),
                                          onPressed: busy
                                              ? null
                                              : onGenerateKey,
                                        ),
                                      ),
                                    Tooltip(
                                      message: 'Copy key',
                                      child: StreamButton.icon(
                                        style: .secondary,
                                        type: .ghost,
                                        icon: Icon(context.streamIcons.copy),
                                        onPressed: encryptionKey.isEmpty
                                            ? null
                                            : () => _copyKey(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                needsKey
                                    ? 'Ask the call creator for the shared key, then enter it here to join.'
                                    : 'Anyone with this key can join and decrypt the call. Share it only with people you trust.',
                                style: textTheme.captionDefault.copyWith(
                                  color: colorScheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _copyKey(BuildContext context) {
    Clipboard.setData(ClipboardData(text: encryptionKey));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Encryption key copied'),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    this.subtitle,
    required this.isOn,
    this.warning = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool isOn;

  /// Whether the state the header reports is one the user has to act on
  /// elsewhere — an encrypted call this platform cannot join.
  final bool warning;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;
    final icons = context.streamIcons;

    return Row(
      spacing: spacing.sm,
      children: [
        Icon(
          isOn ? icons.lock : icons.unlock,
          color: switch ((isOn, warning)) {
            (_, true) => colorScheme.accentWarning,
            (true, false) => colorScheme.accentPrimary,
            (false, false) => colorScheme.textSecondary,
          },
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyEmphasis.copyWith(
                  color: colorScheme.textPrimary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: textTheme.captionDefault.copyWith(
                    color: colorScheme.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
