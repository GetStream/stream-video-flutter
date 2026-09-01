// 📦 Package imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import '../utils/call_encryption.dart';
import '../utils/e2ee.dart';
import '../utils/random_words.dart';
import '../widgets/lobby_device_controls.dart';
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
  RtcLocalAudioTrack? _microphoneTrack;
  RtcLocalCameraTrack? _cameraTrack;
  RtcMediaDevice? _selectedAudioInputDevice;
  RtcMediaDevice? _selectedAudioOutputDevice;
  RtcMediaDevice? _selectedVideoInputDevice;
  bool _blurEnabled = false;

  final _userAuthController = locator.get<UserAuthController>();
  late StreamVideoEffectsManager _videoEffectsManager;

  /// The call about to be joined.
  late final Call _call;

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
  /// manager from then on.
  bool _joining = false;

  bool _hasMicrophonePermission = false;
  bool _hasCameraPermission = false;

  @override
  void initState() {
    super.initState();
    _call = widget.call;
    _videoEffectsManager = StreamVideoEffectsManager(_call);

    // If an invite includes a key, the call should be encrypted and the user doesn't need to input anything.
    // For new calls, an invite key will also trigger encrypted call creation.
    final invitedKey = widget.initialEncryptionKey;
    if (invitedKey != null && invitedKey.isNotEmpty) {
      _encryptionEnabled = true;
      _setEncryptionKey(invitedKey);
    }
  }

  Future<void> joinCallPressed() async {
    if (_creatingCall) return;

    // Creation is deferred to here so the switch above stays live for as long
    // as it means anything: the encryption mode is fixed at creation, and this
    // is the last moment before it is.
    if (!_callExists) {
      final created = await _createCall();
      if (!created || !mounted) return;
    }

    // The manager has to be attached before any peer connection exists, and
    // the join happens on the next screen — so this is the last moment.
    final isEncrypted = isCallEncrypted(_call.state.value.settings);
    if (isEncrypted && _encryptionKey.isNotEmpty) {
      final attached = await _attachE2EE();
      if (!attached || !mounted) return;
    }

    var options = const CallConnectOptions();

    final cameraTrack = _cameraTrack;
    if (cameraTrack != null) {
      options = options.copyWith(camera: TrackOption.enabled());
    }

    final microphoneTrack = _microphoneTrack;
    if (microphoneTrack != null) {
      options = options.copyWith(microphone: TrackOption.enabled());
    }

    if (_selectedAudioInputDevice != null) {
      options = options.copyWith(audioInputDevice: _selectedAudioInputDevice);
    }

    if (_selectedAudioOutputDevice != null) {
      options = options.copyWith(audioOutputDevice: _selectedAudioOutputDevice);
    }

    if (_selectedVideoInputDevice != null) {
      options = options.copyWith(videoInputDevice: _selectedVideoInputDevice);
    }

    _joining = true;
    widget.onJoinCallPressed(
      call: _call,
      connectOptions: options,
      effectsManager: _videoEffectsManager,
      encryptionKey: isEncrypted && _encryptionKey.isNotEmpty
          ? _encryptionKey
          : null,
    );
  }

  /// Derives the shared key and attaches a manager to [_call].
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
      await _call.setE2EEManager(e2ee);
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
      final result = await _call.getOrCreate(
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
  void dispose() {
    _cameraTrack?.stop();
    _microphoneTrack?.stop();

    _cameraTrack = null;
    _microphoneTrack = null;
    _encryptionKeyController.dispose();

    if (!_joining) unawaited(_call.clearE2EEManager());

    super.dispose();
  }

  Future<void> _selectVideoInput(RtcMediaDevice? device) async {
    // Recording the choice is enough to get a new track: the key below changes
    // with it, so the preview is rebuilt and opens the newly chosen camera.
    //
    // The track it handed over earlier is ours to release, though, and the
    // preview will not do it for us — nothing else holds a reference once it
    // reports the replacement.
    await _cameraTrack?.stop();
    _cameraTrack = null;

    if (mounted) setState(() => _selectedVideoInputDevice = device);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    final colorTheme = context.streamColorScheme;
    final currentUser = _userAuthController.currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamUserAvatar(user: currentUser!),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Icon(
                  context.streamIcons.language,
                  color: colorTheme.accentPrimary,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Set up your call',
                  textAlign: TextAlign.center,
                  style: textTheme.headingLg,
                ),
                const SizedBox(height: 16),
                StreamLobbyVideo(
                  // Keyed on the selected camera, since the preview owns the
                  // track it renders and has no way to be handed a different
                  // one — remounting is how the device change reaches it.
                  key: ValueKey(_selectedVideoInputDevice?.id),
                  call: _call,
                  initialCameraDevice: _selectedVideoInputDevice,
                  onMicrophoneTrackSet: (track) {
                    _microphoneTrack = track;

                    // A non-null track means getUserMedia succeeded, so we
                    // have permission and device labels are now populated.
                    if (track != null && !_hasMicrophonePermission) {
                      setState(() => _hasMicrophonePermission = true);
                    }
                  },
                  onCameraTrackSet: (track) {
                    _cameraTrack = track;

                    if (track != null && !_hasCameraPermission) {
                      setState(() => _hasCameraPermission = true);
                    }

                    if (track != null && _blurEnabled) {
                      _videoEffectsManager.applyBackgroundBlurFilter(
                        BlurIntensity.medium,
                        track: track,
                      );
                    }
                  },
                  additionalActionsBuilder: (context, call) {
                    return [
                      Tooltip(
                        message: _blurEnabled
                            ? 'Disable background blur'
                            : 'Enable background blur',
                        child: CallFeatureButton(
                          icon: Icon(context.streamIcons.blurFill),
                          selected: _blurEnabled,
                          onPressed: () async {
                            setState(() {
                              _blurEnabled = !_blurEnabled;
                            });

                            if (_blurEnabled) {
                              await _videoEffectsManager
                                  .applyBackgroundBlurFilter(
                                    BlurIntensity.medium,
                                    track: _cameraTrack,
                                  );
                            } else {
                              await _videoEffectsManager.disableAllFilters(
                                track: _cameraTrack,
                              );
                            }
                          },
                        ),
                      ),
                    ];
                  },
                ),
                const SizedBox(height: 12),
                LobbyDeviceControls(
                  microphoneEnabled: _hasMicrophonePermission,
                  cameraEnabled: _hasCameraPermission,
                  selectedAudioInput: _selectedAudioInputDevice,
                  selectedAudioOutput: _selectedAudioOutputDevice,
                  selectedVideoInput: _selectedVideoInputDevice,
                  onAudioInputSelected: (device) {
                    setState(() => _selectedAudioInputDevice = device);
                  },
                  onAudioOutputSelected: (device) {
                    setState(() => _selectedAudioOutputDevice = device);
                  },
                  onVideoInputSelected: _selectVideoInput,
                ),

                const SizedBox(height: 24),
                LobbyEncryption(
                  call: _call,
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
                    if (wasEmpty != next.isEmpty) setState(() {});
                  },
                  onGenerateKey: () =>
                      setState(() => _setEncryptionKey(getRandomWords())),
                ),
                const SizedBox(height: 24),
                // An `auto-on` call requires every participant to encrypt, so
                // the server rejects a join without a key.
                PartialCallStateBuilder(
                  call: _call,
                  selector: (state) => isCallEncrypted(state.settings),
                  builder: (context, isEncrypted) {
                    final willBeEncrypted = _callExists
                        ? isEncrypted
                        : _encryptionEnabled;
                    final needsKey = willBeEncrypted && _encryptionKey.isEmpty;

                    return Column(
                      children: [
                        if (needsKey)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Enter the shared encryption key to join',
                              textAlign: TextAlign.center,
                              style: textTheme.captionDefault.copyWith(
                                color: colorTheme.textSecondary,
                              ),
                            ),
                          ),
                        SizedBox(
                          width: 400,
                          child: StreamButton(
                            onPressed: needsKey || _creatingCall
                                ? null
                                : joinCallPressed,
                            child: const Text('Start a test call'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 56),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
