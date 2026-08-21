// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
import '../utils/assets.dart';
import '../widgets/lobby_device_controls.dart';

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
  RtcMediaDevice? _selectedAudioOutputDevice;
  RtcMediaDevice? _selectedVideoInputDevice;
  bool _blurEnabled = false;

  final _userAuthController = locator.get<UserAuthController>();
  late StreamVideoEffectsManager _videoEffectsManager;

  bool _hasMicrophonePermission = false;
  bool _hasCameraPermission = false;

  @override
  void initState() {
    super.initState();
    _videoEffectsManager = StreamVideoEffectsManager(widget.call);
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

    if (_selectedAudioOutputDevice != null) {
      options = options.copyWith(audioOutputDevice: _selectedAudioOutputDevice);
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
    super.dispose();
  }

  Future<void> _selectVideoInput(RtcMediaDevice? device) async {
    _selectedVideoInputDevice = device;

    _cameraTrack = device != null
        ? await _cameraTrack?.selectVideoInput(device, [])
        : await _cameraTrack?.recreate([]);

    if (mounted) setState(() {});
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
                LobbyDeviceControls(
                  showMicrophone: _hasMicrophonePermission,
                  showCamera: _hasCameraPermission,
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
                            SizedBox(
                              width: double.infinity,
                              child: StreamButton(
                                onPressed: joinCallPressed,
                                child: const Text('Start a test call'),
                              ),
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
