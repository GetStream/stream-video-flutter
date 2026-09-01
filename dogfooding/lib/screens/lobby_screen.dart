// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app/user_auth_controller.dart';
import '../di/injector.dart';
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
                  // Keyed on the chosen device, not on the track it produces.
                  // Keying on the track makes the preview's identity depend on
                  // its own output, so any later rebuild — switching between
                  // light and dark, say — tears it down and starts the camera
                  // over, re-enabling it if it had been turned off.
                  key: ValueKey(_selectedVideoInputDevice?.id),
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
                SizedBox(
                  width: 400,
                  child: StreamButton(
                    onPressed: joinCallPressed,
                    child: const Text('Start a test call'),
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
