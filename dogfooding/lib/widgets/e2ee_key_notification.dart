import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../theme/app_palette.dart';
import '../utils/e2ee.dart';

/// What the local peer can conclude about key agreement from its own
/// decryption failures.
sealed class E2eeKeyStatus {
  const E2eeKeyStatus();
}

/// Nothing is failing, or there is nothing to judge from yet.
class E2eeKeyOk extends E2eeKeyStatus {
  const E2eeKeyOk();
}

/// Every publishing peer fails to decrypt. With a shared key that means *this*
/// peer holds the wrong one — a peer with the right key would still decrypt
/// the majority.
class E2eeLocalKeyMismatch extends E2eeKeyStatus {
  const E2eeLocalKeyMismatch();
}

/// Only some peers fail, so their keys differ from ours.
class E2eePeerKeyMismatch extends E2eeKeyStatus {
  const E2eePeerKeyMismatch(this.names);

  final List<String> names;
}

/// Surfaces a shared-key mismatch on an encrypted call.
///
/// Without this a wrong meeting key looks like a broken call rather than a
/// wrong key: media arrives, fails its authentication tag and is dropped, so
/// tiles stay black and audio silent with nothing said about why.
///
/// When the failure looks local the banner doubles as the fix — the key can be
/// re-entered here and goes straight to the native manager, so a mistyped key
/// does not cost a rejoin.
class E2eeKeyNotification extends StatefulWidget {
  const E2eeKeyNotification({
    super.key,
    required this.call,
    this.onKeyApplied,
  });

  /// Called with the passphrase whenever a replacement key is installed.
  ///
  /// The derived bytes go to the encryption manager and never come back out, so
  /// anything that has to show the key again — the invite the call screen
  /// offers — only learns about it here.
  final ValueChanged<String>? onKeyApplied;

  final Call call;

  @override
  State<E2eeKeyNotification> createState() => _E2eeKeyNotificationState();
}

class _E2eeKeyNotificationState extends State<E2eeKeyNotification> {
  StreamSubscription<E2eeEvent>? _subscription;

  /// Keyed per `(userId, trackType)` because the native manager counts
  /// failures per track: a peer publishing audio and video reports them
  /// independently, and their video can recover while audio is still stalled.
  final Set<String> _stalledTracks = {};

