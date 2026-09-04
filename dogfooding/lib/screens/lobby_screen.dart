// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import '../utils/call_encryption.dart';
import '../utils/e2ee.dart';
import '../utils/random_words.dart';
import '../widgets/lobby_encryption.dart';

/// Hands the call over to the call screen once the lobby is done with it.
///
/// [encryptionKey] is the passphrase the call's shared key was derived from,
/// null for a call that is not encrypted or whose key arrived as raw bytes. It
/// travels with the call because the key itself cannot: the encryption manager
/// takes the derived bytes and never gives them back, so the passphrase has to
/// be carried by whoever wants to show it again.
typedef OnJoinCallPressed =
    void Function({
      required Call call,
      required CallConnectOptions connectOptions,
      required StreamVideoEffectsManager effectsManager,
      String? encryptionKey,
    });

/// The dogfooding lobby: the SDK's [StreamLobbyView] under this app's own
/// chrome, with a background-blur toggle spliced into the control row and the
/// encryption settings in the footer.
class LobbyScreen extends StatefulWidget {
  const LobbyScreen({
    super.key,
    required this.onJoinCallPressed,
    required this.call,
    this.callExists = true,
    this.initialEncryptionKey,
  });

  final OnJoinCallPressed onJoinCallPressed;
  final Call call;

  /// A shared passphrase that arrived with an invite — a scanned QR code or a
  /// followed link.
  final String? initialEncryptionKey;

  /// Whether [call] has already been created on the backend.
  ///
  /// When false this screen owns its creation, which happens on the way to
  /// joining.
  final bool callExists;

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final _userAuthController = locator.get<UserAuthController>();
  late final StreamVideoEffectsManager _videoEffectsManager;

  /// Whether to create the call encrypted. Only meaningful until the call
  /// exists, after which the call itself is the answer.
  bool _encryptionEnabled = false;

  /// The shared passphrase, empty when encryption is off.
  String _encryptionKey = '';
  final _encryptionKeyController = TextEditingController();

  /// Whether the call is being created; both the switch and the join button
  /// are inert meanwhile.
  bool _creatingCall = false;

  /// Whether the call has been created from this screen.
  bool _created = false;

  /// Whether the call exists: either it already did, or this screen made it.
  bool get _callExists => widget.callExists || _created;

  /// Set once the call has been handed to the call screen, which owns the
  /// encryption manager from then on.
  bool _joining = false;

  @override
  void initState() {
    super.initState();
    _videoEffectsManager = StreamVideoEffectsManager(widget.call);

    // An invite that carries a key is an invite to an encrypted call, so the
    // user has nothing to fill in. For a call that does not exist yet, it also
    // decides that the call is created encrypted.
    final invitedKey = widget.initialEncryptionKey;
    if (invitedKey != null && invitedKey.isNotEmpty) {
      _encryptionEnabled = true;
      _setEncryptionKey(invitedKey);
    }
  }

  @override
  void dispose() {
    _encryptionKeyController.dispose();
    if (!_joining) unawaited(widget.call.clearE2EEManager());
    super.dispose();
  }

  /// Creates the call if this screen owns its creation, attaches the
  /// encryption manager, and hands the call to the call screen.
  ///
  /// Returns false without joining when any of that fails, which leaves the
  /// lobby on screen with its preview running.
  Future<bool> _joinCallPressed(CallConnectOptions options) async {
    if (_creatingCall) return false;

    // Creation is deferred to here so the encryption switch stays live for as
    // long as it means anything: the mode is fixed at creation, and this is
    // the last moment before it is.
    if (!_callExists) {
      if (!await _createCall() || !mounted) return false;
    }

    // The manager has to be attached before any peer connection exists, and
    // the join happens on the next screen — so this is the last moment.
    final isEncrypted = isCallEncrypted(widget.call.state.value.settings);
    if (isEncrypted && _encryptionKey.isNotEmpty) {
      if (!await _attachE2EE() || !mounted) return false;
    }

    _joining = true;
    widget.onJoinCallPressed(
      call: widget.call,
      connectOptions: options,
      effectsManager: _videoEffectsManager,
      encryptionKey: isEncrypted && _encryptionKey.isNotEmpty
          ? _encryptionKey
          : null,
    );
    return true;
  }

  /// Derives the shared key and attaches a manager to the call.
  Future<bool> _attachE2EE() async {
    if (!EncryptionManager.isSupported) {
      _showError('End-to-end encryption is not available on this platform.');
      return false;
    }

    try {
      final keyBytes = await deriveKeyFromPassphrase(_encryptionKey);
      final e2ee = EncryptionManager.create(
        userId: _userAuthController.currentUser!.id,
      );

      await e2ee.setSharedKey(kE2EESharedKeyIndex, keyBytes);
      await widget.call.setE2EEManager(e2ee);
      return true;
    } catch (e, stk) {
      debugPrint('Failed to enable E2EE: $e\n$stk');
      _showError('Could not enable encryption: $e');
      return false;
    }
  }

