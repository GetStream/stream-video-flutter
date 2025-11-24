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
import '../widgets/stream_button.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({
    super.key,
    required this.onJoinCallPressed,
    required this.call,
  });

  final void Function(CallConnectOptions, StreamVideoEffectsManager)
  onJoinCallPressed;
  final Call call;

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

  bool _hasMicrophonePermission = false;
  bool _hasCameraPermission = false;

  @override
  void initState() {
    super.initState();
    _videoEffectsManager = StreamVideoEffectsManager(widget.call);
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

  void joinCallPressed() {
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

    widget.onJoinCallPressed(options, _videoEffectsManager);
  }

  @override
  void dispose() {
    _cameraTrack?.stop();
    _microphoneTrack?.stop();

    _cameraTrack = null;
    _microphoneTrack = null;
    _deviceChangeSubscription?.cancel();
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

    _selectedVideoInputDevice = result;

    if (_selectedVideoInputDevice != null) {
      _cameraTrack = await _cameraTrack?.selectVideoInput(
        _selectedVideoInputDevice!,
        [],
      );
    } else {
      _cameraTrack = await _cameraTrack?.recreate([]);
    }

    setState(() {});
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
                  key: ValueKey(_cameraTrack),
                  call: widget.call,
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
                            StreamButton.active(
                              label: 'Start a test call',
                              onPressed: joinCallPressed,
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