  bool _dismissed = false;
  bool _applyingKey = false;
  final _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(E2eeKeyNotification oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.call != widget.call) _subscribe();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _keyController.dispose();
    super.dispose();
  }

  void _subscribe() {
    _subscription?.cancel();
    _stalledTracks.clear();

    final manager = widget.call.e2eeManager;
    if (manager == null) return;

    // Stalled means the track has failed past the SDK's tolerance and is not recovering.
    _subscription = manager.events.listen((event) {
      final userId = event.userId;
      if (userId.isEmpty) return;

      final key = '$userId/${event.trackType?.name ?? 'unknown'}';

      switch (event.type) {
        case E2eeEventType.decryptionStalled:
          if (_stalledTracks.add(key)) setState(() {});
        case E2eeEventType.decryptionResumed:
          if (_stalledTracks.remove(key)) setState(() {});
        case _:
          break;
      }
    });
  }

  /// Derives and installs a replacement key without leaving the call.
  Future<void> _applyKey() async {
    final passphrase = _keyController.text.trim();
    final manager = widget.call.e2eeManager;
    if (passphrase.isEmpty || manager == null || _applyingKey) return;

    setState(() => _applyingKey = true);
    try {
      final keyBytes = await deriveKeyFromPassphrase(passphrase);
      await manager.setSharedKey(kE2EESharedKeyIndex, keyBytes);

      // Replaces whatever the call was joined with, so the invite the share
      // card offers hands out the key that is actually in use.
      widget.onKeyApplied?.call(passphrase);
      if (!mounted) return;
      _keyController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not apply the key: $e')),
      );
    } finally {
      if (mounted) setState(() => _applyingKey = false);
    }
  }

  /// Judges the failures against the peers that are actually sending
  /// something: a muted, camera-off peer produces no frames and so no evidence
  /// either way.
  ///
  /// Blind spots worth knowing: alone in the call, or with every peer muted and
  /// camera-off, a wrong key is undetectable. And if two peers share the same
  /// wrong key they decrypt each other, so neither sees a full sweep of
  /// failures.
  E2eeKeyStatus _status(List<CallParticipantState> remoteParticipants) {
    if (_stalledTracks.isEmpty) return const E2eeKeyOk();

    final stalledUserIds = _stalledTracks
        .map((key) => key.substring(0, key.lastIndexOf('/')))
        .toSet();

    // Participants who have left keep stale entries in the set, which is
    // harmless — they are simply not part of this comparison.
    final publishing = remoteParticipants
        .where((it) => it.publishedTracks.isNotEmpty)
        .toList();
    final failing = publishing
        .where((it) => stalledUserIds.contains(it.userId))
        .toList();

    if (failing.isEmpty) return const E2eeKeyOk();
    if (failing.length == publishing.length) {
      return const E2eeLocalKeyMismatch();
    }
    return E2eePeerKeyMismatch(
      failing.map((it) => it.name.isNotEmpty ? it.name : it.userId).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PartialCallStateBuilder(
      call: widget.call,
      selector: (state) => state.otherParticipants,
      builder: (context, remoteParticipants) {
        final status = _status(remoteParticipants);

        // Re-arm once the call recovers, so a later mismatch is surfaced again
        // rather than nagging about this one.
        if (status is E2eeKeyOk) {
          if (_dismissed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _dismissed = false);
            });
          }
          return const SizedBox.shrink();
        }

        if (_dismissed) return const SizedBox.shrink();

        return _Banner(
          onDismiss: () => setState(() => _dismissed = true),
          // Short enough to stay one or two lines in a card this size: the
          // banner sits over someone's video, and the key field below it is
          // the part that matters.
          message: switch (status) {
            E2eeLocalKeyMismatch() =>
              'Nothing is decrypting — your meeting key looks wrong.',
            E2eePeerKeyMismatch(:final names) =>
              "Can't decrypt ${names.join(', ')}",
            E2eeKeyOk() => '',
          },
          keyEntry: status is E2eeLocalKeyMismatch
              ? _KeyEntry(
                  controller: _keyController,
                  busy: _applyingKey,
                  onSubmit: _applyKey,
                )
              : null,
        );
      },
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.message,
    required this.onDismiss,
    this.keyEntry,
  });

  final String message;
  final VoidCallback onDismiss;
  final Widget? keyEntry;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final colorTheme = theme.colorTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: ConstrainedBox(
        // Sits over someone's video, so it takes the room it needs and no
        // more. Without this it is as wide as the call.
        constraints: const BoxConstraints(maxWidth: 420),
        child: DecoratedBox(
          decoration: BoxDecoration(
            // The app's own floating-card surface, the same one the share
            // card uses, with the failure carried by the icon and a hairline
            // rather than by a block of red over the video.
            color: AppColorPalette.buttonSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColorPalette.appRed.withValues(alpha: 0.45),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
            child: Column(
              // Loose vertical constraints come down from the Align this sits
              // in, so the default (max) would stretch the card over the whole
              // participant area.
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.no_encryption_gmailerrorred_rounded,
                      size: 18,
                      color: AppColorPalette.appRed,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message,
                        style: theme.textTheme.footnote.copyWith(
                          color: colorTheme.textHighEmphasis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      iconSize: 16,
                      color: colorTheme.textLowEmphasis,
                      padding: EdgeInsets.zero,
                      // An IconButton reserves a 48px tap target by default,
                      // which on its own makes this twice as tall as its text.
                      constraints: const BoxConstraints.tightFor(
                        width: 28,
                        height: 28,
                      ),
                      onPressed: onDismiss,
                    ),
                  ],
                ),
                if (keyEntry != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 28, top: 6, right: 20),
                    child: keyEntry,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyEntry extends StatelessWidget {
  const _KeyEntry({
    required this.controller,
    required this.busy,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool busy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final colorTheme = theme.colorTheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: !busy,
            autocorrect: false,
            enableSuggestions: false,
            style: theme.textTheme.footnote.copyWith(
              color: colorTheme.textHighEmphasis,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              hintText: 'Meeting key',
              hintStyle: theme.textTheme.footnote.copyWith(
                color: colorTheme.textLowEmphasis,
              ),
              filled: true,
              fillColor: AppColorPalette.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColorPalette.primary),
              ),
            ),
            onSubmitted: (_) => onSubmit(),
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColorPalette.primary,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            minimumSize: const Size(0, 34),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: busy ? null : onSubmit,
          child: Text(
            busy ? 'Applying…' : 'Apply',
            style: theme.textTheme.footnoteBold,
          ),
        ),
      ],
    );
  }
}