  Future<bool> _createCall() async {
    setState(() => _creatingCall = true);

    try {
      final result = await widget.call.getOrCreate(
        video: true,
        encryption: _encryptionEnabled
            ? const StreamEncryptionSettings(mode: StreamEncryptionMode.autoOn)
            : null,
      );

      if (result is Failure) {
        _showError('Could not create the call: ${result.videoError.message}');
        return false;
      }

      _created = true;
      return true;
    } catch (e) {
      _showError('Could not create the call: $e');
      return false;
    } finally {
      if (mounted) setState(() => _creatingCall = false);
    }
  }

  /// Records the encryption mode to create the call with.
  void _toggleEncryption(bool enabled) {
    setState(() {
      _encryptionEnabled = enabled;
      _setEncryptionKey(
        enabled
            ? (_encryptionKey.isNotEmpty ? _encryptionKey : getRandomWords())
            : '',
      );
    });
  }

  void _setEncryptionKey(String key) {
    _encryptionKey = key;
    _encryptionKeyController.text = key;
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;
    final currentUser = _userAuthController.currentUser!;

    // Picking a preset for the window is a demo of what a host can do, not
    // something the SDK does: StreamLobbyView defaults to LobbyActions.simple()
    // at every width. On Android and iOS the split buttons and the select
    // inputs open bottom sheets with nothing here saying so.
    final extras = [
      const StreamLobbyParticipantsControl(),
      _BlurToggle(effects: _videoEffectsManager),
    ];
    final actions = switch (context.streamScreenSize) {
      StreamScreenSize.small => LobbyActions.regular(extraControls: extras),
      _ => LobbyActions.full(extraControls: extras),
    };

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamUserAvatar(user: currentUser),
        ),
        titleSpacing: 4,
        centerTitle: false,
        title: Text(currentUser.name, style: textTheme.headingXs),
        actions: [
          StreamButton.icon(
            style: .secondary,
            type: .ghost,
            icon: Icon(context.streamIcons.leave),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.xxl,
          ),
          // An `auto-on` call requires every participant to encrypt, so the
          // server rejects a join without a key.
          child: PartialCallStateBuilder(
            call: widget.call,
            selector: (state) => isCallEncrypted(state.settings),
            builder: (context, isEncrypted) {
              final willBeEncrypted = _callExists
                  ? isEncrypted
                  : _encryptionEnabled;
              final needsKey = willBeEncrypted && _encryptionKey.isEmpty;

              return StreamLobbyView(
                call: widget.call,
                actions: actions,
                title: Text('Set up your call', style: textTheme.headingLg),
                joinButtonLabel: const Text('Start a test call'),
                joinEnabled: !needsKey && !_creatingCall,
                footer: LobbyEncryption(
                  call: widget.call,
                  callExists: _callExists,
                  encryptionEnabled: _encryptionEnabled,
                  encryptionKey: _encryptionKey,
                  busy: _creatingCall,
                  keyController: _encryptionKeyController,
                  onEncryptionToggled: _toggleEncryption,
                  onEncryptionKeyChanged: (value) {
                    final next = value.trim();
                    final wasEmpty = _encryptionKey.isEmpty;
                    _encryptionKey = next;
                    // Only the join button and the hint depend on the key, and
                    // only on whether there is one at all.
                    if (wasEmpty != next.isEmpty) setState(() {});
                  },
                  onGenerateKey: () =>
                      setState(() => _setEncryptionKey(getRandomWords())),
                ),
                onJoinCallPressed: _joinCallPressed,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Blurs whatever is behind the user in the preview.
///
/// A feature button rather than a control: it is off by default and should
/// read as switched on, not as something taken away.
class _BlurToggle extends StatefulWidget {
  const _BlurToggle({required this.effects});

  final StreamVideoEffectsManager effects;

  @override
  State<_BlurToggle> createState() => _BlurToggleState();
}

class _BlurToggleState extends State<_BlurToggle> {
  bool _enabled = false;
  RtcLocalCameraTrack? _appliedTo;

  @override
  Widget build(BuildContext context) {
    // Reading the controller here subscribes this button to it, so switching
    // camera device rebuilds and the filter is reapplied to the new track.
    final controller = StreamLobbyScope.of(context);
    final track = controller.cameraTrack;

    if (_enabled && track != null && track != _appliedTo) {
      _appliedTo = track;
      widget.effects.applyBackgroundBlurFilter(
        BlurIntensity.medium,
        track: track,
      );
    }

    return Tooltip(
      message: _enabled ? 'Disable background blur' : 'Enable background blur',
      child: CallFeatureButton(
        icon: Icon(context.streamIcons.blurFill),
        selected: _enabled,
        onPressed: () async {
          setState(() => _enabled = !_enabled);

          if (_enabled) {
            _appliedTo = track;
            await widget.effects.applyBackgroundBlurFilter(
              BlurIntensity.medium,
              track: track,
            );
          } else {
            _appliedTo = null;
            await widget.effects.disableAllFilters(track: track);
          }
        },
      ),
    );
  }
}
