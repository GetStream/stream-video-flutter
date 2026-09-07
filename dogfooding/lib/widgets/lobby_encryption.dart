// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import '../utils/call_encryption.dart';

/// Lobby control that turns on end-to-end encryption and manages the shared
/// key.
///
/// Encryption is fixed when a call is created, so what this offers depends
/// entirely on whether [call] exists yet:
/// - not created → a live switch, since the mode is still ours to pick and the
///   call is created with it once the user joins;
/// - created and encrypted → a read-only banner, plus the key field, which is
///   all that is left to collect;
/// - created and plain → the switch, greyed out.
class LobbyEncryption extends StatelessWidget {
  const LobbyEncryption({
    super.key,
    required this.call,
    required this.callExists,
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
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;
    final colorTheme = streamVideoTheme.colorTheme;

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

        final needsKey = callExists && isOn && encryptionKey.isEmpty;

        return Container(
          constraints: const BoxConstraints(maxWidth: 360),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: StreamLobbyViewTheme.of(context).cardBackgroundColor,
            border: isOn
                ? Border.all(
                    color: colorTheme.accentInfo.withValues(alpha: 0.6),
                  )
                : null,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (callExists && isOn)
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
                  trailing: Switch.adaptive(
                    value: isOn,
                    activeTrackColor: colorTheme.accentInfo,
                    onChanged: callExists || busy ? null : onEncryptionToggled,
                  ),
                ),
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: !isOn
                    ? const SizedBox(width: double.infinity)
                    : Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: keyController,
                                    onChanged: onEncryptionKeyChanged,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    style: textTheme.body.copyWith(
                                      color: colorTheme.textHighEmphasis,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Shared room key',
                                      hintStyle: textTheme.body.copyWith(
                                        color: colorTheme.textLowEmphasis,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (!callExists) ...[
                                  const SizedBox(width: 4),
                                  IconButton(
                                    tooltip: 'Generate a new key',
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                    onPressed: busy ? null : onGenerateKey,
                                  ),
                                ],
                                IconButton(
                                  tooltip: 'Copy key',
                                  icon: const Icon(
                                    Icons.copy_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: encryptionKey.isEmpty
                                      ? null
                                      : () => _copyKey(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              needsKey
                                  ? 'Ask the call creator for the shared key, then enter it here.'
                                  : 'Anyone with this key can join and decrypt the call. Share it only with people you trust.',
                              style: textTheme.footnote.copyWith(
                                color: colorTheme.textLowEmphasis,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
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
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool isOn;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;
    final colorTheme = streamVideoTheme.colorTheme;

    return Row(
      children: [
        Icon(
          isOn ? Icons.lock_rounded : Icons.lock_open_rounded,
          color: isOn ? colorTheme.accentInfo : colorTheme.textLowEmphasis,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyBold.copyWith(
                  color: colorTheme.textHighEmphasis,
                ),
              ),
              const SizedBox(height: 2),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: textTheme.footnote.copyWith(
                    color: colorTheme.textLowEmphasis,
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
