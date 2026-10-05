// 📦 Package imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import '../utils/assets.dart';
import '../utils/call_encryption.dart';
import '../utils/e2ee.dart';
import '../utils/hifi_audio.dart';
import '../utils/random_words.dart';
import '../widgets/lobby_encryption.dart';
import '../widgets/stream_button.dart';

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
  RtcMediaDevice? _selectedVideoInputDevice;
  bool _blurEnabled = false;

  final _deviceNotifier = RtcMediaDeviceNotifier.instance;
  StreamSubscription<List<RtcMediaDevice>>? _deviceChangeSubscription;
  List<RtcMediaDevice> _audioInputDevices = const [];
  List<RtcMediaDevice> _videoInputDevices = const [];

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

  /// Whether to join with HiFi (stereo, music quality) audio.
  bool _hifiEnabled = false;

  /// Whether the HiFi switch is rebuilding the preview; the switch is inert
  /// meanwhile.
  bool _switchingHiFi = false;

  /// Bumped to remount the preview, which builds a new peer connection
  /// factory and new tracks on the way.
  int _previewGeneration = 0;

  @override
  void initState() {
    super.initState();
    _call = widget.call;
    _videoEffectsManager = StreamVideoEffectsManager(_call);
    _hifiEnabled = isHiFiAudioPolicy(_call.state.value.preferences);

    // If an invite includes a key, the call should be encrypted and the user doesn't need to input anything.
    // For new calls, an invite key will also trigger encrypted call creation.
    final invitedKey = widget.initialEncryptionKey;
    if (invitedKey != null && invitedKey.isNotEmpty) {
      _encryptionEnabled = true;
      _setEncryptionKey(invitedKey);
    }

    _deviceChangeSubscription = _deviceNotifier.onDeviceChange.listen(
      _handleDeviceChange,
    );
    unawaited(_deviceNotifier.enumerateDevices());
    Permission.microphone.isGranted.then(
      (value) => setState(() => _hasMicrophonePermission = value),
    );
    Permission.camera.isGranted.then(
      (value) => setState(() => _hasCameraPermission = value),
    );
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

    if (_hifiEnabled) {
      final prepared = await _prepareHiFi();
      if (!prepared || !mounted) return;
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

  /// Allows HiFi audio on the call and selects the music profile, which the
  /// SDK then publishes in stereo with voice processing off.
  Future<bool> _prepareHiFi() async {
    try {
      final audio = _call.state.value.settings.audio;
      if (!audio.hifiAudioEnabled) {
        final updated = await _call.update(audio: withHiFiAudioEnabled(audio));
        if (updated is Failure) {
          _showError('Could not enable HiFi audio: ${updated.error.message}');
          return false;
        }

        // The update does not touch the local call state, and the profile
        // below is refused until the state says HiFi is allowed.
        final reloaded = await _call.get();
        if (reloaded is Failure) {
          _showError('Could not enable HiFi audio: ${reloaded.error.message}');
          return false;
        }
      }

      final result = _call.setAudioBitrateProfile(
        SfuAudioBitrateProfile.musicHighQuality,
      );
      if (result is Failure) {
        _showError('Could not enable HiFi audio: ${result.error.message}');
        return false;
      }

      return true;
    } catch (e) {
      _showError('Could not enable HiFi audio: $e');
      return false;
    }
  }

  /// Switches the audio policy the call will be joined with.
  ///
  /// The policy is fixed when the call's peer connection factory is built,
  /// and the preview has already built one. Its tracks are stopped so the SDK
  /// can drop that factory, then the preview is remounted to build a new one
  /// with the new policy.
  Future<void> _toggleHiFi() async {
    if (_switchingHiFi) return;
    final enabled = !_hifiEnabled;
    setState(() => _switchingHiFi = true);

    await _cameraTrack?.stop();
    await _microphoneTrack?.stop();
    _cameraTrack = null;
    _microphoneTrack = null;

    _call.updateCallPreferences(
      withHiFiAudioPolicy(_call.state.value.preferences, enabled: enabled),
    );

    if (!mounted) return;
    setState(() {
      _hifiEnabled = enabled;
      _switchingHiFi = false;
      _previewGeneration++;
    });
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
        _showError('Could not create the call: ${result.error.message}');
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
    _deviceChangeSubscription?.cancel();
    _encryptionKeyController.dispose();

    if (!_joining) unawaited(_call.clearE2EEManager());

    super.dispose();
  }

  void _handleDeviceChange(List<RtcMediaDevice> devices) {
    if (!mounted) return;

    final audioInputs = devices
        .where((device) => device.kind == RtcMediaDeviceKind.audioInput)
        .toList(growable: false);
    final videoInputs = devices
        .where((device) => device.kind == RtcMediaDeviceKind.videoInput)
        .toList(growable: false);

    setState(() {
      _audioInputDevices = audioInputs;
      _videoInputDevices = videoInputs;
    });
  }

  Future<void> _showAudioInputPicker(BuildContext context) async {
    final result = await showModalBottomSheet<RtcMediaDevice?>(
      context: context,
      builder: (context) {
        return _DevicePickerSheet(
          title: 'Select audio input',
          emptyLabel: 'No audio inputs available',
          devices: _audioInputDevices,
          selectedDeviceId: _selectedAudioInputDevice?.id,
          onDeviceSelected: (device) {
            Navigator.of(context).pop(device);
          },
        );
      },
    );

    if (!mounted) return;

    setState(() {
      _selectedAudioInputDevice = result;
    });
  }

  Future<void> _showVideoInputPicker(BuildContext context) async {
    final result = await showModalBottomSheet<RtcMediaDevice?>(
      context: context,
      builder: (context) {
        return _DevicePickerSheet(
          title: 'Select video input',
          emptyLabel: 'No video inputs available',
          devices: _videoInputDevices,
          selectedDeviceId: _selectedVideoInputDevice?.id,
          onDeviceSelected: (device) {
            Navigator.of(context).pop(device);
          },
        );
      },
    );

    if (!mounted) return;

    setState(() {
      _selectedVideoInputDevice = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;
    final colorTheme = streamVideoTheme.colorTheme;
    final currentUser = _userAuthController.currentUser;

    final theme = StreamLobbyViewTheme.of(context);

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
        title: Text(currentUser.name, style: textTheme.body),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
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
                SvgPicture.asset(globalNetworkAssest, width: 35),
                const SizedBox(height: 8),
                Text(
                  'Set up your call\nbefore joining',
                  textAlign: TextAlign.center,
                  style: textTheme.title1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorTheme.textHighEmphasis,
                  ),
                ),
                const SizedBox(height: 16),
                StreamLobbyVideo(
                  // Keyed on the selected camera, since the preview owns the
                  // track it renders and has no way to be handed a different
                  // one — remounting is how the device change reaches it. The
                  // HiFi switch remounts it the same way.
                  key: ValueKey(
                    (_selectedVideoInputDevice?.id, _previewGeneration),
                  ),
                  call: _call,
                  initialCameraDevice: _selectedVideoInputDevice,
                  onMicrophoneTrackSet: (track) => _microphoneTrack = track,
                  onCameraTrackSet: (track) {
                    _cameraTrack = track;

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
                        child: CallControlOption(
                          icon: _blurEnabled
                              ? const Icon(Icons.blur_on)
                              : const Icon(Icons.blur_off),
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
                      Tooltip(
                        message: _hifiEnabled
                            ? 'Disable HiFi stereo audio'
                            : 'Enable HiFi stereo audio',
                        child: CallControlOption(
                          icon: _hifiEnabled
                              ? const Icon(Icons.music_note)
                              : const Icon(Icons.music_off),
                          onPressed: _switchingHiFi || _creatingCall
                              ? null
                              : _toggleHiFi,
                        ),
                      ),
                    ];
                  },
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 12,
                  children: [
                    if (_hasMicrophonePermission)
                      Tooltip(
                        message: 'Select audio input device',
                        child: CallControlOption(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          icon: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 220),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.mic_rounded),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    _selectedAudioInputDevice?.label ??
                                        'Default',
                                    style: textTheme.body,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: _audioInputDevices.isEmpty
                              ? null
                              : () => _showAudioInputPicker(context),
                        ),
                      ),
                    if (_hasMicrophonePermission || _hasCameraPermission)
                      const SizedBox(width: 12),
                    if (_hasCameraPermission)
                      Tooltip(
                        message: 'Select video input device',
                        child: CallControlOption(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          icon: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 220),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.videocam_rounded),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    _selectedVideoInputDevice?.label ??
                                        'Default',
                                    style: textTheme.body,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: _videoInputDevices.isEmpty
                              ? null
                              : () => _showVideoInputPicker(context),
                        ),
                      ),
                  ],
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
                Container(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.cardBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.lock_person),
                                ),
                                Expanded(
                                  child: Text(
                                    'Start a private test call. This demo is built on Stream’s SDKs and runs on our global edge network.',
                                    style: textTheme.footnote.copyWith(
                                      color: colorTheme.textLowEmphasis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // An `auto-on` call requires every participant to
                            // encrypt, so the server rejects a join without a
                            // key.
                            PartialCallStateBuilder(
                              call: _call,
                              selector: (state) =>
                                  isCallEncrypted(state.settings),
                              builder: (context, isEncrypted) {
                                final willBeEncrypted = _callExists
                                    ? isEncrypted
                                    : _encryptionEnabled;
                                final needsKey =
                                    willBeEncrypted && _encryptionKey.isEmpty;

                                return Column(
                                  children: [
                                    if (needsKey)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          'Enter the shared encryption key to join',
                                          textAlign: TextAlign.center,
                                          style: textTheme.footnote.copyWith(
                                            color: colorTheme.textLowEmphasis,
                                          ),
                                        ),
                                      ),
                                    StreamButton.active(
                                      label: 'Start a test call',
                                      onPressed: needsKey || _creatingCall
                                          ? null
                                          : joinCallPressed,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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

class _DevicePickerSheet extends StatelessWidget {
  const _DevicePickerSheet({
    required this.title,
    required this.emptyLabel,
    required this.devices,
    required this.selectedDeviceId,
    required this.onDeviceSelected,
  });

  final String title;
  final String emptyLabel;
  final List<RtcMediaDevice> devices;
  final String? selectedDeviceId;
  final ValueChanged<RtcMediaDevice?> onDeviceSelected;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: streamVideoTheme.textTheme.title3,
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: devices.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _DeviceListTile(
                      label: 'System default',
                      selected: selectedDeviceId == null,
                      onTap: () => onDeviceSelected(null),
                    );
                  }

                  final device = devices[index - 1];
                  final label = device.label.isNotEmpty
                      ? device.label
                      : device.id;

                  return _DeviceListTile(
                    label: label,
                    selected: device.id == selectedDeviceId,
                    onTap: () => onDeviceSelected(device),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceListTile extends StatelessWidget {
  const _DeviceListTile({
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final colorTheme = streamVideoTheme.colorTheme;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: selected
          ? colorTheme.accentPrimary.withValues(alpha: .08)
          : colorTheme.textHighEmphasis.withValues(alpha: .04),
      title: Text(
        label,
        style: streamVideoTheme.textTheme.body,
      ),

      trailing: selected
          ? Icon(
              Icons.check,
              color: colorTheme.accentPrimary,
            )
          : null,
      onTap: onTap,
    );
  }
}
